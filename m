Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaH1Sqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:46:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaH1ShM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:12 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 82/97] mm: do not use unnecessary atomic operations when adding pages to the LRU
Date: Thu, 28 Aug 2014 19:35:30 +0100
Message-Id: <1409250945-30874-83-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 mm/swap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index afeabe3..270b520 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -565,13 +565,15 @@ static void __lru_cache_add(struct page *page)
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
-- 
1.8.4.5

