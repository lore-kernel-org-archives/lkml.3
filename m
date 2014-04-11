Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbaDKKgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:36:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47571 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbaDKKgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:36:05 -0400
Subject: [PATCH 2/3] ppc/kvm: Set the runlatch bit of a CPU just before
 starting guest
To: linuxppc-dev@ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 11 Apr 2014 16:01:58 +0530
Message-ID: <20140411103157.27683.79563.stgit@preeti.in.ibm.com>
In-Reply-To: <20140411103030.27683.2107.stgit@preeti.in.ibm.com>
References: <20140411103030.27683.2107.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041110-7182-0000-0000-00000A4DB42C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The secondary threads in the core are kept offline before launching guests
in kvm on powerpc: "371fefd6f2dc4666:KVM: PPC: Allow book3s_hv guests to use
SMT processor modes."

Hence their runlatch bits are cleared. When the secondary threads are called
in to start a guest, their runlatch bits need to be set to indicate that they
are busy. The primary thread has its runlatch bit set though, but there is no
harm in setting this bit once again. Hence set the runlatch bit for all
threads before they start guest.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index ffbb871..b254075 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -242,6 +242,12 @@ kvm_novcpu_exit:
  */
 	.globl	kvm_start_guest
 kvm_start_guest:
+
+	/* Set runlatch bit the minute you wake up from nap */
+	mfspr	r1, SPRN_CTRLF
+	ori 	r1, r1, 1
+	mtspr	SPRN_CTRLT, r1
+
 	ld	r2,PACATOC(r13)
 
 	li	r0,KVM_HWTHREAD_IN_KVM

