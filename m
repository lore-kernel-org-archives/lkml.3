Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbaHYSCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:02:37 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34468 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933384AbaHYSCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:02:10 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 7/9] powerpc/powernv: Add winkle infrastructure
Date: Mon, 25 Aug 2014 23:31:11 +0530
Message-Id: <1408989673-14137-8-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082518-5806-0000-0000-0000004C05F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Winkle causes power to be gated off to the entire chiplet. Hence the
hypervisor/firmware state in the entire chiplet is lost.

This patch adds necessary infrastructure to support winkle. Specifically
does following:
- Before entering winkle, save state of registers that need to be
  restored on wake up (SDR1, HFSCR)

- SRR1 bits 46:47 which is used to identify which power saving mode cpu
  woke up from is '11' for both winkle and sleep. Hence introduce a flag
  in PACA to distinguish b/w winkle and sleep.

- Upon waking up, restore all saved registers, recover slb

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Suggested-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/machdep.h     |  1 +
 arch/powerpc/include/asm/paca.h        |  3 ++
 arch/powerpc/include/asm/ppc-opcode.h  |  2 +
 arch/powerpc/include/asm/processor.h   |  2 +
 arch/powerpc/kernel/asm-offsets.c      |  1 +
 arch/powerpc/kernel/exceptions-64s.S   |  4 +-
 arch/powerpc/kernel/idle.c             | 11 +++++
 arch/powerpc/kernel/idle_power7.S      | 81 +++++++++++++++++++++++++++++++++-
 arch/powerpc/platforms/powernv/setup.c | 24 ++++++++++
 9 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index f37014f..0a3ced9 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -301,6 +301,7 @@ struct machdep_calls {
 	/* Idle handlers */
 	void		(*setup_idle)(void);
 	unsigned long	(*power7_sleep)(void);
+	unsigned long	(*power7_winkle)(void);
 };
 
 extern void e500_idle(void);
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index a5139ea..3358f09 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -158,6 +158,9 @@ struct paca_struct {
 	 * early exception handler for use by high level C handler
 	 */
 	struct opal_machine_check_event *opal_mc_evt;
+
+	/* Flag to distinguish b/w sleep and winkle */
+	u8 offline_state;
 #endif
 #ifdef CONFIG_PPC_BOOK3S_64
 	/* Exclusive emergency stack pointer for machine check exception. */
diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 6f85362..5155be7 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -194,6 +194,7 @@
 
 #define PPC_INST_NAP			0x4c000364
 #define PPC_INST_SLEEP			0x4c0003a4
+#define PPC_INST_WINKLE			0x4c0003e4
 
 /* A2 specific instructions */
 #define PPC_INST_ERATWE			0x7c0001a6
@@ -374,6 +375,7 @@
 
 #define PPC_NAP			stringify_in_c(.long PPC_INST_NAP)
 #define PPC_SLEEP		stringify_in_c(.long PPC_INST_SLEEP)
+#define PPC_WINKLE		stringify_in_c(.long PPC_INST_WINKLE)
 
 /* BHRB instructions */
 #define PPC_CLRBHRB		stringify_in_c(.long PPC_INST_CLRBHRB)
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 41953cd..00e3df9 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -455,6 +455,8 @@ extern void arch_setup_idle(void);
 extern void power7_nap(int check_irq);
 extern unsigned long power7_sleep(void);
 extern unsigned long __power7_sleep(void);
+extern unsigned long power7_winkle(void);
+extern unsigned long __power7_winkle(void);
 extern void flush_instruction_cache(void);
 extern void hard_reset_now(void);
 extern void poweroff_now(void);
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 9d7dede..ea98817 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -731,6 +731,7 @@ int main(void)
 	DEFINE(OPAL_MC_SRR0, offsetof(struct opal_machine_check_event, srr0));
 	DEFINE(OPAL_MC_SRR1, offsetof(struct opal_machine_check_event, srr1));
 	DEFINE(PACA_OPAL_MC_EVT, offsetof(struct paca_struct, opal_mc_evt));
+	DEFINE(PACAOFFLINESTATE, offsetof(struct paca_struct, offline_state));
 #endif
 
 	return 0;
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index c64f3cc0..6c6db2b 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -133,8 +133,8 @@ BEGIN_FTR_SECTION
 	b	power7_wakeup_noloss
 2:	b	power7_wakeup_loss
 
-	/* Fast Sleep wakeup on PowerNV */
-8:	b 	power7_wakeup_tb_loss
+	/* Fast Sleep / Winkle wakeup on PowerNV */
+8:	b 	power7_wakeup_hv_state_loss
 
 9:
 END_FTR_SECTION_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 1f268e0..ed46217 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -98,6 +98,17 @@ unsigned long power7_sleep(void)
 	return ret;
 }
 
+unsigned long power7_winkle(void)
+{
+	unsigned long ret;
+
+	if (ppc_md.power7_winkle)
+		ret = ppc_md.power7_winkle();
+	else
+		ret = __power7_winkle();
+	return ret;
+}
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index c3481c9..87b2556 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -18,6 +18,13 @@
 #include <asm/hw_irq.h>
 #include <asm/kvm_book3s_asm.h>
 #include <asm/opal.h>
+#include <asm/mmu-hash64.h>
+
+/*
+ * Use volatile GPRs' space to save essential SPRs before entering winkle
+ */
+#define _SDR1	GPR3
+#define _TSCR	GPR4
 
 #undef DEBUG
 
@@ -39,6 +46,7 @@
  * Pass requested state in r3:
  * 	0 - nap
  * 	1 - sleep
+ *	2 - winkle
  *
  * To check IRQ_HAPPENED in r4
  * 	0 - don't check
@@ -109,9 +117,27 @@ _GLOBAL(power7_enter_nap_mode)
 #endif
 	cmpwi	cr0,r3,1
 	beq	2f
+	cmpwi	cr0,r3,2
+	beq	3f
 	IDLE_STATE_ENTER_SEQ(PPC_NAP)
 	/* No return */
-2:	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
+2:
+	li	r4,1
+	stb	r4,PACAOFFLINESTATE(r13)
+	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
+	/* No return */
+
+3:
+	mfspr   r4,SPRN_SDR1
+	std     r4,_SDR1(r1)
+
+	mfspr   r4,SPRN_TSCR
+	std     r4,_TSCR(r1)
+
+	/* Enter winkle */
+        li      r4,0
+        stb     r4,PACAOFFLINESTATE(r13)
+	IDLE_STATE_ENTER_SEQ(PPC_WINKLE)
 	/* No return */
 
 _GLOBAL(power7_idle)
@@ -187,6 +213,59 @@ ALT_FTR_SECTION_END_NESTED_IFSET(CPU_FTR_ARCH_207S, 66);		\
 20:	nop;
 
 
+_GLOBAL(__power7_winkle)
+	li	r3,2
+	li	r4,1
+	b	power7_powersave_common
+	/* No return */
+
+_GLOBAL(power7_wakeup_hv_state_loss)
+	/* Check paca flag to diffentiate b/w fast sleep and winkle */
+	lbz	r4,PACAOFFLINESTATE(13)
+	cmpwi	cr0,r4,0
+	bne	power7_wakeup_tb_loss
+
+	ld      r2,PACATOC(r13);
+	ld      r1,PACAR1(r13)
+
+	bl 	__restore_cpu_power8
+
+	/* Time base re-sync */
+	li	r3,OPAL_RESYNC_TIMEBASE
+	bl	opal_call_realmode;
+
+	/* Restore SLB  from PACA */
+	ld	r8,PACA_SLBSHADOWPTR(r13)
+
+	.rept	SLB_NUM_BOLTED
+	li	r3, SLBSHADOW_SAVEAREA
+	LDX_BE	r5, r8, r3
+	addi	r3, r3, 8
+	LDX_BE	r6, r8, r3
+	andis.	r7,r5,SLB_ESID_V@h
+	beq	1f
+	slbmte	r6,r5
+1:	addi	r8,r8,16
+	.endr
+
+	ld      r4,_SDR1(r1)
+	mtspr   SPRN_SDR1,r4
+
+	ld      r4,_TSCR(r1)
+	mtspr   SPRN_TSCR,r4
+
+	REST_NVGPRS(r1)
+	REST_GPR(2, r1)
+	ld      r3,_CCR(r1)
+	ld      r4,_MSR(r1)
+	ld      r5,_NIP(r1)
+	addi    r1,r1,INT_FRAME_SIZE
+	mtcr    r3
+	mfspr   r3,SPRN_SRR1            /* Return SRR1 */
+	mtspr   SPRN_SRR1,r4
+	mtspr   SPRN_SRR0,r5
+	rfid
+
 _GLOBAL(power7_wakeup_tb_loss)
 	ld	r2,PACATOC(r13);
 	ld	r1,PACAR1(r13)
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 9d9a898..f45b52d 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -370,6 +370,29 @@ static unsigned long pnv_power7_sleep(void)
 	return srr1;
 }
 
+/*
+ * We need to keep track of offline cpus also for calling
+ * fastsleep workaround appropriately
+ */
+static unsigned long pnv_power7_winkle(void)
+{
+	int cpu, primary_thread;
+	unsigned long srr1;
+
+	cpu = smp_processor_id();
+	primary_thread = cpu_first_thread_sibling(cpu);
+
+	if (need_fastsleep_workaround) {
+		pnv_apply_fastsleep_workaround(1, primary_thread);
+		srr1 = __power7_winkle();
+		pnv_apply_fastsleep_workaround(0, primary_thread);
+	} else {
+			srr1 = __power7_winkle();
+	}
+	return srr1;
+}
+
+
 static void __init pnv_setup_machdep_opal(void)
 {
 	ppc_md.get_boot_time = opal_get_boot_time;
@@ -384,6 +407,7 @@ static void __init pnv_setup_machdep_opal(void)
 	ppc_md.handle_hmi_exception = opal_handle_hmi_exception;
 	ppc_md.setup_idle = pnv_setup_idle;
 	ppc_md.power7_sleep = pnv_power7_sleep;
+	ppc_md.power7_winkle = pnv_power7_winkle;
 }
 
 #ifdef CONFIG_PPC_POWERNV_RTAS
-- 
1.9.0

