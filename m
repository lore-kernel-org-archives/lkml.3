Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbbA1Btc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:49:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341AbbA1Bif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>, Theodore Tso <tytso@mit.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 60/77] mm: do not use unnecessary atomic operations when adding pages to the LRU
Date: Tue, 27 Jan 2015 17:27:38 -0800
Message-Id: <20150128012747.767246625@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 6fb81a17d21f2a138b8f424af4cf379f2b694060 upstream.

When adding pages to the LRU we clear the active bit unconditionally.
As the page could be reachable from other paths we cannot use unlocked
operations without risk of corruption such as a parallel
mark_page_accessed.  This patch tests if is necessary to clear the
active flag before using an atomic operation.  This potentially opens a
tiny race when PageActive is checked as mark_page_accessed could be
called after PageActive was checked.  The race already exists but this
patch changes it slightly.  The consequence is that that the page may be
promoted to the active list that might have been left on the inactive
list before the patch.  It's too tiny a race and too marginal a
consequence to always use atomic operations for.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/swap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/swap.c
+++ b/mm/swap.c
@@ -597,13 +597,15 @@ static void __lru_cache_add(struct page
  */
 void lru_cache_add_anon(struct page *page)
 {
-	ClearPageActive(page);
+	if (PageActive(page))
+		ClearPageActive(page);
 	__lru_cache_add(page);
 }
 
 void lru_cache_add_file(struct page *page)
 {
-	ClearPageActive(page);
+	if (PageActive(page))
+		ClearPageActive(page);
 	__lru_cache_add(page);
 }
 EXPORT_SYMBOL(lru_cache_add_file);


