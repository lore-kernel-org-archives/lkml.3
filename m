Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaKMJM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:12:57 -0500
Received: from mx2.parallels.com ([199.115.105.18]:56884 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaKMJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:12:53 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 2/2] memcg: turn memcg_kmem_skip_account into a bit field
Date: Thu, 13 Nov 2014 12:12:43 +0300
Message-ID: <f1fc9fefd7f140daadcf33f806fce29a30120fbe.1415868622.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <c07e576c9b76c00fbcc1978f9659bf5b83513d14.1415868622.git.vdavydov@parallels.com>
References: <c07e576c9b76c00fbcc1978f9659bf5b83513d14.1415868622.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't supposed to stack, so turn it into a bit-field to save 4 bytes
on the task_struct.

Also, remove the memcg_stop/resume_kmem_account helpers - it is clearer
to set/clear the flag inline. Regarding the overwhelming comment to the
helpers, which is removed by this patch too, we already have a compact
yet accurate explanation in memcg_schedule_cache_create, no need in yet
another one.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/sched.h |    7 +++++--
 mm/memcontrol.c       |   35 ++---------------------------------
 2 files changed, 7 insertions(+), 35 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ffd1444b087c..8db31ef98d2f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1364,6 +1364,10 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
+#ifdef CONFIG_MEMCG_KMEM
+	unsigned memcg_kmem_skip_account:1;
+#endif
+
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	pid_t pid;
@@ -1679,8 +1683,7 @@ struct task_struct {
 	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
-#ifdef CONFIG_MEMCG /* memcg uses this to do batch job */
-	unsigned int memcg_kmem_skip_account;
+#ifdef CONFIG_MEMCG
 	struct memcg_oom_info {
 		struct mem_cgroup *memcg;
 		gfp_t gfp_mask;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d9fab72da52e..11cbfde4dc6d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2673,37 +2673,6 @@ static void memcg_unregister_cache(struct kmem_cache *cachep)
 	css_put(&memcg->css);
 }
 
-/*
- * During the creation a new cache, we need to disable our accounting mechanism
- * altogether. This is true even if we are not creating, but rather just
- * enqueing new caches to be created.
- *
- * This is because that process will trigger allocations; some visible, like
- * explicit kmallocs to auxiliary data structures, name strings and internal
- * cache structures; some well concealed, like INIT_WORK() that can allocate
- * objects during debug.
- *
- * If any allocation happens during memcg_kmem_get_cache, we will recurse back
- * to it. This may not be a bounded recursion: since the first cache creation
- * failed to complete (waiting on the allocation), we'll just try to create the
- * cache again, failing at the same point.
- *
- * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
- * memcg_kmem_skip_account. So we enclose anything that might allocate memory
- * inside the following two functions.
- */
-static inline void memcg_stop_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account++;
-}
-
-static inline void memcg_resume_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account--;
-}
-
 int __memcg_cleanup_cache_params(struct kmem_cache *s)
 {
 	struct kmem_cache *c;
@@ -2798,9 +2767,9 @@ static void memcg_schedule_register_cache(struct mem_cgroup *memcg,
 	 * this point we can't allow ourselves back into memcg_kmem_get_cache,
 	 * the safest choice is to do it like this, wrapping the whole function.
 	 */
-	memcg_stop_kmem_account();
+	current->memcg_kmem_skip_account = 1;
 	__memcg_schedule_register_cache(memcg, cachep);
-	memcg_resume_kmem_account();
+	current->memcg_kmem_skip_account = 0;
 }
 
 int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order)
-- 
1.7.10.4

