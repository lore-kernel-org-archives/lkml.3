Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaBGMNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:13:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42272 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaBGLvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Schwab <schwab@linux-m68k.org>, Alexander Graf <agraf@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 179/233] KVM: PPC: Book3S HV: use xics_wake_cpu only when defined
Date: Fri,  7 Feb 2014 11:46:38 +0000
Message-Id: <1391773652-25214-180-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 48eaef0518a565d3852e301c860e1af6a6db5a84 upstream.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7629cd3..5648808 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -82,10 +82,13 @@ void kvmppc_fast_vcpu_kick(struct kvm_vcpu *vcpu)
 
 	/* CPU points to the first thread of the core */
 	if (cpu != me && cpu >= 0 && cpu < nr_cpu_ids) {
+#ifdef CONFIG_KVM_XICS
 		int real_cpu = cpu + vcpu->arch.ptid;
 		if (paca[real_cpu].kvm_hstate.xics_phys)
 			xics_wake_cpu(real_cpu);
-		else if (cpu_online(cpu))
+		else
+#endif
+		if (cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
 	put_cpu();
@@ -1090,7 +1093,9 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu)
 	smp_wmb();
 #if defined(CONFIG_PPC_ICP_NATIVE) && defined(CONFIG_SMP)
 	if (vcpu->arch.ptid) {
+#ifdef CONFIG_KVM_XICS
 		xics_wake_cpu(cpu);
+#endif
 		++vc->n_woken;
 	}
 #endif
-- 
1.8.3.2

