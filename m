Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaDXKHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:07:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbaDXIyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 088/182] KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n
Date: Thu, 24 Apr 2014 09:50:13 +0100
Message-Id: <1398329507-5911-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5648808..abdbd35 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -82,7 +82,7 @@ void kvmppc_fast_vcpu_kick(struct kvm_vcpu *vcpu)
 
 	/* CPU points to the first thread of the core */
 	if (cpu != me && cpu >= 0 && cpu < nr_cpu_ids) {
-#ifdef CONFIG_KVM_XICS
+#ifdef CONFIG_PPC_ICP_NATIVE
 		int real_cpu = cpu + vcpu->arch.ptid;
 		if (paca[real_cpu].kvm_hstate.xics_phys)
 			xics_wake_cpu(real_cpu);
@@ -1093,9 +1093,7 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu)
 	smp_wmb();
 #if defined(CONFIG_PPC_ICP_NATIVE) && defined(CONFIG_SMP)
 	if (vcpu->arch.ptid) {
-#ifdef CONFIG_KVM_XICS
 		xics_wake_cpu(cpu);
-#endif
 		++vc->n_woken;
 	}
 #endif
-- 
1.9.1

