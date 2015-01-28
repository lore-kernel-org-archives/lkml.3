Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbbA2JDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:03:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44783 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754198AbbA2JCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 102/176] ftrace/jprobes/x86: Fix conflict between jprobes and function graph tracing
Date: Wed, 28 Jan 2015 15:28:52 +0100
Message-Id: <98621891a08259f781e8d939527d9b6cff2aa2c1.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 237d28db036e411f22c03cfd5b0f6dc2aa9bf3bc upstream.

If the function graph tracer traces a jprobe callback, the system will
crash. This can easily be demonstrated by compiling the jprobe
sample module that is in the kernel tree, loading it and running the
function graph tracer.

 # modprobe jprobe_example.ko
 # echo function_graph > /sys/kernel/debug/tracing/current_tracer
 # ls

The first two commands end up in a nice crash after the first fork.
(do_fork has a jprobe attached to it, so "ls" just triggers that fork)

The problem is caused by the jprobe_return() that all jprobe callbacks
must end with. The way jprobes works is that the function a jprobe
is attached to has a breakpoint placed at the start of it (or it uses
ftrace if fentry is supported). The breakpoint handler (or ftrace callback)
will copy the stack frame and change the ip address to return to the
jprobe handler instead of the function. The jprobe handler must end
with jprobe_return() which swaps the stack and does an int3 (breakpoint).
This breakpoint handler will then put back the saved stack frame,
simulate the instruction at the beginning of the function it added
a breakpoint to, and then continue on.

For function tracing to work, it hijakes the return address from the
stack frame, and replaces it with a hook function that will trace
the end of the call. This hook function will restore the return
address of the function call.

If the function tracer traces the jprobe handler, the hook function
for that handler will not be called, and its saved return address
will be used for the next function. This will result in a kernel crash.

To solve this, pause function tracing before the jprobe handler is called
and unpause it before it returns back to the function it probed.

Some other updates:

Used a variable "saved_sp" to hold kcb->jprobe_saved_sp. This makes the
code look a bit cleaner and easier to understand (various tries to fix
this bug required this change).

Note, if fentry is being used, jprobes will change the ip address before
the function graph tracer runs and it will not be able to trace the
function that the jprobe is probing.

Link: http://lkml.kernel.org/r/20150114154329.552437962@goodmis.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/kprobes/core.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 79a3f9682871..a1f5b1866cbe 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1017,6 +1017,15 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	regs->flags &= ~X86_EFLAGS_IF;
 	trace_hardirqs_off();
 	regs->ip = (unsigned long)(jp->entry);
+
+	/*
+	 * jprobes use jprobe_return() which skips the normal return
+	 * path of the function, and this messes up the accounting of the
+	 * function graph tracer to get messed up.
+	 *
+	 * Pause function graph tracing while performing the jprobe function.
+	 */
+	pause_graph_tracing();
 	return 1;
 }
 
@@ -1042,24 +1051,25 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->ip - 1);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	void *saved_sp = kcb->jprobe_saved_sp;
 
 	if ((addr > (u8 *) jprobe_return) &&
 	    (addr < (u8 *) jprobe_return_end)) {
-		if (stack_addr(regs) != kcb->jprobe_saved_sp) {
+		if (stack_addr(regs) != saved_sp) {
 			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk(KERN_ERR
 			       "current sp %p does not match saved sp %p\n",
-			       stack_addr(regs), kcb->jprobe_saved_sp);
+			       stack_addr(regs), saved_sp);
 			printk(KERN_ERR "Saved registers for jprobe %p\n", jp);
 			show_regs(saved_regs);
 			printk(KERN_ERR "Current registers\n");
 			show_regs(regs);
 			BUG();
 		}
+		/* It's OK to start function graph tracing again */
+		unpause_graph_tracing();
 		*regs = kcb->jprobe_saved_regs;
-		memcpy((kprobe_opcode_t *)(kcb->jprobe_saved_sp),
-		       kcb->jprobes_stack,
-		       MIN_STACK_SIZE(kcb->jprobe_saved_sp));
+		memcpy(saved_sp, kcb->jprobes_stack, MIN_STACK_SIZE(saved_sp));
 		preempt_enable_no_resched();
 		return 1;
 	}
-- 
2.2.2

