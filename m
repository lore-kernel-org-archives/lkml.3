Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3LSQNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:13:30 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:48052 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab3LSPue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:50:34 -0500
Message-Id: <20131219155030.973571127@linux.com>
Date: Thu, 19 Dec 2013 09:50:17 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 02/40] tracing: Replace __get_cpu_var uses with this_cpu_ptr
References: <20131219155015.443763038@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_trace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace uses of &__get_cpu_var for address calculation with this_cpu_ptr.

CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/kprobes.h
===================================================================
--- linux.orig/include/linux/kprobes.h	2013-12-02 16:07:46.104736079 -0600
+++ linux/include/linux/kprobes.h	2013-12-02 16:07:46.104736079 -0600
@@ -355,7 +355,7 @@ static inline void reset_current_kprobe(
 
 static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
 {
-	return (&__get_cpu_var(kprobe_ctlblk));
+	return this_cpu_ptr(&kprobe_ctlblk);
 }
 
 int register_kprobe(struct kprobe *p);
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c	2013-12-02 16:07:46.104736079 -0600
+++ linux/kernel/trace/ftrace.c	2013-12-02 16:07:46.104736079 -0600
@@ -864,7 +864,7 @@ function_profile_call(unsigned long ip,
 
 	local_irq_save(flags);
 
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
@@ -895,7 +895,7 @@ static void profile_graph_return(struct
 	unsigned long flags;
 
 	local_irq_save(flags);
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
Index: linux/kernel/trace/trace.c
===================================================================
--- linux.orig/kernel/trace/trace.c	2013-12-02 16:07:46.104736079 -0600
+++ linux/kernel/trace/trace.c	2013-12-02 16:07:46.104736079 -0600
@@ -1685,7 +1685,7 @@ static void __ftrace_trace_stack(struct
 	 */
 	barrier();
 	if (use_stack == 1) {
-		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
 		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
 
 		if (regs)

