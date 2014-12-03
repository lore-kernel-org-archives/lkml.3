Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaLCHvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:51:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:2631 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaLCHu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852582"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 24/25] KVM: Suppress posted-interrupt when 'SN' is set
Date: Wed,  3 Dec 2014 15:39:53 +0800
Message-Id: <1417592394-24343-25-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we don't support urgent interrupt, all interrupts
are recognized as non-urgent interrupt, so we cannot send
posted-interrupt when 'SN' is set.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index dc6fd84..6b2f3e7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4306,15 +4306,22 @@ static int vmx_vm_has_apicv(struct kvm *kvm)
 static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	int r;
+	int r, sn;
 
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
 		return;
 
+	/*
+	 * Currently, we don't support urgent interrupt, all interrupts
+	 * are recognized as non-urgent interrupt, so we cannot send
+	 * posted-interrupt when 'SN' is set.
+	 */
+	sn = pi_test_sn(&vmx->pi_desc);
+
 	r = pi_test_and_set_on(&vmx->pi_desc);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 #ifdef CONFIG_SMP
-	if (!r && (vcpu->mode == IN_GUEST_MODE))
+	if (!r && !sn && (vcpu->mode == IN_GUEST_MODE))
 		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
 				POSTED_INTR_VECTOR);
 	else
-- 
1.7.1

