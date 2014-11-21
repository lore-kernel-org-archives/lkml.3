Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaKUV0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:26:35 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48361 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaKUV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:26:33 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 5/5] x86, traps: Add ist_begin_non_atomic and ist_end_non_atomic
Date: Fri, 21 Nov 2014 13:26:11 -0800
Message-Id: <7ddd4ff60524d065af84b9d70b1128967b37fa7b.1416604491.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some IST handlers, if the interrupt came from user mode,
we can safely enable preemption.  Add helpers to do it safely.

This is intended to be used my the memory failure code in
do_machine_check.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/traps.h |  2 ++
 arch/x86/kernel/traps.c      | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index eb16a61bfd06..04ba537fc721 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -112,6 +112,8 @@ asmlinkage void mce_threshold_interrupt(void);
 
 extern enum ctx_state ist_enter(struct pt_regs *regs);
 extern void ist_exit(struct pt_regs *regs, enum ctx_state prev_state);
+extern void ist_begin_non_atomic(struct pt_regs *regs);
+extern void ist_end_non_atomic(void);
 
 /* Interrupts/Exceptions */
 enum {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6a02760df7b4..2b5f2e038e3f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -140,6 +140,44 @@ void ist_exit(struct pt_regs *regs, enum ctx_state prev_state)
 		rcu_nmi_exit();
 }
 
+/**
+ * ist_begin_non_atomic() - begin a non-atomic section in an IST exception
+ * @regs:	regs passed to the IST exception handler
+ *
+ * IST exception handlers normally cannot schedule.  As a special
+ * exception, if the exception interrupted userspace code (i.e.
+ * user_mode_vm(regs) would return true) and the exception was not
+ * a double fault, it can be safe to schedule.  ist_begin_non_atomic()
+ * begins a non-atomic section within an ist_enter()/ist_exit() region.
+ * Callers are responsible for enabling interrupts themselves inside
+ * the non-atomic section, and callers must call is_end_non_atomic()
+ * before ist_exit().
+ */
+void ist_begin_non_atomic(struct pt_regs *regs)
+{
+	BUG_ON(!user_mode_vm(regs));
+
+	/*
+	 * Sanity check: we need to be on the normal thread stack.  This
+	 * will catch asm bugs and any attempt to use ist_preempt_enable
+	 * from double_fault.
+	 */
+	BUG_ON(((current_stack_pointer() ^ this_cpu_read_stable(kernel_stack))
+		& ~(THREAD_SIZE - 1)) != 0);
+
+	preempt_count_sub(HARDIRQ_OFFSET);
+}
+
+/**
+ * ist_end_non_atomic() - begin a non-atomic section in an IST exception
+ *
+ * Ends a non-atomic section started with ist_begin_non_atomic().
+ */
+void ist_end_non_atomic(void)
+{
+	preempt_count_add(HARDIRQ_OFFSET);
+}
+
 static nokprobe_inline int
 do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 		  struct pt_regs *regs,	long error_code)
-- 
1.9.3

