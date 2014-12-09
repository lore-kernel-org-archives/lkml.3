Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaLIS5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:57:18 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33809 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaLIS5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:57:17 -0500
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 1/4] powerpc: powernv: Switch off MMU before entering nap/sleep/rvwinkle mode
Date: Wed, 10 Dec 2014 00:26:50 +0530
Message-Id: <1418151413-6141-2-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418151413-6141-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1418151413-6141-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120918-0033-0000-0000-00000145CA18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

Currently, when going idle, we set the flag indicating that we are in
nap mode (paca->kvm_hstate.hwthread_state) and then execute the nap
(or sleep or rvwinkle) instruction, all with the MMU on.  This is bad
for two reasons: (a) the architecture specifies that those instructions
must be executed with the MMU off, and in fact with only the SF, HV, ME
and possibly RI bits set, and (b) this introduces a race, because as
soon as we set the flag, another thread can switch the MMU to a guest
context.  If the race is lost, this thread will typically start looping
on relocation-on ISIs at 0xc...4400.

This fixes it by setting the MSR as required by the architecture before
setting the flag or executing the nap/sleep/rvwinkle instruction.

[ shreyas@linux.vnet.ibm.com: Edited to handle LE ]
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/reg.h    |  2 ++
 arch/powerpc/kernel/idle_power7.S | 18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index c998279..a68ee15 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -118,8 +118,10 @@
 #define __MSR		(MSR_ME | MSR_RI | MSR_IR | MSR_DR | MSR_ISF |MSR_HV)
 #ifdef __BIG_ENDIAN__
 #define MSR_		__MSR
+#define MSR_IDLE	(MSR_ME | MSR_SF | MSR_HV)
 #else
 #define MSR_		(__MSR | MSR_LE)
+#define MSR_IDLE	(MSR_ME | MSR_SF | MSR_HV | MSR_LE)
 #endif
 #define MSR_KERNEL	(MSR_ | MSR_64BIT)
 #define MSR_USER32	(MSR_ | MSR_PR | MSR_EE)
diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index 18c0687..e5aba6a 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -101,7 +101,23 @@ _GLOBAL(power7_powersave_common)
 	std	r9,_MSR(r1)
 	std	r1,PACAR1(r13)
 
-_GLOBAL(power7_enter_nap_mode)
+	/*
+	 * Go to real mode to do the nap, as required by the architecture.
+	 * Also, we need to be in real mode before setting hwthread_state,
+	 * because as soon as we do that, another thread can switch
+	 * the MMU context to the guest.
+	 */
+	LOAD_REG_IMMEDIATE(r5, MSR_IDLE)
+	li	r6, MSR_RI
+	andc	r6, r9, r6
+	LOAD_REG_ADDR(r7, power7_enter_nap_mode)
+	mtmsrd	r6, 1		/* clear RI before setting SRR0/1 */
+	mtspr	SPRN_SRR0, r7
+	mtspr	SPRN_SRR1, r5
+	rfid
+
+	.globl	power7_enter_nap_mode
+power7_enter_nap_mode:
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	/* Tell KVM we're napping */
 	li	r4,KVM_HWTHREAD_IN_NAP
-- 
1.9.3

