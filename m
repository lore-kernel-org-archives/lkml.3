Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaAPNlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:41:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaAPNlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:41:31 -0500
Date: Thu, 16 Jan 2014 05:40:50 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-7479f3c9cf67edf5e8a76b21ea3726757f35cf53@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, raistlin@linux.it,
        juri.lelli@gmail.com
In-Reply-To: <20140115162242.GJ31570@twins.programming.kicks-ass.net>
References: <20140115162242.GJ31570@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move SCHED_RESET_ON_FORK into attr::
 sched_flags
Git-Commit-ID: 7479f3c9cf67edf5e8a76b21ea3726757f35cf53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:40:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7479f3c9cf67edf5e8a76b21ea3726757f35cf53
Gitweb:     http://git.kernel.org/tip/7479f3c9cf67edf5e8a76b21ea3726757f35cf53
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 15 Jan 2014 17:05:04 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:17 +0100

sched: Move SCHED_RESET_ON_FORK into attr::sched_flags

I noticed the new sched_{set,get}attr() calls didn't properly deal
with the SCHED_RESET_ON_FORK hack.

Instead of propagating the flags in high bits nonsense use the brand
spanking new attr::sched_flags field.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Link: http://lkml.kernel.org/r/20140115162242.GJ31570@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/sched.h |  5 +++++
 kernel/sched/core.c        | 42 ++++++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 2d5e49a..34f9d73 100644
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5a6ccdf..93a2836 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3267,8 +3267,7 @@ recheck:
 		reset_on_fork = p->sched_reset_on_fork;
 		policy = oldpolicy = p->policy;
 	} else {
-		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
-		policy &= ~SCHED_RESET_ON_FORK;
+		reset_on_fork = !!(attr->sched_flags & SCHED_FLAG_RESET_ON_FORK);
 
 		if (policy != SCHED_DEADLINE &&
 				policy != SCHED_FIFO && policy != SCHED_RR &&
@@ -3277,6 +3276,9 @@ recheck:
 			return -EINVAL;
 	}
 
+	if (attr->sched_flags & ~(SCHED_FLAG_RESET_ON_FORK))
+		return -EINVAL;
+
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
@@ -3443,6 +3445,26 @@ change:
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
@@ -3456,12 +3478,7 @@ change:
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
 
@@ -3487,12 +3504,7 @@ EXPORT_SYMBOL_GPL(sched_setattr);
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
@@ -3792,6 +3804,8 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 		goto out_unlock;
 
 	attr.sched_policy = p->policy;
+	if (p->sched_reset_on_fork)
+		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
 	if (task_has_dl_policy(p))
 		__getparam_dl(p, &attr);
 	else if (task_has_rt_policy(p))
