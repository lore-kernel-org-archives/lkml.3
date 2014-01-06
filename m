Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaAFXrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:47:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaAFWjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 121/144] mm: munlock: fix deadlock in __munlock_pagevec()
Date: Mon,  6 Jan 2014 14:38:02 -0800
Message-Id: <20140106223748.815811640@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit 3b25df93c6e37e323b86a2a8c1e00c0a2821c6c9 upstream.

Commit 7225522bb429 ("mm: munlock: batch non-THP page isolation and
munlock+putback using pagevec" introduced __munlock_pagevec() to speed
up munlock by holding lru_lock over multiple isolated pages.  Pages that
fail to be isolated are put_page()d immediately, also within the lock.

This can lead to deadlock when __munlock_pagevec() becomes the holder of
the last page pin and put_page() leads to __page_cache_release() which
also locks lru_lock.  The deadlock has been observed by Sasha Levin
using trinity.

This patch avoids the deadlock by deferring put_page() operations until
lru_lock is released.  Another pagevec (which is also used by later
phases of the function is reused to gather the pages for put_page()
operation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mlock.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -298,10 +298,12 @@ static void __munlock_pagevec(struct pag
 {
 	int i;
 	int nr = pagevec_count(pvec);
-	int delta_munlocked = -nr;
+	int delta_munlocked;
 	struct pagevec pvec_putback;
 	int pgrescued = 0;
 
+	pagevec_init(&pvec_putback, 0);
+
 	/* Phase 1: page isolation */
 	spin_lock_irq(&zone->lru_lock);
 	for (i = 0; i < nr; i++) {
@@ -330,18 +332,21 @@ skip_munlock:
 			/*
 			 * We won't be munlocking this page in the next phase
 			 * but we still need to release the follow_page_mask()
-			 * pin.
+			 * pin. We cannot do it under lru_lock however. If it's
+			 * the last pin, __page_cache_release would deadlock.
 			 */
+			pagevec_add(&pvec_putback, pvec->pages[i]);
 			pvec->pages[i] = NULL;
-			put_page(page);
-			delta_munlocked++;
 		}
 	}
+	delta_munlocked = -nr + pagevec_count(&pvec_putback);
 	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 	spin_unlock_irq(&zone->lru_lock);
 
+	/* Now we can release pins of pages that we are not munlocking */
+	pagevec_release(&pvec_putback);
+
 	/* Phase 2: page munlock */
-	pagevec_init(&pvec_putback, 0);
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
 


