Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbaF3MOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:14:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51997 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Paul Mackerras <paulus@samba.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 083/181] KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n
Date: Mon, 30 Jun 2014 13:51:44 +0200
Message-Id: <d271551a64f0cdbd5d0aa0a08a35697509455e03.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7505258c5fcb0a1cc3c76a47b4cf9506d21d10e6 upstream.

I noticed KVM is broken when KVM in-kernel XICS emulation
(CONFIG_KVM_XICS) is disabled.

The problem was introduced in 48eaef05 (KVM: PPC: Book3S HV: use
xics_wake_cpu only when defined). It used CONFIG_KVM_XICS to wrap
xics_wake_cpu, where CONFIG_PPC_ICP_NATIVE should have been
used.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: stable@vger.kernel.org
Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/kvm/book3s_hv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e1ab62e0d548..211974a386d6 100644
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
@@ -1092,9 +1092,7 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu)
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
2.0.0

