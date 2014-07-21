Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaGUMd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:33:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41051 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaGUMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:33:37 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, wanpeng.li@linux.intel.com, kvm@vger.kernel.org,
        jan.kiszka@siemens.com, mtosatti@redhat.com
Subject: [PATCH 1/2] KVM: nVMX: fix lifetime issues for vmcs02
Date: Mon, 21 Jul 2014 14:33:24 +0200
Message-Id: <1405946005-4228-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405946005-4228-1-git-send-email-pbonzini@redhat.com>
References: <1405946005-4228-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_nested needs the loaded_vmcs to be valid if it is a vmcs02, in
order to detach it from the shadow vmcs.  However, this is not
available anymore after commit 26a865f4aa8e (KVM: VMX: fix use after
free of vmx->loaded_vmcs, 2014-01-03).

Revert that patch, and fix its problem by forcing a vmcs01 as the
active VMCS before freeing all the nested VMX state.

Reported-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Tested-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7534a9f67cc8..462334eaa3c0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5772,22 +5772,27 @@ static void nested_free_vmcs02(struct vcpu_vmx *vmx, gpa_t vmptr)
 
 /*
  * Free all VMCSs saved for this vcpu, except the one pointed by
- * vmx->loaded_vmcs. These include the VMCSs in vmcs02_pool (except the one
- * currently used, if running L2), and vmcs01 when running L2.
+ * vmx->loaded_vmcs. We must be running L1, so vmx->loaded_vmcs
+ * must be &vmx->vmcs01.
  */
 static void nested_free_all_saved_vmcss(struct vcpu_vmx *vmx)
 {
 	struct vmcs02_list *item, *n;
+
+	WARN_ON(vmx->loaded_vmcs != &vmx->vmcs01);
 	list_for_each_entry_safe(item, n, &vmx->nested.vmcs02_pool, list) {
-		if (vmx->loaded_vmcs != &item->vmcs02)
-			free_loaded_vmcs(&item->vmcs02);
+		/*
+		 * Something will leak if the above WARN triggers.  Better than
+		 * a use-after-free.
+		 */
+		if (vmx->loaded_vmcs == &item->vmcs02)
+			continue;
+
+		free_loaded_vmcs(&item->vmcs02);
 		list_del(&item->list);
 		kfree(item);
+		vmx->nested.vmcs02_num--;
 	}
-	vmx->nested.vmcs02_num = 0;
-
-	if (vmx->loaded_vmcs != &vmx->vmcs01)
-		free_loaded_vmcs(&vmx->vmcs01);
 }
 
 /*
@@ -7557,13 +7562,31 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_complete_interrupts(vmx);
 }
 
+static void vmx_load_vmcs01(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int cpu;
+
+	if (vmx->loaded_vmcs == &vmx->vmcs01)
+		return;
+
+	cpu = get_cpu();
+	vmx->loaded_vmcs = &vmx->vmcs01;
+	vmx_vcpu_put(vcpu);
+	vmx_vcpu_load(vcpu, cpu);
+	vcpu->cpu = cpu;
+	put_cpu();
+}
+
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	free_vpid(vmx);
-	free_loaded_vmcs(vmx->loaded_vmcs);
+	leave_guest_mode(vcpu);
+	vmx_load_vmcs01(vcpu);
 	free_nested(vmx);
+	free_loaded_vmcs(vmx->loaded_vmcs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
@@ -8721,7 +8744,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 			      unsigned long exit_qualification)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	int cpu;
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 	/* trying to cancel vmlaunch/vmresume is a bug */
@@ -8746,12 +8768,7 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 				       vmcs12->vm_exit_intr_error_code,
 				       KVM_ISA_VMX);
 
-	cpu = get_cpu();
-	vmx->loaded_vmcs = &vmx->vmcs01;
-	vmx_vcpu_put(vcpu);
-	vmx_vcpu_load(vcpu, cpu);
-	vcpu->cpu = cpu;
-	put_cpu();
+	vmx_load_vmcs01(vcpu);
 
 	vm_entry_controls_init(vmx, vmcs_read32(VM_ENTRY_CONTROLS));
 	vm_exit_controls_init(vmx, vmcs_read32(VM_EXIT_CONTROLS));
-- 
1.8.3.1


