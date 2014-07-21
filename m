Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbaGUMdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:33:39 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37184 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaGUMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:33:37 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, wanpeng.li@linux.intel.com, kvm@vger.kernel.org,
        jan.kiszka@siemens.com, mtosatti@redhat.com
Subject: [PATCH 2/2] KVM: nVMX: clean up nested_release_vmcs12 and code around it
Date: Mon, 21 Jul 2014 14:33:25 +0200
Message-Id: <1405946005-4228-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405946005-4228-1-git-send-email-pbonzini@redhat.com>
References: <1405946005-4228-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make nested_release_vmcs12 idempotent.

Tested-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 462334eaa3c0..3300f4f2da48 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6109,20 +6109,27 @@ static int nested_vmx_check_permission(struct kvm_vcpu *vcpu)
 static inline void nested_release_vmcs12(struct vcpu_vmx *vmx)
 {
 	u32 exec_control;
+	if (vmx->nested.current_vmptr == -1ull)
+		return;
+
+	/* current_vmptr and current_vmcs12 are always set/reset together */
+	if (WARN_ON(vmx->nested.current_vmcs12 == NULL))
+		return;
+
 	if (enable_shadow_vmcs) {
-		if (vmx->nested.current_vmcs12 != NULL) {
-			/* copy to memory all shadowed fields in case
-			   they were modified */
-			copy_shadow_to_vmcs12(vmx);
-			vmx->nested.sync_shadow_vmcs = false;
-			exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
-			exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
-			vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
-			vmcs_write64(VMCS_LINK_POINTER, -1ull);
-		}
+		/* copy to memory all shadowed fields in case
+		   they were modified */
+		copy_shadow_to_vmcs12(vmx);
+		vmx->nested.sync_shadow_vmcs = false;
+		exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
+		exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
+		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
+		vmcs_write64(VMCS_LINK_POINTER, -1ull);
 	}
 	kunmap(vmx->nested.current_vmcs12_page);
 	nested_release_page(vmx->nested.current_vmcs12_page);
+	vmx->nested.current_vmptr = -1ull;
+	vmx->nested.current_vmcs12 = NULL;
 }
 
 /*
@@ -6133,12 +6140,9 @@ static void free_nested(struct vcpu_vmx *vmx)
 {
 	if (!vmx->nested.vmxon)
 		return;
+
 	vmx->nested.vmxon = false;
-	if (vmx->nested.current_vmptr != -1ull) {
-		nested_release_vmcs12(vmx);
-		vmx->nested.current_vmptr = -1ull;
-		vmx->nested.current_vmcs12 = NULL;
-	}
+	nested_release_vmcs12(vmx);
 	if (enable_shadow_vmcs)
 		free_vmcs(vmx->nested.current_shadow_vmcs);
 	/* Unpin physical memory we referred to in current vmcs02 */
@@ -6175,11 +6179,8 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	if (nested_vmx_check_vmptr(vcpu, EXIT_REASON_VMCLEAR, &vmptr))
 		return 1;
 
-	if (vmptr == vmx->nested.current_vmptr) {
+	if (vmptr == vmx->nested.current_vmptr)
 		nested_release_vmcs12(vmx);
-		vmx->nested.current_vmptr = -1ull;
-		vmx->nested.current_vmcs12 = NULL;
-	}
 
 	page = nested_get_page(vcpu, vmptr);
 	if (page == NULL) {
@@ -6521,9 +6522,8 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 			skip_emulated_instruction(vcpu);
 			return 1;
 		}
-		if (vmx->nested.current_vmptr != -1ull)
-			nested_release_vmcs12(vmx);
 
+		nested_release_vmcs12(vmx);
 		vmx->nested.current_vmptr = vmptr;
 		vmx->nested.current_vmcs12 = new_vmcs12;
 		vmx->nested.current_vmcs12_page = page;
-- 
1.8.3.1

