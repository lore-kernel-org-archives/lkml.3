Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaDXK6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:58:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaDXK6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:58:49 -0400
Date: Thu, 24 Apr 2014 03:57:59 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-be8f274323c26ddc7e6fd6c44254b7abcdbe6389@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, jkosina@suse.cz, jan.kiszka@siemens.com,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com, jlebon@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, jan.kiszka@siemens.com, jkosina@suse.cz,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, jlebon@redhat.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <20140417081658.26341.57354.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081658.26341.57354.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes: Prohibit probing on .entry.text code
Git-Commit-ID: be8f274323c26ddc7e6fd6c44254b7abcdbe6389
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

Commit-ID:  be8f274323c26ddc7e6fd6c44254b7abcdbe6389
Gitweb:     http://git.kernel.org/tip/be8f274323c26ddc7e6fd6c44254b7abcdbe6389
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:16:58 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:02:56 +0200

kprobes: Prohibit probing on .entry.text code

.entry.text is a code area which is used for interrupt/syscall
entries, which includes many sensitive code.
Thus, it is better to prohibit probing on all of such code
instead of a part of that.
Since some symbols are already registered on kprobe blacklist,
this also removes them from the blacklist.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jonathan Lebon <jlebon@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/20140417081658.26341.57354.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/entry_32.S     | 33 ---------------------------------
 arch/x86/kernel/entry_64.S     | 20 --------------------
 arch/x86/kernel/kprobes/core.c |  8 ++++++++
 include/linux/kprobes.h        |  1 +
 kernel/kprobes.c               | 13 ++++++++-----
 5 files changed, 17 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f46..0ca5bf1 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -315,10 +315,6 @@ ENTRY(ret_from_kernel_thread)
 ENDPROC(ret_from_kernel_thread)
 
 /*
- * Interrupt exit functions should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
-/*
  * Return to user mode is not as complex as all this looks,
  * but we want the default path for a system call return to
  * go as quickly as possible which is why some of this is
@@ -372,10 +368,6 @@ need_resched:
 END(resume_kernel)
 #endif
 	CFI_ENDPROC
-/*
- * End of kprobes section
- */
-	.popsection
 
 /* SYSENTER_RETURN points to after the "sysenter" instruction in
    the vsyscall page.  See vsyscall-sysentry.S, which defines the symbol.  */
@@ -495,10 +487,6 @@ sysexit_audit:
 	PTGS_TO_GS_EX
 ENDPROC(ia32_sysenter_target)
 
-/*
- * syscall stub including irq exit should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
 	# system call handler stub
 ENTRY(system_call)
 	RING0_INT_FRAME			# can't unwind into user space anyway
@@ -691,10 +679,6 @@ syscall_badsys:
 	jmp resume_userspace
 END(syscall_badsys)
 	CFI_ENDPROC
-/*
- * End of kprobes section
- */
-	.popsection
 
 .macro FIXUP_ESPFIX_STACK
 /*
@@ -781,10 +765,6 @@ common_interrupt:
 ENDPROC(common_interrupt)
 	CFI_ENDPROC
 
-/*
- *  Irq entries should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
 #define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
@@ -961,10 +941,6 @@ ENTRY(spurious_interrupt_bug)
 	jmp error_code
 	CFI_ENDPROC
 END(spurious_interrupt_bug)
-/*
- * End of kprobes section
- */
-	.popsection
 
 #ifdef CONFIG_XEN
 /* Xen doesn't set %esp to be precisely what the normal sysenter
@@ -1239,11 +1215,6 @@ return_to_handler:
 	jmp *%ecx
 #endif
 
-/*
- * Some functions should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
-
 #ifdef CONFIG_TRACING
 ENTRY(trace_page_fault)
 	RING0_EC_FRAME
@@ -1453,7 +1424,3 @@ ENTRY(async_page_fault)
 END(async_page_fault)
 #endif
 
-/*
- * End of kprobes section
- */
-	.popsection
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..43bb389 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -487,8 +487,6 @@ ENDPROC(native_usergs_sysret64)
 	TRACE_IRQS_OFF
 	.endm
 
-/* save complete stack frame */
-	.pushsection .kprobes.text, "ax"
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
@@ -517,7 +515,6 @@ ENTRY(save_paranoid)
 1:	ret
 	CFI_ENDPROC
 END(save_paranoid)
-	.popsection
 
 /*
  * A newly forked process directly context switches into this address.
@@ -975,10 +972,6 @@ END(interrupt)
 	call \func
 	.endm
 
-/*
- * Interrupt entry/exit should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
 	/*
 	 * The interrupt stubs push (~vector+0x80) onto the stack and
 	 * then jump to common_interrupt.
@@ -1113,10 +1106,6 @@ ENTRY(retint_kernel)
 
 	CFI_ENDPROC
 END(common_interrupt)
-/*
- * End of kprobes section
- */
-       .popsection
 
 /*
  * APIC interrupts.
@@ -1477,11 +1466,6 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 	hyperv_callback_vector hyperv_vector_handler
 #endif /* CONFIG_HYPERV */
 
-/*
- * Some functions should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
-
 paranoidzeroentry_ist debug do_debug DEBUG_STACK
 paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
 paranoiderrorentry stack_segment do_stack_segment
@@ -1898,7 +1882,3 @@ ENTRY(ignore_sysret)
 	CFI_ENDPROC
 END(ignore_sysret)
 
-/*
- * End of kprobes section
- */
-	.popsection
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index da7bdaa..7751b3d 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1065,6 +1065,14 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+bool arch_within_kprobe_blacklist(unsigned long addr)
+{
+	return  (addr >= (unsigned long)__kprobes_text_start &&
+		 addr < (unsigned long)__kprobes_text_end) ||
+		(addr >= (unsigned long)__entry_text_start &&
+		 addr < (unsigned long)__entry_text_end);
+}
+
 int __init arch_init_kprobes(void)
 {
 	return 0;
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 925eaf2..cdf9251 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -265,6 +265,7 @@ extern void arch_disarm_kprobe(struct kprobe *p);
 extern int arch_init_kprobes(void);
 extern void show_registers(struct pt_regs *regs);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
+extern bool arch_within_kprobe_blacklist(unsigned long addr);
 
 struct kprobe_insn_cache {
 	struct mutex mutex;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceeadfc..5b5ac76 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -96,9 +96,6 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"preempt_schedule",},
 	{"native_get_debugreg",},
-	{"irq_entries_start",},
-	{"common_interrupt",},
-	{"mcount",},	/* mcount can be called from everywhere */
 	{NULL}    /* Terminator */
 };
 
@@ -1324,12 +1321,18 @@ out:
 	return ret;
 }
 
+bool __weak arch_within_kprobe_blacklist(unsigned long addr)
+{
+	/* The __kprobes marked functions and entry code must not be probed */
+	return addr >= (unsigned long)__kprobes_text_start &&
+	       addr < (unsigned long)__kprobes_text_end;
+}
+
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
 
-	if (addr >= (unsigned long)__kprobes_text_start &&
-	    addr < (unsigned long)__kprobes_text_end)
+	if (arch_within_kprobe_blacklist(addr))
 		return -EINVAL;
 	/*
 	 * If there exists a kprobe_blacklist, verify and
