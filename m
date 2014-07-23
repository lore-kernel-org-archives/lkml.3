Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbaGWP2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:28:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64296 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758091AbaGWP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:28:28 -0400
Date: Wed, 23 Jul 2014 11:28:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sched: Use macro for magic number of -1 for setparam
Message-ID: <20140723112826.6ed6cbce@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of passing around a magic number -1 for the sched_setparam()
policy, use a more descriptive macro name like SETPARAM_POLICY.

[ based on top of Daniel's sched_setparam() fix ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-trace.git/kernel/sched/core.c
===================================================================
--- linux-trace.git.orig/kernel/sched/core.c	2014-07-23 11:19:24.396368654 -0400
+++ linux-trace.git/kernel/sched/core.c	2014-07-23 11:27:30.013401767 -0400
@@ -3203,12 +3203,18 @@
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
@@ -3557,11 +3563,8 @@
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
@@ -3731,7 +3734,7 @@
  */
 SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 {
-	return do_sched_setscheduler(pid, -1, param);
+	return do_sched_setscheduler(pid, SETPARAM_POLICY, param);
 }
 
 /**
