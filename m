Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3LPKPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:15:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab3LPKO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:14:29 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        joern@logfs.org, Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, stable@kernel.org
Subject: [PATCH 2/3] mm: munlock: fix deadlock in __munlock_pagevec()
Date: Mon, 16 Dec 2013 11:14:15 +0100
Message-Id: <1387188856-21027-3-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387188856-21027-1-git-send-email-vbabka@suse.cz>
References: <52AE07B4.4020203@oracle.com>
 <1387188856-21027-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7225522bb ("mm: munlock: batch non-THP page isolation and
munlock+putback using pagevec" introduced __munlock_pagevec() to speed up
munlock by holding lru_lock over multiple isolated pages. Pages that fail to
be isolated are put_back() immediately, also within the lock.

This can lead to deadlock when __munlock_pagevec() becomes the holder of the
last page pin and put_back() leads to __page_cache_release() which also locks
lru_lock. The deadlock has been observed by Sasha Levin using trinity.

This patch avoids the deadlock by deferring put_back() operations until
lru_lock is released. Another pagevec (which is also used by later phases
of the function is reused to gather the pages for put_back() operation.

Cc: stable@kernel.org
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mlock.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 3847b13..31383d5 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -295,10 +295,12 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
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
@@ -327,16 +329,22 @@ skip_munlock:
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
+	for (i = 0; i < pagevec_count(&pvec_putback); i++) {
+		put_page(pvec_putback.pages[i]);
+	}
+
 	/* Phase 2: page munlock */
 	pagevec_init(&pvec_putback, 0);
 	for (i = 0; i < nr; i++) {
-- 
1.8.4

