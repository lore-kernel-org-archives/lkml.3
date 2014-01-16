Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaAPSdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:33:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44689 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaAPSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:33:14 -0500
Date: Thu, 16 Jan 2014 19:33:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Fix __sched_setscheduler() nice test
Message-ID: <20140116183305.GB9481@laptop.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115120418.GD31570@twins.programming.kicks-ass.net>
 <52D7E343.40909@linaro.org>
 <20140116141743.GT31570@twins.programming.kicks-ass.net>
 <52D7EAA4.2080208@linaro.org>
 <20140116142546.GU31570@twins.programming.kicks-ass.net>
 <52D7ED0A.2030502@linaro.org>
 <20140116154239.GR7572@laptop.programming.kicks-ass.net>
 <52D7FFCE.1030108@linaro.org>
 <20140116165425.GA9481@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116165425.GA9481@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I tried to make can_nice() do what I thought it did; but I'm not sure
the result is worth the effort.

Also, binder seems to use can_nice() -- but I really couldn't be arsed
to look at it.

---

Index: linux-2.6/kernel/sched/auto_group.c
===================================================================
--- linux-2.6.orig/kernel/sched/auto_group.c
+++ linux-2.6/kernel/sched/auto_group.c
@@ -210,7 +210,7 @@ int proc_sched_autogroup_set_nice(struct
 	if (err)
 		return err;
 
-	if (nice < 0 && !can_nice(current, nice))
+	if (!can_nice(current, nice))
 		return -EPERM;
 
 	/* this is a heavy operation taking global locks.. */
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -3017,17 +3017,22 @@ void set_user_nice(struct task_struct *p
 EXPORT_SYMBOL(set_user_nice);
 
 /*
- * can_nice - check if a task can reduce its nice value
+ * can_nice - check if a task can change its nice value
  * @p: task
  * @nice: nice value
  */
-int can_nice(const struct task_struct *p, const int nice)
+bool can_nice(const struct task_struct *p, const int nice)
 {
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
 	int nice_rlim = 20 - nice;
 
-	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
-		capable(CAP_SYS_NICE));
+	if (nice >= TASK_NICE(p))
+		return true;
+
+	if (nice_rlim <= task_rlimit(p, RLIMIT_NICE) || capable(CAP_SYS_NICE))
+		return true;
+
+	return false;
 }
 
 #ifdef __ARCH_WANT_SYS_NICE
@@ -3059,7 +3064,7 @@ SYSCALL_DEFINE1(nice, int, increment)
 	if (nice > 19)
 		nice = 19;
 
-	if (increment < 0 && !can_nice(current, nice))
+	if (!can_nice(current, nice))
 		return -EPERM;
 
 	retval = security_task_setnice(current, nice);
@@ -3296,8 +3301,7 @@ static int __sched_setscheduler(struct t
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (fair_policy(policy)) {
-			if (attr->sched_nice < TASK_NICE(p) &&
-			    !can_nice(p, attr->sched_nice))
+			if (!can_nice(p, attr->sched_nice))
 				return -EPERM;
 		}
 
@@ -3320,8 +3324,18 @@ static int __sched_setscheduler(struct t
 		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
 		 */
 		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
-			if (!can_nice(p, TASK_NICE(p)))
-				return -EPERM;
+			int static_prio = p->static_prio;
+			int err = 0;
+
+			p->static_prio = NICE_TO_PRIO(20);
+
+			if (!can_nice(p, PRIO_TO_NICE(static_prio)))
+				err = -EPERM;
+
+			p->static_prio = static_prio;
+
+			if (err)
+				return err;
 		}
 
 		/* can't change other user's priorities */
Index: linux-2.6/kernel/sys.c
===================================================================
--- linux-2.6.orig/kernel/sys.c
+++ linux-2.6/kernel/sys.c
@@ -144,7 +144,7 @@ static int set_one_prio(struct task_stru
 		error = -EPERM;
 		goto out;
 	}
-	if (niceval < task_nice(p) && !can_nice(p, niceval)) {
+	if (!can_nice(p, niceval)) {
 		error = -EACCES;
 		goto out;
 	}
