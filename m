Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaAOQXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:23:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42141 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaAOQXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:23:01 -0500
Date: Wed, 15 Jan 2014 17:22:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, raistlin@linux.it, juri.lelli@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: [RFC][PATCH] sched: Move SCHED_RESET_ON_FORK into attr::sched_flags
Message-ID: <20140115162242.GJ31570@twins.programming.kicks-ass.net>
References: <1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
 <tip-d50dde5a10f305253cbc3855307f608f8a3c5f73@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d50dde5a10f305253cbc3855307f608f8a3c5f73@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Does something like the below make sense to you guys?

---
Subject: sched: Move SCHED_RESET_ON_FORK into attr::sched_flags
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Jan 15 17:05:04 CET 2014

I noticed the new sched_{set,get}attr() calls didn't properly deal
with the SCHED_RESET_ON_FORK hack.

Instead of propagating the flags in high bits nonsense use the brand
spanking new attr::sched_flags field.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-h96ck1ivcs35jbpcnuwyu5fr@git.kernel.org
---
 include/uapi/linux/sched.h |    5 +++++
 kernel/sched/core.c        |   42 ++++++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 14 deletions(-)

--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -40,8 +40,13 @@
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
 #define SCHED_DEADLINE		6
+
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
 
+/*
+ * For the sched_{set,get}attr() calls
+ */
+#define SCHED_FLAG_RESET_ON_FORK	0x01
 
 #endif /* _UAPI_LINUX_SCHED_H */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3267,8 +3267,7 @@ static int __sched_setscheduler(struct t
 		reset_on_fork = p->sched_reset_on_fork;
 		policy = oldpolicy = p->policy;
 	} else {
-		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
-		policy &= ~SCHED_RESET_ON_FORK;
+		reset_on_fork = !!(attr->sched_flags & SCHED_FLAG_RESET_ON_FORK);
 
 		if (policy != SCHED_DEADLINE &&
 				policy != SCHED_FIFO && policy != SCHED_RR &&
@@ -3277,6 +3276,9 @@ static int __sched_setscheduler(struct t
 			return -EINVAL;
 	}
 
+	if (attr->sched_flags & ~(SCHED_FLAG_RESET_ON_FORK))
+		return -EINVAL;
+
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
@@ -3444,6 +3446,26 @@ static int __sched_setscheduler(struct t
 	return 0;
 }
 
+static int _sched_setscheduler(struct task_struct *p, int policy,
+			       const struct sched_param *param, bool check)
+{
+	struct sched_attr attr = {
+		.sched_policy   = policy,
+		.sched_priority = param->sched_priority,
+		.sched_nice	= PRIO_TO_NICE(p->static_prio),
+	};
+
+	/*
+	 * Fixup the legacy SCHED_RESET_ON_FORK hack
+	 */
+	if (policy & SCHED_RESET_ON_FORK) {
+		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
+		policy &= ~SCHED_RESET_ON_FORK;
+		attr.sched_policy = policy;
+	}
+
+	return __sched_setscheduler(p, &attr, check);
+}
 /**
  * sched_setscheduler - change the scheduling policy and/or RT priority of a thread.
  * @p: the task in question.
@@ -3457,12 +3479,7 @@ static int __sched_setscheduler(struct t
 int sched_setscheduler(struct task_struct *p, int policy,
 		       const struct sched_param *param)
 {
-	struct sched_attr attr = {
-		.sched_policy   = policy,
-		.sched_priority = param->sched_priority,
-		.sched_nice	= PRIO_TO_NICE(p->static_prio),
-	};
-	return __sched_setscheduler(p, &attr, true);
+	return _sched_setscheduler(p, policy, param, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
 
@@ -3488,12 +3505,7 @@ EXPORT_SYMBOL_GPL(sched_setattr);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
 {
-	struct sched_attr attr = {
-		.sched_policy   = policy,
-		.sched_priority = param->sched_priority,
-		.sched_nice	= PRIO_TO_NICE(p->static_prio),
-	};
-	return __sched_setscheduler(p, &attr, false);
+	return _sched_setscheduler(p, policy, param, false);
 }
 
 static int
@@ -3793,6 +3805,8 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pi
 		goto out_unlock;
 
 	attr.sched_policy = p->policy;
+	if (p->sched_reset_on_fork)
+		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
 	if (task_has_dl_policy(p))
 		__getparam_dl(p, &attr);
 	else if (task_has_rt_policy(p))
