Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaIVDxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:53:09 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:61396 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaIVDxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:53:07 -0400
Message-ID: <541F9CEA.8090905@huawei.com>
Date: Mon, 22 Sep 2014 11:52:10 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic
 flags
References: <541F9C96.10705@huawei.com>
In-Reply-To: <541F9C96.10705@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.541F9CEF.0078,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 0ed955da02e2758e1a51d72eb8bf1da0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we change cpuset.memory_spread_{page,slab}, cpuset will flip
PF_SPREAD_{PAGE,SLAB} bit of tsk->flags for each task in that cpuset.
This should be done using atomic bitops, but currently we don't,
which is broken.

Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend
when one thread tried to clear PF_USED_MATH while at the same time another
thread tried to flip PF_SPREAD_PAGE/PF_SPREAD_SLAB. They both operate on
the same task.

Here's the full report:
https://lkml.org/lkml/2014/9/19/230

To fix this, we make PF_SPREAD_PAGE and PF_SPARED_SLAB atomic flags.

Fixes: 950592f7b991 ("cpusets: update tasks' page/slab spread flags in time")
Cc: <stable@vger.kernel.org> # 2.6.31+
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/cpuset.h | 4 ++--
 include/linux/sched.h  | 6 ++++--
 kernel/cpuset.c        | 9 +++++----
 3 files changed, 11 insertions(+), 8 deletions(-)

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
index 04a2ae2..ee634d1 100644
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
@@ -1958,6 +1956,8 @@ static inline void memalloc_noio_restore(unsigned int flags)
 
 /* Per-process atomic flags. */
 #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
+#define PFA_SPREAD_PAGE  1      /* Spread page cache over cpuset */
+#define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpuset */
 
 #define TASK_PFA_BITOPS(name, func)				\
 static inline bool task_##func(struct task_struct *p)		\
@@ -1970,6 +1970,8 @@ static inline void task_clear_##func(struct task_struct *p)	\
 { clear_bit(PFA_##name, &p->atomic_flags); }
 
 TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)
+TASK_PFA_BITOPS(SPREAD_PAGE, spread_page)
+TASK_PFA_BITOPS(SPREAD_SLAB, spread_slab)
 
 /*
  * task->jobctl flags
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
-- 
1.8.0.2

