Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab3HGPAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:00:05 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60312 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3HGO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:58:49 -0400
Message-ID: <201308071458.r77EwmbN013095@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 6 Aug 2013 16:04:13 -0400
Subject: [PATCH] tile: fast-path unaligned memory access for tilegx
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change enables unaligned userspace memory access via a kernel
fast path on tilegx.  The kernel tracks user PC/instruction pairs
per-thread using a direct-mapped cache in userspace.  The cache
maps those PC/instruction pairs to JIT'ed instruction sequences that
load or store using byte-wide load store intructions and then
synthesize 2-, 4- or 8-byte load or store results.  Once an
instruction has been seen to generate an unaligned access once,
subsequent hits on that instruction typically require overhead
of only around 50 cycles if cache and TLB is hot.

We support the prctl() PR_GET_UNALIGN / PR_SET_UNALIGN sys call to
enable or disable unaligned fixups on a per-process basis.

To do this we pull some of the tilepro unaligned support out of the
single_step.c file; tilepro uses instruction disassembly for both
single-step and unaligned access support.  Since tilegx actually has
hardware singlestep support, though, it's cleaner to keep the tilegx
unaligned access code in a separate file.  While we're at it,
properly rename the tilepro-specific types, etc., to have tilepro
suffixes instead of generic tile suffixes.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/processor.h   |    7 +
 arch/tile/include/asm/ptrace.h      |    3 +-
 arch/tile/include/asm/sections.h    |    4 +-
 arch/tile/include/asm/thread_info.h |    6 +
 arch/tile/include/asm/traps.h       |   11 +
 arch/tile/kernel/Makefile           |    3 +-
 arch/tile/kernel/asm-offsets.c      |    6 +
 arch/tile/kernel/intvec_32.S        |    1 -
 arch/tile/kernel/intvec_64.S        |  220 ++++-
 arch/tile/kernel/proc.c             |    2 -
 arch/tile/kernel/process.c          |   21 +
 arch/tile/kernel/ptrace.c           |    4 +-
 arch/tile/kernel/single_step.c      |  119 +--
 arch/tile/kernel/unaligned.c        | 1609 +++++++++++++++++++++++++++++++++++
 arch/tile/mm/fault.c                |   41 +
 15 files changed, 1990 insertions(+), 67 deletions(-)
 create mode 100644 arch/tile/kernel/unaligned.c

diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index b3f1049..cda2724 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -247,6 +247,13 @@ unsigned long get_wchan(struct task_struct *p);
 #define KSTK_EIP(task)	task_pc(task)
 #define KSTK_ESP(task)	task_sp(task)
 
+/* Fine-grained unaligned JIT support */
+#define GET_UNALIGN_CTL(tsk, adr)	get_unalign_ctl((tsk), (adr))
+#define SET_UNALIGN_CTL(tsk, val)	set_unalign_ctl((tsk), (val))
+
+extern int get_unalign_ctl(struct task_struct *tsk, unsigned long adr);
+extern int set_unalign_ctl(struct task_struct *tsk, unsigned int val);
+
 /* Standard format for printing registers and other word-size data. */
 #ifdef __tilegx__
 # define REGFMT "0x%016lx"
diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index fd41226..73b681b 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -79,8 +79,7 @@ extern void single_step_execve(void);
 
 struct task_struct;
 
-extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
-			 int error_code);
+extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs);
 
 #ifdef __tilegx__
 /* We need this since sigval_t has a user pointer in it, for GETSIGINFO etc. */
diff --git a/arch/tile/include/asm/sections.h b/arch/tile/include/asm/sections.h
index 7d8a935..cc95276 100644
--- a/arch/tile/include/asm/sections.h
+++ b/arch/tile/include/asm/sections.h
@@ -28,7 +28,9 @@ extern char __w1data_begin[], __w1data_end[];
 
 /* Not exactly sections, but PC comparison points in the code. */
 extern char __rt_sigreturn[], __rt_sigreturn_end[];
-#ifndef __tilegx__
+#ifdef __tilegx__
+extern char __start_unalign_asm_code[], __end_unalign_asm_code[];
+#else
 extern char sys_cmpxchg[], __sys_cmpxchg_end[];
 extern char __sys_cmpxchg_grab_lock[];
 extern char __start_atomic_asm_code[], __end_atomic_asm_code[];
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index d1733de..b8aa6df 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -39,6 +39,11 @@ struct thread_info {
 	struct restart_block	restart_block;
 	struct single_step_state *step_state;	/* single step state
 						   (if non-zero) */
+	int			align_ctl;	/* controls unaligned access */
+#ifdef __tilegx__
+	unsigned long		unalign_jit_tmp[4]; /* temp r0..r3 storage */
+	void __user		*unalign_jit_base; /* unalign fixup JIT base */
+#endif
 };
 
 /*
@@ -56,6 +61,7 @@ struct thread_info {
 		.fn = do_no_restart_syscall,	\
 	},					\
 	.step_state	= NULL,			\
+	.align_ctl	= 0,			\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/tile/include/asm/traps.h b/arch/tile/include/asm/traps.h
index e28c3df4..8cd7f2e 100644
--- a/arch/tile/include/asm/traps.h
+++ b/arch/tile/include/asm/traps.h
@@ -15,6 +15,7 @@
 #ifndef _ASM_TILE_TRAPS_H
 #define _ASM_TILE_TRAPS_H
 
+#ifndef __ASSEMBLY__
 #include <arch/chip.h>
 
 /* mm/fault.c */
@@ -71,4 +72,14 @@ void gx_singlestep_handle(struct pt_regs *, int fault_num);
 void fill_ra_stack(void);
 #endif
 
+/* Handle unalign data fixup. */
+extern void do_unaligned(struct pt_regs *regs, int vecnum);
+
+#endif /* __ASSEMBLY__ */
+
+#ifdef __tilegx__
+/* 128 byte JIT per unalign fixup. */
+#define UNALIGN_JIT_SHIFT    7
+#endif
+
 #endif /* _ASM_TILE_TRAPS_H */
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index 5334be8..6846c4e 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -5,7 +5,8 @@
 extra-y := vmlinux.lds head_$(BITS).o
 obj-y := backtrace.o entry.o irq.o messaging.o \
 	pci-dma.o proc.o process.o ptrace.o reboot.o \
-	setup.o signal.o single_step.o stack.o sys.o sysfs.o time.o traps.o \
+	setup.o signal.o single_step.o stack.o sys.o \
+	sysfs.o time.o traps.o unaligned.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
 
 obj-$(CONFIG_HARDWALL)		+= hardwall.o
diff --git a/arch/tile/kernel/asm-offsets.c b/arch/tile/kernel/asm-offsets.c
index 8fff475..8652b0b 100644
--- a/arch/tile/kernel/asm-offsets.c
+++ b/arch/tile/kernel/asm-offsets.c
@@ -60,6 +60,12 @@ void foo(void)
 	       offsetof(struct thread_info, homecache_cpu));
 	DEFINE(THREAD_INFO_STEP_STATE_OFFSET,
 	       offsetof(struct thread_info, step_state));
+#ifdef __tilegx__
+	DEFINE(THREAD_INFO_UNALIGN_JIT_BASE_OFFSET,
+	       offsetof(struct thread_info, unalign_jit_base));
+	DEFINE(THREAD_INFO_UNALIGN_JIT_TMP_OFFSET,
+	       offsetof(struct thread_info, unalign_jit_tmp));
+#endif
 
 	DEFINE(TASK_STRUCT_THREAD_KSP_OFFSET,
 	       offsetof(struct task_struct, thread.ksp));
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 25966af..3880613 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1420,7 +1420,6 @@ handle_ill:
 	{
 	 lw     r0, r0          /* indirect thru thread_info to get task_info*/
 	 addi   r1, sp, C_ABI_SAVE_AREA_SIZE  /* put ptregs pointer into r1 */
-	 move   r2, zero        /* load error code into r2 */
 	}
 
 	jal     send_sigtrap    /* issue a SIGTRAP */
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 85d4839..0db068c 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -17,11 +17,13 @@
 #include <linux/linkage.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
+#include <linux/init.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/irqflags.h>
 #include <asm/asm-offsets.h>
 #include <asm/types.h>
+#include <asm/traps.h>
 #include <asm/signal.h>
 #include <hv/hypervisor.h>
 #include <arch/abi.h>
@@ -98,6 +100,189 @@
 	}
 	.endm
 
+	/*
+	 * Unalign data exception fast handling: In order to handle
+	 * unaligned data access, a fast JIT version is generated and stored
+	 * in a specific area in user space. We first need to do a quick poke
+	 * to see if the JIT is available. We use certain bits in the fault
+	 * PC (3 to 9 is used for 16KB page size) as index to address the JIT
+	 * code area. The first 64bit word is the fault PC, and the 2nd one is
+	 * the fault bundle itself. If these 2 words both match, then we
+	 * directly "iret" to JIT code. If not, a slow path is invoked to
+	 * generate new JIT code. Note: the current JIT code WILL be
+	 * overwritten if it existed. So, ideally we can handle 128 unalign
+	 * fixups via JIT. For lookup efficiency and to effectively support
+	 * tight loops with multiple unaligned reference, a simple
+	 * direct-mapped cache is used.
+	 *
+	 * SPR_EX_CONTEXT_K_0 is modified to return to JIT code.
+	 * SPR_EX_CONTEXT_K_1 has ICS set.
+	 * SPR_EX_CONTEXT_0_0 is setup to user program's next PC.
+	 * SPR_EX_CONTEXT_0_1 = 0.
+	 */
+	.macro int_hand_unalign_fast  vecnum, vecname
+	.org  (\vecnum << 8)
+intvec_\vecname:
+	/* Put r3 in SPR_SYSTEM_SAVE_K_1.  */
+	mtspr   SPR_SYSTEM_SAVE_K_1, r3
+
+	mfspr   r3, SPR_EX_CONTEXT_K_1
+	/*
+	 * Examine if exception comes from user without ICS set.
+	 * If not, just go directly to the slow path.
+	 */
+	bnez    r3, hand_unalign_slow_nonuser
+
+	mfspr   r3, SPR_SYSTEM_SAVE_K_0
+
+	/* Get &thread_info->unalign_jit_tmp[0] in r3. */
+	mm      r3, zero, LOG2_THREAD_SIZE, 63
+#if THREAD_SIZE < 65536
+	addli   r3, r3, -(PAGE_SIZE - THREAD_INFO_UNALIGN_JIT_TMP_OFFSET)
+#else
+	addli   r3, r3, -(PAGE_SIZE/2)
+	addli   r3, r3, -(PAGE_SIZE/2 - THREAD_INFO_UNALIGN_JIT_TMP_OFFSET)
+#endif
+
+	/*
+	 * Save r0, r1, r2 into thread_info array r3 points to
+	 * from low to high memory in order.
+	 */
+	st_add  r3, r0, 8
+	st_add  r3, r1, 8
+	{
+	 st_add r3, r2, 8
+	 andi   r2, sp, 7
+	}
+
+	/* Save stored r3 value so we can revert it on a page fault. */
+	mfspr   r1, SPR_SYSTEM_SAVE_K_1
+	st      r3, r1
+
+	{
+	 /* Generate a SIGBUS if sp is not 8-byte aligned. */
+	 bnez   r2, hand_unalign_slow_badsp
+	}
+
+	/*
+	 * Get the thread_info in r0; load r1 with pc. Set the low bit of sp
+	 * as an indicator to the page fault code in case we fault.
+	 */
+	{
+	 ori    sp, sp, 1
+	 mfspr  r1, SPR_EX_CONTEXT_K_0
+	}
+
+	/* Add the jit_info offset in thread_info; extract r1 [3:9] into r2. */
+	{
+	 addli  r0, r3, THREAD_INFO_UNALIGN_JIT_BASE_OFFSET - \
+	  (THREAD_INFO_UNALIGN_JIT_TMP_OFFSET + (3 * 8))
+	 bfextu r2, r1, 3, (2 + PAGE_SHIFT - UNALIGN_JIT_SHIFT)
+	}
+
+	/* Load the jit_info; multiply r2 by 128. */
+	{
+	 ld     r0, r0
+	 shli   r2, r2, UNALIGN_JIT_SHIFT
+	}
+
+	/*
+	 * If r0 is NULL, the JIT page is not mapped, so go to slow path;
+	 * add offset r2 to r0 at the same time.
+	 */
+	{
+	 beqz   r0, hand_unalign_slow
+	 add    r2, r0, r2
+	}
+
+        /*
+	 * We are loading from userspace (both the JIT info PC and
+	 * instruction word, and the instruction word we executed)
+	 * and since either could fault while holding the interrupt
+	 * critical section, we must tag this region and check it in
+	 * do_page_fault() to handle it properly.
+	 */
+ENTRY(__start_unalign_asm_code)
+
+	/* Load first word of JIT in r0 and increment r2 by 8. */
+	ld_add  r0, r2, 8
+
+	/*
+	 * Compare the PC with the 1st word in JIT; load the fault bundle
+	 * into r1.
+	 */
+	{
+	 cmpeq  r0, r0, r1
+	 ld     r1, r1
+	}
+
+	/* Go to slow path if PC doesn't match. */
+	beqz    r0, hand_unalign_slow
+
+	/*
+	 * Load the 2nd word of JIT, which is supposed to be the fault
+	 * bundle for a cache hit. Increment r2; after this bundle r2 will
+	 * point to the potential start of the JIT code we want to run.
+	 */
+	ld_add  r0, r2, 8
+
+	/* No further accesses to userspace are done after this point. */
+ENTRY(__end_unalign_asm_code)
+
+	/* Compare the real bundle with what is saved in the JIT area. */
+	{
+	 cmpeq  r0, r1, r0
+	 mtspr  SPR_EX_CONTEXT_0_1, zero
+	}
+
+	/* Go to slow path if the fault bundle does not match. */
+	beqz    r0, hand_unalign_slow
+
+	/*
+	 * A cache hit is found.
+	 * r2 points to start of JIT code (3rd word).
+	 * r0 is the fault pc.
+	 * r1 is the fault bundle.
+	 * Reset the low bit of sp.
+	 */
+	{
+	 mfspr  r0, SPR_EX_CONTEXT_K_0
+	 andi   sp, sp, ~1
+	}
+
+	/* Write r2 into EX_CONTEXT_K_0 and increment PC. */
+	{
+	 mtspr  SPR_EX_CONTEXT_K_0, r2
+	 addi   r0, r0, 8
+	}
+
+	/*
+	 * Set ICS on kernel EX_CONTEXT_K_1 in order to "iret" to
+	 * user with ICS set. This way, if the JIT fixup causes another
+	 * unalign exception (which shouldn't be possible) the user
+	 * process will be terminated with SIGBUS. Also, our fixup will
+	 * run without interleaving with external interrupts.
+	 * Each fixup is at most 14 bundles, so it won't hold ICS for long.
+	 */
+	{
+	 movei  r1, PL_ICS_EX1(USER_PL, 1)
+	 mtspr  SPR_EX_CONTEXT_0_0, r0
+	}
+
+	{
+	 mtspr  SPR_EX_CONTEXT_K_1, r1
+	 addi   r3, r3, -(3 * 8)
+	}
+
+	/* Restore r0..r3. */
+	ld_add  r0, r3, 8
+	ld_add  r1, r3, 8
+	ld_add  r2, r3, 8
+	ld      r3, r3
+
+	iret
+	ENDPROC(intvec_\vecname)
+	.endm
 
 #ifdef __COLLECT_LINKER_FEEDBACK__
 	.pushsection .text.intvec_feedback,"ax"
@@ -118,8 +303,7 @@ intvec_feedback:
 	 * The "processing" argument specifies the code for processing
 	 * the interrupt. Defaults to "handle_interrupt".
 	 */
-	.macro  int_hand vecnum, vecname, c_routine, processing=handle_interrupt
-	.org    (\vecnum << 8)
+	.macro __int_hand vecnum, vecname, c_routine,processing=handle_interrupt
 intvec_\vecname:
 	/* Temporarily save a register so we have somewhere to work. */
 
@@ -1223,10 +1407,31 @@ STD_ENTRY(_sys_clone)
 	j       sys_clone
 	STD_ENDPROC(_sys_clone)
 
-/* The single-step support may need to read all the registers. */
+	/*
+	 * Recover r3, r2, r1 and r0 here saved by unalign fast vector.
+	 * The vector area limit is 32 bundles, so we handle the reload here.
+	 * r0, r1, r2 are in thread_info from low to high memory in order.
+	 * r3 points to location the original r3 was saved.
+	 * We put this code in the __HEAD section so it can be reached
+	 * via a conditional branch from the fast path.
+	 */
+	__HEAD
+hand_unalign_slow:
+	andi    sp, sp, ~1
+hand_unalign_slow_badsp:
+	addi    r3, r3, -(3 * 8)
+	ld_add  r0, r3, 8
+	ld_add  r1, r3, 8
+	ld      r2, r3
+hand_unalign_slow_nonuser:
+	mfspr   r3, SPR_SYSTEM_SAVE_K_1
+	__int_hand     INT_UNALIGN_DATA, UNALIGN_DATA_SLOW, int_unalign
+
+/* The unaligned data support needs to read all the registers. */
 int_unalign:
 	push_extra_callee_saves r0
-	j       do_trap
+	j       do_unaligned
+ENDPROC(hand_unalign_slow)
 
 /* Fill the return address stack with nonzero entries. */
 STD_ENTRY(fill_ra_stack)
@@ -1240,6 +1445,11 @@ STD_ENTRY(fill_ra_stack)
 4:	jrp	r0
 	STD_ENDPROC(fill_ra_stack)
 
+	.macro int_hand  vecnum, vecname, c_routine, processing=handle_interrupt
+	.org   (\vecnum << 8)
+		__int_hand   \vecnum, \vecname, \c_routine, \processing
+	.endm
+
 /* Include .intrpt1 array of interrupt vectors */
 	.section ".intrpt1", "ax"
 
@@ -1272,7 +1482,7 @@ STD_ENTRY(fill_ra_stack)
 	int_hand     INT_SWINT_1, SWINT_1, SYSCALL, handle_syscall
 	int_hand     INT_SWINT_0, SWINT_0, do_trap
 	int_hand     INT_ILL_TRANS, ILL_TRANS, do_trap
-	int_hand     INT_UNALIGN_DATA, UNALIGN_DATA, int_unalign
+	int_hand_unalign_fast INT_UNALIGN_DATA, UNALIGN_DATA
 	int_hand     INT_DTLB_MISS, DTLB_MISS, do_page_fault
 	int_hand     INT_DTLB_ACCESS, DTLB_ACCESS, do_page_fault
 	int_hand     INT_IDN_FIREWALL, IDN_FIREWALL, do_hardwall_trap
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index dafc447..681100c 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -113,7 +113,6 @@ arch_initcall(proc_tile_init);
  * Support /proc/sys/tile directory
  */
 
-#ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
 static ctl_table unaligned_subtable[] = {
 	{
 		.procname	= "enabled",
@@ -160,4 +159,3 @@ static int __init proc_sys_tile_init(void)
 }
 
 arch_initcall(proc_sys_tile_init);
-#endif
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 8d6c51d..25678b8 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -33,6 +33,7 @@
 #include <asm/syscalls.h>
 #include <asm/traps.h>
 #include <asm/setup.h>
+#include <asm/uaccess.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -147,6 +148,14 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	 */
 	task_thread_info(p)->step_state = NULL;
 
+#ifdef __tilegx__
+	/*
+	 * Do not clone unalign jit fixup from the parent; each thread
+	 * must allocate its own on demand.
+	 */
+	task_thread_info(p)->unalign_jit_base = NULL;
+#endif
+
 	/*
 	 * Copy the registers onto the kernel stack so the
 	 * return-from-interrupt code will reload it into registers.
@@ -205,6 +214,18 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	return 0;
 }
 
+int set_unalign_ctl(struct task_struct *tsk, unsigned int val)
+{
+	task_thread_info(tsk)->align_ctl = val;
+	return 0;
+}
+
+int get_unalign_ctl(struct task_struct *tsk, unsigned long adr)
+{
+	return put_user(task_thread_info(tsk)->align_ctl,
+			(unsigned int __user *)adr);
+}
+
 /*
  * Return "current" if it looks plausible, or else a pointer to a dummy.
  * This can be helpful if we are just trying to emit a clean panic.
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 0f83ed4..bac1874 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -272,7 +272,7 @@ void do_syscall_trace_exit(struct pt_regs *regs)
 		trace_sys_exit(regs, regs->regs[0]);
 }
 
-void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
+void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs)
 {
 	struct siginfo info;
 
@@ -288,5 +288,5 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 /* Handle synthetic interrupt delivered only by the simulator. */
 void __kprobes do_breakpoint(struct pt_regs* regs, int fault_num)
 {
-	send_sigtrap(current, regs, fault_num);
+	send_sigtrap(current, regs);
 }
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 27742e8..c617327 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -12,41 +12,30 @@
  *   more details.
  *
  * A code-rewriter that enables instruction single-stepping.
- * Derived from iLib's single-stepping code.
  */
 
-#ifndef __tilegx__   /* Hardware support for single step unavailable. */
-
-/* These functions are only used on the TILE platform */
+#include <linux/smp.h>
+#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
 #include <linux/uaccess.h>
 #include <linux/mman.h>
 #include <linux/types.h>
 #include <linux/err.h>
+#include <linux/prctl.h>
 #include <asm/cacheflush.h>
+#include <asm/traps.h>
+#include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <arch/abi.h>
+#include <arch/spr_def.h>
 #include <arch/opcode.h>
 
-#define signExtend17(val) sign_extend((val), 17)
-#define TILE_X1_MASK (0xffffffffULL << 31)
-
-int unaligned_printk;
 
-static int __init setup_unaligned_printk(char *str)
-{
-	long val;
-	if (strict_strtol(str, 0, &val) != 0)
-		return 0;
-	unaligned_printk = val;
-	pr_info("Printk for each unaligned data accesses is %s\n",
-		unaligned_printk ? "enabled" : "disabled");
-	return 1;
-}
-__setup("unaligned_printk=", setup_unaligned_printk);
+#ifndef __tilegx__   /* Hardware support for single step unavailable. */
 
-unsigned int unaligned_fixup_count;
+#define signExtend17(val) sign_extend((val), 17)
+#define TILE_X1_MASK (0xffffffffULL << 31)
 
 enum mem_op {
 	MEMOP_NONE,
@@ -56,12 +45,13 @@ enum mem_op {
 	MEMOP_STORE_POSTINCR
 };
 
-static inline tile_bundle_bits set_BrOff_X1(tile_bundle_bits n, s32 offset)
+static inline tilepro_bundle_bits set_BrOff_X1(tilepro_bundle_bits n,
+	s32 offset)
 {
-	tile_bundle_bits result;
+	tilepro_bundle_bits result;
 
 	/* mask out the old offset */
-	tile_bundle_bits mask = create_BrOff_X1(-1);
+	tilepro_bundle_bits mask = create_BrOff_X1(-1);
 	result = n & (~mask);
 
 	/* or in the new offset */
@@ -70,10 +60,11 @@ static inline tile_bundle_bits set_BrOff_X1(tile_bundle_bits n, s32 offset)
 	return result;
 }
 
-static inline tile_bundle_bits move_X1(tile_bundle_bits n, int dest, int src)
+static inline tilepro_bundle_bits move_X1(tilepro_bundle_bits n, int dest,
+	int src)
 {
-	tile_bundle_bits result;
-	tile_bundle_bits op;
+	tilepro_bundle_bits result;
+	tilepro_bundle_bits op;
 
 	result = n & (~TILE_X1_MASK);
 
@@ -87,13 +78,13 @@ static inline tile_bundle_bits move_X1(tile_bundle_bits n, int dest, int src)
 	return result;
 }
 
-static inline tile_bundle_bits nop_X1(tile_bundle_bits n)
+static inline tilepro_bundle_bits nop_X1(tilepro_bundle_bits n)
 {
 	return move_X1(n, TREG_ZERO, TREG_ZERO);
 }
 
-static inline tile_bundle_bits addi_X1(
-	tile_bundle_bits n, int dest, int src, int imm)
+static inline tilepro_bundle_bits addi_X1(
+	tilepro_bundle_bits n, int dest, int src, int imm)
 {
 	n &= ~TILE_X1_MASK;
 
@@ -107,15 +98,26 @@ static inline tile_bundle_bits addi_X1(
 	return n;
 }
 
-static tile_bundle_bits rewrite_load_store_unaligned(
+static tilepro_bundle_bits rewrite_load_store_unaligned(
 	struct single_step_state *state,
-	tile_bundle_bits bundle,
+	tilepro_bundle_bits bundle,
 	struct pt_regs *regs,
 	enum mem_op mem_op,
 	int size, int sign_ext)
 {
 	unsigned char __user *addr;
 	int val_reg, addr_reg, err, val;
+	int align_ctl;
+
+	align_ctl = unaligned_fixup;
+	switch (task_thread_info(current)->align_ctl) {
+	case PR_UNALIGN_NOPRINT:
+		align_ctl = 1;
+		break;
+	case PR_UNALIGN_SIGBUS:
+		align_ctl = 0;
+		break;
+	}
 
 	/* Get address and value registers */
 	if (bundle & TILEPRO_BUNDLE_Y_ENCODING_MASK) {
@@ -160,7 +162,7 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 	 * tilepro hardware would be doing, if it could provide us with the
 	 * actual bad address in an SPR, which it doesn't.
 	 */
-	if (unaligned_fixup == 0) {
+	if (align_ctl == 0) {
 		siginfo_t info = {
 			.si_signo = SIGBUS,
 			.si_code = BUS_ADRALN,
@@ -209,14 +211,14 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 
 	if (err) {
 		siginfo_t info = {
-			.si_signo = SIGSEGV,
-			.si_code = SEGV_MAPERR,
+			.si_signo = SIGBUS,
+			.si_code = BUS_ADRALN,
 			.si_addr = addr
 		};
-		trace_unhandled_signal("segfault", regs,
-				       (unsigned long)addr, SIGSEGV);
+		trace_unhandled_signal("bad address for unaligned fixup", regs,
+				       (unsigned long)addr, SIGBUS);
 		force_sig_info(info.si_signo, &info, current);
-		return (tile_bundle_bits) 0;
+		return (tilepro_bundle_bits) 0;
 	}
 
 	if (unaligned_printk || unaligned_fixup_count == 0) {
@@ -285,7 +287,7 @@ void single_step_execve(void)
 	ti->step_state = NULL;
 }
 
-/**
+/*
  * single_step_once() - entry point when single stepping has been triggered.
  * @regs: The machine register state
  *
@@ -304,20 +306,31 @@ void single_step_execve(void)
  */
 void single_step_once(struct pt_regs *regs)
 {
-	extern tile_bundle_bits __single_step_ill_insn;
-	extern tile_bundle_bits __single_step_j_insn;
-	extern tile_bundle_bits __single_step_addli_insn;
-	extern tile_bundle_bits __single_step_auli_insn;
+	extern tilepro_bundle_bits __single_step_ill_insn;
+	extern tilepro_bundle_bits __single_step_j_insn;
+	extern tilepro_bundle_bits __single_step_addli_insn;
+	extern tilepro_bundle_bits __single_step_auli_insn;
 	struct thread_info *info = (void *)current_thread_info();
 	struct single_step_state *state = info->step_state;
 	int is_single_step = test_ti_thread_flag(info, TIF_SINGLESTEP);
-	tile_bundle_bits __user *buffer, *pc;
-	tile_bundle_bits bundle;
+	tilepro_bundle_bits __user *buffer, *pc;
+	tilepro_bundle_bits bundle;
 	int temp_reg;
 	int target_reg = TREG_LR;
 	int err;
 	enum mem_op mem_op = MEMOP_NONE;
 	int size = 0, sign_ext = 0;  /* happy compiler */
+	int align_ctl;
+
+	align_ctl = unaligned_fixup;
+	switch (task_thread_info(current)->align_ctl) {
+	case PR_UNALIGN_NOPRINT:
+		align_ctl = 1;
+		break;
+	case PR_UNALIGN_SIGBUS:
+		align_ctl = 0;
+		break;
+	}
 
 	asm(
 "    .pushsection .rodata.single_step\n"
@@ -356,6 +369,9 @@ void single_step_once(struct pt_regs *regs)
 		/* allocate a cache line of writable, executable memory */
 		buffer = (void __user *) vm_mmap(NULL, 0, 64,
 					  PROT_EXEC | PROT_READ | PROT_WRITE,
+#ifdef CONFIG_HOMECACHE
+					  MAP_CACHE_HOME_TASK |
+#endif
 					  MAP_PRIVATE | MAP_ANONYMOUS,
 					  0);
 
@@ -390,7 +406,7 @@ void single_step_once(struct pt_regs *regs)
 	if (regs->faultnum == INT_SWINT_1)
 		regs->pc -= 8;
 
-	pc = (tile_bundle_bits __user *)(regs->pc);
+	pc = (tilepro_bundle_bits __user *)(regs->pc);
 	if (get_user(bundle, pc) != 0) {
 		pr_err("Couldn't read instruction at %p trying to step\n", pc);
 		return;
@@ -627,9 +643,9 @@ void single_step_once(struct pt_regs *regs)
 
 	/*
 	 * Check if we need to rewrite an unaligned load/store.
-	 * Returning zero is a special value meaning we need to SIGSEGV.
+	 * Returning zero is a special value meaning we generated a signal.
 	 */
-	if (mem_op != MEMOP_NONE && unaligned_fixup >= 0) {
+	if (mem_op != MEMOP_NONE && align_ctl >= 0) {
 		bundle = rewrite_load_store_unaligned(state, bundle, regs,
 						      mem_op, size, sign_ext);
 		if (bundle == 0)
@@ -668,9 +684,9 @@ void single_step_once(struct pt_regs *regs)
 		}
 
 		/* End with a jump back to the next instruction */
-		delta = ((regs->pc + TILE_BUNDLE_SIZE_IN_BYTES) -
+		delta = ((regs->pc + TILEPRO_BUNDLE_SIZE_IN_BYTES) -
 			(unsigned long)buffer) >>
-			TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES;
+			TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES;
 		bundle = __single_step_j_insn;
 		bundle |= create_JOffLong_X1(delta);
 		err |= __put_user(bundle, buffer++);
@@ -698,9 +714,6 @@ void single_step_once(struct pt_regs *regs)
 }
 
 #else
-#include <linux/smp.h>
-#include <linux/ptrace.h>
-#include <arch/spr_def.h>
 
 static DEFINE_PER_CPU(unsigned long, ss_saved_pc);
 
@@ -743,10 +756,10 @@ void gx_singlestep_handle(struct pt_regs *regs, int fault_num)
 	} else if ((*ss_pc != regs->pc) ||
 		   (!(control & SPR_SINGLE_STEP_CONTROL_1__CANCELED_MASK))) {
 
-		ptrace_notify(SIGTRAP);
 		control |= SPR_SINGLE_STEP_CONTROL_1__CANCELED_MASK;
 		control |= SPR_SINGLE_STEP_CONTROL_1__INHIBIT_MASK;
 		__insn_mtspr(SPR_SINGLE_STEP_CONTROL_K, control);
+		send_sigtrap(current, regs);
 	}
 }
 
diff --git a/arch/tile/kernel/unaligned.c b/arch/tile/kernel/unaligned.c
new file mode 100644
index 0000000..b425fb6
--- /dev/null
+++ b/arch/tile/kernel/unaligned.c
@@ -0,0 +1,1609 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * A code-rewriter that handles unaligned exception.
+ */
+
+#include <linux/smp.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/thread_info.h>
+#include <linux/uaccess.h>
+#include <linux/mman.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/compat.h>
+#include <linux/prctl.h>
+#include <asm/cacheflush.h>
+#include <asm/traps.h>
+#include <asm/uaccess.h>
+#include <asm/unaligned.h>
+#include <arch/abi.h>
+#include <arch/spr_def.h>
+#include <arch/opcode.h>
+
+
+/*
+ * This file handles unaligned exception for tile-Gx. The tilepro's unaligned
+ * exception is supported out of single_step.c
+ */
+
+int unaligned_printk;
+
+static int __init setup_unaligned_printk(char *str)
+{
+	long val;
+	if (kstrtol(str, 0, &val) != 0)
+		return 0;
+	unaligned_printk = val;
+	pr_info("Printk for each unaligned data accesses is %s\n",
+		unaligned_printk ? "enabled" : "disabled");
+	return 1;
+}
+__setup("unaligned_printk=", setup_unaligned_printk);
+
+unsigned int unaligned_fixup_count;
+
+#ifdef __tilegx__
+
+/*
+ * Unalign data jit fixup code fragement. Reserved space is 128 bytes.
+ * The 1st 64-bit word saves fault PC address, 2nd word is the fault
+ * instruction bundle followed by 14 JIT bundles.
+ */
+
+struct unaligned_jit_fragment {
+	unsigned long       pc;
+	tilegx_bundle_bits  bundle;
+	tilegx_bundle_bits  insn[14];
+};
+
+/*
+ * Check if a nop or fnop at bundle's pipeline X0.
+ */
+
+static bool is_bundle_x0_nop(tilegx_bundle_bits bundle)
+{
+	return (((get_UnaryOpcodeExtension_X0(bundle) ==
+		  NOP_UNARY_OPCODE_X0) &&
+		 (get_RRROpcodeExtension_X0(bundle) ==
+		  UNARY_RRR_0_OPCODE_X0) &&
+		 (get_Opcode_X0(bundle) ==
+		  RRR_0_OPCODE_X0)) ||
+		((get_UnaryOpcodeExtension_X0(bundle) ==
+		  FNOP_UNARY_OPCODE_X0) &&
+		 (get_RRROpcodeExtension_X0(bundle) ==
+		  UNARY_RRR_0_OPCODE_X0) &&
+		 (get_Opcode_X0(bundle) ==
+		  RRR_0_OPCODE_X0)));
+}
+
+/*
+ * Check if nop or fnop at bundle's pipeline X1.
+ */
+
+static bool is_bundle_x1_nop(tilegx_bundle_bits bundle)
+{
+	return (((get_UnaryOpcodeExtension_X1(bundle) ==
+		  NOP_UNARY_OPCODE_X1) &&
+		 (get_RRROpcodeExtension_X1(bundle) ==
+		  UNARY_RRR_0_OPCODE_X1) &&
+		 (get_Opcode_X1(bundle) ==
+		  RRR_0_OPCODE_X1)) ||
+		((get_UnaryOpcodeExtension_X1(bundle) ==
+		  FNOP_UNARY_OPCODE_X1) &&
+		 (get_RRROpcodeExtension_X1(bundle) ==
+		  UNARY_RRR_0_OPCODE_X1) &&
+		 (get_Opcode_X1(bundle) ==
+		  RRR_0_OPCODE_X1)));
+}
+
+/*
+ * Check if nop or fnop at bundle's Y0 pipeline.
+ */
+
+static bool is_bundle_y0_nop(tilegx_bundle_bits bundle)
+{
+	return (((get_UnaryOpcodeExtension_Y0(bundle) ==
+		  NOP_UNARY_OPCODE_Y0) &&
+		 (get_RRROpcodeExtension_Y0(bundle) ==
+		  UNARY_RRR_1_OPCODE_Y0) &&
+		 (get_Opcode_Y0(bundle) ==
+		  RRR_1_OPCODE_Y0)) ||
+		((get_UnaryOpcodeExtension_Y0(bundle) ==
+		  FNOP_UNARY_OPCODE_Y0) &&
+		 (get_RRROpcodeExtension_Y0(bundle) ==
+		  UNARY_RRR_1_OPCODE_Y0) &&
+		 (get_Opcode_Y0(bundle) ==
+		  RRR_1_OPCODE_Y0)));
+}
+
+/*
+ * Check if nop or fnop at bundle's pipeline Y1.
+ */
+
+static bool is_bundle_y1_nop(tilegx_bundle_bits bundle)
+{
+	return (((get_UnaryOpcodeExtension_Y1(bundle) ==
+		  NOP_UNARY_OPCODE_Y1) &&
+		 (get_RRROpcodeExtension_Y1(bundle) ==
+		  UNARY_RRR_1_OPCODE_Y1) &&
+		 (get_Opcode_Y1(bundle) ==
+		  RRR_1_OPCODE_Y1)) ||
+		((get_UnaryOpcodeExtension_Y1(bundle) ==
+		  FNOP_UNARY_OPCODE_Y1) &&
+		 (get_RRROpcodeExtension_Y1(bundle) ==
+		  UNARY_RRR_1_OPCODE_Y1) &&
+		 (get_Opcode_Y1(bundle) ==
+		  RRR_1_OPCODE_Y1)));
+}
+
+/*
+ * Test if a bundle's y0 and y1 pipelines are both nop or fnop.
+ */
+
+static bool is_y0_y1_nop(tilegx_bundle_bits bundle)
+{
+	return is_bundle_y0_nop(bundle) && is_bundle_y1_nop(bundle);
+}
+
+/*
+ * Test if a bundle's x0 and x1 pipelines are both nop or fnop.
+ */
+
+static bool is_x0_x1_nop(tilegx_bundle_bits bundle)
+{
+	return is_bundle_x0_nop(bundle) && is_bundle_x1_nop(bundle);
+}
+
+/*
+ * Find the destination, source registers of fault unalign access instruction
+ * at X1 or Y2. Also, allocate up to 3 scratch registers clob1, clob2 and
+ * clob3, which are guaranteed different from any register used in the fault
+ * bundle. r_alias is used to return if the other instructions other than the
+ * unalign load/store shares same register with ra, rb and rd.
+ */
+
+static void find_regs(tilegx_bundle_bits bundle, uint64_t *rd, uint64_t *ra,
+		      uint64_t *rb, uint64_t *clob1, uint64_t *clob2,
+		      uint64_t *clob3, bool *r_alias)
+{
+	int i;
+	uint64_t reg;
+	uint64_t reg_map = 0, alias_reg_map = 0, map;
+	bool alias;
+
+	*ra = -1;
+	*rb = -1;
+
+	if (rd)
+		*rd = -1;
+
+	*clob1 = -1;
+	*clob2 = -1;
+	*clob3 = -1;
+	alias = false;
+
+	/*
+	 * Parse fault bundle, find potential used registers and mark
+	 * corresponding bits in reg_map and alias_map. These 2 bit maps
+	 * are used to find the scratch registers and determine if there
+	 * is register alais.
+	 */
+	if (bundle & TILEGX_BUNDLE_MODE_MASK) {  /* Y Mode Bundle. */
+
+		reg = get_SrcA_Y2(bundle);
+		reg_map |= 1ULL << reg;
+		*ra = reg;
+		reg = get_SrcBDest_Y2(bundle);
+		reg_map |= 1ULL << reg;
+
+		if (rd) {
+			/* Load. */
+			*rd = reg;
+			alias_reg_map = (1ULL << *rd) | (1ULL << *ra);
+		} else {
+			/* Store. */
+			*rb = reg;
+			alias_reg_map = (1ULL << *ra) | (1ULL << *rb);
+		}
+
+		if (!is_bundle_y1_nop(bundle)) {
+			reg = get_SrcA_Y1(bundle);
+			reg_map |= (1ULL << reg);
+			map = (1ULL << reg);
+
+			reg = get_SrcB_Y1(bundle);
+			reg_map |= (1ULL << reg);
+			map |= (1ULL << reg);
+
+			reg = get_Dest_Y1(bundle);
+			reg_map |= (1ULL << reg);
+			map |= (1ULL << reg);
+
+			if (map & alias_reg_map)
+				alias = true;
+		}
+
+		if (!is_bundle_y0_nop(bundle)) {
+			reg = get_SrcA_Y0(bundle);
+			reg_map |= (1ULL << reg);
+			map = (1ULL << reg);
+
+			reg = get_SrcB_Y0(bundle);
+			reg_map |= (1ULL << reg);
+			map |= (1ULL << reg);
+
+			reg = get_Dest_Y0(bundle);
+			reg_map |= (1ULL << reg);
+			map |= (1ULL << reg);
+
+			if (map & alias_reg_map)
+				alias = true;
+		}
+	} else	{ /* X Mode Bundle. */
+
+		reg = get_SrcA_X1(bundle);
+		reg_map |= (1ULL << reg);
+		*ra = reg;
+		if (rd)	{
+			/* Load. */
+			reg = get_Dest_X1(bundle);
+			reg_map |= (1ULL << reg);
+			*rd = reg;
+			alias_reg_map = (1ULL << *rd) | (1ULL << *ra);
+		} else {
+			/* Store. */
+			reg = get_SrcB_X1(bundle);
+			reg_map |= (1ULL << reg);
+			*rb = reg;
+			alias_reg_map = (1ULL << *ra) | (1ULL << *rb);
+		}
+
+		if (!is_bundle_x0_nop(bundle)) {
+			reg = get_SrcA_X0(bundle);
+			reg_map |= (1ULL << reg);
+			map = (1ULL << reg);
+
+			reg = get_SrcB_X0(bundle);
+			reg_map |= (1ULL << reg);
+			map |= (1ULL << reg);
+
+			reg = get_Dest_X0(bundle);
+			reg_map |= (1ULL << reg);
+			map |= (1ULL << reg);
+
+			if (map & alias_reg_map)
+				alias = true;
+		}
+	}
+
+	/*
+	 * "alias" indicates if the unalign access registers have collision
+	 * with others in the same bundle. We jsut simply test all register
+	 * operands case (RRR), ignored the case with immidate. If a bundle
+	 * has no register alias, we may do fixup in a simple or fast manner.
+	 * So if an immidata field happens to hit with a register, we may end
+	 * up fall back to the generic handling.
+	 */
+
+	*r_alias = alias;
+
+	/* Flip bits on reg_map. */
+	reg_map ^= -1ULL;
+
+	/* Scan reg_map lower 54(TREG_SP) bits to find 3 set bits. */
+	for (i = 0; i < TREG_SP; i++) {
+		if (reg_map & (0x1ULL << i)) {
+			if (*clob1 == -1) {
+				*clob1 = i;
+			} else if (*clob2 == -1) {
+				*clob2 = i;
+			} else if (*clob3 == -1) {
+				*clob3 = i;
+				return;
+			}
+		}
+	}
+}
+
+/*
+ * Sanity check for register ra, rb, rd, clob1/2/3. Return true if any of them
+ * is unexpected.
+ */
+
+static bool check_regs(uint64_t rd, uint64_t ra, uint64_t rb,
+		       uint64_t clob1, uint64_t clob2,  uint64_t clob3)
+{
+	bool unexpected = false;
+	if ((ra >= 56) && (ra != TREG_ZERO))
+		unexpected = true;
+
+	if ((clob1 >= 56) || (clob2 >= 56) || (clob3 >= 56))
+		unexpected = true;
+
+	if (rd != -1) {
+		if ((rd >= 56) && (rd != TREG_ZERO))
+			unexpected = true;
+	} else {
+		if ((rb >= 56) && (rb != TREG_ZERO))
+			unexpected = true;
+	}
+	return unexpected;
+}
+
+
+#define  GX_INSN_X0_MASK   ((1ULL << 31) - 1)
+#define  GX_INSN_X1_MASK   (((1ULL << 31) - 1) << 31)
+#define  GX_INSN_Y0_MASK   ((0xFULL << 27) | (0xFFFFFULL))
+#define  GX_INSN_Y1_MASK   (GX_INSN_Y0_MASK << 31)
+#define  GX_INSN_Y2_MASK   ((0x7FULL << 51) | (0x7FULL << 20))
+
+#ifdef __LITTLE_ENDIAN
+#define  GX_INSN_BSWAP(_bundle_)    (_bundle_)
+#else
+#define  GX_INSN_BSWAP(_bundle_)    swab64(_bundle_)
+#endif /* __LITTLE_ENDIAN */
+
+/*
+ * __JIT_CODE(.) creates template bundles in .rodata.unalign_data section.
+ * The corresponding static function jix_x#_###(.) generates partial or
+ * whole bundle based on the template and given arguments.
+ */
+
+#define __JIT_CODE(_X_)						\
+	asm (".pushsection .rodata.unalign_data, \"a\"\n"	\
+	     _X_"\n"						\
+	     ".popsection\n")
+
+__JIT_CODE("__unalign_jit_x1_mtspr:   {mtspr 0,  r0}");
+static tilegx_bundle_bits jit_x1_mtspr(int spr, int reg)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_mtspr;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_mtspr) & GX_INSN_X1_MASK) |
+		create_MT_Imm14_X1(spr) | create_SrcA_X1(reg);
+}
+
+__JIT_CODE("__unalign_jit_x1_mfspr:   {mfspr r0, 0}");
+static tilegx_bundle_bits  jit_x1_mfspr(int reg, int spr)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_mfspr;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_mfspr) & GX_INSN_X1_MASK) |
+		create_MF_Imm14_X1(spr) | create_Dest_X1(reg);
+}
+
+__JIT_CODE("__unalign_jit_x0_addi:   {addi  r0, r0, 0; iret}");
+static tilegx_bundle_bits  jit_x0_addi(int rd, int ra, int imm8)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x0_addi;
+	return (GX_INSN_BSWAP(__unalign_jit_x0_addi) & GX_INSN_X0_MASK) |
+		create_Dest_X0(rd) | create_SrcA_X0(ra) |
+		create_Imm8_X0(imm8);
+}
+
+__JIT_CODE("__unalign_jit_x1_ldna:   {ldna  r0, r0}");
+static tilegx_bundle_bits  jit_x1_ldna(int rd, int ra)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_ldna;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_ldna) &  GX_INSN_X1_MASK) |
+		create_Dest_X1(rd) | create_SrcA_X1(ra);
+}
+
+__JIT_CODE("__unalign_jit_x0_dblalign:   {dblalign r0, r0 ,r0}");
+static tilegx_bundle_bits  jit_x0_dblalign(int rd, int ra, int rb)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x0_dblalign;
+	return (GX_INSN_BSWAP(__unalign_jit_x0_dblalign) & GX_INSN_X0_MASK) |
+		create_Dest_X0(rd) | create_SrcA_X0(ra) |
+		create_SrcB_X0(rb);
+}
+
+__JIT_CODE("__unalign_jit_x1_iret:   {iret}");
+static tilegx_bundle_bits  jit_x1_iret(void)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_iret;
+	return GX_INSN_BSWAP(__unalign_jit_x1_iret) & GX_INSN_X1_MASK;
+}
+
+__JIT_CODE("__unalign_jit_x01_fnop:   {fnop;fnop}");
+static tilegx_bundle_bits  jit_x0_fnop(void)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x01_fnop;
+	return GX_INSN_BSWAP(__unalign_jit_x01_fnop) & GX_INSN_X0_MASK;
+}
+
+static tilegx_bundle_bits  jit_x1_fnop(void)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x01_fnop;
+	return GX_INSN_BSWAP(__unalign_jit_x01_fnop) & GX_INSN_X1_MASK;
+}
+
+__JIT_CODE("__unalign_jit_y2_dummy:   {fnop; fnop; ld zero, sp}");
+static tilegx_bundle_bits  jit_y2_dummy(void)
+{
+	extern  tilegx_bundle_bits __unalign_jit_y2_dummy;
+	return GX_INSN_BSWAP(__unalign_jit_y2_dummy) & GX_INSN_Y2_MASK;
+}
+
+static tilegx_bundle_bits  jit_y1_fnop(void)
+{
+	extern  tilegx_bundle_bits __unalign_jit_y2_dummy;
+	return GX_INSN_BSWAP(__unalign_jit_y2_dummy) & GX_INSN_Y1_MASK;
+}
+
+__JIT_CODE("__unalign_jit_x1_st1_add:  {st1_add r1, r0, 0}");
+static tilegx_bundle_bits  jit_x1_st1_add(int ra, int rb, int imm8)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_st1_add;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_st1_add) &
+		(~create_SrcA_X1(-1)) &
+		GX_INSN_X1_MASK) | create_SrcA_X1(ra) |
+		create_SrcB_X1(rb) | create_Dest_Imm8_X1(imm8);
+}
+
+__JIT_CODE("__unalign_jit_x1_st:  {crc32_8 r1, r0, r0; st  r0, r0}");
+static tilegx_bundle_bits  jit_x1_st(int ra, int rb)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_st;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_st) & GX_INSN_X1_MASK) |
+		create_SrcA_X1(ra) | create_SrcB_X1(rb);
+}
+
+__JIT_CODE("__unalign_jit_x1_st_add:  {st_add  r1, r0, 0}");
+static tilegx_bundle_bits  jit_x1_st_add(int ra, int rb, int imm8)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_st_add;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_st_add) &
+		(~create_SrcA_X1(-1)) &
+		GX_INSN_X1_MASK) | create_SrcA_X1(ra) |
+		create_SrcB_X1(rb) | create_Dest_Imm8_X1(imm8);
+}
+
+__JIT_CODE("__unalign_jit_x1_ld:  {crc32_8 r1, r0, r0; ld  r0, r0}");
+static tilegx_bundle_bits  jit_x1_ld(int rd, int ra)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_ld;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_ld) & GX_INSN_X1_MASK) |
+		create_Dest_X1(rd) | create_SrcA_X1(ra);
+}
+
+__JIT_CODE("__unalign_jit_x1_ld_add:  {ld_add  r1, r0, 0}");
+static tilegx_bundle_bits  jit_x1_ld_add(int rd, int ra, int imm8)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_ld_add;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_ld_add) &
+		(~create_Dest_X1(-1)) &
+		GX_INSN_X1_MASK) | create_Dest_X1(rd) |
+		create_SrcA_X1(ra) | create_Imm8_X1(imm8);
+}
+
+__JIT_CODE("__unalign_jit_x0_bfexts:  {bfexts r0, r0, 0, 0}");
+static tilegx_bundle_bits  jit_x0_bfexts(int rd, int ra, int bfs, int bfe)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x0_bfexts;
+	return (GX_INSN_BSWAP(__unalign_jit_x0_bfexts) &
+		GX_INSN_X0_MASK) |
+		create_Dest_X0(rd) | create_SrcA_X0(ra) |
+		create_BFStart_X0(bfs) | create_BFEnd_X0(bfe);
+}
+
+__JIT_CODE("__unalign_jit_x0_bfextu:  {bfextu r0, r0, 0, 0}");
+static tilegx_bundle_bits  jit_x0_bfextu(int rd, int ra, int bfs, int bfe)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x0_bfextu;
+	return (GX_INSN_BSWAP(__unalign_jit_x0_bfextu) &
+		GX_INSN_X0_MASK) |
+		create_Dest_X0(rd) | create_SrcA_X0(ra) |
+		create_BFStart_X0(bfs) | create_BFEnd_X0(bfe);
+}
+
+__JIT_CODE("__unalign_jit_x1_addi:  {bfextu r1, r1, 0, 0; addi r0, r0, 0}");
+static tilegx_bundle_bits  jit_x1_addi(int rd, int ra, int imm8)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_addi;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_addi) & GX_INSN_X1_MASK) |
+		create_Dest_X1(rd) | create_SrcA_X1(ra) |
+		create_Imm8_X1(imm8);
+}
+
+__JIT_CODE("__unalign_jit_x0_shrui:  {shrui r0, r0, 0; iret}");
+static tilegx_bundle_bits  jit_x0_shrui(int rd, int ra, int imm6)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x0_shrui;
+	return (GX_INSN_BSWAP(__unalign_jit_x0_shrui) &
+		GX_INSN_X0_MASK) |
+		create_Dest_X0(rd) | create_SrcA_X0(ra) |
+		create_ShAmt_X0(imm6);
+}
+
+__JIT_CODE("__unalign_jit_x0_rotli:  {rotli r0, r0, 0; iret}");
+static tilegx_bundle_bits  jit_x0_rotli(int rd, int ra, int imm6)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x0_rotli;
+	return (GX_INSN_BSWAP(__unalign_jit_x0_rotli) &
+		GX_INSN_X0_MASK) |
+		create_Dest_X0(rd) | create_SrcA_X0(ra) |
+		create_ShAmt_X0(imm6);
+}
+
+__JIT_CODE("__unalign_jit_x1_bnezt:  {bnezt r0, __unalign_jit_x1_bnezt}");
+static tilegx_bundle_bits  jit_x1_bnezt(int ra, int broff)
+{
+	extern  tilegx_bundle_bits __unalign_jit_x1_bnezt;
+	return (GX_INSN_BSWAP(__unalign_jit_x1_bnezt) &
+		GX_INSN_X1_MASK) |
+		create_SrcA_X1(ra) | create_BrOff_X1(broff);
+}
+
+#undef __JIT_CODE
+
+/*
+ * This function generates unalign fixup JIT.
+ *
+ * We fist find unalign load/store instruction's destination, source
+ * reguisters: ra, rb and rd. and 3 scratch registers by calling
+ * find_regs(...). 3 scratch clobbers should not alias with any register
+ * used in the fault bundle. Then analyze the fault bundle to determine
+ * if it's a load or store, operand width, branch or address increment etc.
+ * At last generated JIT is copied into JIT code area in user space.
+ */
+
+static
+void jit_bundle_gen(struct pt_regs *regs, tilegx_bundle_bits bundle,
+		    int align_ctl)
+{
+	struct thread_info *info = current_thread_info();
+	struct unaligned_jit_fragment frag;
+	struct unaligned_jit_fragment *jit_code_area;
+	tilegx_bundle_bits bundle_2 = 0;
+	/* If bundle_2_enable = false, bundle_2 is fnop/nop operation. */
+	bool     bundle_2_enable = true;
+	uint64_t ra, rb, rd = -1, clob1, clob2, clob3;
+	/*
+	 * Indicate if the unalign access
+	 * instruction's registers hit with
+	 * others in the same bundle.
+	 */
+	bool     alias = false;
+	bool     load_n_store = true;
+	bool     load_store_signed = false;
+	unsigned int  load_store_size = 8;
+	bool     y1_br = false;  /* True, for a branch in same bundle at Y1.*/
+	int      y1_br_reg = 0;
+	/* True for link operation. i.e. jalr or lnk at Y1 */
+	bool     y1_lr = false;
+	int      y1_lr_reg = 0;
+	bool     x1_add = false;/* True, for load/store ADD instruction at X1*/
+	int      x1_add_imm8 = 0;
+	bool     unexpected = false;
+	int      n = 0, k;
+
+	jit_code_area =
+		(struct unaligned_jit_fragment *)(info->unalign_jit_base);
+
+	memset((void *)&frag, 0, sizeof(frag));
+
+	/* 0: X mode, Otherwise: Y mode. */
+	if (bundle & TILEGX_BUNDLE_MODE_MASK) {
+		unsigned int mod, opcode;
+
+		if (get_Opcode_Y1(bundle) == RRR_1_OPCODE_Y1 &&
+		    get_RRROpcodeExtension_Y1(bundle) ==
+		    UNARY_RRR_1_OPCODE_Y1) {
+
+			opcode = get_UnaryOpcodeExtension_Y1(bundle);
+
+			/*
+			 * Test "jalr", "jalrp", "jr", "jrp" instruction at Y1
+			 * pipeline.
+			 */
+			switch (opcode) {
+			case JALR_UNARY_OPCODE_Y1:
+			case JALRP_UNARY_OPCODE_Y1:
+				y1_lr = true;
+				y1_lr_reg = 55; /* Link register. */
+				/* FALLTHROUGH */
+			case JR_UNARY_OPCODE_Y1:
+			case JRP_UNARY_OPCODE_Y1:
+				y1_br = true;
+				y1_br_reg = get_SrcA_Y1(bundle);
+				break;
+			case LNK_UNARY_OPCODE_Y1:
+				/* "lnk" at Y1 pipeline. */
+				y1_lr = true;
+				y1_lr_reg = get_Dest_Y1(bundle);
+				break;
+			}
+		}
+
+		opcode = get_Opcode_Y2(bundle);
+		mod = get_Mode(bundle);
+
+		/*
+		 *  bundle_2 is bundle after making Y2 as a dummy operation
+		 *  - ld zero, sp
+		 */
+		bundle_2 = (bundle & (~GX_INSN_Y2_MASK)) | jit_y2_dummy();
+
+		/* Make Y1 as fnop if Y1 is a branch or lnk operation. */
+		if (y1_br || y1_lr) {
+			bundle_2 &= ~(GX_INSN_Y1_MASK);
+			bundle_2 |= jit_y1_fnop();
+		}
+
+		if (is_y0_y1_nop(bundle_2))
+			bundle_2_enable = false;
+
+		if (mod == MODE_OPCODE_YC2) {
+			/* Store. */
+			load_n_store = false;
+			load_store_size = 1 << opcode;
+			load_store_signed = false;
+			find_regs(bundle, 0, &ra, &rb, &clob1, &clob2,
+				  &clob3, &alias);
+			if (load_store_size > 8)
+				unexpected = true;
+		} else {
+			/* Load. */
+			load_n_store = true;
+			if (mod == MODE_OPCODE_YB2) {
+				switch (opcode) {
+				case LD_OPCODE_Y2:
+					load_store_signed = false;
+					load_store_size = 8;
+					break;
+				case LD4S_OPCODE_Y2:
+					load_store_signed = true;
+					load_store_size = 4;
+					break;
+				case LD4U_OPCODE_Y2:
+					load_store_signed = false;
+					load_store_size = 4;
+					break;
+				default:
+					unexpected = true;
+				}
+			} else if (mod == MODE_OPCODE_YA2) {
+				if (opcode == LD2S_OPCODE_Y2) {
+					load_store_signed = true;
+					load_store_size = 2;
+				} else if (opcode == LD2U_OPCODE_Y2) {
+					load_store_signed = false;
+					load_store_size = 2;
+				} else
+					unexpected = true;
+			} else
+				unexpected = true;
+			find_regs(bundle, &rd, &ra, &rb, &clob1, &clob2,
+				  &clob3, &alias);
+		}
+	} else {
+		unsigned int opcode;
+
+		/* bundle_2 is bundle after making X1 as "fnop". */
+		bundle_2 = (bundle & (~GX_INSN_X1_MASK)) | jit_x1_fnop();
+
+		if (is_x0_x1_nop(bundle_2))
+			bundle_2_enable = false;
+
+		if (get_Opcode_X1(bundle) == RRR_0_OPCODE_X1) {
+			opcode = get_UnaryOpcodeExtension_X1(bundle);
+
+			if (get_RRROpcodeExtension_X1(bundle) ==
+			    UNARY_RRR_0_OPCODE_X1) {
+				load_n_store = true;
+				find_regs(bundle, &rd, &ra, &rb, &clob1,
+					  &clob2, &clob3, &alias);
+
+				switch (opcode) {
+				case LD_UNARY_OPCODE_X1:
+					load_store_signed = false;
+					load_store_size = 8;
+					break;
+				case LD4S_UNARY_OPCODE_X1:
+					load_store_signed = true;
+					/* FALLTHROUGH */
+				case LD4U_UNARY_OPCODE_X1:
+					load_store_size = 4;
+					break;
+
+				case LD2S_UNARY_OPCODE_X1:
+					load_store_signed = true;
+					/* FALLTHROUGH */
+				case LD2U_UNARY_OPCODE_X1:
+					load_store_size = 2;
+					break;
+				default:
+					unexpected = true;
+				}
+			} else {
+				load_n_store = false;
+				load_store_signed = false;
+				find_regs(bundle, 0, &ra, &rb,
+					  &clob1, &clob2, &clob3,
+					  &alias);
+
+				opcode = get_RRROpcodeExtension_X1(bundle);
+				switch (opcode)	{
+				case ST_RRR_0_OPCODE_X1:
+					load_store_size = 8;
+					break;
+				case ST4_RRR_0_OPCODE_X1:
+					load_store_size = 4;
+					break;
+				case ST2_RRR_0_OPCODE_X1:
+					load_store_size = 2;
+					break;
+				default:
+					unexpected = true;
+				}
+			}
+		} else if (get_Opcode_X1(bundle) == IMM8_OPCODE_X1) {
+			load_n_store = true;
+			opcode = get_Imm8OpcodeExtension_X1(bundle);
+			switch (opcode)	{
+			case LD_ADD_IMM8_OPCODE_X1:
+				load_store_size = 8;
+				break;
+
+			case LD4S_ADD_IMM8_OPCODE_X1:
+				load_store_signed = true;
+				/* FALLTHROUGH */
+			case LD4U_ADD_IMM8_OPCODE_X1:
+				load_store_size = 4;
+				break;
+
+			case LD2S_ADD_IMM8_OPCODE_X1:
+				load_store_signed = true;
+				/* FALLTHROUGH */
+			case LD2U_ADD_IMM8_OPCODE_X1:
+				load_store_size = 2;
+				break;
+
+			case ST_ADD_IMM8_OPCODE_X1:
+				load_n_store = false;
+				load_store_size = 8;
+				break;
+			case ST4_ADD_IMM8_OPCODE_X1:
+				load_n_store = false;
+				load_store_size = 4;
+				break;
+			case ST2_ADD_IMM8_OPCODE_X1:
+				load_n_store = false;
+				load_store_size = 2;
+				break;
+			default:
+				unexpected = true;
+			}
+
+			if (!unexpected) {
+				x1_add = true;
+				if (load_n_store)
+					x1_add_imm8 = get_Imm8_X1(bundle);
+				else
+					x1_add_imm8 = get_Dest_Imm8_X1(bundle);
+			}
+
+			find_regs(bundle, load_n_store ? (&rd) : NULL,
+				  &ra, &rb, &clob1, &clob2, &clob3, &alias);
+		} else
+			unexpected = true;
+	}
+
+	/*
+	 * Some sanity check for register numbers extracted from fault bundle.
+	 */
+	if (check_regs(rd, ra, rb, clob1, clob2, clob3) == true)
+		unexpected = true;
+
+	/* Give warning if register ra has an aligned address. */
+	if (!unexpected)
+		WARN_ON(!((load_store_size - 1) & (regs->regs[ra])));
+
+
+	/*
+	 * Fault came from kernel space, here we only need take care of
+	 * unaligned "get_user/put_user" macros defined in "uaccess.h".
+	 * Basically, we will handle bundle like this:
+	 * {ld/2u/4s rd, ra; movei rx, 0} or {st/2/4 ra, rb; movei rx, 0}
+	 * (Refer to file "arch/tile/include/asm/uaccess.h" for details).
+	 * For either load or store, byte-wise operation is performed by calling
+	 * get_user() or put_user(). If the macro returns non-zero value,
+	 * set the value to rx, otherwise set zero to rx. Finally make pc point
+	 * to next bundle and return.
+	 */
+
+	if (EX1_PL(regs->ex1) != USER_PL) {
+
+		unsigned long rx = 0;
+		unsigned long x = 0, ret = 0;
+
+		if (y1_br || y1_lr || x1_add ||
+		    (load_store_signed !=
+		     (load_n_store && load_store_size == 4))) {
+			/* No branch, link, wrong sign-ext or load/store add. */
+			unexpected = true;
+		} else if (!unexpected) {
+			if (bundle & TILEGX_BUNDLE_MODE_MASK) {
+				/*
+				 * Fault bundle is Y mode.
+				 * Check if the Y1 and Y0 is the form of
+				 * { movei rx, 0; nop/fnop }, if yes,
+				 * find the rx.
+				 */
+
+				if ((get_Opcode_Y1(bundle) == ADDI_OPCODE_Y1)
+				    && (get_SrcA_Y1(bundle) == TREG_ZERO) &&
+				    (get_Imm8_Y1(bundle) == 0) &&
+				    is_bundle_y0_nop(bundle)) {
+					rx = get_Dest_Y1(bundle);
+				} else if ((get_Opcode_Y0(bundle) ==
+					    ADDI_OPCODE_Y0) &&
+					   (get_SrcA_Y0(bundle) == TREG_ZERO) &&
+					   (get_Imm8_Y0(bundle) == 0) &&
+					   is_bundle_y1_nop(bundle)) {
+					rx = get_Dest_Y0(bundle);
+				} else {
+					unexpected = true;
+				}
+			} else {
+				/*
+				 * Fault bundle is X mode.
+				 * Check if the X0 is 'movei rx, 0',
+				 * if yes, find the rx.
+				 */
+
+				if ((get_Opcode_X0(bundle) == IMM8_OPCODE_X0)
+				    && (get_Imm8OpcodeExtension_X0(bundle) ==
+					ADDI_IMM8_OPCODE_X0) &&
+				    (get_SrcA_X0(bundle) == TREG_ZERO) &&
+				    (get_Imm8_X0(bundle) == 0)) {
+					rx = get_Dest_X0(bundle);
+				} else {
+					unexpected = true;
+				}
+			}
+
+			/* rx should be less than 56. */
+			if (!unexpected && (rx >= 56))
+				unexpected = true;
+		}
+
+		if (!search_exception_tables(regs->pc)) {
+			/* No fixup in the exception tables for the pc. */
+			unexpected = true;
+		}
+
+		if (unexpected) {
+			/* Unexpected unalign kernel fault. */
+			struct task_struct *tsk = validate_current();
+
+			bust_spinlocks(1);
+
+			show_regs(regs);
+
+			if (unlikely(tsk->pid < 2)) {
+				panic("Kernel unalign fault running %s!",
+				      tsk->pid ? "init" : "the idle task");
+			}
+#ifdef SUPPORT_DIE
+			die("Oops", regs);
+#endif
+			bust_spinlocks(1);
+
+			do_group_exit(SIGKILL);
+
+		} else {
+			unsigned long i, b = 0;
+			unsigned char *ptr =
+				(unsigned char *)regs->regs[ra];
+			if (load_n_store) {
+				/* handle get_user(x, ptr) */
+				for (i = 0; i < load_store_size; i++) {
+					ret = get_user(b, ptr++);
+					if (!ret) {
+						/* Success! update x. */
+#ifdef __LITTLE_ENDIAN
+						x |= (b << (8 * i));
+#else
+						x <<= 8;
+						x |= b;
+#endif /* __LITTLE_ENDIAN */
+					} else {
+						x = 0;
+						break;
+					}
+				}
+
+				/* Sign-extend 4-byte loads. */
+				if (load_store_size == 4)
+					x = (long)(int)x;
+
+				/* Set register rd. */
+				regs->regs[rd] = x;
+
+				/* Set register rx. */
+				regs->regs[rx] = ret;
+
+				/* Bump pc. */
+				regs->pc += 8;
+
+			} else {
+				/* Handle put_user(x, ptr) */
+				x = regs->regs[rb];
+#ifdef __LITTLE_ENDIAN
+				b = x;
+#else
+				/*
+				 * Swap x in order to store x from low
+				 * to high memory same as the
+				 * little-endian case.
+				 */
+				switch (load_store_size) {
+				case 8:
+					b = swab64(x);
+					break;
+				case 4:
+					b = swab32(x);
+					break;
+				case 2:
+					b = swab16(x);
+					break;
+				}
+#endif /* __LITTLE_ENDIAN */
+				for (i = 0; i < load_store_size; i++) {
+					ret = put_user(b, ptr++);
+					if (ret)
+						break;
+					/* Success! shift 1 byte. */
+					b >>= 8;
+				}
+				/* Set register rx. */
+				regs->regs[rx] = ret;
+
+				/* Bump pc. */
+				regs->pc += 8;
+			}
+		}
+
+		unaligned_fixup_count++;
+
+		if (unaligned_printk) {
+			pr_info("%s/%d. Unalign fixup for kernel access "
+				"to userspace %lx.",
+				current->comm, current->pid, regs->regs[ra]);
+		}
+
+		/* Done! Return to the exception handler. */
+		return;
+	}
+
+	if ((align_ctl == 0) || unexpected) {
+		siginfo_t info = {
+			.si_signo = SIGBUS,
+			.si_code = BUS_ADRALN,
+			.si_addr = (unsigned char __user *)0
+		};
+		if (unaligned_printk)
+			pr_info("Unalign bundle: unexp @%llx, %llx",
+				(unsigned long long)regs->pc,
+				(unsigned long long)bundle);
+
+		if (ra < 56) {
+			unsigned long uaa = (unsigned long)regs->regs[ra];
+			/* Set bus Address. */
+			info.si_addr = (unsigned char __user *)uaa;
+		}
+
+		unaligned_fixup_count++;
+
+		trace_unhandled_signal("unaligned fixup trap", regs,
+				       (unsigned long)info.si_addr, SIGBUS);
+		force_sig_info(info.si_signo, &info, current);
+		return;
+	}
+
+#ifdef __LITTLE_ENDIAN
+#define UA_FIXUP_ADDR_DELTA          1
+#define UA_FIXUP_BFEXT_START(_B_)    0
+#define UA_FIXUP_BFEXT_END(_B_)     (8 * (_B_) - 1)
+#else /* __BIG_ENDIAN */
+#define UA_FIXUP_ADDR_DELTA          -1
+#define UA_FIXUP_BFEXT_START(_B_)   (64 - 8 * (_B_))
+#define UA_FIXUP_BFEXT_END(_B_)      63
+#endif /* __LITTLE_ENDIAN */
+
+
+
+	if ((ra != rb) && (rd != TREG_SP) && !alias &&
+	    !y1_br && !y1_lr && !x1_add) {
+		/*
+		 * Simple case: ra != rb and no register alias found,
+		 * and no branch or link. This will be the majority.
+		 * We can do a little better for simplae case than the
+		 * generic scheme below.
+		 */
+		if (!load_n_store) {
+			/*
+			 * Simple store: ra != rb, no need for scratch register.
+			 * Just store and rotate to right bytewise.
+			 */
+#ifdef __BIG_ENDIAN
+			frag.insn[n++] =
+				jit_x0_addi(ra, ra, load_store_size - 1) |
+				jit_x1_fnop();
+#endif /* __BIG_ENDIAN */
+			for (k = 0; k < load_store_size; k++) {
+				/* Store a byte. */
+				frag.insn[n++] =
+					jit_x0_rotli(rb, rb, 56) |
+					jit_x1_st1_add(ra, rb,
+						       UA_FIXUP_ADDR_DELTA);
+			}
+#ifdef __BIG_ENDIAN
+			frag.insn[n] = jit_x1_addi(ra, ra, 1);
+#else
+			frag.insn[n] = jit_x1_addi(ra, ra,
+						   -1 * load_store_size);
+#endif /* __LITTLE_ENDIAN */
+
+			if (load_store_size == 8) {
+				frag.insn[n] |= jit_x0_fnop();
+			} else if (load_store_size == 4) {
+				frag.insn[n] |= jit_x0_rotli(rb, rb, 32);
+			} else { /* = 2 */
+				frag.insn[n] |= jit_x0_rotli(rb, rb, 16);
+			}
+			n++;
+			if (bundle_2_enable)
+				frag.insn[n++] = bundle_2;
+			frag.insn[n++] = jit_x0_fnop() | jit_x1_iret();
+		} else {
+			if (rd == ra) {
+				/* Use two clobber registers: clob1/2. */
+				frag.insn[n++] =
+					jit_x0_addi(TREG_SP, TREG_SP, -16) |
+					jit_x1_fnop();
+				frag.insn[n++] =
+					jit_x0_addi(clob1, ra, 7) |
+					jit_x1_st_add(TREG_SP, clob1, -8);
+				frag.insn[n++] =
+					jit_x0_addi(clob2, ra, 0) |
+					jit_x1_st(TREG_SP, clob2);
+				frag.insn[n++] =
+					jit_x0_fnop() |
+					jit_x1_ldna(rd, ra);
+				frag.insn[n++] =
+					jit_x0_fnop() |
+					jit_x1_ldna(clob1, clob1);
+				/*
+				 * Note: we must make sure that rd must not
+				 * be sp. Recover clob1/2 from stack.
+				 */
+				frag.insn[n++] =
+					jit_x0_dblalign(rd, clob1, clob2) |
+					jit_x1_ld_add(clob2, TREG_SP, 8);
+				frag.insn[n++] =
+					jit_x0_fnop() |
+					jit_x1_ld_add(clob1, TREG_SP, 16);
+			} else {
+				/* Use one clobber register: clob1 only. */
+				frag.insn[n++] =
+					jit_x0_addi(TREG_SP, TREG_SP, -16) |
+					jit_x1_fnop();
+				frag.insn[n++] =
+					jit_x0_addi(clob1, ra, 7) |
+					jit_x1_st(TREG_SP, clob1);
+				frag.insn[n++] =
+					jit_x0_fnop() |
+					jit_x1_ldna(rd, ra);
+				frag.insn[n++] =
+					jit_x0_fnop() |
+					jit_x1_ldna(clob1, clob1);
+				/*
+				 * Note: we must make sure that rd must not
+				 * be sp. Recover clob1 from stack.
+				 */
+				frag.insn[n++] =
+					jit_x0_dblalign(rd, clob1, ra) |
+					jit_x1_ld_add(clob1, TREG_SP, 16);
+			}
+
+			if (bundle_2_enable)
+				frag.insn[n++] = bundle_2;
+			/*
+			 * For non 8-byte load, extract corresponding bytes and
+			 * signed extension.
+			 */
+			if (load_store_size == 4) {
+				if (load_store_signed)
+					frag.insn[n++] =
+						jit_x0_bfexts(
+							rd, rd,
+							UA_FIXUP_BFEXT_START(4),
+							UA_FIXUP_BFEXT_END(4)) |
+						jit_x1_fnop();
+				else
+					frag.insn[n++] =
+						jit_x0_bfextu(
+							rd, rd,
+							UA_FIXUP_BFEXT_START(4),
+							UA_FIXUP_BFEXT_END(4)) |
+						jit_x1_fnop();
+			} else if (load_store_size == 2) {
+				if (load_store_signed)
+					frag.insn[n++] =
+						jit_x0_bfexts(
+							rd, rd,
+							UA_FIXUP_BFEXT_START(2),
+							UA_FIXUP_BFEXT_END(2)) |
+						jit_x1_fnop();
+				else
+					frag.insn[n++] =
+						jit_x0_bfextu(
+							rd, rd,
+							UA_FIXUP_BFEXT_START(2),
+							UA_FIXUP_BFEXT_END(2)) |
+						jit_x1_fnop();
+			}
+
+			frag.insn[n++] =
+				jit_x0_fnop()  |
+				jit_x1_iret();
+		}
+	} else if (!load_n_store) {
+
+		/*
+		 * Generic memory store cases: use 3 clobber registers.
+		 *
+		 * Alloc space for saveing clob2,1,3 on user's stack.
+		 * register clob3 points to where clob2 saved, followed by
+		 * clob1 and 3 from high to low memory.
+		 */
+		frag.insn[n++] =
+			jit_x0_addi(TREG_SP, TREG_SP, -32)    |
+			jit_x1_fnop();
+		frag.insn[n++] =
+			jit_x0_addi(clob3, TREG_SP, 16)  |
+			jit_x1_st_add(TREG_SP, clob3, 8);
+#ifdef __LITTLE_ENDIAN
+		frag.insn[n++] =
+			jit_x0_addi(clob1, ra, 0)   |
+			jit_x1_st_add(TREG_SP, clob1, 8);
+#else
+		frag.insn[n++] =
+			jit_x0_addi(clob1, ra, load_store_size - 1)   |
+			jit_x1_st_add(TREG_SP, clob1, 8);
+#endif
+		if (load_store_size == 8) {
+			/*
+			 * We save one byte a time, not for fast, but compact
+			 * code. After each store, data source register shift
+			 * right one byte. unchanged after 8 stores.
+			 */
+			frag.insn[n++] =
+				jit_x0_addi(clob2, TREG_ZERO, 7)     |
+				jit_x1_st_add(TREG_SP, clob2, 16);
+			frag.insn[n++] =
+				jit_x0_rotli(rb, rb, 56)      |
+				jit_x1_st1_add(clob1, rb, UA_FIXUP_ADDR_DELTA);
+			frag.insn[n++] =
+				jit_x0_addi(clob2, clob2, -1) |
+				jit_x1_bnezt(clob2, -1);
+			frag.insn[n++] =
+				jit_x0_fnop()                 |
+				jit_x1_addi(clob2, y1_br_reg, 0);
+		} else if (load_store_size == 4) {
+			frag.insn[n++] =
+				jit_x0_addi(clob2, TREG_ZERO, 3)     |
+				jit_x1_st_add(TREG_SP, clob2, 16);
+			frag.insn[n++] =
+				jit_x0_rotli(rb, rb, 56)      |
+				jit_x1_st1_add(clob1, rb, UA_FIXUP_ADDR_DELTA);
+			frag.insn[n++] =
+				jit_x0_addi(clob2, clob2, -1) |
+				jit_x1_bnezt(clob2, -1);
+			/*
+			 * same as 8-byte case, but need shift another 4
+			 * byte to recover rb for 4-byte store.
+			 */
+			frag.insn[n++] = jit_x0_rotli(rb, rb, 32)      |
+				jit_x1_addi(clob2, y1_br_reg, 0);
+		} else { /* =2 */
+			frag.insn[n++] =
+				jit_x0_addi(clob2, rb, 0)     |
+				jit_x1_st_add(TREG_SP, clob2, 16);
+			for (k = 0; k < 2; k++) {
+				frag.insn[n++] =
+					jit_x0_shrui(rb, rb, 8)  |
+					jit_x1_st1_add(clob1, rb,
+						       UA_FIXUP_ADDR_DELTA);
+			}
+			frag.insn[n++] =
+				jit_x0_addi(rb, clob2, 0)       |
+				jit_x1_addi(clob2, y1_br_reg, 0);
+		}
+
+		if (bundle_2_enable)
+			frag.insn[n++] = bundle_2;
+
+		if (y1_lr) {
+			frag.insn[n++] =
+				jit_x0_fnop()                    |
+				jit_x1_mfspr(y1_lr_reg,
+					     SPR_EX_CONTEXT_0_0);
+		}
+		if (y1_br) {
+			frag.insn[n++] =
+				jit_x0_fnop()                    |
+				jit_x1_mtspr(SPR_EX_CONTEXT_0_0,
+					     clob2);
+		}
+		if (x1_add) {
+			frag.insn[n++] =
+				jit_x0_addi(ra, ra, x1_add_imm8) |
+				jit_x1_ld_add(clob2, clob3, -8);
+		} else {
+			frag.insn[n++] =
+				jit_x0_fnop()                    |
+				jit_x1_ld_add(clob2, clob3, -8);
+		}
+		frag.insn[n++] =
+			jit_x0_fnop()   |
+			jit_x1_ld_add(clob1, clob3, -8);
+		frag.insn[n++] = jit_x0_fnop()   | jit_x1_ld(clob3, clob3);
+		frag.insn[n++] = jit_x0_fnop()   | jit_x1_iret();
+
+	} else {
+		/*
+		 * Generic memory load cases.
+		 *
+		 * Alloc space for saveing clob1,2,3 on user's stack.
+		 * register clob3 points to where clob1 saved, followed
+		 * by clob2 and 3 from high to low memory.
+		 */
+
+		frag.insn[n++] =
+			jit_x0_addi(TREG_SP, TREG_SP, -32) |
+			jit_x1_fnop();
+		frag.insn[n++] =
+			jit_x0_addi(clob3, TREG_SP, 16) |
+			jit_x1_st_add(TREG_SP, clob3, 8);
+		frag.insn[n++] =
+			jit_x0_addi(clob2, ra, 0) |
+			jit_x1_st_add(TREG_SP, clob2, 8);
+
+		if (y1_br) {
+			frag.insn[n++] =
+				jit_x0_addi(clob1, y1_br_reg, 0) |
+				jit_x1_st_add(TREG_SP, clob1, 16);
+		} else {
+			frag.insn[n++] =
+				jit_x0_fnop() |
+				jit_x1_st_add(TREG_SP, clob1, 16);
+		}
+
+		if (bundle_2_enable)
+			frag.insn[n++] = bundle_2;
+
+		if (y1_lr) {
+			frag.insn[n++] =
+				jit_x0_fnop()  |
+				jit_x1_mfspr(y1_lr_reg,
+					     SPR_EX_CONTEXT_0_0);
+		}
+
+		if (y1_br) {
+			frag.insn[n++] =
+				jit_x0_fnop() |
+				jit_x1_mtspr(SPR_EX_CONTEXT_0_0,
+					     clob1);
+		}
+
+		frag.insn[n++] =
+			jit_x0_addi(clob1, clob2, 7)      |
+			jit_x1_ldna(rd, clob2);
+		frag.insn[n++] =
+			jit_x0_fnop()                     |
+			jit_x1_ldna(clob1, clob1);
+		frag.insn[n++] =
+			jit_x0_dblalign(rd, clob1, clob2) |
+			jit_x1_ld_add(clob1, clob3, -8);
+		if (x1_add) {
+			frag.insn[n++] =
+				jit_x0_addi(ra, ra, x1_add_imm8) |
+				jit_x1_ld_add(clob2, clob3, -8);
+		} else {
+			frag.insn[n++] =
+				jit_x0_fnop()  |
+				jit_x1_ld_add(clob2, clob3, -8);
+		}
+
+		frag.insn[n++] =
+			jit_x0_fnop() |
+			jit_x1_ld(clob3, clob3);
+
+		if (load_store_size == 4) {
+			if (load_store_signed)
+				frag.insn[n++] =
+					jit_x0_bfexts(
+						rd, rd,
+						UA_FIXUP_BFEXT_START(4),
+						UA_FIXUP_BFEXT_END(4)) |
+					jit_x1_fnop();
+			else
+				frag.insn[n++] =
+					jit_x0_bfextu(
+						rd, rd,
+						UA_FIXUP_BFEXT_START(4),
+						UA_FIXUP_BFEXT_END(4)) |
+					jit_x1_fnop();
+		} else if (load_store_size == 2) {
+			if (load_store_signed)
+				frag.insn[n++] =
+					jit_x0_bfexts(
+						rd, rd,
+						UA_FIXUP_BFEXT_START(2),
+						UA_FIXUP_BFEXT_END(2)) |
+					jit_x1_fnop();
+			else
+				frag.insn[n++] =
+					jit_x0_bfextu(
+						rd, rd,
+						UA_FIXUP_BFEXT_START(2),
+						UA_FIXUP_BFEXT_END(2)) |
+					jit_x1_fnop();
+		}
+
+		frag.insn[n++] = jit_x0_fnop() | jit_x1_iret();
+	}
+
+	/* Max JIT bundle count is 14. */
+	WARN_ON(n > 14);
+
+	if (!unexpected) {
+		int status = 0;
+		int idx = (regs->pc >> 3) &
+			((1ULL << (PAGE_SHIFT - UNALIGN_JIT_SHIFT)) - 1);
+
+		frag.pc = regs->pc;
+		frag.bundle = bundle;
+
+		if (unaligned_printk) {
+			pr_info("%s/%d, Unalign fixup: pc=%lx "
+				"bundle=%lx %d %d %d %d %d %d %d %d.",
+				current->comm, current->pid,
+				(unsigned long)frag.pc,
+				(unsigned long)frag.bundle,
+				(int)alias, (int)rd, (int)ra,
+				(int)rb, (int)bundle_2_enable,
+				(int)y1_lr, (int)y1_br, (int)x1_add);
+
+			for (k = 0; k < n; k += 2)
+				pr_info("[%d] %016llx %016llx", k,
+					(unsigned long long)frag.insn[k],
+					(unsigned long long)frag.insn[k+1]);
+		}
+
+		/* Swap bundle byte order for big endian sys. */
+#ifdef __BIG_ENDIAN
+		frag.bundle = GX_INSN_BSWAP(frag.bundle);
+		for (k = 0; k < n; k++)
+			frag.insn[k] = GX_INSN_BSWAP(frag.insn[k]);
+#endif /* __BIG_ENDIAN */
+
+		status = copy_to_user((void __user *)&jit_code_area[idx],
+				      &frag, sizeof(frag));
+		if (status) {
+			/* Fail to copy JIT into user land. send SIGSEGV. */
+			siginfo_t info = {
+				.si_signo = SIGSEGV,
+				.si_code = SEGV_MAPERR,
+				.si_addr = (void __user *)&jit_code_area[idx]
+			};
+
+			pr_warn("Unalign fixup: pid=%d %s jit_code_area=%llx",
+				current->pid, current->comm,
+				(unsigned long long)&jit_code_area[idx]);
+
+			trace_unhandled_signal("segfault in unalign fixup",
+					       regs,
+					       (unsigned long)info.si_addr,
+					       SIGSEGV);
+			force_sig_info(info.si_signo, &info, current);
+			return;
+		}
+
+
+		/* Do a cheaper increment, not accurate. */
+		unaligned_fixup_count++;
+		__flush_icache_range((unsigned long)&jit_code_area[idx],
+				     (unsigned long)&jit_code_area[idx] +
+				     sizeof(frag));
+
+		/* Setup SPR_EX_CONTEXT_0_0/1 for returning to user program.*/
+		__insn_mtspr(SPR_EX_CONTEXT_0_0, regs->pc + 8);
+		__insn_mtspr(SPR_EX_CONTEXT_0_1, PL_ICS_EX1(USER_PL, 0));
+
+		/* Modify pc at the start of new JIT. */
+		regs->pc = (unsigned long)&jit_code_area[idx].insn[0];
+		/* Set ICS in SPR_EX_CONTEXT_K_1. */
+		regs->ex1 = PL_ICS_EX1(USER_PL, 1);
+	}
+}
+
+
+/*
+ * C function to generate unalign data JIT. Called from unalign data
+ * interrupt handler.
+ *
+ * First check if unalign fix is disabled or exception did not not come from
+ * user space or sp register points to unalign address, if true, generate a
+ * SIGBUS. Then map a page into user space as JIT area if it is not mapped
+ * yet. Genenerate JIT code by calling jit_bundle_gen(). After that return
+ * back to exception handler.
+ *
+ * The exception handler will "iret" to new generated JIT code after
+ * restoring caller saved registers. In theory, the JIT code will perform
+ * another "iret" to resume user's program.
+ */
+
+void do_unaligned(struct pt_regs *regs, int vecnum)
+{
+	tilegx_bundle_bits __user  *pc;
+	tilegx_bundle_bits bundle;
+	struct thread_info *info = current_thread_info();
+	int align_ctl;
+
+	/* Checks the per-process unaligned JIT flags */
+	align_ctl = unaligned_fixup;
+	switch (task_thread_info(current)->align_ctl) {
+	case PR_UNALIGN_NOPRINT:
+		align_ctl = 1;
+		break;
+	case PR_UNALIGN_SIGBUS:
+		align_ctl = 0;
+		break;
+	}
+
+	/* Enable iterrupt in order to access user land. */
+	local_irq_enable();
+
+	/*
+	 * The fault came from kernel space. Two choices:
+	 * (a) unaligned_fixup < 1, we will first call get/put_user fixup
+	 *     to return -EFAULT. If no fixup, simply panic the kernel.
+	 * (b) unaligned_fixup >=1, we will try to fix the unaligned access
+	 *     if it was triggered by get_user/put_user() macros. Panic the
+	 *     kernel if it is not fixable.
+	 */
+
+	if (EX1_PL(regs->ex1) != USER_PL) {
+
+		if (align_ctl < 1) {
+			unaligned_fixup_count++;
+			/* If exception came from kernel, try fix it up. */
+			if (fixup_exception(regs)) {
+				if (unaligned_printk)
+					pr_info("Unalign fixup: %d %llx @%llx",
+						(int)unaligned_fixup,
+						(unsigned long long)regs->ex1,
+						(unsigned long long)regs->pc);
+				return;
+			}
+			/* Not fixable. Go panic. */
+			panic("Unalign exception in Kernel. pc=%lx",
+			      regs->pc);
+			return;
+		} else {
+			/*
+			 * Try to fix the exception. If we can't, panic the
+			 * kernel.
+			 */
+			bundle = GX_INSN_BSWAP(
+				*((tilegx_bundle_bits *)(regs->pc)));
+			jit_bundle_gen(regs, bundle, align_ctl);
+			return;
+		}
+	}
+
+	/*
+	 * Fault came from user with ICS or stack is not aligned.
+	 * If so, we will trigger SIGBUS.
+	 */
+	if ((regs->sp & 0x7) || (regs->ex1) || (align_ctl < 0)) {
+		siginfo_t info = {
+			.si_signo = SIGBUS,
+			.si_code = BUS_ADRALN,
+			.si_addr = (unsigned char __user *)0
+		};
+
+		if (unaligned_printk)
+			pr_info("Unalign fixup: %d %llx @%llx",
+				(int)unaligned_fixup,
+				(unsigned long long)regs->ex1,
+				(unsigned long long)regs->pc);
+
+		unaligned_fixup_count++;
+
+		trace_unhandled_signal("unaligned fixup trap", regs, 0, SIGBUS);
+		force_sig_info(info.si_signo, &info, current);
+		return;
+	}
+
+
+	/* Read the bundle casued the exception! */
+	pc = (tilegx_bundle_bits __user *)(regs->pc);
+	if (get_user(bundle, pc) != 0) {
+		/* Probably never be here since pc is valid user address.*/
+		siginfo_t info = {
+			.si_signo = SIGSEGV,
+			.si_code = SEGV_MAPERR,
+			.si_addr = (void __user *)pc
+		};
+		pr_err("Couldn't read instruction at %p trying to step\n", pc);
+		trace_unhandled_signal("segfault in unalign fixup", regs,
+				       (unsigned long)info.si_addr, SIGSEGV);
+		force_sig_info(info.si_signo, &info, current);
+		return;
+	}
+
+	if (!info->unalign_jit_base) {
+		void __user *user_page;
+
+		/*
+		 * Allocate a page in userland.
+		 * For 64-bit processes we try to place the mapping far
+		 * from anything else that might be going on (specifically
+		 * 64 GB below the top of the user address space).  If it
+		 * happens not to be possible to put it there, it's OK;
+		 * the kernel will choose another location and we'll
+		 * remember it for later.
+		 */
+		if (is_compat_task())
+			user_page = NULL;
+		else
+			user_page = (void __user *)(TASK_SIZE - (1UL << 36)) +
+				(current->pid << PAGE_SHIFT);
+
+		user_page = (void __user *) vm_mmap(NULL,
+						    (unsigned long)user_page,
+						    PAGE_SIZE,
+						    PROT_EXEC | PROT_READ |
+						    PROT_WRITE,
+#ifdef CONFIG_HOMECACHE
+						    MAP_CACHE_HOME_TASK |
+#endif
+						    MAP_PRIVATE |
+						    MAP_ANONYMOUS,
+						    0);
+
+		if (IS_ERR((void __force *)user_page)) {
+			pr_err("Out of kernel pages trying do_mmap.\n");
+			return;
+		}
+
+		/* Save the address in the thread_info struct */
+		info->unalign_jit_base = user_page;
+		if (unaligned_printk)
+			pr_info("Unalign bundle: %d:%d, allocate page @%llx",
+				raw_smp_processor_id(), current->pid,
+				(unsigned long long)user_page);
+	}
+
+	/* Generate unalign JIT */
+	jit_bundle_gen(regs, GX_INSN_BSWAP(bundle), align_ctl);
+}
+
+#endif /* __tilegx__ */
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 6152819..7863298 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -722,8 +722,49 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 {
 	int is_page_fault;
 
+#ifdef __tilegx__
+	/*
+	 * We don't need early do_page_fault_ics() support, since unlike
+	 * Pro we don't need to worry about unlocking the atomic locks.
+	 * There is only one current case in GX where we touch any memory
+	 * under ICS other than our own kernel stack, and we handle that
+	 * here.  (If we crash due to trying to touch our own stack,
+	 * we're in too much trouble for C code to help out anyway.)
+	 */
+	if (write & ~1) {
+		unsigned long pc = write & ~1;
+		if (pc >= (unsigned long) __start_unalign_asm_code &&
+		    pc < (unsigned long) __end_unalign_asm_code) {
+			struct thread_info *ti = current_thread_info();
+			/*
+			 * Our EX_CONTEXT is still what it was from the
+			 * initial unalign exception, but now we've faulted
+			 * on the JIT page.  We would like to complete the
+			 * page fault however is appropriate, and then retry
+			 * the instruction that caused the unalign exception.
+			 * Our state has been "corrupted" by setting the low
+			 * bit in "sp", and stashing r0..r3 in the
+			 * thread_info area, so we revert all of that, then
+			 * continue as if this were a normal page fault.
+			 */
+			regs->sp &= ~1UL;
+			regs->regs[0] = ti->unalign_jit_tmp[0];
+			regs->regs[1] = ti->unalign_jit_tmp[1];
+			regs->regs[2] = ti->unalign_jit_tmp[2];
+			regs->regs[3] = ti->unalign_jit_tmp[3];
+			write &= 1;
+		} else {
+			pr_alert("%s/%d: ICS set at page fault at %#lx: %#lx\n",
+				 current->comm, current->pid, pc, address);
+			show_regs(regs);
+			do_group_exit(SIGKILL);
+			return;
+		}
+	}
+#else
 	/* This case should have been handled by do_page_fault_ics(). */
 	BUG_ON(write & ~1);
+#endif
 
 #if CHIP_HAS_TILE_DMA()
 	/*
-- 
1.8.3.1

