Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810Ab3GDGY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:24:27 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:53290
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938Ab3GDGYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:24:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <mikey@neuling.org>,
        <benh@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <agraf@suse.de>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 2/2] powerpc: move debug registers in a structure
Date: Thu, 4 Jul 2013 11:45:46 +0530
Message-ID: <1372918546-15075-3-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we can use same data type struct with KVM and
also help in using other debug related function.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/include/asm/processor.h |   38 +++++----
 arch/powerpc/include/asm/reg_booke.h |    8 +-
 arch/powerpc/kernel/asm-offsets.c    |    2 +-
 arch/powerpc/kernel/process.c        |   42 +++++-----
 arch/powerpc/kernel/ptrace.c         |  154 +++++++++++++++++-----------------
 arch/powerpc/kernel/ptrace32.c       |    2 +-
 arch/powerpc/kernel/signal_32.c      |    6 +-
 arch/powerpc/kernel/traps.c          |   35 ++++----
 8 files changed, 147 insertions(+), 140 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 47a35b0..9e9aa26 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -147,22 +147,7 @@ typedef struct {
 #define TS_FPR(i) fpr[i][TS_FPROFFSET]
 #define TS_TRANS_FPR(i) transact_fpr[i][TS_FPROFFSET]
 
-struct thread_struct {
-	unsigned long	ksp;		/* Kernel stack pointer */
-	unsigned long	ksp_limit;	/* if ksp <= ksp_limit stack overflow */
-
-#ifdef CONFIG_PPC64
-	unsigned long	ksp_vsid;
-#endif
-	struct pt_regs	*regs;		/* Pointer to saved register state */
-	mm_segment_t	fs;		/* for get_fs() validation */
-#ifdef CONFIG_BOOKE
-	/* BookE base exception scratch space; align on cacheline */
-	unsigned long	normsave[8] ____cacheline_aligned;
-#endif
-#ifdef CONFIG_PPC32
-	void		*pgdir;		/* root of page-table tree */
-#endif
+struct debug_reg {
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
 	/*
 	 * The following help to manage the use of Debug Control Registers
@@ -199,6 +184,27 @@ struct thread_struct {
 	unsigned long	dvc2;
 #endif
 #endif
+};
+
+struct thread_struct {
+	unsigned long	ksp;		/* Kernel stack pointer */
+	unsigned long	ksp_limit;	/* if ksp <= ksp_limit stack overflow */
+
+#ifdef CONFIG_PPC64
+	unsigned long	ksp_vsid;
+#endif
+	struct pt_regs	*regs;		/* Pointer to saved register state */
+	mm_segment_t	fs;		/* for get_fs() validation */
+#ifdef CONFIG_BOOKE
+	/* BookE base exception scratch space; align on cacheline */
+	unsigned long	normsave[8] ____cacheline_aligned;
+#endif
+#ifdef CONFIG_PPC32
+	void		*pgdir;		/* root of page-table tree */
+#endif
+	/* Debug Registers */
+	struct debug_reg debug;
+
 	/* FP and VSX 0-31 register set */
 	double		fpr[32][TS_FPRWIDTH] __attribute__((aligned(16)));
 	struct {
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
index b417de3..455dc89 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -381,7 +381,7 @@
 #define DBCR0_IA34T	0x00004000	/* Instr Addr 3-4 range Toggle */
 #define DBCR0_FT	0x00000001	/* Freeze Timers on debug event */
 
-#define dbcr_iac_range(task)	((task)->thread.dbcr0)
+#define dbcr_iac_range(task)	((task)->thread.debug.dbcr0)
 #define DBCR_IAC12I	DBCR0_IA12			/* Range Inclusive */
 #define DBCR_IAC12X	(DBCR0_IA12 | DBCR0_IA12X)	/* Range Exclusive */
 #define DBCR_IAC12MODE	(DBCR0_IA12 | DBCR0_IA12X)	/* IAC 1-2 Mode Bits */
@@ -395,7 +395,7 @@
 #define DBCR1_DAC1W	0x20000000	/* DAC1 Write Debug Event */
 #define DBCR1_DAC2W	0x10000000	/* DAC2 Write Debug Event */
 
-#define dbcr_dac(task)	((task)->thread.dbcr1)
+#define dbcr_dac(task)	((task)->thread.debug.dbcr1)
 #define DBCR_DAC1R	DBCR1_DAC1R
 #define DBCR_DAC1W	DBCR1_DAC1W
 #define DBCR_DAC2R	DBCR1_DAC2R
@@ -441,7 +441,7 @@
 #define DBCR0_CRET	0x00000020	/* Critical Return Debug Event */
 #define DBCR0_FT	0x00000001	/* Freeze Timers on debug event */
 
-#define dbcr_dac(task)	((task)->thread.dbcr0)
+#define dbcr_dac(task)	((task)->thread.debug.dbcr0)
 #define DBCR_DAC1R	DBCR0_DAC1R
 #define DBCR_DAC1W	DBCR0_DAC1W
 #define DBCR_DAC2R	DBCR0_DAC2R
@@ -475,7 +475,7 @@
 #define DBCR1_IAC34MX	0x000000C0	/* Instr Addr 3-4 range eXclusive */
 #define DBCR1_IAC34AT	0x00000001	/* Instr Addr 3-4 range Toggle */
 
-#define dbcr_iac_range(task)	((task)->thread.dbcr1)
+#define dbcr_iac_range(task)	((task)->thread.debug.dbcr1)
 #define DBCR_IAC12I	DBCR1_IAC12M	/* Range Inclusive */
 #define DBCR_IAC12X	DBCR1_IAC12MX	/* Range Exclusive */
 #define DBCR_IAC12MODE	DBCR1_IAC12MX	/* IAC 1-2 Mode Bits */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index c7e8afc..d56727c 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -113,7 +113,7 @@ int main(void)
 #endif /* CONFIG_SPE */
 #endif /* CONFIG_PPC64 */
 #if defined(CONFIG_4xx) || defined(CONFIG_BOOKE)
-	DEFINE(THREAD_DBCR0, offsetof(struct thread_struct, dbcr0));
+	DEFINE(THREAD_DBCR0, offsetof(struct thread_struct, debug.dbcr0));
 #endif
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	DEFINE(THREAD_KVM_SVCPU, offsetof(struct thread_struct, kvm_shadow_vcpu));
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 19b8733..f8ae5e3 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -312,28 +312,28 @@ static DEFINE_PER_CPU(struct arch_hw_breakpoint, current_brk);
  */
 static void set_debug_reg_defaults(struct thread_struct *thread)
 {
-	thread->iac1 = thread->iac2 = 0;
+	thread->debug.iac1 = thread->debug.iac2 = 0;
 #if CONFIG_PPC_ADV_DEBUG_IACS > 2
-	thread->iac3 = thread->iac4 = 0;
+	thread->debug.iac3 = thread->debug.iac4 = 0;
 #endif
-	thread->dac1 = thread->dac2 = 0;
+	thread->debug.dac1 = thread->debug.dac2 = 0;
 #if CONFIG_PPC_ADV_DEBUG_DVCS > 0
-	thread->dvc1 = thread->dvc2 = 0;
+	thread->debug.dvc1 = thread->debug.dvc2 = 0;
 #endif
-	thread->dbcr0 = 0;
+	thread->debug.dbcr0 = 0;
 #ifdef CONFIG_BOOKE
 	/*
 	 * Force User/Supervisor bits to b11 (user-only MSR[PR]=1)
 	 */
-	thread->dbcr1 = DBCR1_IAC1US | DBCR1_IAC2US |
+	thread->debug.dbcr1 = DBCR1_IAC1US | DBCR1_IAC2US |
 			DBCR1_IAC3US | DBCR1_IAC4US;
 	/*
 	 * Force Data Address Compare User/Supervisor bits to be User-only
 	 * (0b11 MSR[PR]=1) and set all other bits in DBCR2 register to be 0.
 	 */
-	thread->dbcr2 = DBCR2_DAC1US | DBCR2_DAC2US;
+	thread->debug.dbcr2 = DBCR2_DAC1US | DBCR2_DAC2US;
 #else
-	thread->dbcr1 = 0;
+	thread->debug.dbcr1 = 0;
 #endif
 }
 
@@ -346,22 +346,22 @@ static void prime_debug_regs(struct thread_struct *thread)
 	 */
 	mtmsr(mfmsr() & ~MSR_DE);
 
-	mtspr(SPRN_IAC1, thread->iac1);
-	mtspr(SPRN_IAC2, thread->iac2);
+	mtspr(SPRN_IAC1, thread->debug.iac1);
+	mtspr(SPRN_IAC2, thread->debug.iac2);
 #if CONFIG_PPC_ADV_DEBUG_IACS > 2
-	mtspr(SPRN_IAC3, thread->iac3);
-	mtspr(SPRN_IAC4, thread->iac4);
+	mtspr(SPRN_IAC3, thread->debug.iac3);
+	mtspr(SPRN_IAC4, thread->debug.iac4);
 #endif
-	mtspr(SPRN_DAC1, thread->dac1);
-	mtspr(SPRN_DAC2, thread->dac2);
+	mtspr(SPRN_DAC1, thread->debug.dac1);
+	mtspr(SPRN_DAC2, thread->debug.dac2);
 #if CONFIG_PPC_ADV_DEBUG_DVCS > 0
-	mtspr(SPRN_DVC1, thread->dvc1);
-	mtspr(SPRN_DVC2, thread->dvc2);
+	mtspr(SPRN_DVC1, thread->debug.dvc1);
+	mtspr(SPRN_DVC2, thread->debug.dvc2);
 #endif
-	mtspr(SPRN_DBCR0, thread->dbcr0);
-	mtspr(SPRN_DBCR1, thread->dbcr1);
+	mtspr(SPRN_DBCR0, thread->debug.dbcr0);
+	mtspr(SPRN_DBCR1, thread->debug.dbcr1);
 #ifdef CONFIG_BOOKE
-	mtspr(SPRN_DBCR2, thread->dbcr2);
+	mtspr(SPRN_DBCR2, thread->debug.dbcr2);
 #endif
 }
 /*
@@ -371,8 +371,8 @@ static void prime_debug_regs(struct thread_struct *thread)
  */
 static void switch_booke_debug_regs(struct thread_struct *new_thread)
 {
-	if ((current->thread.dbcr0 & DBCR0_IDM)
-		|| (new_thread->dbcr0 & DBCR0_IDM))
+	if ((current->thread.debug.dbcr0 & DBCR0_IDM)
+		|| (new_thread->debug.dbcr0 & DBCR0_IDM))
 			prime_debug_regs(new_thread);
 }
 #else	/* !CONFIG_PPC_ADV_DEBUG_REGS */
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 64f7bd5..9bb0b8a 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -854,8 +854,8 @@ void user_enable_single_step(struct task_struct *task)
 
 	if (regs != NULL) {
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-		task->thread.dbcr0 &= ~DBCR0_BT;
-		task->thread.dbcr0 |= DBCR0_IDM | DBCR0_IC;
+		task->thread.debug.dbcr0 &= ~DBCR0_BT;
+		task->thread.debug.dbcr0 |= DBCR0_IDM | DBCR0_IC;
 		regs->msr |= MSR_DE;
 #else
 		regs->msr &= ~MSR_BE;
@@ -871,8 +871,8 @@ void user_enable_block_step(struct task_struct *task)
 
 	if (regs != NULL) {
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-		task->thread.dbcr0 &= ~DBCR0_IC;
-		task->thread.dbcr0 = DBCR0_IDM | DBCR0_BT;
+		task->thread.debug.dbcr0 &= ~DBCR0_IC;
+		task->thread.debug.dbcr0 = DBCR0_IDM | DBCR0_BT;
 		regs->msr |= MSR_DE;
 #else
 		regs->msr &= ~MSR_SE;
@@ -894,16 +894,16 @@ void user_disable_single_step(struct task_struct *task)
 		 * And, after doing so, if all debug flags are off, turn
 		 * off DBCR0(IDM) and MSR(DE) .... Torez
 		 */
-		task->thread.dbcr0 &= ~DBCR0_IC;
+		task->thread.debug.dbcr0 &= ~DBCR0_IC;
 		/*
 		 * Test to see if any of the DBCR_ACTIVE_EVENTS bits are set.
 		 */
-		if (!DBCR_ACTIVE_EVENTS(task->thread.dbcr0,
-					task->thread.dbcr1)) {
+		if (!DBCR_ACTIVE_EVENTS(task->thread.debug.dbcr0,
+					task->thread.debug.dbcr1)) {
 			/*
 			 * All debug events were off.....
 			 */
-			task->thread.dbcr0 &= ~DBCR0_IDM;
+			task->thread.debug.dbcr0 &= ~DBCR0_IDM;
 			regs->msr &= ~MSR_DE;
 		}
 #else
@@ -1031,14 +1031,14 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 	 */
 
 	/* DAC's hold the whole address without any mode flags */
-	task->thread.dac1 = data & ~0x3UL;
+	task->thread.debug.dac1 = data & ~0x3UL;
 
-	if (task->thread.dac1 == 0) {
+	if (task->thread.debug.dac1 == 0) {
 		dbcr_dac(task) &= ~(DBCR_DAC1R | DBCR_DAC1W);
-		if (!DBCR_ACTIVE_EVENTS(task->thread.dbcr0,
-					task->thread.dbcr1)) {
+		if (!DBCR_ACTIVE_EVENTS(task->thread.debug.dbcr0,
+					task->thread.debug.dbcr1)) {
 			task->thread.regs->msr &= ~MSR_DE;
-			task->thread.dbcr0 &= ~DBCR0_IDM;
+			task->thread.debug.dbcr0 &= ~DBCR0_IDM;
 		}
 		return 0;
 	}
@@ -1050,7 +1050,7 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 
 	/* Set the Internal Debugging flag (IDM bit 1) for the DBCR0
 	   register */
-	task->thread.dbcr0 |= DBCR0_IDM;
+	task->thread.debug.dbcr0 |= DBCR0_IDM;
 
 	/* Check for write and read flags and set DBCR0
 	   accordingly */
@@ -1080,10 +1080,10 @@ static long set_instruction_bp(struct task_struct *child,
 			      struct ppc_hw_breakpoint *bp_info)
 {
 	int slot;
-	int slot1_in_use = ((child->thread.dbcr0 & DBCR0_IAC1) != 0);
-	int slot2_in_use = ((child->thread.dbcr0 & DBCR0_IAC2) != 0);
-	int slot3_in_use = ((child->thread.dbcr0 & DBCR0_IAC3) != 0);
-	int slot4_in_use = ((child->thread.dbcr0 & DBCR0_IAC4) != 0);
+	int slot1_in_use = ((child->thread.debug.dbcr0 & DBCR0_IAC1) != 0);
+	int slot2_in_use = ((child->thread.debug.dbcr0 & DBCR0_IAC2) != 0);
+	int slot3_in_use = ((child->thread.debug.dbcr0 & DBCR0_IAC3) != 0);
+	int slot4_in_use = ((child->thread.debug.dbcr0 & DBCR0_IAC4) != 0);
 
 	if (dbcr_iac_range(child) & DBCR_IAC12MODE)
 		slot2_in_use = 1;
@@ -1102,9 +1102,9 @@ static long set_instruction_bp(struct task_struct *child,
 		/* We need a pair of IAC regsisters */
 		if ((!slot1_in_use) && (!slot2_in_use)) {
 			slot = 1;
-			child->thread.iac1 = bp_info->addr;
-			child->thread.iac2 = bp_info->addr2;
-			child->thread.dbcr0 |= DBCR0_IAC1;
+			child->thread.debug.iac1 = bp_info->addr;
+			child->thread.debug.iac2 = bp_info->addr2;
+			child->thread.debug.dbcr0 |= DBCR0_IAC1;
 			if (bp_info->addr_mode ==
 					PPC_BREAKPOINT_MODE_RANGE_EXCLUSIVE)
 				dbcr_iac_range(child) |= DBCR_IAC12X;
@@ -1113,9 +1113,9 @@ static long set_instruction_bp(struct task_struct *child,
 #if CONFIG_PPC_ADV_DEBUG_IACS > 2
 		} else if ((!slot3_in_use) && (!slot4_in_use)) {
 			slot = 3;
-			child->thread.iac3 = bp_info->addr;
-			child->thread.iac4 = bp_info->addr2;
-			child->thread.dbcr0 |= DBCR0_IAC3;
+			child->thread.debug.iac3 = bp_info->addr;
+			child->thread.debug.iac4 = bp_info->addr2;
+			child->thread.debug.dbcr0 |= DBCR0_IAC3;
 			if (bp_info->addr_mode ==
 					PPC_BREAKPOINT_MODE_RANGE_EXCLUSIVE)
 				dbcr_iac_range(child) |= DBCR_IAC34X;
@@ -1135,30 +1135,30 @@ static long set_instruction_bp(struct task_struct *child,
 			 */
 			if (slot2_in_use || (slot3_in_use == slot4_in_use)) {
 				slot = 1;
-				child->thread.iac1 = bp_info->addr;
-				child->thread.dbcr0 |= DBCR0_IAC1;
+				child->thread.debug.iac1 = bp_info->addr;
+				child->thread.debug.dbcr0 |= DBCR0_IAC1;
 				goto out;
 			}
 		}
 		if (!slot2_in_use) {
 			slot = 2;
-			child->thread.iac2 = bp_info->addr;
-			child->thread.dbcr0 |= DBCR0_IAC2;
+			child->thread.debug.iac2 = bp_info->addr;
+			child->thread.debug.dbcr0 |= DBCR0_IAC2;
 #if CONFIG_PPC_ADV_DEBUG_IACS > 2
 		} else if (!slot3_in_use) {
 			slot = 3;
-			child->thread.iac3 = bp_info->addr;
-			child->thread.dbcr0 |= DBCR0_IAC3;
+			child->thread.debug.iac3 = bp_info->addr;
+			child->thread.debug.dbcr0 |= DBCR0_IAC3;
 		} else if (!slot4_in_use) {
 			slot = 4;
-			child->thread.iac4 = bp_info->addr;
-			child->thread.dbcr0 |= DBCR0_IAC4;
+			child->thread.debug.iac4 = bp_info->addr;
+			child->thread.debug.dbcr0 |= DBCR0_IAC4;
 #endif
 		} else
 			return -ENOSPC;
 	}
 out:
-	child->thread.dbcr0 |= DBCR0_IDM;
+	child->thread.debug.dbcr0 |= DBCR0_IDM;
 	child->thread.regs->msr |= MSR_DE;
 
 	return slot;
@@ -1168,49 +1168,49 @@ static int del_instruction_bp(struct task_struct *child, int slot)
 {
 	switch (slot) {
 	case 1:
-		if ((child->thread.dbcr0 & DBCR0_IAC1) == 0)
+		if ((child->thread.debug.dbcr0 & DBCR0_IAC1) == 0)
 			return -ENOENT;
 
 		if (dbcr_iac_range(child) & DBCR_IAC12MODE) {
 			/* address range - clear slots 1 & 2 */
-			child->thread.iac2 = 0;
+			child->thread.debug.iac2 = 0;
 			dbcr_iac_range(child) &= ~DBCR_IAC12MODE;
 		}
-		child->thread.iac1 = 0;
-		child->thread.dbcr0 &= ~DBCR0_IAC1;
+		child->thread.debug.iac1 = 0;
+		child->thread.debug.dbcr0 &= ~DBCR0_IAC1;
 		break;
 	case 2:
-		if ((child->thread.dbcr0 & DBCR0_IAC2) == 0)
+		if ((child->thread.debug.dbcr0 & DBCR0_IAC2) == 0)
 			return -ENOENT;
 
 		if (dbcr_iac_range(child) & DBCR_IAC12MODE)
 			/* used in a range */
 			return -EINVAL;
-		child->thread.iac2 = 0;
-		child->thread.dbcr0 &= ~DBCR0_IAC2;
+		child->thread.debug.iac2 = 0;
+		child->thread.debug.dbcr0 &= ~DBCR0_IAC2;
 		break;
 #if CONFIG_PPC_ADV_DEBUG_IACS > 2
 	case 3:
-		if ((child->thread.dbcr0 & DBCR0_IAC3) == 0)
+		if ((child->thread.debug.dbcr0 & DBCR0_IAC3) == 0)
 			return -ENOENT;
 
 		if (dbcr_iac_range(child) & DBCR_IAC34MODE) {
 			/* address range - clear slots 3 & 4 */
-			child->thread.iac4 = 0;
+			child->thread.debug.iac4 = 0;
 			dbcr_iac_range(child) &= ~DBCR_IAC34MODE;
 		}
-		child->thread.iac3 = 0;
-		child->thread.dbcr0 &= ~DBCR0_IAC3;
+		child->thread.debug.iac3 = 0;
+		child->thread.debug.dbcr0 &= ~DBCR0_IAC3;
 		break;
 	case 4:
-		if ((child->thread.dbcr0 & DBCR0_IAC4) == 0)
+		if ((child->thread.debug.dbcr0 & DBCR0_IAC4) == 0)
 			return -ENOENT;
 
 		if (dbcr_iac_range(child) & DBCR_IAC34MODE)
 			/* Used in a range */
 			return -EINVAL;
-		child->thread.iac4 = 0;
-		child->thread.dbcr0 &= ~DBCR0_IAC4;
+		child->thread.debug.iac4 = 0;
+		child->thread.debug.dbcr0 &= ~DBCR0_IAC4;
 		break;
 #endif
 	default:
@@ -1240,18 +1240,18 @@ static int set_dac(struct task_struct *child, struct ppc_hw_breakpoint *bp_info)
 			dbcr_dac(child) |= DBCR_DAC1R;
 		if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
 			dbcr_dac(child) |= DBCR_DAC1W;
-		child->thread.dac1 = (unsigned long)bp_info->addr;
+		child->thread.debug.dac1 = (unsigned long)bp_info->addr;
 #if CONFIG_PPC_ADV_DEBUG_DVCS > 0
 		if (byte_enable) {
-			child->thread.dvc1 =
+			child->thread.debug.dvc1 =
 				(unsigned long)bp_info->condition_value;
-			child->thread.dbcr2 |=
+			child->thread.debug.dbcr2 |=
 				((byte_enable << DBCR2_DVC1BE_SHIFT) |
 				 (condition_mode << DBCR2_DVC1M_SHIFT));
 		}
 #endif
 #ifdef CONFIG_PPC_ADV_DEBUG_DAC_RANGE
-	} else if (child->thread.dbcr2 & DBCR2_DAC12MODE) {
+	} else if (child->thread.debug.dbcr2 & DBCR2_DAC12MODE) {
 		/* Both dac1 and dac2 are part of a range */
 		return -ENOSPC;
 #endif
@@ -1261,19 +1261,19 @@ static int set_dac(struct task_struct *child, struct ppc_hw_breakpoint *bp_info)
 			dbcr_dac(child) |= DBCR_DAC2R;
 		if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
 			dbcr_dac(child) |= DBCR_DAC2W;
-		child->thread.dac2 = (unsigned long)bp_info->addr;
+		child->thread.debug.dac2 = (unsigned long)bp_info->addr;
 #if CONFIG_PPC_ADV_DEBUG_DVCS > 0
 		if (byte_enable) {
-			child->thread.dvc2 =
+			child->thread.debug.dvc2 =
 				(unsigned long)bp_info->condition_value;
-			child->thread.dbcr2 |=
+			child->thread.debug.dbcr2 |=
 				((byte_enable << DBCR2_DVC2BE_SHIFT) |
 				 (condition_mode << DBCR2_DVC2M_SHIFT));
 		}
 #endif
 	} else
 		return -ENOSPC;
-	child->thread.dbcr0 |= DBCR0_IDM;
+	child->thread.debug.dbcr0 |= DBCR0_IDM;
 	child->thread.regs->msr |= MSR_DE;
 
 	return slot + 4;
@@ -1285,32 +1285,32 @@ static int del_dac(struct task_struct *child, int slot)
 		if ((dbcr_dac(child) & (DBCR_DAC1R | DBCR_DAC1W)) == 0)
 			return -ENOENT;
 
-		child->thread.dac1 = 0;
+		child->thread.debug.dac1 = 0;
 		dbcr_dac(child) &= ~(DBCR_DAC1R | DBCR_DAC1W);
 #ifdef CONFIG_PPC_ADV_DEBUG_DAC_RANGE
-		if (child->thread.dbcr2 & DBCR2_DAC12MODE) {
-			child->thread.dac2 = 0;
-			child->thread.dbcr2 &= ~DBCR2_DAC12MODE;
+		if (child->thread.debug.dbcr2 & DBCR2_DAC12MODE) {
+			child->thread.debug.dac2 = 0;
+			child->thread.debug.dbcr2 &= ~DBCR2_DAC12MODE;
 		}
-		child->thread.dbcr2 &= ~(DBCR2_DVC1M | DBCR2_DVC1BE);
+		child->thread.debug.dbcr2 &= ~(DBCR2_DVC1M | DBCR2_DVC1BE);
 #endif
 #if CONFIG_PPC_ADV_DEBUG_DVCS > 0
-		child->thread.dvc1 = 0;
+		child->thread.debug.dvc1 = 0;
 #endif
 	} else if (slot == 2) {
 		if ((dbcr_dac(child) & (DBCR_DAC2R | DBCR_DAC2W)) == 0)
 			return -ENOENT;
 
 #ifdef CONFIG_PPC_ADV_DEBUG_DAC_RANGE
-		if (child->thread.dbcr2 & DBCR2_DAC12MODE)
+		if (child->thread.debug.dbcr2 & DBCR2_DAC12MODE)
 			/* Part of a range */
 			return -EINVAL;
-		child->thread.dbcr2 &= ~(DBCR2_DVC2M | DBCR2_DVC2BE);
+		child->thread.debug.dbcr2 &= ~(DBCR2_DVC2M | DBCR2_DVC2BE);
 #endif
 #if CONFIG_PPC_ADV_DEBUG_DVCS > 0
-		child->thread.dvc2 = 0;
+		child->thread.debug.dvc2 = 0;
 #endif
-		child->thread.dac2 = 0;
+		child->thread.debug.dac2 = 0;
 		dbcr_dac(child) &= ~(DBCR_DAC2R | DBCR_DAC2W);
 	} else
 		return -EINVAL;
@@ -1352,22 +1352,22 @@ static int set_dac_range(struct task_struct *child,
 			return -EIO;
 	}
 
-	if (child->thread.dbcr0 &
+	if (child->thread.debug.dbcr0 &
 	    (DBCR0_DAC1R | DBCR0_DAC1W | DBCR0_DAC2R | DBCR0_DAC2W))
 		return -ENOSPC;
 
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_READ)
-		child->thread.dbcr0 |= (DBCR0_DAC1R | DBCR0_IDM);
+		child->thread.debug.dbcr0 |= (DBCR0_DAC1R | DBCR0_IDM);
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
-		child->thread.dbcr0 |= (DBCR0_DAC1W | DBCR0_IDM);
-	child->thread.dac1 = bp_info->addr;
-	child->thread.dac2 = bp_info->addr2;
+		child->thread.debug.dbcr0 |= (DBCR0_DAC1W | DBCR0_IDM);
+	child->thread.debug.dac1 = bp_info->addr;
+	child->thread.debug.dac2 = bp_info->addr2;
 	if (mode == PPC_BREAKPOINT_MODE_RANGE_INCLUSIVE)
-		child->thread.dbcr2  |= DBCR2_DAC12M;
+		child->thread.debug.dbcr2  |= DBCR2_DAC12M;
 	else if (mode == PPC_BREAKPOINT_MODE_RANGE_EXCLUSIVE)
-		child->thread.dbcr2  |= DBCR2_DAC12MX;
+		child->thread.debug.dbcr2  |= DBCR2_DAC12MX;
 	else	/* PPC_BREAKPOINT_MODE_MASK */
-		child->thread.dbcr2  |= DBCR2_DAC12MM;
+		child->thread.debug.dbcr2  |= DBCR2_DAC12MM;
 	child->thread.regs->msr |= MSR_DE;
 
 	return 5;
@@ -1507,9 +1507,9 @@ static long ppc_del_hwdebug(struct task_struct *child, long data)
 		rc = del_dac(child, (int)data - 4);
 
 	if (!rc) {
-		if (!DBCR_ACTIVE_EVENTS(child->thread.dbcr0,
-					child->thread.dbcr1)) {
-			child->thread.dbcr0 &= ~DBCR0_IDM;
+		if (!DBCR_ACTIVE_EVENTS(child->thread.debug.dbcr0,
+					child->thread.debug.dbcr1)) {
+			child->thread.debug.dbcr0 &= ~DBCR0_IDM;
 			child->thread.regs->msr &= ~MSR_DE;
 		}
 	}
@@ -1691,7 +1691,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		if (addr > 0)
 			break;
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-		ret = put_user(child->thread.dac1, datalp);
+		ret = put_user(child->thread.debug.dac1, datalp);
 #else
 		dabr_fake = ((child->thread.hw_brk.address & (~HW_BRK_TYPE_DABR)) |
 			     (child->thread.hw_brk.type & HW_BRK_TYPE_DABR));
diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index f51599e..18c7c65 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -269,7 +269,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		if (addr > 0)
 			break;
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-		ret = put_user(child->thread.dac1, (u32 __user *)data);
+		ret = put_user(child->thread.debug.dac1, (u32 __user *)data);
 #else
 		dabr_fake = (
 			(child->thread.hw_brk.address & (~HW_BRK_TYPE_DABR)) |
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 0f83122..f5be6f1 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1300,7 +1300,7 @@ int sys_debug_setcontext(struct ucontext __user *ctx,
 	unsigned char tmp;
 	unsigned long new_msr = regs->msr;
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-	unsigned long new_dbcr0 = current->thread.dbcr0;
+	unsigned long new_dbcr0 = current->thread.debug.dbcr0;
 #endif
 
 	for (i=0; i<ndbg; i++) {
@@ -1315,7 +1315,7 @@ int sys_debug_setcontext(struct ucontext __user *ctx,
 			} else {
 				new_dbcr0 &= ~DBCR0_IC;
 				if (!DBCR_ACTIVE_EVENTS(new_dbcr0,
-						current->thread.dbcr1)) {
+						current->thread.debug.dbcr1)) {
 					new_msr &= ~MSR_DE;
 					new_dbcr0 &= ~DBCR0_IDM;
 				}
@@ -1350,7 +1350,7 @@ int sys_debug_setcontext(struct ucontext __user *ctx,
 	   the user is really doing something wrong. */
 	regs->msr = new_msr;
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-	current->thread.dbcr0 = new_dbcr0;
+	current->thread.debug.dbcr0 = new_dbcr0;
 #endif
 
 	if (!access_ok(VERIFY_READ, ctx, sizeof(*ctx))
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index bf33c22..1998685 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -352,8 +352,8 @@ static inline int check_io_access(struct pt_regs *regs)
 #define REASON_TRAP		ESR_PTR
 
 /* single-step stuff */
-#define single_stepping(regs)	(current->thread.dbcr0 & DBCR0_IC)
-#define clear_single_step(regs)	(current->thread.dbcr0 &= ~DBCR0_IC)
+#define single_stepping(regs)	(current->thread.debug.dbcr0 & DBCR0_IC)
+#define clear_single_step(regs)	(current->thread.debug.dbcr0 &= ~DBCR0_IC)
 
 #else
 /* On non-4xx, the reason for the machine check or program
@@ -1485,7 +1485,7 @@ static void handle_debug(struct pt_regs *regs, unsigned long debug_status)
 	if (debug_status & (DBSR_DAC1R | DBSR_DAC1W)) {
 		dbcr_dac(current) &= ~(DBCR_DAC1R | DBCR_DAC1W);
 #ifdef CONFIG_PPC_ADV_DEBUG_DAC_RANGE
-		current->thread.dbcr2 &= ~DBCR2_DAC12MODE;
+		current->thread.debug.dbcr2 &= ~DBCR2_DAC12MODE;
 #endif
 		do_send_trap(regs, mfspr(SPRN_DAC1), debug_status, TRAP_HWBKPT,
 			     5);
@@ -1496,24 +1496,24 @@ static void handle_debug(struct pt_regs *regs, unsigned long debug_status)
 			     6);
 		changed |= 0x01;
 	}  else if (debug_status & DBSR_IAC1) {
-		current->thread.dbcr0 &= ~DBCR0_IAC1;
+		current->thread.debug.dbcr0 &= ~DBCR0_IAC1;
 		dbcr_iac_range(current) &= ~DBCR_IAC12MODE;
 		do_send_trap(regs, mfspr(SPRN_IAC1), debug_status, TRAP_HWBKPT,
 			     1);
 		changed |= 0x01;
 	}  else if (debug_status & DBSR_IAC2) {
-		current->thread.dbcr0 &= ~DBCR0_IAC2;
+		current->thread.debug.dbcr0 &= ~DBCR0_IAC2;
 		do_send_trap(regs, mfspr(SPRN_IAC2), debug_status, TRAP_HWBKPT,
 			     2);
 		changed |= 0x01;
 	}  else if (debug_status & DBSR_IAC3) {
-		current->thread.dbcr0 &= ~DBCR0_IAC3;
+		current->thread.debug.dbcr0 &= ~DBCR0_IAC3;
 		dbcr_iac_range(current) &= ~DBCR_IAC34MODE;
 		do_send_trap(regs, mfspr(SPRN_IAC3), debug_status, TRAP_HWBKPT,
 			     3);
 		changed |= 0x01;
 	}  else if (debug_status & DBSR_IAC4) {
-		current->thread.dbcr0 &= ~DBCR0_IAC4;
+		current->thread.debug.dbcr0 &= ~DBCR0_IAC4;
 		do_send_trap(regs, mfspr(SPRN_IAC4), debug_status, TRAP_HWBKPT,
 			     4);
 		changed |= 0x01;
@@ -1523,19 +1523,20 @@ static void handle_debug(struct pt_regs *regs, unsigned long debug_status)
 	 * Check all other debug flags and see if that bit needs to be turned
 	 * back on or not.
 	 */
-	if (DBCR_ACTIVE_EVENTS(current->thread.dbcr0, current->thread.dbcr1))
+	if (DBCR_ACTIVE_EVENTS(current->thread.debug.dbcr0,
+	    current->thread.debug.dbcr1))
 		regs->msr |= MSR_DE;
 	else
 		/* Make sure the IDM flag is off */
-		current->thread.dbcr0 &= ~DBCR0_IDM;
+		current->thread.debug.dbcr0 &= ~DBCR0_IDM;
 
 	if (changed & 0x01)
-		mtspr(SPRN_DBCR0, current->thread.dbcr0);
+		mtspr(SPRN_DBCR0, current->thread.debug.dbcr0);
 }
 
 void __kprobes DebugException(struct pt_regs *regs, unsigned long debug_status)
 {
-	current->thread.dbsr = debug_status;
+	current->thread.debug.dbsr = debug_status;
 
 	/* Hack alert: On BookE, Branch Taken stops on the branch itself, while
 	 * on server, it stops on the target of the branch. In order to simulate
@@ -1552,8 +1553,8 @@ void __kprobes DebugException(struct pt_regs *regs, unsigned long debug_status)
 
 		/* Do the single step trick only when coming from userspace */
 		if (user_mode(regs)) {
-			current->thread.dbcr0 &= ~DBCR0_BT;
-			current->thread.dbcr0 |= DBCR0_IDM | DBCR0_IC;
+			current->thread.debug.dbcr0 &= ~DBCR0_BT;
+			current->thread.debug.dbcr0 |= DBCR0_IDM | DBCR0_IC;
 			regs->msr |= MSR_DE;
 			return;
 		}
@@ -1581,13 +1582,13 @@ void __kprobes DebugException(struct pt_regs *regs, unsigned long debug_status)
 			return;
 
 		if (user_mode(regs)) {
-			current->thread.dbcr0 &= ~DBCR0_IC;
-			if (DBCR_ACTIVE_EVENTS(current->thread.dbcr0,
-					       current->thread.dbcr1))
+			current->thread.debug.dbcr0 &= ~DBCR0_IC;
+			if (DBCR_ACTIVE_EVENTS(current->thread.debug.dbcr0,
+					       current->thread.debug.dbcr1))
 				regs->msr |= MSR_DE;
 			else
 				/* Make sure the IDM bit is off */
-				current->thread.dbcr0 &= ~DBCR0_IDM;
+				current->thread.debug.dbcr0 &= ~DBCR0_IDM;
 		}
 
 		_exception(SIGTRAP, regs, TRAP_TRACE, regs->nip);
-- 
1.7.0.4


