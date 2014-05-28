Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaE1En5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:43:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38583 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbaE1Eny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:43:54 -0400
Subject: [PATCH 4/6] KVM: PPC: Book3S HV: Consolidate the idle-state enter
 sequence in KVM
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        svaidyan@in.ibm.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 10:09:12 +0530
Message-ID: <20140528043912.15676.7002.stgit@preeti.in.ibm.com>
In-Reply-To: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
References: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052804-0320-0000-0000-00000363EC5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Now that the support for fast sleep idle state is present, the KVM
standby threads can be put to fast sleep when they are either idle
or do not have a guest to run. Today they enter nap in these scenarios.
The purpose is to gain maximum power savings in a KVM scenario as well
when an entire cpu core is idle.

As a precursor, consolidate the code common across all idle states.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[ Changelog added by <preeti@linux.vnet.ibm.com> ]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index b031f93..43aa806 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -40,6 +40,17 @@
 #define NAPPING_CEDE	1
 #define NAPPING_NOVCPU	2
 
+#define IDLE_STATE_ENTER_SEQ_HV(IDLE_INST)			\
+	/* Magic NAP/SLEEP/WINKLE mode enter sequence */	\
+	std	r0, HSTATE_SCRATCH0(r13);			\
+	ptesync;						\
+	ld	r0, HSTATE_SCRATCH0(r13);			\
+1:	cmpd	r0, r0;						\
+	bne	1b;						\
+	IDLE_INST;						\
+	b	.
+
+
 /*
  * Call kvmppc_hv_entry in real mode.
  * Must be called with interrupts hard-disabled.
@@ -325,13 +336,9 @@ kvm_do_nap:
 	rlwimi	r4, r3, 0, LPCR_PECE0 | LPCR_PECE1
 	mtspr	SPRN_LPCR, r4
 	isync
-	std	r0, HSTATE_SCRATCH0(r13)
-	ptesync
-	ld	r0, HSTATE_SCRATCH0(r13)
-1:	cmpd	r0, r0
-	bne	1b
-	nap
-	b	.
+	IDLE_STATE_ENTER_SEQ_HV(PPC_NAP)
+	/* No return */
+
 
 /******************************************************************************
  *                                                                            *
@@ -2027,13 +2034,8 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	mtspr	SPRN_LPCR,r5
 	isync
 	li	r0, 0
-	std	r0, HSTATE_SCRATCH0(r13)
-	ptesync
-	ld	r0, HSTATE_SCRATCH0(r13)
-1:	cmpd	r0, r0
-	bne	1b
-	nap
-	b	.
+	IDLE_STATE_ENTER_SEQ_HV(PPC_NAP)
+	/* No return */
 
 33:	mr	r4, r3
 	li	r3, 0

