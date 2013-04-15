Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641Ab3DONAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:00:36 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54895 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3DONAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:00:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnatapov@redhat.com, jan.kiszka@siemens.com, kvm@vger.kernel.org
Subject: [PATCH v2] kvm: nVMX: check vmcs12 for valid activity state
Date: Mon, 15 Apr 2013 15:00:27 +0200
Message-Id: <1366030827-5662-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM does not use the activity state VMCS field, and does not support
it in nested VMX either (the corresponding bits in the misc VMX feature
MSR are zero).  Fail entry if the activity state is set to anything but
"active".

Since the value will always be the same for L1 and L2, we do not need
to read and write the corresponding VMCS field on L1/L2 transitions,
either.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: remove read/write of vmcs12->guest_activity_state,
	use GUEST_ACTIVITY_ACTIVE.

 arch/x86/kvm/vmx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c75c25d..c252adf 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7004,7 +7004,6 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		vmcs12->vm_entry_instruction_len);
 	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
 		vmcs12->guest_interruptibility_info);
-	vmcs_write32(GUEST_ACTIVITY_STATE, vmcs12->guest_activity_state);
 	vmcs_write32(GUEST_SYSENTER_CS, vmcs12->guest_sysenter_cs);
 	kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
 	vmcs_writel(GUEST_RFLAGS, vmcs12->guest_rflags);
@@ -7223,6 +7222,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return 1;
 	}
 
+	if (vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE) {
+		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+		return 1;
+	}
+
 	if ((vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_MSR_BITMAPS) &&
 			!IS_ALIGNED(vmcs12->msr_bitmap, PAGE_SIZE)) {
 		/*TODO: Also verify bits beyond physical address width are 0*/
@@ -7411,7 +7415,6 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_gdtr_base = vmcs_readl(GUEST_GDTR_BASE);
 	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
 
-	vmcs12->guest_activity_state = vmcs_read32(GUEST_ACTIVITY_STATE);
 	vmcs12->guest_interruptibility_info =
 		vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
 	vmcs12->guest_pending_dbg_exceptions =
-- 
1.8.1.4

