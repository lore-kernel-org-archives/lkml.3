Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaHTUyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaHTUyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:54:13 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 3/6] KVM: VMX: make PLE window per-VCPU
Date: Wed, 20 Aug 2014 22:53:14 +0200
Message-Id: <1408567997-21222-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change PLE window into per-VCPU variable, seeded from module parameter,
to allow greater flexibility.

Brings in a small overhead on every vmentry.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/vmx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2b306f9..18e0e52 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -484,6 +484,9 @@ struct vcpu_vmx {
 
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
+
+	/* Dynamic PLE window. */
+	int ple_window;
 };
 
 enum segment_cache_field {
@@ -4402,7 +4405,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	if (ple_gap) {
 		vmcs_write32(PLE_GAP, ple_gap);
-		vmcs_write32(PLE_WINDOW, ple_window);
+		vmx->ple_window = ple_window;
 	}
 
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
@@ -7387,6 +7390,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required)
 		return;
 
+	if (ple_gap)
+		vmcs_write32(PLE_WINDOW, vmx->ple_window);
+
 	if (vmx->nested.sync_shadow_vmcs) {
 		copy_vmcs12_to_shadow(vmx);
 		vmx->nested.sync_shadow_vmcs = false;
-- 
2.0.4

