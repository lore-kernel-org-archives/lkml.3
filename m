Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaCMPLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:11:46 -0400
Received: from relay.parallels.com ([195.214.232.42]:56628 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaCMPGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:06:55 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH RESEND -mm 01/12] memcg: flush cache creation works before memcg cache destruction
Date: Thu, 13 Mar 2014 19:06:39 +0400
Message-ID: <4cccfcf74595f26532a6dda7264dc420df82fb8a.1394708827.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1394708827.git.vdavydov@parallels.com>
References: <cover.1394708827.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we get to memcg cache destruction, either from the root cache
destruction path or when turning memcg offline, there still might be
memcg cache creation works pending that was scheduled before we
initiated destruction. We need to flush them before starting to destroy
memcg caches, otherwise we can get a leaked kmem cache or, even worse,
an attempt to use after free.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
---
 mm/memcontrol.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9d489a9e7701..b183aaf1b616 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2904,6 +2904,7 @@ static DEFINE_MUTEX(set_limit_mutex);
 
 #ifdef CONFIG_MEMCG_KMEM
 static DEFINE_MUTEX(activate_kmem_mutex);
+static struct workqueue_struct *memcg_cache_create_wq;
 
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
@@ -3327,6 +3328,15 @@ int __kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 	int i, failed = 0;
 
 	/*
+	 * Since the cache is being destroyed, it shouldn't be allocated from
+	 * any more, and therefore no new memcg cache creation works could be
+	 * scheduled. However, there still might be pending works scheduled
+	 * before the cache destruction was initiated. Flush them before
+	 * destroying child caches to avoid nasty races.
+	 */
+	flush_workqueue(memcg_cache_create_wq);
+
+	/*
 	 * If the cache is being destroyed, we trust that there is no one else
 	 * requesting objects from it. Even if there are, the sanity checks in
 	 * kmem_cache_destroy should caught this ill-case.
@@ -3374,6 +3384,15 @@ static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
 	if (!memcg_kmem_is_active(memcg))
 		return;
 
+	/*
+	 * By the time we get here, the cgroup must be empty. That said no new
+	 * allocations can happen from its caches, and therefore no new memcg
+	 * cache creation works can be scheduled. However, there still might be
+	 * pending works scheduled before the cgroup was turned offline. Flush
+	 * them before destroying memcg caches to avoid nasty races.
+	 */
+	flush_workqueue(memcg_cache_create_wq);
+
 	mutex_lock(&memcg->slab_caches_mutex);
 	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
@@ -3418,7 +3437,7 @@ static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
 	cw->cachep = cachep;
 
 	INIT_WORK(&cw->work, memcg_create_cache_work_func);
-	schedule_work(&cw->work);
+	queue_work(memcg_cache_create_wq, &cw->work);
 }
 
 static void memcg_create_cache_enqueue(struct mem_cgroup *memcg,
@@ -3621,10 +3640,20 @@ void __memcg_kmem_uncharge_pages(struct page *page, int order)
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 	memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
 }
+
+static void __init memcg_kmem_init(void)
+{
+	memcg_cache_create_wq = alloc_workqueue("memcg_cache_create", 0, 1);
+	BUG_ON(!memcg_cache_create_wq);
+}
 #else
 static inline void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
 {
 }
+
+static void __init memcg_kmem_init(void)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -7181,6 +7210,7 @@ static int __init mem_cgroup_init(void)
 	enable_swap_cgroup();
 	mem_cgroup_soft_limit_tree_init();
 	memcg_stock_init();
+	memcg_kmem_init();
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
-- 
1.7.10.4

