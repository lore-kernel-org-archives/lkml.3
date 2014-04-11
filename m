Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbaDKKgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:36:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42255 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbaDKKgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:36:15 -0400
Subject: [PATCH 3/3] ppc/kvm: Clear the runlatch bit of a vcpu before napping
To: linuxppc-dev@ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 11 Apr 2014 16:02:08 +0530
Message-ID: <20140411103207.27683.87113.stgit@preeti.in.ibm.com>
In-Reply-To: <20140411103030.27683.2107.stgit@preeti.in.ibm.com>
References: <20140411103030.27683.2107.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041110-5806-0000-0000-000024998B40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the guest cedes the vcpu or the vcpu has no guest to
run it naps. Clear the runlatch bit of the vcpu before
napping to indicate an idle cpu.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index b254075..b031f93 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -315,6 +315,11 @@ kvm_no_guest:
 	li	r0, KVM_HWTHREAD_IN_NAP
 	stb	r0, HSTATE_HWTHREAD_STATE(r13)
 kvm_do_nap:
+	/* Clear the runlatch bit before napping */
+	mfspr	r2, SPRN_CTRLF
+	clrrdi	r2, r2, 1
+	mtspr	SPRN_CTRLT, r2
+
 	li	r3, LPCR_PECE0
 	mfspr	r4, SPRN_LPCR
 	rlwimi	r4, r3, 0, LPCR_PECE0 | LPCR_PECE1
@@ -2005,8 +2010,13 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_206)
 
 	/*
 	 * Take a nap until a decrementer or external or doobell interrupt
-	 * occurs, with PECE1, PECE0 and PECEDP set in LPCR
+	 * occurs, with PECE1, PECE0 and PECEDP set in LPCR. Also clear the
+	 * runlatch bit before napping.
 	 */
+	mfspr	r2, SPRN_CTRLF
+	clrrdi	r2, r2, 1
+	mtspr	SPRN_CTRLT, r2
+
 	li	r0,1
 	stb	r0,HSTATE_HWTHREAD_REQ(r13)
 	mfspr	r5,SPRN_LPCR

