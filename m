Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbbAMWfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:35:32 -0500
Received: from ozlabs.org ([103.22.144.67]:43737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbbAMWfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:35:31 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: rostedt@goodmis.org
Cc: <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@osdl.org>,
        tglx@linutronix.de, mathieu.desnoyers@efficios.com,
        xiakaixu@huawei.com
Subject: [PATCH] tracing: Allow raw_syscall tracepoints to work from boot
Date: Wed, 14 Jan 2015 09:35:17 +1100
Message-Id: <1421188517-18312-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 5f893b2639b2 "tracing: Move enabling tracepoints to just after
rcu_init()", tracing was enabled earlier in boot.

This broke tracing of the raw_syscall tracepoints from boot using the
trace_event kernel parameter.

When the registration function for the raw_syscall tracepoints runs, it
iterates over all tasks setting TIF_SYSCALL_TRACEPOINT. However now that
this happens earlier in boot, the loop has no effect because there are
no tasks in existence other than init_task, which is skipped by the
for_each_process_thread() macro.

We can fix it by explicitly setting TIF_SYSCALL_TRACEPOINT for the
init_task. That way when pid 1 is cloned from init_task it will inherit
TIF_SYSCALL_TRACEPOINT.

Fixes: 5f893b2639b2 ("tracing: Move enabling tracepoints to just after rcu_init()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 kernel/tracepoint.c | 6 ++++++
 1 file changed, 6 insertions(+)


It feels a bit naughty to be whacking init_task like this, but it also
seems like the right fix?

Should we also clear it in the unregfunc? I can't see how that would
ever be needed in practice?


diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 3490407dc7b7..43a03e22c16c 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -496,6 +496,12 @@ void syscall_regfunc(void)
 
 	if (!sys_tracepoint_refcount) {
 		read_lock(&tasklist_lock);
+		/*
+		 * If we run very early in boot then we need to hit init_task
+		 * directly so that pid 1 will inherit the TIF flag.
+		 */
+		set_tsk_thread_flag(&init_task, TIF_SYSCALL_TRACEPOINT);
+
 		for_each_process_thread(p, t) {
 			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		}
-- 
2.1.0

