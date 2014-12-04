Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaLDP6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:58:13 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56981 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaLDP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:39 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 8/9] kvm: vmx: add MSR logic for XSAVES
Date: Thu,  4 Dec 2014 16:57:13 +0100
Message-Id: <1417708634-24333-9-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <wanpeng.li@linux.intel.com>

Add logic to get/set the XSS model-specific register.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx.c              | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0271f6bcf123..0c4c88c008ce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -362,6 +362,7 @@ struct kvm_vcpu_arch {
 	int mp_state;
 	u64 ia32_misc_enable_msr;
 	bool tpr_access_reporting;
+	u64 ia32_xss;
 
 	/*
 	 * Paging state of the vcpu
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 88048c72b6b1..ad1153a725a2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -99,6 +99,8 @@ module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 static bool __read_mostly nested = 0;
 module_param(nested, bool, S_IRUGO);
 
+static u64 __read_mostly host_xss;
+
 #define KVM_GUEST_CR0_MASK (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST (X86_CR0_WP | X86_CR0_NE)
 #define KVM_VM_CR0_ALWAYS_ON						\
@@ -2570,6 +2572,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
 		return vmx_get_vmx_msr(vcpu, msr_index, pdata);
+	case MSR_IA32_XSS:
+		if (!vmx_xsaves_supported())
+			return 1;
+		data = vcpu->arch.ia32_xss;
+		break;
 	case MSR_TSC_AUX:
 		if (!to_vmx(vcpu)->rdtscp_enabled)
 			return 1;
@@ -2661,6 +2668,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return 1; /* they are read-only */
+	case MSR_IA32_XSS:
+		if (!vmx_xsaves_supported())
+			return 1;
+		/*
+		 * The only supported bit as of Skylake is bit 8, but
+		 * it is not supported on KVM.
+		 */
+		if (data != 0)
+			return 1;
+		vcpu->arch.ia32_xss = data;
+		if (vcpu->arch.ia32_xss != host_xss)
+			add_atomic_switch_msr(vmx, MSR_IA32_XSS,
+				vcpu->arch.ia32_xss, host_xss);
+		else
+			clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
+		break;
 	case MSR_TSC_AUX:
 		if (!vmx->rdtscp_enabled)
 			return 1;
@@ -2896,7 +2919,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 			SECONDARY_EXEC_ENABLE_INVPCID |
 			SECONDARY_EXEC_APIC_REGISTER_VIRT |
 			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
-			SECONDARY_EXEC_SHADOW_VMCS;
+			SECONDARY_EXEC_SHADOW_VMCS |
+			SECONDARY_EXEC_XSAVES;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -3019,6 +3043,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		}
 	}
 
+	if (cpu_has_xsaves)
+		rdmsrl(MSR_IA32_XSS, host_xss);
+
 	return 0;
 }
 
-- 
1.8.3.1


