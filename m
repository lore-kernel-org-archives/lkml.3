Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaLIS5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:57:47 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47786 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaLIS53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:57:29 -0500
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 4/4] powernv: powerpc: Add winkle support for offline cpus
Date: Wed, 10 Dec 2014 00:26:53 +0530
Message-Id: <1418151413-6141-5-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418151413-6141-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1418151413-6141-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120918-0037-0000-0000-00000012B86F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Winkle is a deep idle state supported in power8 chips. A core enters
winkle when all the threads of the core enter winkle. In this state
power supply to the entire chiplet i.e core, private L2 and private L3
is turned off. As a result it gives higher powersavings compared to
sleep.

But entering winkle results in a total hypervisor state loss. Hence the
hypervisor context has to be preserved before entering winkle and
restored upon wake up.

Power-on Reset Engine (PORE) is a dedicated engine which is responsible
for powering on the chiplet during wake up. It can be programmed to
restore the register contests of a few specific registers. This patch
uses PORE to restore register state wherever possible and uses stack to
save and restore rest of the necessary registers.

With hypervisor state restore things fall under three categories-
per-core state, per-subcore state and per-thread state. To manage this,
extend the infrastructure introduced for sleep. Mainly we add a paca
variable subcore_sibling_mask. Using this and the core_idle_state we can
distingush first thread in core and subcore.

Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/opal.h                |   3 +
 arch/powerpc/include/asm/paca.h                |   2 +
 arch/powerpc/include/asm/ppc-opcode.h          |   2 +
 arch/powerpc/include/asm/processor.h           |   1 +
 arch/powerpc/include/asm/reg.h                 |   2 +
 arch/powerpc/kernel/asm-offsets.c              |   2 +
 arch/powerpc/kernel/exceptions-64s.S           |  11 +-
 arch/powerpc/kernel/idle_power7.S              | 141 +++++++++++++++++++++++--
 arch/powerpc/platforms/powernv/opal-wrappers.S |   1 +
 arch/powerpc/platforms/powernv/setup.c         |  73 +++++++++++++
 arch/powerpc/platforms/powernv/smp.c           |   4 +-
 arch/powerpc/platforms/powernv/subcore.c       |  34 ++++++
 arch/powerpc/platforms/powernv/subcore.h       |   1 +
 13 files changed, 266 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index bef7fbc..f0ca2d9 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -153,6 +153,7 @@ struct opal_sg_list {
 #define OPAL_PCI_EEH_FREEZE_SET			97
 #define OPAL_HANDLE_HMI				98
 #define OPAL_CONFIG_CPU_IDLE_STATE		99
+#define OPAL_SLW_SET_REG			100
 #define OPAL_REGISTER_DUMP_REGION		101
 #define OPAL_UNREGISTER_DUMP_REGION		102
 
@@ -163,6 +164,7 @@ struct opal_sg_list {
  */
 #define OPAL_PM_NAP_ENABLED	0x00010000
 #define OPAL_PM_SLEEP_ENABLED	0x00020000
+#define OPAL_PM_WINKLE_ENABLED	0x00040000
 #define OPAL_PM_SLEEP_ENABLED_ER1	0x00080000
 
 #ifndef __ASSEMBLY__
@@ -972,6 +974,7 @@ int64_t opal_sensor_read(uint32_t sensor_hndl, int token, __be32 *sensor_data);
 int64_t opal_handle_hmi(void);
 int64_t opal_register_dump_region(uint32_t id, uint64_t start, uint64_t end);
 int64_t opal_unregister_dump_region(uint32_t id);
+int64_t opal_slw_set_reg(uint64_t cpu_pir, uint64_t sprn, uint64_t val);
 int64_t opal_pci_set_phb_cxl_mode(uint64_t phb_id, uint64_t mode, uint64_t pe_number);
 
 /* Internal functions */
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index e2c4737..c979577 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -164,6 +164,8 @@ struct paca_struct {
 	u8 thread_idle_state;		/* PNV_THREAD_RUNNING/NAP/SLEEP	*/
 	/* Mask to indicate thread id in core */
 	u8 thread_mask;
+	/* Mask to denote subcore sibling threads */
+	u8 subcore_sibling_mask;
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
index f5c45b3..bf117d8 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -453,6 +453,7 @@ enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 extern unsigned long power7_nap(int check_irq);
 extern unsigned long power7_sleep(void);
+extern unsigned long power7_winkle(void);
 extern void flush_instruction_cache(void);
 extern void hard_reset_now(void);
 extern void poweroff_now(void);
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index a68ee15..1c874fb 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -373,6 +373,7 @@
 #define SPRN_DBAT7L	0x23F	/* Data BAT 7 Lower Register */
 #define SPRN_DBAT7U	0x23E	/* Data BAT 7 Upper Register */
 #define SPRN_PPR	0x380	/* SMT Thread status Register */
+#define SPRN_TSCR	0x399	/* Thread Switch Control Register */
 
 #define SPRN_DEC	0x016		/* Decrement Register */
 #define SPRN_DER	0x095		/* Debug Enable Regsiter */
@@ -730,6 +731,7 @@
 #define SPRN_BESCR	806	/* Branch event status and control register */
 #define   BESCR_GE	0x8000000000000000ULL /* Global Enable */
 #define SPRN_WORT	895	/* Workload optimization register - thread */
+#define SPRN_WORC	863	/* Workload optimization register - core */
 
 #define SPRN_PMC1	787
 #define SPRN_PMC2	788
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 3bc0352..f262e3e 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -737,6 +737,8 @@ int main(void)
 			offsetof(struct paca_struct, thread_idle_state));
 	DEFINE(PACA_THREAD_MASK,
 			offsetof(struct paca_struct, thread_mask));
+	DEFINE(PACA_SUBCORE_SIBLING_MASK,
+			offsetof(struct paca_struct, subcore_sibling_mask));
 #endif
 
 	return 0;
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index f36e4f8..77d5e26 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -102,9 +102,7 @@ system_reset_pSeries:
 #ifdef CONFIG_PPC_P7_NAP
 BEGIN_FTR_SECTION
 	/* Running native on arch 2.06 or later, check if we are
-	 * waking up from nap. We only handle no state loss and
-	 * supervisor state loss. We do -not- handle hypervisor
-	 * state loss at this time.
+	 * waking up from nap/sleep/winkle.
 	 */
 	mfspr	r13,SPRN_SRR1
 	rlwinm.	r13,r13,47-31,30,31
@@ -112,7 +110,14 @@ BEGIN_FTR_SECTION
 
 	cmpwi	cr3,r13,2
 
+	/* Check if last bit of HSPGR0 is set. This indicates whether we are
+	 * waking up from winkle */
 	GET_PACA(r13)
+	clrldi	r5,r13,63
+	clrrdi	r13,r13,1
+	cmpwi	cr4,r5,1
+	mtspr	SPRN_HSPRG0,r13
+
 	lbz	r0,PACA_THREAD_IDLE_STATE(r13)
 	cmpwi   cr2,r0,PNV_THREAD_NAP
 	bgt     cr2,8f				/* Either sleep or Winkle */
diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index 34b4130..e45bc90 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -19,8 +19,22 @@
 #include <asm/kvm_book3s_asm.h>
 #include <asm/opal.h>
 #include <asm/cpuidle.h>
+#include <asm/mmu-hash64.h>
 
 #undef DEBUG
+/*
+ * Use unused space in the interrupt stack to save and restore
+ * registers for winkle support.
+ */
+#define _SDR1	GPR3
+#define _RPR	GPR4
+#define _SPURR	GPR5
+#define _PURR	GPR6
+#define _TSCR	GPR7
+#define _DSCR	GPR8
+#define _AMOR	GPR9
+#define _WORT	GPR10
+#define _WORC	GPR11
 
 /* Idle state entry routines */
 
@@ -124,8 +138,8 @@ power7_enter_nap_mode:
 	stb	r4,HSTATE_HWTHREAD_STATE(r13)
 #endif
 	stb	r3,PACA_THREAD_IDLE_STATE(r13)
-	cmpwi	cr1,r3,PNV_THREAD_SLEEP
-	bge	cr1,2f
+	cmpwi	cr3,r3,PNV_THREAD_SLEEP
+	bge	cr3,2f
 	IDLE_STATE_ENTER_SEQ(PPC_NAP)
 	/* No return */
 2:
@@ -154,7 +168,8 @@ pnv_fastsleep_workaround_at_entry:
 	bne-	lwarx_loop1
 	isync
 
-common_enter: /* common code for all the threads entering sleep */
+common_enter: /* common code for all the threads entering sleep  or winkle */
+	bgt	cr3,enter_winkle
 	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
 
 fastsleep_workaround_at_entry:
@@ -175,6 +190,30 @@ fastsleep_workaround_at_entry:
 	stw	r0,0(r14)
 	b	common_enter
 
+enter_winkle:
+	/*
+	 * Note all register i.e per-core, per-subcore or per-thread is saved
+	 * here since any thread in the core might wake up first
+	 */
+	mfspr	r3,SPRN_SDR1
+	std	r3,_SDR1(r1)
+	mfspr	r3,SPRN_RPR
+	std	r3,_RPR(r1)
+	mfspr	r3,SPRN_SPURR
+	std	r3,_SPURR(r1)
+	mfspr	r3,SPRN_PURR
+	std	r3,_PURR(r1)
+	mfspr	r3,SPRN_TSCR
+	std	r3,_TSCR(r1)
+	mfspr	r3,SPRN_DSCR
+	std	r3,_DSCR(r1)
+	mfspr	r3,SPRN_AMOR
+	std	r3,_AMOR(r1)
+	mfspr	r3,SPRN_WORT
+	std	r3,_WORT(r1)
+	mfspr	r3,SPRN_WORC
+	std	r3,_WORC(r1)
+	IDLE_STATE_ENTER_SEQ(PPC_WINKLE)
 
 _GLOBAL(power7_idle)
 	/* Now check if user or arch enabled NAP mode */
@@ -197,6 +236,12 @@ _GLOBAL(power7_sleep)
 	b	power7_powersave_common
 	/* No return */
 
+_GLOBAL(power7_winkle)
+	li	r3,3
+	li	r4,1
+	b	power7_powersave_common
+	/* No return */
+
 #define CHECK_HMI_INTERRUPT						\
 	mfspr	r0,SPRN_SRR1;						\
 BEGIN_FTR_SECTION_NESTED(66);						\
@@ -250,11 +295,23 @@ lwarx_loop2:
 	bne	core_idle_lock_held
 
 	cmpwi	cr2,r15,0
+	lbz	r4,PACA_SUBCORE_SIBLING_MASK(r13)
+	and	r4,r4,r15
+	cmpwi	cr1,r4,0	/* Check if first in subcore */
+
+	/*
+	 * At this stage
+	 * cr1 - 0b0100 if first thread to wakeup in subcore
+	 * cr2 - 0b0100 if first thread to wakeup in core
+	 * cr3-  0b0010 if waking up from sleep or winkle
+	 * cr4 - 0b0100 if waking up from winkle
+	 */
+
 	or	r15,r15,r7		/* Set thread bit */
 
-	beq	cr2,first_thread
+	beq	cr1,first_thread_in_subcore
 
-	/* Not first thread in core to wake up */
+	/* Not first thread in subcore to wake up */
 	stwcx.	r15,0,r14
 	bne-	lwarx_loop2
 	isync
@@ -269,14 +326,35 @@ core_idle_lock_loop:
 	HMT_MEDIUM
 	b	lwarx_loop2
 
-first_thread:
-	/* First thread in core to wakeup */
+first_thread_in_subcore:
+	/* First thread in subcore to wakeup */
 	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
 	stwcx.	r15,0,r14
 	bne-	lwarx_loop2
 	isync
 
 	/*
+	 * If waking up from sleep, subcore state is not lost. Hence
+	 * skip subcore state restore
+	 */
+	bne	cr4,subcore_state_restored
+
+	/* Restore per-subcore state */
+	ld      r4,_SDR1(r1)
+	mtspr   SPRN_SDR1,r4
+	ld      r4,_RPR(r1)
+	mtspr   SPRN_RPR,r4
+	ld	r4,_AMOR(r1)
+	mtspr	SPRN_AMOR,r4
+
+subcore_state_restored:
+	/* Check if the thread is also the first thread in the core. If not,
+	 * skip to clear_lock */
+	bne	cr2,clear_lock
+
+first_thread_in_core:
+
+	/*
 	 * First thread in the core waking up from fastsleep. It needs to
 	 * call the fastsleep workaround code if the platform requires it.
 	 * Call it unconditionally here. The below branch instruction will
@@ -296,12 +374,61 @@ timebase_resync:
 	bl	opal_call_realmode;
 	/* TODO: Check r3 for failure */
 
+	/*
+	 * If waking up from sleep, per core state is not lost, skip to
+	 * clear_lock.
+	 */
+	bne	cr4,clear_lock
+
+	/* Restore per core state */
+	ld	r4,_TSCR(r1)
+	mtspr	SPRN_TSCR,r4
+	ld	r4,_WORC(r1)
+	mtspr	SPRN_WORC,r4
+
 clear_lock:
 	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
 	lwsync
 	stw	r15,0(r14)
 
 common_exit:
+	/* Common to all threads
+	 *
+	 * If waking up from sleep, hypervisor state is not lost. Hence
+	 * skip hypervisor state restore.
+	 */
+	bne	cr4,hypervisor_state_restored
+
+	/* Waking up from winkle */
+
+	/* Restore per thread state */
+	bl	__restore_cpu_power8
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
+	ld	r4,_SPURR(r1)
+	mtspr	SPRN_SPURR,r4
+	ld	r4,_PURR(r1)
+	mtspr	SPRN_PURR,r4
+	ld	r4,_DSCR(r1)
+	mtspr	SPRN_DSCR,r4
+	ld	r4,_WORT(r1)
+	mtspr	SPRN_WORT,r4
+
+hypervisor_state_restored:
+
 	li	r5,PNV_THREAD_RUNNING
 	stb     r5,PACA_THREAD_IDLE_STATE(r13)
 
diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
index a0f43e8..72b4af8 100644
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -284,6 +284,7 @@ OPAL_CALL(opal_sensor_read,			OPAL_SENSOR_READ);
 OPAL_CALL(opal_get_param,			OPAL_GET_PARAM);
 OPAL_CALL(opal_set_param,			OPAL_SET_PARAM);
 OPAL_CALL(opal_handle_hmi,			OPAL_HANDLE_HMI);
+OPAL_CALL(opal_slw_set_reg,			OPAL_SLW_SET_REG);
 OPAL_CALL(opal_register_dump_region,		OPAL_REGISTER_DUMP_REGION);
 OPAL_CALL(opal_unregister_dump_region,		OPAL_UNREGISTER_DUMP_REGION);
 OPAL_CALL(opal_pci_set_phb_cxl_mode,		OPAL_PCI_SET_PHB_CXL_MODE);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 585d0cd..70b0cb5 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -41,6 +41,7 @@
 #include <asm/code-patching.h>
 
 #include "powernv.h"
+#include "subcore.h"
 
 static void __init pnv_setup_arch(void)
 {
@@ -294,6 +295,74 @@ static void __init pnv_setup_machdep_rtas(void)
 #endif /* CONFIG_PPC_POWERNV_RTAS */
 
 static u32 supported_cpuidle_states;
+int pnv_save_sprs_for_winkle(void)
+{
+	int cpu;
+	int rc;
+
+	/*
+	 * hid0, hid1, hid4, hid5, hmeer and lpcr values are symmetric accross
+	 * all cpus at boot. Get these reg values of current cpu and use the
+	 * same accross all cpus.
+	 */
+	uint64_t lpcr_val = mfspr(SPRN_LPCR);
+	uint64_t hid0_val = mfspr(SPRN_HID0);
+	uint64_t hid1_val = mfspr(SPRN_HID1);
+	uint64_t hid4_val = mfspr(SPRN_HID4);
+	uint64_t hid5_val = mfspr(SPRN_HID5);
+	uint64_t hmeer_val = mfspr(SPRN_HMEER);
+
+	for_each_possible_cpu(cpu) {
+		uint64_t pir = get_hard_smp_processor_id(cpu);
+		uint64_t hsprg0_val = (uint64_t)&paca[cpu];
+
+		/*
+		 * HSPRG0 is used to store the cpu's pointer to paca. Hence last
+		 * 3 bits are guaranteed to be 0. Program slw to restore HSPRG0
+		 * with 63rd bit set, so that when a thread wakes up at 0x100 we
+		 * can use this bit to distinguish between fastsleep and
+		 * deep winkle.
+		 */
+		hsprg0_val |= 1;
+
+		rc = opal_slw_set_reg(pir, SPRN_HSPRG0, hsprg0_val);
+		if (rc != 0)
+			return rc;
+
+		rc = opal_slw_set_reg(pir, SPRN_LPCR, lpcr_val);
+		if (rc != 0)
+			return rc;
+
+		/* HIDs are per core registers */
+		if (cpu_thread_in_core(cpu) == 0) {
+
+			rc = opal_slw_set_reg(pir, SPRN_HMEER, hmeer_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID0, hid0_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID1, hid1_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID4, hid4_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID5, hid5_val);
+			if (rc != 0)
+				return rc;
+
+		}
+
+	}
+
+	return 0;
+
+}
 
 static void pnv_alloc_idle_core_states(void)
 {
@@ -327,6 +396,10 @@ static void pnv_alloc_idle_core_states(void)
 			paca[cpu].thread_mask = 1 << j;
 		}
 	}
+	update_subcore_sibling_mask();
+	if (supported_cpuidle_states & OPAL_PM_WINKLE_ENABLED)
+		pnv_save_sprs_for_winkle();
+
 }
 
 u32 pnv_get_supported_cpuidle_states(void)
diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index c0691d0..f11b646 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -168,7 +168,9 @@ static void pnv_smp_cpu_kill_self(void)
 	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
 	while (!generic_check_cpu_restart(cpu)) {
 		ppc64_runlatch_off();
-		if ((idle_states & OPAL_PM_SLEEP_ENABLED) ||
+		if (idle_states & OPAL_PM_WINKLE_ENABLED)
+			srr1 = power7_winkle();
+		else if ((idle_states & OPAL_PM_SLEEP_ENABLED) ||
 				(idle_states & OPAL_PM_SLEEP_ENABLED_ER1))
 			srr1 = power7_sleep();
 		else
diff --git a/arch/powerpc/platforms/powernv/subcore.c b/arch/powerpc/platforms/powernv/subcore.c
index c87f96b..f60f80a 100644
--- a/arch/powerpc/platforms/powernv/subcore.c
+++ b/arch/powerpc/platforms/powernv/subcore.c
@@ -160,6 +160,18 @@ static void wait_for_sync_step(int step)
 	mb();
 }
 
+static void update_hid_in_slw(u64 hid0)
+{
+	u64 idle_states = pnv_get_supported_cpuidle_states();
+
+	if (idle_states & OPAL_PM_WINKLE_ENABLED) {
+		/* OPAL call to patch slw with the new HID0 value */
+		u64 cpu_pir = hard_smp_processor_id();
+
+		opal_slw_set_reg(cpu_pir, SPRN_HID0, hid0);
+	}
+}
+
 static void unsplit_core(void)
 {
 	u64 hid0, mask;
@@ -179,6 +191,7 @@ static void unsplit_core(void)
 	hid0 = mfspr(SPRN_HID0);
 	hid0 &= ~HID0_POWER8_DYNLPARDIS;
 	mtspr(SPRN_HID0, hid0);
+	update_hid_in_slw(hid0);
 
 	while (mfspr(SPRN_HID0) & mask)
 		cpu_relax();
@@ -215,6 +228,7 @@ static void split_core(int new_mode)
 	hid0  = mfspr(SPRN_HID0);
 	hid0 |= HID0_POWER8_DYNLPARDIS | split_parms[i].value;
 	mtspr(SPRN_HID0, hid0);
+	update_hid_in_slw(hid0);
 
 	/* Wait for it to happen */
 	while (!(mfspr(SPRN_HID0) & split_parms[i].mask))
@@ -251,6 +265,25 @@ bool cpu_core_split_required(void)
 	return true;
 }
 
+void update_subcore_sibling_mask(void)
+{
+	int cpu;
+	/*
+	 * sibling mask for the first cpu. Left shift this by required bits
+	 * to get sibling mask for the rest of the cpus.
+	 */
+	int sibling_mask_first_cpu =  (1 << threads_per_subcore) - 1;
+
+	for_each_possible_cpu(cpu) {
+		int tid = cpu_thread_in_core(cpu);
+		int offset = (tid / threads_per_subcore) * threads_per_subcore;
+		int mask = sibling_mask_first_cpu << offset;
+
+		paca[cpu].subcore_sibling_mask = mask;
+
+	}
+}
+
 static int cpu_update_split_mode(void *data)
 {
 	int cpu, new_mode = *(int *)data;
@@ -284,6 +317,7 @@ static int cpu_update_split_mode(void *data)
 		/* Make the new mode public */
 		subcores_per_core = new_mode;
 		threads_per_subcore = threads_per_core / subcores_per_core;
+		update_subcore_sibling_mask();
 
 		/* Make sure the new mode is written before we exit */
 		mb();
diff --git a/arch/powerpc/platforms/powernv/subcore.h b/arch/powerpc/platforms/powernv/subcore.h
index 148abc9..604eb40 100644
--- a/arch/powerpc/platforms/powernv/subcore.h
+++ b/arch/powerpc/platforms/powernv/subcore.h
@@ -15,4 +15,5 @@
 
 #ifndef __ASSEMBLY__
 void split_core_secondary_loop(u8 *state);
+extern void update_subcore_sibling_mask(void);
 #endif
-- 
1.9.3

