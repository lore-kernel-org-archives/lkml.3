Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987AbaBDWCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:02:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934157AbaBDVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>, Alexander Graf <agraf@suse.de>
Subject: [PATCH 3.12 119/133] KVM: PPC: Book3S HV: use xics_wake_cpu only when defined
Date: Tue,  4 Feb 2014 13:08:40 -0800
Message-Id: <20140204210740.391615581@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 48eaef0518a565d3852e301c860e1af6a6db5a84 upstream.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -82,10 +82,13 @@ void kvmppc_fast_vcpu_kick(struct kvm_vc
 
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
@@ -1089,7 +1092,9 @@ static void kvmppc_start_thread(struct k
 	smp_wmb();
 #if defined(CONFIG_PPC_ICP_NATIVE) && defined(CONFIG_SMP)
 	if (vcpu->arch.ptid) {
+#ifdef CONFIG_KVM_XICS
 		xics_wake_cpu(cpu);
+#endif
 		++vc->n_woken;
 	}
 #endif


