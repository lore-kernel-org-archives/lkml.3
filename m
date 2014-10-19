Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaJSPbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:31:40 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42269 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaJSPb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:31:27 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: update mem_cgroup_page_lruvec() documentation
Date: Sun, 19 Oct 2014 11:30:16 -0400
Message-Id: <1413732616-15962-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

7512102cf64d ("memcg: fix GPF when cgroup removal races with last
exit") added a pc->mem_cgroup reset into mem_cgroup_page_lruvec() to
prevent a crash where an anon page gets uncharged on unmap, the memcg
is released, and then the final LRU isolation on free dereferences the
stale pc->mem_cgroup pointer.

But since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API"), pages
are only uncharged AFTER that final LRU isolation, which guarantees
the memcg's lifetime until then.  pc->mem_cgroup now only needs to be
reset for swapcache readahead pages.

Update the comment and callsite requirements accordingly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3a203c7ec6c7..fc1d7ca96b9d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1262,9 +1262,13 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
 }
 
 /**
- * mem_cgroup_page_lruvec - return lruvec for adding an lru page
+ * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
  * @zone: zone of the page
+ *
+ * This function is only safe when following the LRU page isolation
+ * and putback protocol: the LRU lock must be held, and the page must
+ * either be PageLRU() or the caller must have isolated/allocated it.
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
 {
@@ -1282,13 +1286,9 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
 	memcg = pc->mem_cgroup;
 
 	/*
-	 * Surreptitiously switch any uncharged offlist page to root:
-	 * an uncharged page off lru does nothing to secure
-	 * its former mem_cgroup from sudden removal.
-	 *
-	 * Our caller holds lru_lock, and PageCgroupUsed is updated
-	 * under page_cgroup lock: between them, they make all uses
-	 * of pc->mem_cgroup safe.
+	 * Swapcache readahead pages are added to the LRU - and
+	 * possibly migrated - before they are charged.  Ensure
+	 * pc->mem_cgroup is sane.
 	 */
 	if (!PageLRU(page) && !PageCgroupUsed(pc) && memcg != root_mem_cgroup)
 		pc->mem_cgroup = memcg = root_mem_cgroup;
-- 
2.1.2

