Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaJGT2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:28:32 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:35801 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbaJGT22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:28:28 -0400
From: minyard@acm.org
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 3/3] mips: Add DWARF unwinding to assembly
Date: Tue,  7 Oct 2014 14:27:14 -0500
Message-Id: <1412710034-16908-4-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412710034-16908-1-git-send-email-minyard@acm.org>
References: <1412710034-16908-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

This will allow kdump dumps and kgdb to work correctly
with MIPS.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 arch/mips/Makefile                 |  14 ++-
 arch/mips/include/asm/asm.h        |  13 +-
 arch/mips/include/asm/dwarf2.h     |   6 +
 arch/mips/include/asm/stackframe.h | 245 +++++++++++++++++++++----------------
 arch/mips/kernel/entry.S           |   2 +-
 arch/mips/kernel/genex.S           |  21 ++--
 arch/mips/mm/tlbex-fault.S         |   7 +-
 7 files changed, 187 insertions(+), 121 deletions(-)
 create mode 100644 arch/mips/include/asm/dwarf2.h

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index bbac51e1..6a76ee6 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -238,11 +238,23 @@ ifdef CONFIG_64BIT
   endif
 endif
 
-KBUILD_AFLAGS	+= $(cflags-y)
+
+# do binutils support CFI?
+cfireg := $$$$0
+cfi := $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(cfireg)$(comma)0\n.cfi_endproc,-DCONFIG_AS_CFI=1)
+# is .cfi_signal_frame supported too?
+cfi-sigframe := $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
+cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
+
+KBUILD_AFLAGS	+= $(cfi) $(cfi-sigframe) $(cfi-sections) $(cflags-y)
 KBUILD_CFLAGS	+= $(cflags-y)
 KBUILD_CPPFLAGS += -DVMLINUX_LOAD_ADDRESS=$(load-y)
 KBUILD_CPPFLAGS += -DDATAOFFSET=$(if $(dataoffset-y),$(dataoffset-y),0)
 
+# This is required to get dwarf unwinding tables into .debug_frame
+# instead of .eh_frame so we don't discard them.
+KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
+
 bootvars-y	= VMLINUX_LOAD_ADDRESS=$(load-y) \
 		  VMLINUX_ENTRY_ADDRESS=$(entry-y)
 
diff --git a/arch/mips/include/asm/asm.h b/arch/mips/include/asm/asm.h
index 7c26b28..8eb79862 100644
--- a/arch/mips/include/asm/asm.h
+++ b/arch/mips/include/asm/asm.h
@@ -19,6 +19,9 @@
 
 #include <asm/sgidefs.h>
 #include <asm/asm-eva.h>
+#ifdef __ASSEMBLY__
+#include <asm/dwarf2.h>
+#endif
 
 #ifndef CAT
 #ifdef __STDC__
@@ -54,7 +57,9 @@
 		.align	2;				\
 		.type	symbol, @function;		\
 		.ent	symbol, 0;			\
-symbol:		.frame	sp, 0, ra
+symbol:		.frame	sp, 0, ra;			\
+		CFI_STARTPROC
+
 
 /*
  * NESTED - declare nested routine entry point
@@ -63,13 +68,15 @@ symbol:		.frame	sp, 0, ra
 		.globl	symbol;				\
 		.align	2;				\
 		.type	symbol, @function;		\
-		.ent	symbol, 0;			 \
-symbol:		.frame	sp, framesize, rpc
+		.ent	symbol, 0;			\
+symbol:		.frame	sp, framesize, rpc;		\
+		CFI_STARTPROC
 
 /*
  * END - mark end of function
  */
 #define END(function)					\
+		CFI_ENDPROC;				\
 		.end	function;			\
 		.size	function, .-function
 
diff --git a/arch/mips/include/asm/dwarf2.h b/arch/mips/include/asm/dwarf2.h
new file mode 100644
index 0000000..1728acd
--- /dev/null
+++ b/arch/mips/include/asm/dwarf2.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_MIPS_DWARF2_H
+#define _ASM_MIPS_DWARF2_H
+
+#include <asm-generic/dwarf2.h>
+
+#endif /* _ASM_MIPS_DWARF2_H */
diff --git a/arch/mips/include/asm/stackframe.h b/arch/mips/include/asm/stackframe.h
index b188c79..0976f03 100644
--- a/arch/mips/include/asm/stackframe.h
+++ b/arch/mips/include/asm/stackframe.h
@@ -18,6 +18,30 @@
 #include <asm/mipsregs.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/dwarf2.h>
+
+/* Make the addition of cfi info a little easier. */
+	.macro cfi_rel_offset reg offset=0 docfi=0
+	.if \docfi
+	CFI_REL_OFFSET \reg, \offset
+	.endif
+	.endm
+
+	.macro cfi_st reg offset=0 docfi=0
+	LONG_S	\reg, \offset(sp)
+	cfi_rel_offset \reg, \offset, \docfi
+	.endm
+
+	.macro cfi_restore reg offset=0 docfi=0
+	.if \docfi
+	CFI_RESTORE \reg
+	.endif
+	.endm
+
+	.macro cfi_ld reg offset=0 docfi=0
+	LONG_L	\reg, \offset(sp)
+	cfi_restore \reg \offset \docfi
+	.endm
 
 #if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
 #define STATMASK 0x3f
@@ -25,14 +49,14 @@
 #define STATMASK 0x1f
 #endif
 
-		.macro	SAVE_AT
+		.macro	SAVE_AT docfi=0
 		.set	push
 		.set	noat
-		LONG_S	$1, PT_R1(sp)
+		cfi_st	$1, PT_R1, \docfi
 		.set	pop
 		.endm
 
-		.macro	SAVE_TEMP
+		.macro	SAVE_TEMP docfi=0
 #ifdef CONFIG_CPU_HAS_SMARTMIPS
 		mflhxu	v1
 		LONG_S	v1, PT_LO(sp)
@@ -44,20 +68,20 @@
 		mfhi	v1
 #endif
 #ifdef CONFIG_32BIT
-		LONG_S	$8, PT_R8(sp)
-		LONG_S	$9, PT_R9(sp)
+		cfi_st	$8, PT_R8, \docfi
+		cfi_st	$9, PT_R9, \docfi
 #endif
-		LONG_S	$10, PT_R10(sp)
-		LONG_S	$11, PT_R11(sp)
-		LONG_S	$12, PT_R12(sp)
+		cfi_st	$10, PT_R10, \docfi
+		cfi_st	$11, PT_R11, \docfi
+		cfi_st	$12, PT_R12, \docfi
 #ifndef CONFIG_CPU_HAS_SMARTMIPS
 		LONG_S	v1, PT_HI(sp)
 		mflo	v1
 #endif
-		LONG_S	$13, PT_R13(sp)
-		LONG_S	$14, PT_R14(sp)
-		LONG_S	$15, PT_R15(sp)
-		LONG_S	$24, PT_R24(sp)
+		cfi_st	$13, PT_R13, \docfi
+		cfi_st	$14, PT_R14, \docfi
+		cfi_st	$15, PT_R15, \docfi
+		cfi_st	$24, PT_R24, \docfi
 #ifndef CONFIG_CPU_HAS_SMARTMIPS
 		LONG_S	v1, PT_LO(sp)
 #endif
@@ -71,16 +95,16 @@
 #endif
 		.endm
 
-		.macro	SAVE_STATIC
-		LONG_S	$16, PT_R16(sp)
-		LONG_S	$17, PT_R17(sp)
-		LONG_S	$18, PT_R18(sp)
-		LONG_S	$19, PT_R19(sp)
-		LONG_S	$20, PT_R20(sp)
-		LONG_S	$21, PT_R21(sp)
-		LONG_S	$22, PT_R22(sp)
-		LONG_S	$23, PT_R23(sp)
-		LONG_S	$30, PT_R30(sp)
+		.macro	SAVE_STATIC docfi=0
+		cfi_st	$16, PT_R16, \docfi
+		cfi_st	$17, PT_R17, \docfi
+		cfi_st	$18, PT_R18, \docfi
+		cfi_st	$19, PT_R19, \docfi
+		cfi_st	$20, PT_R20, \docfi
+		cfi_st	$21, PT_R21, \docfi
+		cfi_st	$22, PT_R22, \docfi
+		cfi_st	$23, PT_R23, \docfi
+		cfi_st	$30, PT_R30, \docfi
 		.endm
 
 #ifdef CONFIG_SMP
@@ -143,7 +167,7 @@
 		.endm
 #endif
 
-		.macro	SAVE_SOME
+		.macro	SAVE_SOME docfi=0
 		.set	push
 		.set	noat
 		.set	reorder
@@ -157,16 +181,26 @@
 		get_saved_sp
 #ifndef CONFIG_CPU_DADDI_WORKAROUNDS
 8:		move	k0, sp
+		.if \docfi
+		CFI_REGISTER sp, k0
+		.endif
 		PTR_SUBU sp, k1, PT_SIZE
 #else
 		.set	at=k0
 8:		PTR_SUBU k1, PT_SIZE
 		.set	noat
 		move	k0, sp
+		.if \docfi
+		CFI_REGISTER sp, k0
+		.endif
 		move	sp, k1
 #endif
-		LONG_S	k0, PT_R29(sp)
-		LONG_S	$3, PT_R3(sp)
+		.if \docfi
+		CFI_DEF_CFA sp,0
+		.endif
+		cfi_st	k0, PT_R29, \docfi
+		cfi_rel_offset  sp, PT_R29, \docfi
+		cfi_st	v1, PT_R3, \docfi
 		/*
 		 * You might think that you don't need to save $0,
 		 * but the FPU emulator and gdb remote debug stub
@@ -174,23 +208,26 @@
 		 */
 		LONG_S	$0, PT_R0(sp)
 		mfc0	v1, CP0_STATUS
-		LONG_S	$2, PT_R2(sp)
+		cfi_st	v0, PT_R2, \docfi
 		LONG_S	v1, PT_STATUS(sp)
-		LONG_S	$4, PT_R4(sp)
+		cfi_st	$4, PT_R4, \docfi
 		mfc0	v1, CP0_CAUSE
-		LONG_S	$5, PT_R5(sp)
+		cfi_st	$5, PT_R5, \docfi
 		LONG_S	v1, PT_CAUSE(sp)
-		LONG_S	$6, PT_R6(sp)
+		cfi_st	$6, PT_R6, \docfi
 		MFC0	v1, CP0_EPC
-		LONG_S	$7, PT_R7(sp)
+		cfi_st	$7, PT_R7, \docfi
 #ifdef CONFIG_64BIT
-		LONG_S	$8, PT_R8(sp)
-		LONG_S	$9, PT_R9(sp)
+		cfi_st	$8, PT_R8, \docfi
+		cfi_st	$9, PT_R9, \docfi
 #endif
 		LONG_S	v1, PT_EPC(sp)
-		LONG_S	$25, PT_R25(sp)
-		LONG_S	$28, PT_R28(sp)
-		LONG_S	$31, PT_R31(sp)
+		.if \docfi
+		CFI_REL_OFFSET ra, PT_EPC
+		.endif
+		cfi_st	$25, PT_R25, \docfi
+		cfi_st	$28, PT_R28, \docfi
+		cfi_st	$31, PT_R31, \docfi
 		ori	$28, sp, _THREAD_MASK
 		xori	$28, _THREAD_MASK
 #ifdef CONFIG_CPU_CAVIUM_OCTEON
@@ -200,21 +237,21 @@
 		.set	pop
 		.endm
 
-		.macro	SAVE_ALL
-		SAVE_SOME
-		SAVE_AT
-		SAVE_TEMP
-		SAVE_STATIC
+		.macro	SAVE_ALL docfi=0
+		SAVE_SOME \docfi
+		SAVE_AT \docfi
+		SAVE_TEMP \docfi
+		SAVE_STATIC \docfi
 		.endm
 
-		.macro	RESTORE_AT
+		.macro	RESTORE_AT docfi=0
 		.set	push
 		.set	noat
-		LONG_L	$1,  PT_R1(sp)
+		cfi_ld	$1, PT_R1, \docfi
 		.set	pop
 		.endm
 
-		.macro	RESTORE_TEMP
+		.macro	RESTORE_TEMP docfi=0
 #ifdef CONFIG_CPU_CAVIUM_OCTEON
 		/* Restore the Octeon multiplier state */
 		jal	octeon_mult_restore
@@ -233,33 +270,33 @@
 		mthi	$24
 #endif
 #ifdef CONFIG_32BIT
-		LONG_L	$8, PT_R8(sp)
-		LONG_L	$9, PT_R9(sp)
+		cfi_ld	$8, PT_R8, \docfi
+		cfi_ld	$9, PT_R9, \docfi
 #endif
-		LONG_L	$10, PT_R10(sp)
-		LONG_L	$11, PT_R11(sp)
-		LONG_L	$12, PT_R12(sp)
-		LONG_L	$13, PT_R13(sp)
-		LONG_L	$14, PT_R14(sp)
-		LONG_L	$15, PT_R15(sp)
-		LONG_L	$24, PT_R24(sp)
+		cfi_ld	$10, PT_R10, \docfi
+		cfi_ld	$11, PT_R11, \docfi
+		cfi_ld	$12, PT_R12, \docfi
+		cfi_ld	$13, PT_R13, \docfi
+		cfi_ld	$14, PT_R14, \docfi
+		cfi_ld	$15, PT_R15, \docfi
+		cfi_ld	$24, PT_R24, \docfi
 		.endm
 
-		.macro	RESTORE_STATIC
-		LONG_L	$16, PT_R16(sp)
-		LONG_L	$17, PT_R17(sp)
-		LONG_L	$18, PT_R18(sp)
-		LONG_L	$19, PT_R19(sp)
-		LONG_L	$20, PT_R20(sp)
-		LONG_L	$21, PT_R21(sp)
-		LONG_L	$22, PT_R22(sp)
-		LONG_L	$23, PT_R23(sp)
-		LONG_L	$30, PT_R30(sp)
+		.macro	RESTORE_STATIC docfi=0
+		cfi_ld	$16, PT_R16, \docfi
+		cfi_ld	$17, PT_R17, \docfi
+		cfi_ld	$18, PT_R18, \docfi
+		cfi_ld	$19, PT_R19, \docfi
+		cfi_ld	$20, PT_R20, \docfi
+		cfi_ld	$21, PT_R21, \docfi
+		cfi_ld	$22, PT_R22, \docfi
+		cfi_ld	$23, PT_R23, \docfi
+		cfi_ld	$30, PT_R30, \docfi
 		.endm
 
 #if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
 
-		.macro	RESTORE_SOME
+		.macro	RESTORE_SOME docfi=0
 		.set	push
 		.set	reorder
 		.set	noat
@@ -274,30 +311,30 @@
 		and	v0, v1
 		or	v0, a0
 		mtc0	v0, CP0_STATUS
-		LONG_L	$31, PT_R31(sp)
-		LONG_L	$28, PT_R28(sp)
-		LONG_L	$25, PT_R25(sp)
-		LONG_L	$7,  PT_R7(sp)
-		LONG_L	$6,  PT_R6(sp)
-		LONG_L	$5,  PT_R5(sp)
-		LONG_L	$4,  PT_R4(sp)
-		LONG_L	$3,  PT_R3(sp)
-		LONG_L	$2,  PT_R2(sp)
+		cfi_ld	$31, PT_R31, \docfi
+		cfi_ld	$28, PT_R28, \docfi
+		cfi_ld	$25, PT_R25, \docfi
+		cfi_ld	$7,  PT_R7, \docfi
+		cfi_ld	$6,  PT_R6, \docfi
+		cfi_ld	$5,  PT_R5, \docfi
+		cfi_ld	$4,  PT_R4, \docfi
+		cfi_ld	$3,  PT_R3, \docfi
+		cfi_ld	$2,  PT_R2, \docfi
 		.set	pop
 		.endm
 
-		.macro	RESTORE_SP_AND_RET
+		.macro	RESTORE_SP_AND_RET docfi=0
 		.set	push
 		.set	noreorder
 		LONG_L	k0, PT_EPC(sp)
-		LONG_L	sp, PT_R29(sp)
+		cfi_ld	sp, PT_R29, \docfi
 		jr	k0
 		 rfe
 		.set	pop
 		.endm
 
 #else
-		.macro	RESTORE_SOME
+		.macro	RESTORE_SOME docfi=0
 		.set	push
 		.set	reorder
 		.set	noat
@@ -314,24 +351,28 @@
 		mtc0	v0, CP0_STATUS
 		LONG_L	v1, PT_EPC(sp)
 		MTC0	v1, CP0_EPC
-		LONG_L	$31, PT_R31(sp)
-		LONG_L	$28, PT_R28(sp)
-		LONG_L	$25, PT_R25(sp)
+		cfi_ld	$31, PT_R31, \docfi
+		cfi_ld	$28, PT_R28, \docfi
+		cfi_ld	$25, PT_R25, \docfi
 #ifdef CONFIG_64BIT
-		LONG_L	$8, PT_R8(sp)
-		LONG_L	$9, PT_R9(sp)
+		cfi_ld	$8, PT_R8, \docfi
+		cfi_ld	$9, PT_R9, \docfi
 #endif
-		LONG_L	$7,  PT_R7(sp)
-		LONG_L	$6,  PT_R6(sp)
-		LONG_L	$5,  PT_R5(sp)
-		LONG_L	$4,  PT_R4(sp)
-		LONG_L	$3,  PT_R3(sp)
-		LONG_L	$2,  PT_R2(sp)
+		cfi_ld	$7,  PT_R7, \docfi
+		cfi_ld	$6,  PT_R6, \docfi
+		cfi_ld	$5,  PT_R5, \docfi
+		cfi_ld	$4,  PT_R4, \docfi
+		cfi_ld	$3,  PT_R3, \docfi
+		cfi_ld	$2,  PT_R2, \docfi
 		.set	pop
 		.endm
 
-		.macro	RESTORE_SP_AND_RET
-		LONG_L	sp, PT_R29(sp)
+		.macro	RESTORE_SP docfi=0
+		cfi_ld	sp, PT_R29, \docfi
+		.endm
+
+		.macro	RESTORE_SP_AND_RET docfi=0
+		RESTORE_SP \docfi
 		.set	arch=r4000
 		eret
 		.set	mips0
@@ -339,24 +380,20 @@
 
 #endif
 
-		.macro	RESTORE_SP
-		LONG_L	sp, PT_R29(sp)
-		.endm
-
-		.macro	RESTORE_ALL
-		RESTORE_TEMP
-		RESTORE_STATIC
-		RESTORE_AT
-		RESTORE_SOME
-		RESTORE_SP
+		.macro	RESTORE_ALL docfi=0
+		RESTORE_TEMP \docfi
+		RESTORE_STATIC \docfi
+		RESTORE_AT \docfi
+		RESTORE_SOME \docfi
+		RESTORE_SP \docfi
 		.endm
 
-		.macro	RESTORE_ALL_AND_RET
-		RESTORE_TEMP
-		RESTORE_STATIC
-		RESTORE_AT
-		RESTORE_SOME
-		RESTORE_SP_AND_RET
+		.macro	RESTORE_ALL_AND_RET docfi=0
+		RESTORE_TEMP \docfi
+		RESTORE_STATIC \docfi
+		RESTORE_AT \docfi
+		RESTORE_SOME \docfi
+		RESTORE_SP_AND_RET \docfi
 		.endm
 
 /*
diff --git a/arch/mips/kernel/entry.S b/arch/mips/kernel/entry.S
index 4353d32..6eb3b28 100644
--- a/arch/mips/kernel/entry.S
+++ b/arch/mips/kernel/entry.S
@@ -144,7 +144,7 @@ FEXPORT(syscall_exit_partial)
 	li	t0, _TIF_ALLWORK_MASK
 	and	t0, a2
 	beqz	t0, restore_partial
-	SAVE_STATIC
+	SAVE_STATIC docfi=0
 syscall_exit_work:
 	LONG_L	t0, PT_STATUS(sp)		# returning to kernel mode?
 	andi	t0, t0, KU_USER
diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index ac35e12..68c8d34 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -151,6 +151,7 @@ LEAF(__r4k_wait)
 	.align	5
 BUILD_ROLLBACK_PROLOGUE handle_int
 NESTED(handle_int, PT_SIZE, sp)
+	CFI_SIGNAL_FRAME
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/*
 	 * Check to see if the interrupted code has just disabled
@@ -182,18 +183,18 @@ NESTED(handle_int, PT_SIZE, sp)
 1:
 	.set pop
 #endif
-	SAVE_ALL
+	SAVE_ALL docfi=1
 	CLI
 	TRACE_IRQS_OFF
 
 	LONG_L	s0, TI_REGS($28)
 	LONG_S	sp, TI_REGS($28)
-	PTR_LA	ra, ret_from_irq
 	PTR_LA  v0, plat_irq_dispatch
-	jr	v0
+	jal	v0
 #ifdef CONFIG_CPU_MICROMIPS
 	nop
 #endif
+	j	ret_from_irq
 	END(handle_int)
 
 	__INIT
@@ -233,8 +234,8 @@ NESTED(except_vec_ejtag_debug, 0, sp)
  */
 BUILD_ROLLBACK_PROLOGUE except_vec_vi
 NESTED(except_vec_vi, 0, sp)
-	SAVE_SOME
-	SAVE_AT
+	SAVE_SOME docfi=1
+	SAVE_AT docfi=1
 	.set	push
 	.set	noreorder
 	PTR_LA	v1, except_vec_vi_handler
@@ -263,8 +264,8 @@ NESTED(except_vec_vi_handler, 0, sp)
 
 	LONG_L	s0, TI_REGS($28)
 	LONG_S	sp, TI_REGS($28)
-	PTR_LA	ra, ret_from_irq
-	jr	v0
+	jal	v0
+	j	ret_from_irq
 	END(except_vec_vi_handler)
 
 /*
@@ -322,6 +323,7 @@ NESTED(except_vec_nmi, 0, sp)
 	__FINIT
 
 NESTED(nmi_handler, PT_SIZE, sp)
+	CFI_SIGNAL_FRAME
 	.set	push
 	.set	noat
 	/*
@@ -400,6 +402,7 @@ NESTED(nmi_handler, PT_SIZE, sp)
 	.macro	__BUILD_HANDLER exception handler clear verbose ext
 	.align	5
 	NESTED(handle_\exception, PT_SIZE, sp)
+	CFI_SIGNAL_FRAME
 	.set	noat
 	SAVE_ALL
 	FEXPORT(handle_\exception\ext)
@@ -407,8 +410,8 @@ NESTED(nmi_handler, PT_SIZE, sp)
 	.set	at
 	__BUILD_\verbose \exception
 	move	a0, sp
-	PTR_LA	ra, ret_from_exception
-	j	do_\handler
+	jal	do_\handler
+	j	ret_from_exception
 	END(handle_\exception)
 	.endm
 
diff --git a/arch/mips/mm/tlbex-fault.S b/arch/mips/mm/tlbex-fault.S
index 318855e..c91cde8 100644
--- a/arch/mips/mm/tlbex-fault.S
+++ b/arch/mips/mm/tlbex-fault.S
@@ -12,14 +12,15 @@
 
 	.macro tlb_do_page_fault, write
 	NESTED(tlb_do_page_fault_\write, PT_SIZE, sp)
-	SAVE_ALL
+	CFI_SIGNAL_FRAME
+	SAVE_ALL docfi=1
 	MFC0	a2, CP0_BADVADDR
 	KMODE
 	move	a0, sp
 	REG_S	a2, PT_BVADDR(sp)
 	li	a1, \write
-	PTR_LA	ra, ret_from_exception
-	j	do_page_fault
+	jal	do_page_fault
+	j	ret_from_exception
 	END(tlb_do_page_fault_\write)
 	.endm
 
-- 
1.8.3.1

