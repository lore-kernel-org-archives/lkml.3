Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaEKTVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:21:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbaEKTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        Scott Wood <scottwood@freescale.com>
Subject: [PATCH 3.14 12/83] KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n
Date: Sun, 11 May 2014 21:19:13 +0200
Message-Id: <20140511191908.745932527@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 7505258c5fcb0a1cc3c76a47b4cf9506d21d10e6 upstream.

I noticed KVM is broken when KVM in-kernel XICS emulation
(CONFIG_KVM_XICS) is disabled.

The problem was introduced in 48eaef05 (KVM: PPC: Book3S HV: use
xics_wake_cpu only when defined). It used CONFIG_KVM_XICS to wrap
xics_wake_cpu, where CONFIG_PPC_ICP_NATIVE should have been
used.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -86,7 +86,7 @@ static void kvmppc_fast_vcpu_kick_hv(str
 
 	/* CPU points to the first thread of the core */
 	if (cpu != me && cpu >= 0 && cpu < nr_cpu_ids) {
-#ifdef CONFIG_KVM_XICS
+#ifdef CONFIG_PPC_ICP_NATIVE
 		int real_cpu = cpu + vcpu->arch.ptid;
 		if (paca[real_cpu].kvm_hstate.xics_phys)
 			xics_wake_cpu(real_cpu);
@@ -1360,9 +1360,7 @@ static void kvmppc_start_thread(struct k
 	smp_wmb();
 #if defined(CONFIG_PPC_ICP_NATIVE) && defined(CONFIG_SMP)
 	if (cpu != smp_processor_id()) {
-#ifdef CONFIG_KVM_XICS
 		xics_wake_cpu(cpu);
-#endif
 		if (vcpu->arch.ptid)
 			++vc->n_woken;
 	}


