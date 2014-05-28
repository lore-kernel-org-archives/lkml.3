Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaE1EoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:44:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48852 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaE1EoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:44:04 -0400
Subject: [PATCH 5/6] KVM: PPC: Book3S HV: Put KVM standby hwthreads to
 fast-sleep instead of nap
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        svaidyan@in.ibm.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 10:09:31 +0530
Message-ID: <20140528043931.15676.74455.stgit@preeti.in.ibm.com>
In-Reply-To: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
References: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052804-1344-0000-0000-000001D646BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Now that the support for fast sleep idle state is present, allow
the KVM standby threads to go to fast sleep if the platform supports
it.This will fetch us maximum power savings if an entire core is idle.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[ Changelog added by <preeti@linux.vnet.ibm.com> ]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   73 ++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 43aa806..69244cc 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -207,7 +207,7 @@ kvmppc_primary_no_guest:
 	li	r3, 1
 	stb	r3, HSTATE_HWTHREAD_REQ(r13)
 
-	b	kvm_do_nap
+	b	kvm_do_idle
 
 kvm_novcpu_wakeup:
 	ld	r1, HSTATE_HOST_R1(r13)
@@ -247,7 +247,7 @@ kvm_novcpu_exit:
 	b	hdec_soon
 
 /*
- * We come in here when wakened from nap mode.
+ * We come in here when wakened from nap or fast-sleep mode.
  * Relocation is off and most register values are lost.
  * r13 points to the PACA.
  */
@@ -303,7 +303,7 @@ kvm_start_guest:
 
 	bl	kvmppc_hv_entry
 
-	/* Back from the guest, go back to nap */
+	/* Back from the guest, go back to nap or fastsleep */
 	/* Clear our vcpu pointer so we don't come back in early */
 	li	r0, 0
 	std	r0, HSTATE_KVM_VCPU(r13)
@@ -314,7 +314,7 @@ kvm_start_guest:
 	 */
 	lwsync
 
-	/* increment the nap count and then go to nap mode */
+	/* increment the nap count and then go to nap or fast-sleep mode */
 	ld	r4, HSTATE_KVM_VCORE(r13)
 	addi	r4, r4, VCORE_NAP_COUNT
 51:	lwarx	r3, 0, r4
@@ -325,6 +325,24 @@ kvm_start_guest:
 kvm_no_guest:
 	li	r0, KVM_HWTHREAD_IN_NAP
 	stb	r0, HSTATE_HWTHREAD_STATE(r13)
+
+kvm_do_idle:
+	/*
+	 * if (supported_cpuidle_states & IDLE_USE_SLEEP)
+	 * 		kvm_do_fastsleep();
+	 * else
+	 *		kvm_do_nap();
+	 */
+	LOAD_REG_ADDRBASE(r3,supported_cpuidle_states)
+	lwz     r4,ADDROFF(supported_cpuidle_states)(r3)
+	/*
+	 * andi. r4,r4,IDLE_USE_SLEEP. Replacing IDLE_USE_SLEEP
+	 * with the immediate value since it is a 32 bit instruction
+	 * and the operand needs to fit into this.
+	 */
+	andi.	r4,r4,2
+	bne	kvm_do_fastsleep
+
 kvm_do_nap:
 	/* Clear the runlatch bit before napping */
 	mfspr	r2, SPRN_CTRLF
@@ -339,6 +357,18 @@ kvm_do_nap:
 	IDLE_STATE_ENTER_SEQ_HV(PPC_NAP)
 	/* No return */
 
+kvm_do_fastsleep:
+	li	r3, LPCR_PECE0
+	mfspr	r4, SPRN_LPCR
+	/* Don't set LPCR_PECE1 since we want to wakeup only on an external
+	 * interrupt, and not on a decrementer interrupt.
+	 */
+	rlwimi	r4, r3, 0, LPCR_PECE0
+	mtspr	SPRN_LPCR, r4
+	isync
+	IDLE_STATE_ENTER_SEQ_HV(PPC_SLEEP)
+	/* No return */
+
 
 /******************************************************************************
  *                                                                            *
@@ -2016,8 +2046,8 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_206)
 	bl	kvmppc_save_fp
 
 	/*
-	 * Take a nap until a decrementer or external or doobell interrupt
-	 * occurs, with PECE1, PECE0 and PECEDP set in LPCR. Also clear the
+	 * Go to fastsleep until an external or doobell interrupt
+	 * occurs, with PECE0 and PECEDP set in LPCR. Also clear the
 	 * runlatch bit before napping.
 	 */
 	mfspr	r2, SPRN_CTRLF
@@ -2026,6 +2056,22 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_206)
 
 	li	r0,1
 	stb	r0,HSTATE_HWTHREAD_REQ(r13)
+	/*
+        * if (supported_cpuidle_states & IDLE_USE_SLEEP)
+        *              PPC_SLEEP;
+        * else
+        *              PPC_NAP;
+        */
+       	LOAD_REG_ADDRBASE(r3,supported_cpuidle_states)
+       	lwz     r4,ADDROFF(supported_cpuidle_states)(r3)
+	/*
+	 * andi. r4,r4,IDLE_USE_SLEEP. Replacing IDLE_USE_SLEEP
+	 * with the immediate value since it is a 32 bit instruction
+	 * and the operand needs to fit into this.
+	 */
+       	andi.   r4,r4,2
+       	bne     35f
+
 	mfspr	r5,SPRN_LPCR
 	ori	r5,r5,LPCR_PECE0 | LPCR_PECE1
 BEGIN_FTR_SECTION
@@ -2037,6 +2083,17 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	IDLE_STATE_ENTER_SEQ_HV(PPC_NAP)
 	/* No return */
 
+35:	mfspr	r5,SPRN_LPCR
+	ori	r5,r5,LPCR_PECE0
+BEGIN_FTR_SECTION
+	oris	r5,r5,LPCR_PECEDP@h
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
+	mtspr	SPRN_LPCR,r5
+	isync
+	li	r0, 0
+	IDLE_STATE_ENTER_SEQ_HV(PPC_SLEEP)
+	/* No return */
+
 33:	mr	r4, r3
 	li	r3, 0
 	li	r12, 0
@@ -2046,7 +2103,7 @@ kvm_end_cede:
 	/* get vcpu pointer */
 	ld	r4, HSTATE_KVM_VCPU(r13)
 
-	/* Woken by external or decrementer interrupt */
+	/* Woken by external */
 	ld	r1, HSTATE_HOST_R1(r13)
 
 	/* load up FP state */
@@ -2129,7 +2186,7 @@ machine_check_realmode:
 	b	fast_interrupt_c_return
 
 /*
- * Check the reason we woke from nap, and take appropriate action.
+ * Check the reason we woke from nap or fastsleep, and take appropriate action.
  * Returns:
  *	0 if nothing needs to be done
  *	1 if something happened that needs to be handled by the host

