Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaIYBlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:41:23 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43629 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaIYBlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:41:21 -0400
Message-ID: <542372AE.2060606@huawei.com>
Date: Thu, 25 Sep 2014 09:41:02 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Miao Xie" <miaox@cn.fujitsu.com>, Kees Cook <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v4 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be
 atomic flags
References: <54237281.5020308@huawei.com>
In-Reply-To: <54237281.5020308@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # 2.6.31+
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 Documentation/cgroups/cpusets.txt |  6 +++---
 include/linux/cpuset.h            |  4 ++--
 include/linux/sched.h             | 13 +++++++++++--
 kernel/cpuset.c                   |  9 +++++----
 mm/slab.c                         |  4 ++--
 5 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 7740038..3c94ff3 100644
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
index 0d4e067..2f073db 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -94,12 +94,12 @@ extern int cpuset_slab_spread_node(void);
 
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
index 5630763..7b1cafe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1903,8 +1903,6 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
-#define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
-#define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
@@ -1958,6 +1956,9 @@ static inline void memalloc_noio_restore(unsigned int flags)
 
 /* Per-process atomic flags. */
 #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
+#define PFA_SPREAD_PAGE  1      /* Spread page cache over cpuset */
+#define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpuset */
+
 
 #define TASK_PFA_TEST(name, func)					\
 	static inline bool task_##func(struct task_struct *p)		\
@@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
 TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
 TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
 
+TASK_PFA_TEST(SPREAD_PAGE, spread_page)
+TASK_PFA_SET(SPREAD_PAGE, spread_page)
+TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
+
+TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
+TASK_PFA_SET(SPREAD_SLAB, spread_slab)
+TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
+
 /*
  * task->jobctl flags
  */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a37f4ed..1f107c7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -365,13 +365,14 @@ static void cpuset_update_task_spread_flag(struct cpuset *cs,
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
index a467b30..881951e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2994,7 +2994,7 @@ out:
 
 #ifdef CONFIG_NUMA
 /*
- * Try allocating on another node if PF_SPREAD_SLAB is a mempolicy is set.
+ * Try allocating on another node if PFA_SPREAD_SLAB is a mempolicy is set.
  *
  * If we are in_interrupt, then process context, including cpusets and
  * mempolicy, may not apply and should not be used for allocation policy.
@@ -3226,7 +3226,7 @@ __do_cache_alloc(struct kmem_cache *cache, gfp_t flags)
 {
 	void *objp;
 
-	if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
+	if (current->mempolicy || cpuset_do_slab_mem_spread()) {
 		objp = alternate_node_alloc(cache, flags);
 		if (objp)
 			goto out;
-- 
1.8.0.2

