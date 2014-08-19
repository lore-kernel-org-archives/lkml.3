Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaHSUhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbaHSUhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:37:34 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: [PATCH 3/9] KVM: VMX: make PLE window per-vcpu
Date: Tue, 19 Aug 2014 22:35:30 +0200
Message-Id: <1408480536-8240-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change PLE window into per-vcpu variable, seeded from module parameter,
to allow greater flexibility.

Brings in a small overhead on every vmentry.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 I've been thinking about a general hierarchical per-vcpu variable model,
 but it's hard to have current performance and sane code.

 arch/x86/kvm/vmx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2b306f9..eaa5574 100644
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
@@ -4403,6 +4406,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	if (ple_gap) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmcs_write32(PLE_WINDOW, ple_window);
+		vmx->ple_window = ple_window;
 	}
 
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
@@ -7387,6 +7391,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
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

