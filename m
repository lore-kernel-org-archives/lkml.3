Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaHEEmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:42:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:6818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbaHEEmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:42:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,802,1400050800"; 
   d="scan'208";a="580080200"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2 1/2] KVM: nVMX: Fix nested vmexit ack intr before load vmcs01
Date: Tue,  5 Aug 2014 12:42:23 +0800
Message-Id: <1407213744-24794-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

External interrupt will cause L1 vmexit w/ reason external interrupt when L2 is 
running. Then L1 will pick up the interrupt through vmcs12 if L1 set the ack 
interrupt bit. Commit 77b0f5d (KVM: nVMX: Ack and write vector info to intr_info
if L1 asks us to) get intr that belongs to L1 before load vmcs01 which is wrong, 
especially this lead to the obvious L1 ack APICv behavior weired since APICv 
is for L1 instead of L2. This patch fix it by ack intr after load vmcs01.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Liu, RongrongX <rongrongx.liu@intel.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/vmx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e618f34..b8122b3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8754,14 +8754,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
 		       exit_qualification);
 
-	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
-	    && nested_exit_intr_ack_set(vcpu)) {
-		int irq = kvm_cpu_get_interrupt(vcpu);
-		WARN_ON(irq < 0);
-		vmcs12->vm_exit_intr_info = irq |
-			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
-	}
-
 	trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
 				       vmcs12->exit_qualification,
 				       vmcs12->idt_vectoring_info_field,
@@ -8771,6 +8763,14 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 
 	vmx_load_vmcs01(vcpu);
 
+	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	    && nested_exit_intr_ack_set(vcpu)) {
+		int irq = kvm_cpu_get_interrupt(vcpu);
+		WARN_ON(irq < 0);
+		vmcs12->vm_exit_intr_info = irq |
+			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
+	}
+
 	vm_entry_controls_init(vmx, vmcs_read32(VM_ENTRY_CONTROLS));
 	vm_exit_controls_init(vmx, vmcs_read32(VM_EXIT_CONTROLS));
 	vmx_segment_cache_clear(vmx);
-- 
1.9.1

