Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaG1IaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:30:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42834 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaG1IaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:30:05 -0400
Date: Mon, 28 Jul 2014 01:28:52 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-c13db6b131a4388edca9867a1457b988b83902f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bristot@redhat.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bristot@redhat.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20140723112826.6ed6cbce@gandalf.local.home>
References: <20140723112826.6ed6cbce@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Use macro for magic number of -1 for setparam
Git-Commit-ID: c13db6b131a4388edca9867a1457b988b83902f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c13db6b131a4388edca9867a1457b988b83902f8
Gitweb:     http://git.kernel.org/tip/c13db6b131a4388edca9867a1457b988b83902f8
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Wed, 23 Jul 2014 11:28:26 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 28 Jul 2014 10:04:14 +0200

sched: Use macro for magic number of -1 for setparam

Instead of passing around a magic number -1 for the sched_setparam()
policy, use a more descriptive macro name like SETPARAM_POLICY.

[ based on top of Daniel's sched_setparam() fix ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Bristot de Oliveira<bristot@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140723112826.6ed6cbce@gandalf.local.home
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2a36a74..2676866 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3218,12 +3218,18 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_yielded = 0;
 }
 
+/*
+ * sched_setparam() passes in -1 for its policy, to let the functions
+ * it calls know not to change it.
+ */
+#define SETPARAM_POLICY	-1
+
 static void __setscheduler_params(struct task_struct *p,
 		const struct sched_attr *attr)
 {
 	int policy = attr->sched_policy;
 
-	if (policy == -1) /* setparam */
+	if (policy == SETPARAM_POLICY)
 		policy = p->policy;
 
 	p->policy = policy;
@@ -3572,11 +3578,8 @@ static int _sched_setscheduler(struct task_struct *p, int policy,
 		.sched_nice	= PRIO_TO_NICE(p->static_prio),
 	};
 
-	/*
-	 * Fixup the legacy SCHED_RESET_ON_FORK hack, except if
-	 * the policy=-1 was passed by sched_setparam().
-	 */
-	if ((policy != -1) && (policy & SCHED_RESET_ON_FORK)) {
+	/* Fixup the legacy SCHED_RESET_ON_FORK hack. */
+	if ((policy != SETPARAM_POLICY) && (policy & SCHED_RESET_ON_FORK)) {
 		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
 		policy &= ~SCHED_RESET_ON_FORK;
 		attr.sched_policy = policy;
@@ -3746,7 +3749,7 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
  */
 SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 {
-	return do_sched_setscheduler(pid, -1, param);
+	return do_sched_setscheduler(pid, SETPARAM_POLICY, param);
 }
 
 /**
