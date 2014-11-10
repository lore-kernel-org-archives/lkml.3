Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKJGit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:38:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:54503 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaKJGgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364155"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 11/13] KVM: Suppress posted-interrupt when 'SN' is set
Date: Mon, 10 Nov 2014 14:26:50 +0800
Message-Id: <1415600812-27773-12-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
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
index 51d2c8a..495cfbd 100644
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

