Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbaHZL3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:29:00 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35073 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaHZL27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:28:59 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] KVM: x86: fix some sparse warnings
Date: Tue, 26 Aug 2014 13:28:52 +0200
Message-Id: <1409052532-18008-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse reports the following easily fixed warnings:

   arch/x86/kvm/vmx.c:8795:48: sparse: Using plain integer as NULL pointer
   arch/x86/kvm/vmx.c:2138:5: sparse: symbol vmx_read_l1_tsc was not declared. Should it be static?
   arch/x86/kvm/vmx.c:6151:48: sparse: Using plain integer as NULL pointer
   arch/x86/kvm/vmx.c:8851:6: sparse: symbol vmx_sched_in was not declared. Should it be static?

   arch/x86/kvm/svm.c:2162:5: sparse: symbol svm_read_l1_tsc was not declared. Should it be static?

Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c |  2 +-
 arch/x86/kvm/vmx.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1703aab84a6d..7cd230e55118 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3031,7 +3031,7 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	return 0;
 }
 
-u64 svm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
+static u64 svm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
 	struct vmcb *vmcb = get_host_vmcb(to_svm(vcpu));
 	return vmcb->control.tsc_offset +
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 73ba2a265f85..d70550d0bcff 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2159,7 +2159,7 @@ static u64 guest_read_tsc(void)
  * Like guest_read_tsc, but always returns L1's notion of the timestamp
  * counter, even if a nested guest (L2) is currently running.
  */
-u64 vmx_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
+static u64 vmx_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
 	u64 tsc_offset;
 
@@ -6246,11 +6246,11 @@ static void free_nested(struct vcpu_vmx *vmx)
 	/* Unpin physical memory we referred to in current vmcs02 */
 	if (vmx->nested.apic_access_page) {
 		nested_release_page(vmx->nested.apic_access_page);
-		vmx->nested.apic_access_page = 0;
+		vmx->nested.apic_access_page = NULL;
 	}
 	if (vmx->nested.virtual_apic_page) {
 		nested_release_page(vmx->nested.virtual_apic_page);
-		vmx->nested.virtual_apic_page = 0;
+		vmx->nested.virtual_apic_page = NULL;
 	}
 
 	nested_free_all_saved_vmcss(vmx);
@@ -8950,11 +8950,11 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	/* Unpin physical memory we referred to in vmcs02 */
 	if (vmx->nested.apic_access_page) {
 		nested_release_page(vmx->nested.apic_access_page);
-		vmx->nested.apic_access_page = 0;
+		vmx->nested.apic_access_page = NULL;
 	}
 	if (vmx->nested.virtual_apic_page) {
 		nested_release_page(vmx->nested.virtual_apic_page);
-		vmx->nested.virtual_apic_page = 0;
+		vmx->nested.virtual_apic_page = NULL;
 	}
 
 	/*
@@ -9010,7 +9010,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	return X86EMUL_CONTINUE;
 }
 
-void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
+static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	if (ple_gap)
 		shrink_ple_window(vcpu);
-- 
1.8.3.1

