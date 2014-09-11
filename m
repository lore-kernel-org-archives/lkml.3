Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaIKIkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:40:20 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:29678 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaIKIhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:39 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 07/10] MIPS: support for hybrid FPRs
Date: Thu, 11 Sep 2014 08:30:20 +0100
Message-ID: <1410420623-11691-8-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hybrid FPRs is a scheme where scalar FP registers are 64b wide, but
accesses to odd indexed single registers use bits 63:32 of the
preceeding even indexed 64b register. In this mode all FP code
except that built for the plain FP64 ABI can execute correctly. Most
notably a combination of FP64A & FP32 code can execute correctly,
allowing for existing FP32 binaries to be linked with new FP64A binaries
that can make use of 64 bit FP & MSA.

Hybrid FPRs are implemented by setting both the FR & FRE bits, trapping
& emulating single precision FP instructions (via Reserved Instruction
exceptions) whilst allowing others to execute natively. It therefore has
a penalty in terms of execution speed, and should only be used when no
fully native mode can be. As more binaries are recompiled to use either
the FPXX or FP64(A) ABIs, the need for hybrid FPRs should diminish.
However in the short to mid term it allows for a gradual transition
towards that world, rather than a complete ABI break which is not
feasible for some users & not desirable for many.

A task will be executed using the hybrid FPR scheme when its
TIF_HYBRID_FPREGS flag is set & TIF_32BIT_FPREGS is clear. A further
patch will set the flags as necessary, this patch simply adds the
infrastructure necessary for the hybrid FPR mode to work.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 arch/mips/include/asm/elf.h         |  3 +++
 arch/mips/include/asm/fpu.h         | 49 +++++++++++++++++++++++++++++++------
 arch/mips/include/asm/thread_info.h |  2 ++
 arch/mips/kernel/traps.c            | 47 +++++++++++++++++++++++++++++++++++
 arch/mips/math-emu/cp1emu.c         |  9 +++++--
 5 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index 1d38fe0..9343529 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -269,6 +269,8 @@ do {									\
 	else								\
 		set_thread_flag(TIF_32BIT_FPREGS);			\
 									\
+	clear_thread_flag(TIF_HYBRID_FPREGS);				\
+									\
 	if (personality(current->personality) != PER_LINUX)		\
 		set_personality(PER_LINUX);				\
 									\
@@ -325,6 +327,7 @@ do {									\
 									\
 	clear_thread_flag(TIF_32BIT_REGS);				\
 	clear_thread_flag(TIF_32BIT_FPREGS);				\
+	clear_thread_flag(TIF_HYBRID_FPREGS);				\
 	clear_thread_flag(TIF_32BIT_ADDR);				\
 									\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)			\
diff --git a/arch/mips/include/asm/fpu.h b/arch/mips/include/asm/fpu.h
index 4d0aeda..6e60431 100644
--- a/arch/mips/include/asm/fpu.h
+++ b/arch/mips/include/asm/fpu.h
@@ -36,14 +36,16 @@ extern void _restore_fp(struct task_struct *);
 
 /*
  * This enum specifies a mode in which we want the FPU to operate, for cores
- * which implement the Status.FR bit. Note that FPU_32BIT & FPU_64BIT
- * purposefully have the values 0 & 1 respectively, so that an integer value
- * of Status.FR can be trivially casted to the corresponding enum fpu_mode.
+ * which implement the Status.FR bit. Note that the bottom bit of the value
+ * purposefully matches the desired value of the Status.FR bit.
  */
 enum fpu_mode {
 	FPU_32BIT = 0,		/* FR = 0 */
-	FPU_64BIT,		/* FR = 1 */
+	FPU_64BIT,		/* FR = 1, FRE = 0 */
 	FPU_AS_IS,
+	FPU_HYBRID,		/* FR = 1, FRE = 1 */
+
+#define FPU_FR_MASK		0x1
 };
 
 static inline int __enable_fpu(enum fpu_mode mode)
@@ -57,6 +59,14 @@ static inline int __enable_fpu(enum fpu_mode mode)
 		enable_fpu_hazard();
 		return 0;
 
+	case FPU_HYBRID:
+		if (!cpu_has_fre)
+			return SIGFPE;
+
+		/* set FRE */
+		write_c0_config5(read_c0_config5() | MIPS_CONF5_FRE);
+		goto fr_common;
+
 	case FPU_64BIT:
 #if !(defined(CONFIG_CPU_MIPS32_R2) || defined(CONFIG_64BIT))
 		/* we only have a 32-bit FPU */
@@ -64,8 +74,11 @@ static inline int __enable_fpu(enum fpu_mode mode)
 #endif
 		/* fall through */
 	case FPU_32BIT:
+		/* clear FRE */
+		write_c0_config5(read_c0_config5() & ~MIPS_CONF5_FRE);
+fr_common:
 		/* set CU1 & change FR appropriately */
-		fr = (int)mode;
+		fr = (int)mode & FPU_FR_MASK;
 		change_c0_status(ST0_CU1 | ST0_FR, ST0_CU1 | (fr ? ST0_FR : 0));
 		enable_fpu_hazard();
 
@@ -102,13 +115,17 @@ static inline int __own_fpu(void)
 	enum fpu_mode mode;
 	int ret;
 
-	mode = !test_thread_flag(TIF_32BIT_FPREGS);
+	if (test_thread_flag(TIF_HYBRID_FPREGS))
+		mode = FPU_HYBRID;
+	else
+		mode = !test_thread_flag(TIF_32BIT_FPREGS);
+
 	ret = __enable_fpu(mode);
 	if (ret)
 		return ret;
 
 	KSTK_STATUS(current) |= ST0_CU1;
-	if (mode == FPU_64BIT)
+	if (mode == FPU_64BIT || mode == FPU_HYBRID)
 		KSTK_STATUS(current) |= ST0_FR;
 	else /* mode == FPU_32BIT */
 		KSTK_STATUS(current) &= ~ST0_FR;
@@ -166,8 +183,24 @@ static inline int init_fpu(void)
 
 	if (cpu_has_fpu) {
 		ret = __own_fpu();
-		if (!ret)
+		if (!ret) {
+			unsigned int config5 = read_c0_config5();
+
+			/*
+			 * Ensure FRE is clear whilst running _init_fpu, since
+			 * single precision FP instructions are used. If FRE
+			 * was set then we'll just end up initialising all 32
+			 * 64b registers.
+			 */
+			write_c0_config5(config5 & ~MIPS_CONF5_FRE);
+			enable_fpu_hazard();
+
 			_init_fpu();
+
+			/* Restore FRE */
+			write_c0_config5(config5);
+			enable_fpu_hazard();
+		}
 	} else
 		fpu_emulator_init_fpu();
 
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 7de8658..99eea59 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -116,6 +116,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_LOAD_WATCH		25	/* If set, load watch registers */
 #define TIF_SYSCALL_TRACEPOINT	26	/* syscall tracepoint instrumentation */
 #define TIF_32BIT_FPREGS	27	/* 32-bit floating point registers */
+#define TIF_HYBRID_FPREGS	28	/* 64b FP registers, odd singles in bits 63:32 of even doubles */
 #define TIF_USEDMSA		29	/* MSA has been used this quantum */
 #define TIF_MSA_CTX_LIVE	30	/* MSA context must be preserved */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
@@ -135,6 +136,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_FPUBOUND		(1<<TIF_FPUBOUND)
 #define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
 #define _TIF_32BIT_FPREGS	(1<<TIF_32BIT_FPREGS)
+#define _TIF_HYBRID_FPREGS	(1<<TIF_HYBRID_FPREGS)
 #define _TIF_USEDMSA		(1<<TIF_USEDMSA)
 #define _TIF_MSA_CTX_LIVE	(1<<TIF_MSA_CTX_LIVE)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 22b19c2..165c275 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -724,6 +724,50 @@ int process_fpemu_return(int sig, void __user *fault_addr)
 	}
 }
 
+static int simulate_fp(struct pt_regs *regs, unsigned int opcode,
+		       unsigned long old_epc, unsigned long old_ra)
+{
+	union mips_instruction inst = { .word = opcode };
+	void __user *fault_addr = NULL;
+	int sig;
+
+	/* If it's obviously not an FP instruction, skip it */
+	switch (inst.i_format.opcode) {
+	case cop1_op:
+	case cop1x_op:
+	case lwc1_op:
+	case ldc1_op:
+	case swc1_op:
+	case sdc1_op:
+		break;
+
+	default:
+		return -1;
+	}
+
+	/*
+	 * do_ri skipped over the instruction via compute_return_epc, undo
+	 * that for the FPU emulator.
+	 */
+	regs->cp0_epc = old_epc;
+	regs->regs[31] = old_ra;
+
+	/* Save the FP context to struct thread_struct */
+	lose_fpu(1);
+
+	/* Run the emulator */
+	sig = fpu_emulator_cop1Handler(regs, &current->thread.fpu, 1,
+				       &fault_addr);
+
+	/* If something went wrong, signal */
+	process_fpemu_return(sig, fault_addr);
+
+	/* Restore the hardware register state */
+	own_fpu(1);
+
+	return 0;
+}
+
 /*
  * XXX Delayed fp exceptions when doing a lazy ctx switch XXX
  */
@@ -1016,6 +1060,9 @@ asmlinkage void do_ri(struct pt_regs *regs)
 
 		if (status < 0)
 			status = simulate_sync(regs, opcode);
+
+		if (status < 0)
+			status = simulate_fp(regs, opcode, old_epc, old31);
 	}
 
 	if (status < 0)
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index bf0fc6b..ef8447f 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -647,9 +647,14 @@ static inline int cop1_64bit(struct pt_regs *xcp)
 	return !test_thread_flag(TIF_32BIT_FPREGS);
 }
 
+static inline bool hybrid_fprs(void)
+{
+	return test_thread_flag(TIF_HYBRID_FPREGS);
+}
+
 #define SIFROMREG(si, x)						\
 do {									\
-	if (cop1_64bit(xcp))						\
+	if (cop1_64bit(xcp) && !hybrid_fprs())				\
 		(si) = get_fpr32(&ctx->fpr[x], 0);			\
 	else								\
 		(si) = get_fpr32(&ctx->fpr[(x) & ~1], (x) & 1);		\
@@ -657,7 +662,7 @@ do {									\
 
 #define SITOREG(si, x)							\
 do {									\
-	if (cop1_64bit(xcp)) {						\
+	if (cop1_64bit(xcp) && !hybrid_fprs()) {			\
 		unsigned i;						\
 		set_fpr32(&ctx->fpr[x], 0, si);				\
 		for (i = 1; i < ARRAY_SIZE(ctx->fpr[x].val32); i++)	\
-- 
2.0.4

