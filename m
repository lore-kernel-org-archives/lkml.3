Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaK0I5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:57:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:42431 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbaK0ItP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:15 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zefan Li <lizefan@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.4 64/91] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic flags
Date: Thu, 27 Nov 2014 16:42:47 +0800
Message-Id: <1417077794-9299-64-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zefan Li <lizefan@huawei.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2ad654bc5e2b211e92f66da1d819e47d79a866f0 upstream.

When we change cpuset.memory_spread_{page,slab}, cpuset will flip
PF_SPREAD_{PAGE,SLAB} bit of tsk->flags for each task in that cpuset.
This should be done using atomic bitops, but currently we don't,
which is broken.

Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happened
when one thread tried to clear PF_USED_MATH while at the same time another
thread tried to flip PF_SPREAD_PAGE/PF_SPREAD_SLAB. They both operate on
the same task.

Here's the full report:
https://lkml.org/lkml/2014/9/19/230

To fix this, we make PF_SPREAD_PAGE and PF_SPREAD_SLAB atomic flags.

v4:
- updated mm/slab.c. (Fengguang Wu)
- updated Documentation.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Fixes: 950592f7b991 ("cpusets: update tasks' page/slab spread flags in time")
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Zefan Li <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[lizf: Backported to 3.4:
 - adjust context
 - check current->flags & PF_MEMPOLICY rather than current->mempolicy]
---
 Documentation/cgroups/cpusets.txt |  6 +++---
 include/linux/cpuset.h            |  4 ++--
 include/linux/sched.h             | 12 ++++++++++--
 kernel/cpuset.c                   |  9 +++++----
 mm/slab.c                         |  4 ++--
 5 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index cefd3d8..a52a39f 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -345,14 +345,14 @@ the named feature on.
 The implementation is simple.
 
 Setting the flag 'cpuset.memory_spread_page' turns on a per-process flag
-PF_SPREAD_PAGE for each task that is in that cpuset or subsequently
+PFA_SPREAD_PAGE for each task that is in that cpuset or subsequently
 joins that cpuset.  The page allocation calls for the page cache
-is modified to perform an inline check for this PF_SPREAD_PAGE task
+is modified to perform an inline check for this PFA_SPREAD_PAGE task
 flag, and if set, a call to a new routine cpuset_mem_spread_node()
 returns the node to prefer for the allocation.
 
 Similarly, setting 'cpuset.memory_spread_slab' turns on the flag
-PF_SPREAD_SLAB, and appropriately marked slab caches will allocate
+PFA_SPREAD_SLAB, and appropriately marked slab caches will allocate
 pages from the node returned by cpuset_mem_spread_node().
 
 The cpuset_mem_spread_node() routine is also simple.  It uses the
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 668f66b..bb48be7 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -74,12 +74,12 @@ extern int cpuset_slab_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
 {
-	return current->flags & PF_SPREAD_PAGE;
+	return task_spread_page(current);
 }
 
 static inline int cpuset_do_slab_mem_spread(void)
 {
-	return current->flags & PF_SPREAD_SLAB;
+	return task_spread_slab(current);
 }
 
 extern int current_cpuset_is_being_rebound(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b85b719..56d8233 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1834,8 +1834,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
-#define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
-#define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
@@ -1868,6 +1866,8 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define used_math() tsk_used_math(current)
 
 /* Per-process atomic flags. */
+#define PFA_SPREAD_PAGE  1      /* Spread page cache over cpuset */
+#define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpuset */
 
 #define TASK_PFA_TEST(name, func)					\
 	static inline bool task_##func(struct task_struct *p)		\
@@ -1970,6 +1970,14 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 }
 #endif
 
+TASK_PFA_TEST(SPREAD_PAGE, spread_page)
+TASK_PFA_SET(SPREAD_PAGE, spread_page)
+TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
+
+TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
+TASK_PFA_SET(SPREAD_SLAB, spread_slab)
+TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
+
 /*
  * Do not use outside of architecture code which knows its limitations.
  *
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9cb82b9..7f3bde5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -326,13 +326,14 @@ static void cpuset_update_task_spread_flag(struct cpuset *cs,
 					struct task_struct *tsk)
 {
 	if (is_spread_page(cs))
-		tsk->flags |= PF_SPREAD_PAGE;
+		task_set_spread_page(tsk);
 	else
-		tsk->flags &= ~PF_SPREAD_PAGE;
+		task_clear_spread_page(tsk);
+
 	if (is_spread_slab(cs))
-		tsk->flags |= PF_SPREAD_SLAB;
+		task_set_spread_slab(tsk);
 	else
-		tsk->flags &= ~PF_SPREAD_SLAB;
+		task_clear_spread_slab(tsk);
 }
 
 /*
diff --git a/mm/slab.c b/mm/slab.c
index 3eb1c38..3714dd9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3321,7 +3321,7 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 
 #ifdef CONFIG_NUMA
 /*
- * Try allocating on another node if PF_SPREAD_SLAB|PF_MEMPOLICY.
+ * Try allocating on another node if PFA_SPREAD_SLAB|PF_MEMPOLICY.
  *
  * If we are in_interrupt, then process context, including cpusets and
  * mempolicy, may not apply and should not be used for allocation policy.
@@ -3562,7 +3562,7 @@ __do_cache_alloc(struct kmem_cache *cache, gfp_t flags)
 {
 	void *objp;
 
-	if (unlikely(current->flags & (PF_SPREAD_SLAB | PF_MEMPOLICY))) {
+	if (unlikely((current->flags & PF_MEMPOLICY) || cpuset_do_slab_mem_spread())) {
 		objp = alternate_node_alloc(cache, flags);
 		if (objp)
 			goto out;
-- 
1.9.1

