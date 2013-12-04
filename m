Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3LDBef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:34:35 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55006 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3LDBe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:34:27 -0500
Subject: [PATCH -tip v4 1/6] kprobes: Prohibit probing on .entry.text code
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 04 Dec 2013 01:28:44 +0000
Message-ID: <20131204012844.22118.28295.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.entry.text is a code area which is used for interrupt/syscall
entries, and there are many sensitive codes.
Thus, it is better to prohibit probing on all of such codes
instead of a part of that.
Since some symbols are already registered on kprobe blacklist,
this also removes them from the blacklist.

Changes from previous:
 - Introduce arch_within_kprobe_blacklist() which checks
   the address is within the .kprobes.text (generic,x86) or
   .entry.text (x86), for fixing build issue on !x86.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/entry_32.S     |   33 ---------------------------------
 arch/x86/kernel/entry_64.S     |   20 --------------------
 arch/x86/kernel/kprobes/core.c |    8 ++++++++
 include/linux/kprobes.h        |    1 +
 kernel/kprobes.c               |   13 ++++++++-----
 5 files changed, 17 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 51e2988..02c2fef 100644
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
index e21b078..c48f8f9 100644
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
index 79a3f96..c01e70f 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1066,6 +1066,14 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
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
index ceeadfc..c6772b9 100644
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
+	return (addr >= (unsigned long)__kprobes_text_start &&
+		addr < (unsigned long)__kprobes_text_end);
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


