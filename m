Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaJAHqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:46:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39260 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaJAHqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:46:48 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH v2 2/3] powerpc/kvm/book3s_hv: Enable CPUs to run guest after waking up from fast-sleep
Date: Wed,  1 Oct 2014 13:15:59 +0530
Message-Id: <1412149560-2953-3-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412149560-2953-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149560-2953-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-7182-0000-0000-00000098588E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When guests have to be launched, the secondary threads which are offline
are woken up to run the guests. Today these threads wake up from nap
and check if they have to run guests. Now that the offline secondary
threads can go to fastsleep or going ahead a deeper idle state such as winkle,
add this check in the wakeup from any of the deep idle states path as well.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Suggested-by: "Srivatsa S. Bhat" <srivatsa@mit.edu>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
[ Changelog added by <preeti@linux.vnet.ibm.com> ]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 050f79a..c64f3cc0 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -100,25 +100,8 @@ system_reset_pSeries:
 	SET_SCRATCH0(r13)
 #ifdef CONFIG_PPC_P7_NAP
 BEGIN_FTR_SECTION
-	/* Running native on arch 2.06 or later, check if we are
-	 * waking up from nap. We only handle no state loss and
-	 * supervisor state loss. We do -not- handle hypervisor
-	 * state loss at this time.
-	 */
-	mfspr	r13,SPRN_SRR1
-	rlwinm.	r13,r13,47-31,30,31
-	beq	9f
 
-	/* waking up from powersave (nap) state */
-	cmpwi	cr1,r13,2
-	/* Total loss of HV state is fatal, we could try to use the
-	 * PIR to locate a PACA, then use an emergency stack etc...
-	 * OPAL v3 based powernv platforms have new idle states
-	 * which fall in this catagory.
-	 */
-	bgt	cr1,8f
 	GET_PACA(r13)
-
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	li	r0,KVM_HWTHREAD_IN_KERNEL
 	stb	r0,HSTATE_HWTHREAD_STATE(r13)
@@ -131,13 +114,27 @@ BEGIN_FTR_SECTION
 1:
 #endif
 
+	/* Running native on arch 2.06 or later, check if we are
+	 * waking up from nap. We only handle no state loss and
+	 * supervisor state loss. We do -not- handle hypervisor
+	 * state loss at this time.
+	 */
+	mfspr	r13,SPRN_SRR1
+	rlwinm.	r13,r13,47-31,30,31
+	beq	9f
+
+	/* waking up from powersave (nap) state */
+	cmpwi	cr1,r13,2
+	GET_PACA(r13)
+
+	bgt	cr1,8f
+
 	beq	cr1,2f
 	b	power7_wakeup_noloss
 2:	b	power7_wakeup_loss
 
 	/* Fast Sleep wakeup on PowerNV */
-8:	GET_PACA(r13)
-	b 	power7_wakeup_tb_loss
+8:	b 	power7_wakeup_tb_loss
 
 9:
 END_FTR_SECTION_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
-- 
1.9.3

