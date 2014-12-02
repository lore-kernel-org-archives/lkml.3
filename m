Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaLBLPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:15:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:10691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbaLBLPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:15:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,500,1413270000"; 
   d="scan'208";a="641285033"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3 2/3] kvm: vmx: add kvm_get/set logic to xsaves
Date: Tue,  2 Dec 2014 19:14:59 +0800
Message-Id: <1417518900-42446-3-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417518900-42446-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1417518900-42446-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kvm_get/set logic to xsaves. 

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/vmx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 12915f1..66d1e3d 100644
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
@@ -2661,6 +2668,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return 1; /* they are read-only */
+	case MSR_IA32_XSS:
+		if (!vmx_xsaves_supported())
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
@@ -3020,6 +3037,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		}
 	}
 
+	if (cpu_has_xsaves)
+		rdmsrl(MSR_IA32_XSS, host_xss);
+
 	return 0;
 }
 
-- 
1.9.1

