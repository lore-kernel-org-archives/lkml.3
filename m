Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaH1TCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:02:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbaH1SgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:25 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 36/97] mm: optimize put_mems_allowed() usage
Date: Thu, 28 Aug 2014 19:34:44 +0100
Message-Id: <1409250945-30874-37-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d26914d11751b23ca2e8747725f2cae10c2f2c1b upstream.

Since put_mems_allowed() is strictly optional, its a seqcount retry, we
don't need to evaluate the function if the allocation was in fact
successful, saving a smp_rmb some loads and comparisons on some relative
fast-paths.

Since the naming, get/put_mems_allowed() does suggest a mandatory
pairing, rename the interface, as suggested by Mel, to resemble the
seqcount interface.

This gives us: read_mems_allowed_begin() and read_mems_allowed_retry(),
where it is important to note that the return value of the latter call
is inverted from its previous incarnation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/cpuset.h | 27 ++++++++++++++-------------
 kernel/cpuset.c        |  2 +-
 mm/filemap.c           |  4 ++--
 mm/hugetlb.c           |  4 ++--
 mm/mempolicy.c         | 12 ++++++------
 mm/page_alloc.c        |  8 ++++----
 mm/slab.c              |  4 ++--
 mm/slub.c              | 16 +++++++---------
 8 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index cc1b01c..6f30672 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -87,25 +87,26 @@ extern void rebuild_sched_domains(void);
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
 /*
- * get_mems_allowed is required when making decisions involving mems_allowed
- * such as during page allocation. mems_allowed can be updated in parallel
- * and depending on the new value an operation can fail potentially causing
- * process failure. A retry loop with get_mems_allowed and put_mems_allowed
- * prevents these artificial failures.
+ * read_mems_allowed_begin is required when making decisions involving
+ * mems_allowed such as during page allocation. mems_allowed can be updated in
+ * parallel and depending on the new value an operation can fail potentially
+ * causing process failure. A retry loop with read_mems_allowed_begin and
+ * read_mems_allowed_retry prevents these artificial failures.
  */
-static inline unsigned int get_mems_allowed(void)
+static inline unsigned int read_mems_allowed_begin(void)
 {
 	return read_seqcount_begin(&current->mems_allowed_seq);
 }
 
 /*
- * If this returns false, the operation that took place after get_mems_allowed
- * may have failed. It is up to the caller to retry the operation if
+ * If this returns true, the operation that took place after
+ * read_mems_allowed_begin may have failed artificially due to a concurrent
+ * update of mems_allowed. It is up to the caller to retry the operation if
  * appropriate.
  */
-static inline bool put_mems_allowed(unsigned int seq)
+static inline bool read_mems_allowed_retry(unsigned int seq)
 {
-	return !read_seqcount_retry(&current->mems_allowed_seq, seq);
+	return read_seqcount_retry(&current->mems_allowed_seq, seq);
 }
 
 static inline void set_mems_allowed(nodemask_t nodemask)
@@ -221,14 +222,14 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 {
 }
 
-static inline unsigned int get_mems_allowed(void)
+static inline unsigned int read_mems_allowed_begin(void)
 {
 	return 0;
 }
 
-static inline bool put_mems_allowed(unsigned int seq)
+static inline bool read_mems_allowed_retry(unsigned int seq)
 {
-	return true;
+	return false;
 }
 
 #endif /* !CONFIG_CPUSETS */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0b29c52..15ae2b7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1022,7 +1022,7 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
 	task_lock(tsk);
 	/*
 	 * Determine if a loop is necessary if another thread is doing
-	 * get_mems_allowed().  If at least one node remains unchanged and
+	 * read_mems_allowed_begin().  If at least one node remains unchanged and
 	 * tsk does not have a mempolicy, then an empty nodemask will not be
 	 * possible when mems_allowed is larger than a word.
 	 */
diff --git a/mm/filemap.c b/mm/filemap.c
index ae4846f..df13a9b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -520,10 +520,10 @@ struct page *__page_cache_alloc(gfp_t gfp)
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
 		do {
-			cpuset_mems_cookie = get_mems_allowed();
+			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
 			page = alloc_pages_exact_node(n, gfp, 0);
-		} while (!put_mems_allowed(cpuset_mems_cookie) && !page);
+		} while (!page && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return page;
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2814ca8..11e679b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -574,7 +574,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 		goto err;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = huge_zonelist(vma, address,
 					htlb_alloc_mask(h), &mpol, &nodemask);
 
@@ -596,7 +596,7 @@ retry_cpuset:
 	}
 
 	mpol_cond_put(mpol);
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0437f35..0bf6476 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1873,7 +1873,7 @@ int node_random(const nodemask_t *maskp)
  * If the effective policy is 'BIND, returns a pointer to the mempolicy's
  * @nodemask for filtering the zonelist.
  *
- * Must be protected by get_mems_allowed()
+ * Must be protected by read_mems_allowed_begin()
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 				gfp_t gfp_flags, struct mempolicy **mpol,
@@ -2037,7 +2037,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 
 retry_cpuset:
 	pol = get_vma_policy(current, vma, addr);
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
@@ -2045,7 +2045,7 @@ retry_cpuset:
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 			goto retry_cpuset;
 
 		return page;
@@ -2055,7 +2055,7 @@ retry_cpuset:
 				      policy_nodemask(gfp, pol));
 	if (unlikely(mpol_needs_cond_ref(pol)))
 		__mpol_put(pol);
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 }
@@ -2089,7 +2089,7 @@ struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 		pol = &default_policy;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/*
 	 * No reference counting needed for current->mempolicy
@@ -2102,7 +2102,7 @@ retry_cpuset:
 				policy_zonelist(gfp, pol, numa_node_id()),
 				policy_nodemask(gfp, pol));
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	return page;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c34b582..74bf3e0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2711,7 +2711,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 		return NULL;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/* The preferred zone is used for statistics later */
 	first_zones_zonelist(zonelist, high_zoneidx,
@@ -2766,7 +2766,7 @@ out:
 	 * the mask is being updated. If a page allocation is about to fail,
 	 * check if the cpuset changed during allocation and if so, retry.
 	 */
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	memcg_kmem_commit_charge(page, memcg, order);
@@ -3034,9 +3034,9 @@ bool skip_free_areas_node(unsigned int flags, int nid)
 		goto out;
 
 	do {
-		cpuset_mems_cookie = get_mems_allowed();
+		cpuset_mems_cookie = read_mems_allowed_begin();
 		ret = !node_isset(nid, cpuset_current_mems_allowed);
-	} while (!put_mems_allowed(cpuset_mems_cookie));
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 out:
 	return ret;
 }
diff --git a/mm/slab.c b/mm/slab.c
index 0b4ddaf..eb4078c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3222,7 +3222,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = node_zonelist(slab_node(), flags);
 
 retry:
@@ -3278,7 +3278,7 @@ retry:
 		}
 	}
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !obj))
+	if (unlikely(!obj && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return obj;
 }
diff --git a/mm/slub.c b/mm/slub.c
index 5c1343a..a88d94c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1635,7 +1635,7 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 		return NULL;
 
 	do {
-		cpuset_mems_cookie = get_mems_allowed();
+		cpuset_mems_cookie = read_mems_allowed_begin();
 		zonelist = node_zonelist(slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
@@ -1647,19 +1647,17 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 				object = get_partial_node(s, n, c, flags);
 				if (object) {
 					/*
-					 * Return the object even if
-					 * put_mems_allowed indicated that
-					 * the cpuset mems_allowed was
-					 * updated in parallel. It's a
-					 * harmless race between the alloc
-					 * and the cpuset update.
+					 * Don't check read_mems_allowed_retry()
+					 * here - if mems_allowed was updated in
+					 * parallel, that was a harmless race
+					 * between allocation and the cpuset
+					 * update
 					 */
-					put_mems_allowed(cpuset_mems_cookie);
 					return object;
 				}
 			}
 		}
-	} while (!put_mems_allowed(cpuset_mems_cookie));
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 #endif
 	return NULL;
 }
-- 
1.8.4.5

