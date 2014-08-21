Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaHUQLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbaHUQKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:10:53 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: [PATCH v3 7/7] KVM: VMX: optimize ple_window updates to VMCS
Date: Thu, 21 Aug 2014 18:08:11 +0200
Message-Id: <1408637291-18533-8-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ple_window is preserved in VMCS, so can write it only after a change.
Do this by keeping a dirty bit.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/vmx.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1318232..f32415b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -510,6 +510,7 @@ struct vcpu_vmx {
 
 	/* Dynamic PLE window. */
 	int ple_window;
+	bool ple_window_dirty;
 };
 
 enum segment_cache_field {
@@ -4426,6 +4427,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 	}
 
+	vmx->ple_window_dirty = ple_gap;
 	if (ple_gap) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmx->ple_window = ple_window;
@@ -5741,6 +5743,9 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 		vmx->ple_window = __grow_ple_window(old);
 	} while (read_seqretry(&ple_window_seqlock, seq));
 
+	if (vmx->ple_window != old)
+		vmx->ple_window_dirty = true;
+
 	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
 }
 
@@ -5756,6 +5761,9 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 		                                      ple_window);
 	} while (read_seqretry(&ple_window_seqlock, seq));
 
+	if (vmx->ple_window != old)
+		vmx->ple_window_dirty = true;
+
 	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
 }
 
@@ -7505,8 +7513,10 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required)
 		return;
 
-	if (ple_gap)
+	if (vmx->ple_window_dirty) {
+		vmx->ple_window_dirty = false;
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
+	}
 
 	if (vmx->nested.sync_shadow_vmcs) {
 		copy_vmcs12_to_shadow(vmx);
-- 
2.1.0

