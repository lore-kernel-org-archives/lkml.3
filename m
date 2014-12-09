Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaLIS5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:57:31 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33877 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbaLIS51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:57:27 -0500
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 3/4] powernv: cpuidle: Redesign idle states management
Date: Wed, 10 Dec 2014 00:26:52 +0530
Message-Id: <1418151413-6141-4-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418151413-6141-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1418151413-6141-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120918-0033-0000-0000-00000145CA3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deep idle states like sleep and winkle are per core idle states. A core
enters these states only when all the threads enter either the
particular idle state or a deeper one. There are tasks like fastsleep
hardware bug workaround and hypervisor core state save which have to be
done only by the last thread of the core entering deep idle state and
similarly tasks like timebase resync, hypervisor core register restore
that have to be done only by the first thread waking up from these
state.

The current idle state management does not have a way to distinguish the
first/last thread of the core waking/entering idle states. Tasks like
timebase resync are done for all the threads. This is not only is
suboptimal, but can cause functionality issues when subcores and kvm is
involved.

This patch adds the necessary infrastructure to track idle states of
threads in a per-core structure. It uses this info to perform tasks like
fastsleep workaround and timebase resync only once per core.

Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
Originally-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/cpuidle.h             |  20 +++
 arch/powerpc/include/asm/opal.h                |   2 +
 arch/powerpc/include/asm/paca.h                |   6 +
 arch/powerpc/include/asm/processor.h           |   2 +-
 arch/powerpc/kernel/asm-offsets.c              |   6 +
 arch/powerpc/kernel/exceptions-64s.S           |  24 +--
 arch/powerpc/kernel/idle_power7.S              | 197 +++++++++++++++++++------
 arch/powerpc/platforms/powernv/opal-wrappers.S |  37 +++++
 arch/powerpc/platforms/powernv/setup.c         |  49 +++++-
 arch/powerpc/platforms/powernv/smp.c           |   3 +-
 drivers/cpuidle/cpuidle-powernv.c              |   3 +-
 11 files changed, 291 insertions(+), 58 deletions(-)
 create mode 100644 arch/powerpc/include/asm/cpuidle.h

diff --git a/arch/powerpc/include/asm/cpuidle.h b/arch/powerpc/include/asm/cpuidle.h
new file mode 100644
index 0000000..d2f99ca
--- /dev/null
+++ b/arch/powerpc/include/asm/cpuidle.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_POWERPC_CPUIDLE_H
+#define _ASM_POWERPC_CPUIDLE_H
+
+#ifdef CONFIG_PPC_POWERNV
+/* Used in powernv idle state management */
+#define PNV_THREAD_RUNNING              0
+#define PNV_THREAD_NAP                  1
+#define PNV_THREAD_SLEEP                2
+#define PNV_THREAD_WINKLE               3
+#define PNV_CORE_IDLE_LOCK_BIT          0x100
+#define PNV_CORE_IDLE_THREAD_BITS       0x0FF
+
+#ifndef __ASSEMBLY__
+extern u32 pnv_fastsleep_workaround_at_entry[];
+extern u32 pnv_fastsleep_workaround_at_exit[];
+#endif
+
+#endif
+
+#endif
diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index f8b95c0..bef7fbc 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -152,6 +152,7 @@ struct opal_sg_list {
 #define OPAL_PCI_ERR_INJECT			96
 #define OPAL_PCI_EEH_FREEZE_SET			97
 #define OPAL_HANDLE_HMI				98
+#define OPAL_CONFIG_CPU_IDLE_STATE		99
 #define OPAL_REGISTER_DUMP_REGION		101
 #define OPAL_UNREGISTER_DUMP_REGION		102
 
@@ -162,6 +163,7 @@ struct opal_sg_list {
  */
 #define OPAL_PM_NAP_ENABLED	0x00010000
 #define OPAL_PM_SLEEP_ENABLED	0x00020000
+#define OPAL_PM_SLEEP_ENABLED_ER1	0x00080000
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index a5139ea..e2c4737 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -158,6 +158,12 @@ struct paca_struct {
 	 * early exception handler for use by high level C handler
 	 */
 	struct opal_machine_check_event *opal_mc_evt;
+
+	/* Per-core mask tracking idle threads and a lock bit-[L][TTTTTTTT] */
+	u32 *core_idle_state_ptr;
+	u8 thread_idle_state;		/* PNV_THREAD_RUNNING/NAP/SLEEP	*/
+	/* Mask to indicate thread id in core */
+	u8 thread_mask;
 #endif
 #ifdef CONFIG_PPC_BOOK3S_64
 	/* Exclusive emergency stack pointer for machine check exception. */
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 29c3798..f5c45b3 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -452,7 +452,7 @@ enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 extern unsigned long power7_nap(int check_irq);
-extern void power7_sleep(void);
+extern unsigned long power7_sleep(void);
 extern void flush_instruction_cache(void);
 extern void hard_reset_now(void);
 extern void poweroff_now(void);
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 9d7dede..3bc0352 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -731,6 +731,12 @@ int main(void)
 	DEFINE(OPAL_MC_SRR0, offsetof(struct opal_machine_check_event, srr0));
 	DEFINE(OPAL_MC_SRR1, offsetof(struct opal_machine_check_event, srr1));
 	DEFINE(PACA_OPAL_MC_EVT, offsetof(struct paca_struct, opal_mc_evt));
+	DEFINE(PACA_CORE_IDLE_STATE_PTR,
+			offsetof(struct paca_struct, core_idle_state_ptr));
+	DEFINE(PACA_THREAD_IDLE_STATE,
+			offsetof(struct paca_struct, thread_idle_state));
+	DEFINE(PACA_THREAD_MASK,
+			offsetof(struct paca_struct, thread_mask));
 #endif
 
 	return 0;
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 55ff2f7..f36e4f8 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -15,6 +15,7 @@
 #include <asm/hw_irq.h>
 #include <asm/exception-64s.h>
 #include <asm/ptrace.h>
+#include <asm/cpuidle.h>
 
 /*
  * We layout physical memory as follows:
@@ -109,15 +110,19 @@ BEGIN_FTR_SECTION
 	rlwinm.	r13,r13,47-31,30,31
 	beq	9f
 
-	/* waking up from powersave (nap) state */
-	cmpwi	cr1,r13,2
-	/* Total loss of HV state is fatal, we could try to use the
-	 * PIR to locate a PACA, then use an emergency stack etc...
-	 * OPAL v3 based powernv platforms have new idle states
-	 * which fall in this catagory.
-	 */
-	bgt	cr1,8f
+	cmpwi	cr3,r13,2
+
 	GET_PACA(r13)
+	lbz	r0,PACA_THREAD_IDLE_STATE(r13)
+	cmpwi   cr2,r0,PNV_THREAD_NAP
+	bgt     cr2,8f				/* Either sleep or Winkle */
+
+	/* Waking up from nap should not cause hypervisor state loss */
+	bgt	cr3,.
+
+	/* Waking up from nap */
+	li	r0,PNV_THREAD_RUNNING
+	stb	r0,PACA_THREAD_IDLE_STATE(r13)	/* Clear thread state */
 
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	li	r0,KVM_HWTHREAD_IN_KERNEL
@@ -133,7 +138,7 @@ BEGIN_FTR_SECTION
 
 	/* Return SRR1 from power7_nap() */
 	mfspr	r3,SPRN_SRR1
-	beq	cr1,2f
+	beq	cr3,2f
 	b	power7_wakeup_noloss
 2:	b	power7_wakeup_loss
 
@@ -1388,6 +1393,7 @@ machine_check_handle_early:
 	MACHINE_CHECK_HANDLER_WINDUP
 	GET_PACA(r13)
 	ld	r1,PACAR1(r13)
+	li	r3,PNV_THREAD_NAP
 	b	power7_enter_nap_mode
 4:
 #endif
diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index e5aba6a..34b4130 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -18,6 +18,7 @@
 #include <asm/hw_irq.h>
 #include <asm/kvm_book3s_asm.h>
 #include <asm/opal.h>
+#include <asm/cpuidle.h>
 
 #undef DEBUG
 
@@ -37,8 +38,7 @@
 
 /*
  * Pass requested state in r3:
- * 	0 - nap
- * 	1 - sleep
+ *	r3 - PNV_THREAD_NAP/SLEEP/WINKLE
  *
  * To check IRQ_HAPPENED in r4
  * 	0 - don't check
@@ -123,12 +123,58 @@ power7_enter_nap_mode:
 	li	r4,KVM_HWTHREAD_IN_NAP
 	stb	r4,HSTATE_HWTHREAD_STATE(r13)
 #endif
-	cmpwi	cr0,r3,1
-	beq	2f
+	stb	r3,PACA_THREAD_IDLE_STATE(r13)
+	cmpwi	cr1,r3,PNV_THREAD_SLEEP
+	bge	cr1,2f
 	IDLE_STATE_ENTER_SEQ(PPC_NAP)
 	/* No return */
-2:	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
-	/* No return */
+2:
+	/* Sleep or winkle */
+	lbz	r7,PACA_THREAD_MASK(r13)
+	ld	r14,PACA_CORE_IDLE_STATE_PTR(r13)
+lwarx_loop1:
+	lwarx	r15,0,r14
+	andc	r15,r15,r7			/* Clear thread bit */
+
+	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
+
+/*
+ * If cr0 = 0, then current thread is the last thread of the core entering
+ * sleep. Last thread needs to execute the hardware bug workaround code if
+ * required by the platform.
+ * Make the workaround call unconditionally here. The below branch call is
+ * patched out when the idle states are discovered if the platform does not
+ * require it.
+ */
+.global pnv_fastsleep_workaround_at_entry
+pnv_fastsleep_workaround_at_entry:
+	beq	fastsleep_workaround_at_entry
+
+	stwcx.	r15,0,r14
+	bne-	lwarx_loop1
+	isync
+
+common_enter: /* common code for all the threads entering sleep */
+	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
+
+fastsleep_workaround_at_entry:
+	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
+	stwcx.	r15,0,r14
+	bne-	lwarx_loop1
+	isync
+
+	/* Fast sleep workaround */
+	li	r3,1
+	li	r4,1
+	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
+	bl	opal_call_realmode
+
+	/* Clear Lock bit */
+	li	r0,0
+	lwsync
+	stw	r0,0(r14)
+	b	common_enter
+
 
 _GLOBAL(power7_idle)
 	/* Now check if user or arch enabled NAP mode */
@@ -141,49 +187,16 @@ _GLOBAL(power7_idle)
 
 _GLOBAL(power7_nap)
 	mr	r4,r3
-	li	r3,0
+	li	r3,PNV_THREAD_NAP
 	b	power7_powersave_common
 	/* No return */
 
 _GLOBAL(power7_sleep)
-	li	r3,1
+	li	r3,PNV_THREAD_SLEEP
 	li	r4,1
 	b	power7_powersave_common
 	/* No return */
 
-/*
- * Make opal call in realmode. This is a generic function to be called
- * from realmode from reset vector. It handles endianess.
- *
- * r13 - paca pointer
- * r1  - stack pointer
- * r3  - opal token
- */
-opal_call_realmode:
-	mflr	r12
-	std	r12,_LINK(r1)
-	ld	r2,PACATOC(r13)
-	/* Set opal return address */
-	LOAD_REG_ADDR(r0,return_from_opal_call)
-	mtlr	r0
-	/* Handle endian-ness */
-	li	r0,MSR_LE
-	mfmsr	r12
-	andc	r12,r12,r0
-	mtspr	SPRN_HSRR1,r12
-	mr	r0,r3			/* Move opal token to r0 */
-	LOAD_REG_ADDR(r11,opal)
-	ld	r12,8(r11)
-	ld	r2,0(r11)
-	mtspr	SPRN_HSRR0,r12
-	hrfid
-
-return_from_opal_call:
-	FIXUP_ENDIAN
-	ld	r0,_LINK(r1)
-	mtlr	r0
-	blr
-
 #define CHECK_HMI_INTERRUPT						\
 	mfspr	r0,SPRN_SRR1;						\
 BEGIN_FTR_SECTION_NESTED(66);						\
@@ -197,7 +210,7 @@ ALT_FTR_SECTION_END_NESTED_IFSET(CPU_FTR_ARCH_207S, 66);		\
 	ld	r2,PACATOC(r13);					\
 	ld	r1,PACAR1(r13);						\
 	std	r3,ORIG_GPR3(r1);	/* Save original r3 */		\
-	li	r3,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
+	li	r0,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
 	bl	opal_call_realmode;					\
 	ld	r3,ORIG_GPR3(r1);	/* Restore original r3 */	\
 20:	nop;
@@ -206,16 +219,105 @@ ALT_FTR_SECTION_END_NESTED_IFSET(CPU_FTR_ARCH_207S, 66);		\
 _GLOBAL(power7_wakeup_tb_loss)
 	ld	r2,PACATOC(r13);
 	ld	r1,PACAR1(r13)
+	/*
+	 * Before entering any idle state, the NVGPRs are saved in the stack
+	 * and they are restored before switching to the process context. Hence
+	 * until they are restored, they are free to be used.
+	 *
+	 * Save SRR1 in a NVGPR as it might be clobbered in opal_call_realmode
+	 * (called in CHECK_HMI_INTERRUPT). SRR1 is required to determine the
+	 * wakeup reason if we branch to kvm_start_guest.
+	 */
 
+	mfspr	r16,SPRN_SRR1
 BEGIN_FTR_SECTION
 	CHECK_HMI_INTERRUPT
 END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
+
+	lbz	r7,PACA_THREAD_MASK(r13)
+	ld	r14,PACA_CORE_IDLE_STATE_PTR(r13)
+lwarx_loop2:
+	lwarx	r15,0,r14
+	andi.	r9,r15,PNV_CORE_IDLE_LOCK_BIT
+	/*
+	 * Lock bit is set in one of the 2 cases-
+	 * a. In the sleep/winkle enter path, the last thread is executing
+	 * fastsleep workaround code.
+	 * b. In the wake up path, another thread is executing fastsleep
+	 * workaround undo code or resyncing timebase or restoring context
+	 * In either case loop until the lock bit is cleared.
+	 */
+	bne	core_idle_lock_held
+
+	cmpwi	cr2,r15,0
+	or	r15,r15,r7		/* Set thread bit */
+
+	beq	cr2,first_thread
+
+	/* Not first thread in core to wake up */
+	stwcx.	r15,0,r14
+	bne-	lwarx_loop2
+	isync
+	b	common_exit
+
+core_idle_lock_held:
+	HMT_LOW
+core_idle_lock_loop:
+	lwz	r15,0(14)
+	andi.   r9,r15,PNV_CORE_IDLE_LOCK_BIT
+	bne	core_idle_lock_loop
+	HMT_MEDIUM
+	b	lwarx_loop2
+
+first_thread:
+	/* First thread in core to wakeup */
+	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
+	stwcx.	r15,0,r14
+	bne-	lwarx_loop2
+	isync
+
+	/*
+	 * First thread in the core waking up from fastsleep. It needs to
+	 * call the fastsleep workaround code if the platform requires it.
+	 * Call it unconditionally here. The below branch instruction will
+	 * be patched out when the idle states are discovered if platform
+	 * does not require workaround.
+	 */
+.global pnv_fastsleep_workaround_at_exit
+pnv_fastsleep_workaround_at_exit:
+	b	fastsleep_workaround_at_exit
+
+timebase_resync:
+	/* Do timebase resync if we are waking up from sleep. Use cr3 value
+	 * set in exceptions-64s.S */
+	ble	cr3,clear_lock
 	/* Time base re-sync */
-	li	r3,OPAL_RESYNC_TIMEBASE
+	li	r0,OPAL_RESYNC_TIMEBASE
 	bl	opal_call_realmode;
-
 	/* TODO: Check r3 for failure */
 
+clear_lock:
+	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
+	lwsync
+	stw	r15,0(r14)
+
+common_exit:
+	li	r5,PNV_THREAD_RUNNING
+	stb     r5,PACA_THREAD_IDLE_STATE(r13)
+
+	mtspr	SPRN_SRR1,r16
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	li      r0,KVM_HWTHREAD_IN_KERNEL
+	stb     r0,HSTATE_HWTHREAD_STATE(r13)
+	/* Order setting hwthread_state vs. testing hwthread_req */
+	sync
+	lbz     r0,HSTATE_HWTHREAD_REQ(r13)
+	cmpwi   r0,0
+	beq     6f
+	b       kvm_start_guest
+6:
+#endif
+
 	REST_NVGPRS(r1)
 	REST_GPR(2, r1)
 	ld	r3,_CCR(r1)
@@ -228,6 +330,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
 	mtspr	SPRN_SRR0,r5
 	rfid
 
+fastsleep_workaround_at_exit:
+	li	r3,1
+	li	r4,0
+	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
+	bl	opal_call_realmode
+	b	timebase_resync
+
 /*
  * R3 here contains the value that will be returned to the caller
  * of power7_nap.
diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
index feb549a..a0f43e8 100644
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -158,6 +158,43 @@ opal_tracepoint_return:
 	blr
 #endif
 
+/*
+ * Make opal call in realmode. This is a generic function to be called
+ * from realmode. It handles endianness.
+ *
+ * r13 - paca pointer
+ * r1  - stack pointer
+ * r0  - opal token
+ */
+_GLOBAL(opal_call_realmode)
+	mflr	r12
+	std	r12,PPC_LR_STKOFF(r1)
+	ld	r2,PACATOC(r13)
+	/* Set opal return address */
+	LOAD_REG_ADDR(r12,return_from_opal_call)
+	mtlr	r12
+
+	mfmsr	r12
+#ifdef __LITTLE_ENDIAN__
+	/* Handle endian-ness */
+	li	r11,MSR_LE
+	andc	r12,r12,r11
+#endif
+	mtspr	SPRN_HSRR1,r12
+	LOAD_REG_ADDR(r11,opal)
+	ld	r12,8(r11)
+	ld	r2,0(r11)
+	mtspr	SPRN_HSRR0,r12
+	hrfid
+
+return_from_opal_call:
+#ifdef __LITTLE_ENDIAN__
+	FIXUP_ENDIAN
+#endif
+	ld	r12,PPC_LR_STKOFF(r1)
+	mtlr	r12
+	blr
+
 OPAL_CALL(opal_invalid_call,			OPAL_INVALID_CALL);
 OPAL_CALL(opal_console_write,			OPAL_CONSOLE_WRITE);
 OPAL_CALL(opal_console_read,			OPAL_CONSOLE_READ);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 34c6665..585d0cd 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -36,6 +36,9 @@
 #include <asm/opal.h>
 #include <asm/kexec.h>
 #include <asm/smp.h>
+#include <asm/cputhreads.h>
+#include <asm/cpuidle.h>
+#include <asm/code-patching.h>
 
 #include "powernv.h"
 
@@ -292,10 +295,45 @@ static void __init pnv_setup_machdep_rtas(void)
 
 static u32 supported_cpuidle_states;
 
+static void pnv_alloc_idle_core_states(void)
+{
+	int i, j;
+	int nr_cores = cpu_nr_cores();
+	u32 *core_idle_state;
+
+	/*
+	 * core_idle_state - First 8 bits track the idle state of each thread
+	 * of the core. The 8th bit is the lock bit. Initially all thread bits
+	 * are set. They are cleared when the thread enters deep idle state
+	 * like sleep and winkle. Initially the lock bit is cleared.
+	 * The lock bit has 2 purposes
+	 * a. While the first thread is restoring core state, it prevents
+	 * other threads in the core from switching to process context.
+	 * b. While the last thread in the core is saving the core state, it
+	 * prevents a different thread from waking up.
+	 */
+	for (i = 0; i < nr_cores; i++) {
+		int first_cpu = i * threads_per_core;
+		int node = cpu_to_node(first_cpu);
+
+		core_idle_state = kmalloc_node(sizeof(u32), GFP_KERNEL, node);
+		*core_idle_state = PNV_CORE_IDLE_THREAD_BITS;
+
+		for (j = 0; j < threads_per_core; j++) {
+			int cpu = first_cpu + j;
+
+			paca[cpu].core_idle_state_ptr = core_idle_state;
+			paca[cpu].thread_idle_state = PNV_THREAD_RUNNING;
+			paca[cpu].thread_mask = 1 << j;
+		}
+	}
+}
+
 u32 pnv_get_supported_cpuidle_states(void)
 {
 	return supported_cpuidle_states;
 }
+EXPORT_SYMBOL_GPL(pnv_get_supported_cpuidle_states);
 
 static int __init pnv_init_idle_states(void)
 {
@@ -332,13 +370,20 @@ static int __init pnv_init_idle_states(void)
 		flags = be32_to_cpu(idle_state_flags[i]);
 		supported_cpuidle_states |= flags;
 	}
-
+	if (!(supported_cpuidle_states & OPAL_PM_SLEEP_ENABLED_ER1)) {
+		patch_instruction(
+			(unsigned int *)pnv_fastsleep_workaround_at_entry,
+			PPC_INST_NOP);
+		patch_instruction(
+			(unsigned int *)pnv_fastsleep_workaround_at_exit,
+			PPC_INST_NOP);
+	}
+	pnv_alloc_idle_core_states();
 	return 0;
 }
 
 subsys_initcall(pnv_init_idle_states);
 
-
 static int __init pnv_probe(void)
 {
 	unsigned long root = of_get_flat_dt_root();
diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 83299ef..c0691d0 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -168,7 +168,8 @@ static void pnv_smp_cpu_kill_self(void)
 	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
 	while (!generic_check_cpu_restart(cpu)) {
 		ppc64_runlatch_off();
-		if (idle_states & OPAL_PM_SLEEP_ENABLED)
+		if ((idle_states & OPAL_PM_SLEEP_ENABLED) ||
+				(idle_states & OPAL_PM_SLEEP_ENABLED_ER1))
 			srr1 = power7_sleep();
 		else
 			srr1 = power7_nap(1);
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 0a7d827..a489b56 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -208,7 +208,8 @@ static int powernv_add_idle_states(void)
 			nr_idle_states++;
 		}
 
-		if (flags & OPAL_PM_SLEEP_ENABLED) {
+		if (flags & OPAL_PM_SLEEP_ENABLED ||
+			flags & OPAL_PM_SLEEP_ENABLED_ER1) {
 			/* Add FASTSLEEP state */
 			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
 			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
-- 
1.9.3

