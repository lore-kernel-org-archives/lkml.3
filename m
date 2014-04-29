Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbaD2TRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:17:44 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:56962
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbaD2TRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:17:43 -0400
Date: Tue, 29 Apr 2014 14:17:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: tracing: Replace __get_cpu_var uses with this_cpu_ptr
Message-ID: <alpine.DEB.2.10.1404291415560.18364@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace uses of &__get_cpu_var for address calculation with this_cpu_ptr.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/kprobes.h
===================================================================
--- linux.orig/include/linux/kprobes.h	2014-04-28 13:09:07.228660946 -0500
+++ linux/include/linux/kprobes.h	2014-04-28 13:09:07.224661022 -0500
@@ -356,7 +356,7 @@

 static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
 {
-	return (&__get_cpu_var(kprobe_ctlblk));
+	return this_cpu_ptr(&kprobe_ctlblk);
 }

 int register_kprobe(struct kprobe *p);
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c	2014-04-28 13:09:07.228660946 -0500
+++ linux/kernel/trace/ftrace.c	2014-04-28 13:09:07.224661022 -0500
@@ -817,7 +817,7 @@

 	local_irq_save(flags);

-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;

@@ -848,7 +848,7 @@
 	unsigned long flags;

 	local_irq_save(flags);
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;

Index: linux/kernel/trace/trace.c
===================================================================
--- linux.orig/kernel/trace/trace.c	2014-04-28 13:09:07.228660946 -0500
+++ linux/kernel/trace/trace.c	2014-04-28 13:09:07.228660946 -0500
@@ -1728,7 +1728,7 @@
 	 */
 	barrier();
 	if (use_stack == 1) {
-		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
 		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;

 		if (regs)
