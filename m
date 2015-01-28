Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbbA2JBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:07 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752923AbbA2JBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/176] powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle mode
Date: Wed, 28 Jan 2015 15:27:23 +0100
Message-Id: <02b586bfc1eb8a7a6153c684f1b52a4db15a49c2.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8117ac6a6c2fa0f847ff6a21a1f32c8d2c8501d0 upstream.

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
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/include/asm/reg.h    |  1 +
 arch/powerpc/kernel/idle_power7.S | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index cb9c1740cee0..390e09872b77 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -116,6 +116,7 @@
 
 /* Server variant */
 #define MSR_		(MSR_ME | MSR_RI | MSR_IR | MSR_DR | MSR_ISF |MSR_HV)
+#define MSR_IDLE	(MSR_ME | MSR_SF | MSR_HV)
 #define MSR_KERNEL	(MSR_ | MSR_64BIT)
 #define MSR_USER32	(MSR_ | MSR_PR | MSR_EE)
 #define MSR_USER64	(MSR_USER32 | MSR_64BIT)
diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index e11863f4e595..df930727f73b 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -84,6 +84,22 @@ _GLOBAL(power7_nap)
 	std	r9,_MSR(r1)
 	std	r1,PACAR1(r13)
 
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
+power7_enter_nap_mode:
 #ifdef CONFIG_KVM_BOOK3S_64_HV
 	/* Tell KVM we're napping */
 	li	r4,KVM_HWTHREAD_IN_NAP
-- 
2.2.2

