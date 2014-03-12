Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbaCLB27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:28:59 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33941 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaCLB24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:28:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 3/8] mm: memcg: inline mem_cgroup_charge_common()
Date: Tue, 11 Mar 2014 21:28:29 -0400
Message-Id: <1394587714-6966-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_charge_common() is used by both cache and anon pages, but
most of its body only applies to anon pages and the remainder is not
worth having in a separate function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abdfab957ad..cfdb9c385d8d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3919,20 +3919,21 @@ out:
 	return ret;
 }
 
-/*
- * Charge the memory controller for page usage.
- * Return
- * 0 if the charge was successful
- * < 0 if the cgroup is over its limit
- */
-static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask, enum charge_type ctype)
+int mem_cgroup_newpage_charge(struct page *page,
+			      struct mm_struct *mm, gfp_t gfp_mask)
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	bool oom = true;
 	int ret;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
+	VM_BUG_ON_PAGE(page_mapped(page), page);
+	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
+	VM_BUG_ON(!mm);
+
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
@@ -3946,22 +3947,11 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, ctype, false);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages,
+				   MEM_CGROUP_CHARGE_TYPE_ANON, false);
 	return 0;
 }
 
-int mem_cgroup_newpage_charge(struct page *page,
-			      struct mm_struct *mm, gfp_t gfp_mask)
-{
-	if (mem_cgroup_disabled())
-		return 0;
-	VM_BUG_ON_PAGE(page_mapped(page), page);
-	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
-	VM_BUG_ON(!mm);
-	return mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_ANON);
-}
-
 /*
  * While swap-in, try_charge -> commit or cancel, the page is locked.
  * And when try_charge() successfully returns, one refcnt to memcg without
@@ -4079,9 +4069,11 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 	if (PageCompound(page))
 		return 0;
 
-	if (!PageSwapCache(page))
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
-	else { /* page is swapcache/shmem */
+	if (!PageSwapCache(page)) {
+		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
+		if (ret != -ENOMEM)
+			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
+	} else { /* page is swapcache/shmem */
 		ret = __mem_cgroup_try_charge_swapin(mm, page,
 						     gfp_mask, &memcg);
 		if (!ret)
-- 
1.9.0

