Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaBJNdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:33:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaBJNdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:33:01 -0500
Date: Mon, 10 Feb 2014 05:32:09 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-d0ea026808ad81de2af14938448419a95211b938@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <1390878045-7096-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1390878045-7096-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Implement task_nice()
  as static inline function
Git-Commit-ID: d0ea026808ad81de2af14938448419a95211b938
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:32:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0ea026808ad81de2af14938448419a95211b938
Gitweb:     http://git.kernel.org/tip/d0ea026808ad81de2af14938448419a95211b938
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 27 Jan 2014 22:00:45 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:28:23 +0100

sched: Implement task_nice() as static inline function

As patch "sched: Move the priority specific bits into a new header file" exposes
the priority related macros in linux/sched/prio.h, we don't have to implement
task_nice() in kernel/sched/core.c any more.

This patch implements it in linux/sched/sched.h as static inline function,
saving the kernel stack and enhancing performance a bit.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: clark.williams@gmail.com
Cc: rostedt@goodmis.org
Cc: raistlin@linux.it
Cc: juri.lelli@gmail.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1390878045-7096-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h      | 11 ++++++++++-
 include/linux/sched/prio.h |  1 -
 kernel/sched/core.c        | 26 +++++++-------------------
 kernel/sched/cputime.c     |  4 ++--
 4 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d97d0a8..e3d5564 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2094,7 +2094,16 @@ static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
-extern int task_nice(const struct task_struct *p);
+/**
+ * task_nice - return the nice value of a given task.
+ * @p: the task in question.
+ *
+ * Return: The nice value [ -20 ... 0 ... 19 ].
+ */
+static inline int task_nice(const struct task_struct *p)
+{
+	return PRIO_TO_NICE((p)->static_prio);
+}
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 13216f1..410ccb7 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -27,7 +27,6 @@
  */
 #define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
 #define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
-#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
 
 /*
  * 'User priority' is the nice value converted to something we
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 210a12a..104c816 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3000,7 +3000,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	unsigned long flags;
 	struct rq *rq;
 
-	if (TASK_NICE(p) == nice || nice < -20 || nice > 19)
+	if (task_nice(p) == nice || nice < -20 || nice > 19)
 		return;
 	/*
 	 * We have to be careful, if called from sys_setpriority(),
@@ -3078,7 +3078,7 @@ SYSCALL_DEFINE1(nice, int, increment)
 	if (increment > 40)
 		increment = 40;
 
-	nice = TASK_NICE(current) + increment;
+	nice = task_nice(current) + increment;
 	if (nice < -20)
 		nice = -20;
 	if (nice > 19)
@@ -3111,18 +3111,6 @@ int task_prio(const struct task_struct *p)
 }
 
 /**
- * task_nice - return the nice value of a given task.
- * @p: the task in question.
- *
- * Return: The nice value [ -20 ... 0 ... 19 ].
- */
-int task_nice(const struct task_struct *p)
-{
-	return TASK_NICE(p);
-}
-EXPORT_SYMBOL(task_nice);
-
-/**
  * idle_cpu - is a given cpu idle currently?
  * @cpu: the processor in question.
  *
@@ -3321,7 +3309,7 @@ recheck:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (fair_policy(policy)) {
-			if (attr->sched_nice < TASK_NICE(p) &&
+			if (attr->sched_nice < task_nice(p) &&
 			    !can_nice(p, attr->sched_nice))
 				return -EPERM;
 		}
@@ -3345,7 +3333,7 @@ recheck:
 		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
 		 */
 		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
-			if (!can_nice(p, TASK_NICE(p)))
+			if (!can_nice(p, task_nice(p)))
 				return -EPERM;
 		}
 
@@ -3385,7 +3373,7 @@ recheck:
 	 * If not changing anything there's no need to proceed further:
 	 */
 	if (unlikely(policy == p->policy)) {
-		if (fair_policy(policy) && attr->sched_nice != TASK_NICE(p))
+		if (fair_policy(policy) && attr->sched_nice != task_nice(p))
 			goto change;
 		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
 			goto change;
@@ -3837,7 +3825,7 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 	else if (task_has_rt_policy(p))
 		attr.sched_priority = p->rt_priority;
 	else
-		attr.sched_nice = TASK_NICE(p);
+		attr.sched_nice = task_nice(p);
 
 	rcu_read_unlock();
 
@@ -7010,7 +6998,7 @@ void normalize_rt_tasks(void)
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
 			 */
-			if (TASK_NICE(p) < 0 && p->mm)
+			if (task_nice(p) < 0 && p->mm)
 				set_user_nice(p, 0);
 			continue;
 		}
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9994791..58624a6 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -142,7 +142,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
 
-	index = (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
+	index = (task_nice(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
 
 	/* Add user time to cpustat. */
 	task_group_account_field(p, index, (__force u64) cputime);
@@ -169,7 +169,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	p->gtime += cputime;
 
 	/* Add guest time to cpustat. */
-	if (TASK_NICE(p) > 0) {
+	if (task_nice(p) > 0) {
 		cpustat[CPUTIME_NICE] += (__force u64) cputime;
 		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
 	} else {
