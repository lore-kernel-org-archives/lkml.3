Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaG3MFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:05:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:5402 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaG3ME6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="365807582"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] KVM: nVMX: nested TPR shadow/threshold emulation
Date: Wed, 30 Jul 2014 20:04:40 +0800
Message-Id: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=61411

TPR shadow/threshold feature is important to speed up the Windows guest. 
Besides, it is a must feature for certain VMM.

We map virtual APIC page address and TPR threshold from L1 VMCS. If 
TPR_BELOW_THRESHOLD VM exit is triggered by L2 guest and L1 interested 
in, we inject it into L1 VMM for handling.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/vmx.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a3845b8..f60846c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2331,7 +2331,7 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 		CPU_BASED_MOV_DR_EXITING | CPU_BASED_UNCOND_IO_EXITING |
 		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_EXITING |
 		CPU_BASED_RDPMC_EXITING | CPU_BASED_RDTSC_EXITING |
-		CPU_BASED_PAUSE_EXITING |
+		CPU_BASED_PAUSE_EXITING | CPU_BASED_TPR_SHADOW |
 		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	/*
 	 * We can allow some features even when not supported by the
@@ -6937,7 +6937,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
 	case EXIT_REASON_MCE_DURING_VMENTRY:
 		return 0;
 	case EXIT_REASON_TPR_BELOW_THRESHOLD:
-		return 1;
+		return nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW);
 	case EXIT_REASON_APIC_ACCESS:
 		return nested_cpu_has2(vmcs12,
 			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
@@ -7058,6 +7058,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
+	if (is_guest_mode(vcpu))
+		return;
+
 	if (irr == -1 || tpr < irr) {
 		vmcs_write32(TPR_THRESHOLD, 0);
 		return;
@@ -7962,14 +7965,14 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		if (!vmx->rdtscp_enabled)
 			exec_control &= ~SECONDARY_EXEC_RDTSCP;
 		/* Take the following fields only from vmcs12 */
-		exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
-				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
+		exec_control &= ~(SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
                                   SECONDARY_EXEC_APIC_REGISTER_VIRT);
 		if (nested_cpu_has(vmcs12,
 				CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 			exec_control |= vmcs12->secondary_vm_exec_control;
 
 		if (exec_control & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) {
+			struct page *virtual_apic_page;
 			/*
 			 * Translate L1 physical address to host physical
 			 * address for vmcs02. Keep the page pinned, so this
@@ -7992,6 +7995,15 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 			else
 				vmcs_write64(APIC_ACCESS_ADDR,
 				  page_to_phys(vmx->nested.apic_access_page));
+
+			virtual_apic_page = nested_get_page(vcpu,
+						vmcs12->virtual_apic_page_addr);
+			if (vmcs_read64(VIRTUAL_APIC_PAGE_ADDR) !=
+					page_to_phys(virtual_apic_page))
+				vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
+					page_to_phys(virtual_apic_page));
+			nested_release_page(virtual_apic_page);
+
 		} else if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
 			exec_control |=
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
@@ -8002,6 +8014,8 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
 
+	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
+		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
 
 	/*
 	 * Set host-state according to L0's settings (vmcs12 is irrelevant here)
-- 
1.9.1

