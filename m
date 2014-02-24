Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBXKzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:55:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:56821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaBXKzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:55:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,534,1389772800"; 
   d="scan'208,223";a="486975730"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "'Paolo Bonzini'" <pbonzini@redhat.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
CC: "'gleb@redhat.com'" <gleb@redhat.com>, "'hpa@zytor.com'" <hpa@zytor.com>
Subject: [PATCH v5 1/3] KVM: x86: Intel MPX vmx and msr handle
Thread-Topic: [PATCH v5 1/3] KVM: x86: Intel MPX vmx and msr handle
Thread-Index: Ac8xTvg3kNsvrn+3Q528/qU+HlkoOg==
Date: Mon, 24 Feb 2014 10:55:46 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350150E3DB@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From caddc009a6d2019034af8f2346b2fd37a81608d0 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Mon, 24 Feb 2014 18:11:11 +0800
Subject: [PATCH v5 1/3] KVM: x86: Intel MPX vmx and msr handle

This patch handle vmx and msr of Intel MPX feature.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/include/asm/kvm_host.h       |    1 +
 arch/x86/include/asm/vmx.h            |    4 ++++
 arch/x86/include/uapi/asm/msr-index.h |    1 +
 arch/x86/kvm/vmx.c                    |   18 ++++++++++++++++--
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fdf83af..1c32ca3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -765,6 +765,7 @@ struct kvm_x86_ops {
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage);
 	void (*handle_external_intr)(struct kvm_vcpu *vcpu);
+	bool (*mpx_supported)(void);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 2067264..7004d21 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -85,6 +85,7 @@
 #define VM_EXIT_SAVE_IA32_EFER                  0x00100000
 #define VM_EXIT_LOAD_IA32_EFER                  0x00200000
 #define VM_EXIT_SAVE_VMX_PREEMPTION_TIMER       0x00400000
+#define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -95,6 +96,7 @@
 #define VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL     0x00002000
 #define VM_ENTRY_LOAD_IA32_PAT			0x00004000
 #define VM_ENTRY_LOAD_IA32_EFER                 0x00008000
+#define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -174,6 +176,8 @@ enum vmcs_field {
 	GUEST_PDPTR2_HIGH               = 0x0000280f,
 	GUEST_PDPTR3                    = 0x00002810,
 	GUEST_PDPTR3_HIGH               = 0x00002811,
+	GUEST_BNDCFGS                   = 0x00002812,
+	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index c19fc60..ed821ed 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -295,6 +295,7 @@
 #define MSR_SMI_COUNT			0x00000034
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_IA32_TSC_ADJUST             0x0000003b
+#define MSR_IA32_BNDCFGS		0x00000d90
 
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a06f101..e4e4b50 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -441,6 +441,7 @@ struct vcpu_vmx {
 #endif
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
+		u64           msr_host_bndcfgs;
 	} host_state;
 	struct {
 		int vm86_active;
@@ -1710,6 +1711,8 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 	if (is_long_mode(&vmx->vcpu))
 		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 #endif
+	if (boot_cpu_has(X86_FEATURE_MPX))
+		rdmsrl(MSR_IA32_BNDCFGS, vmx->host_state.msr_host_bndcfgs);
 	for (i = 0; i < vmx->save_nmsrs; ++i)
 		kvm_set_shared_msr(vmx->guest_msrs[i].index,
 				   vmx->guest_msrs[i].data,
@@ -1747,6 +1750,8 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
+	if (vmx->host_state.msr_host_bndcfgs)
+		wrmsrl(MSR_IA32_BNDCFGS, vmx->host_state.msr_host_bndcfgs);
 	/*
 	 * If the FPU is not active (through the host task or
 	 * the guest vcpu), then restore the cr0.TS bit.
@@ -2837,7 +2842,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
 #endif
 	opt = VM_EXIT_SAVE_IA32_PAT | VM_EXIT_LOAD_IA32_PAT |
-		VM_EXIT_ACK_INTR_ON_EXIT;
+		VM_EXIT_ACK_INTR_ON_EXIT | VM_EXIT_CLEAR_BNDCFGS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2854,7 +2859,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
 	min = 0;
-	opt = VM_ENTRY_LOAD_IA32_PAT;
+	opt = VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -7052,6 +7057,12 @@ static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
 		local_irq_enable();
 }
 
+static bool vmx_mpx_supported(void)
+{
+	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
+}
+
 static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
 {
 	u32 exit_intr_info;
@@ -8634,6 +8645,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_external_intr = vmx_handle_external_intr,
+	.mpx_supported = vmx_mpx_supported,
 };
 
 static int __init vmx_init(void)
@@ -8721,6 +8733,8 @@ static int __init vmx_init(void)
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_CS, false);
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
+	vmx_disable_intercept_for_msr(MSR_IA32_BNDCFGS, true);
+
 	memcpy(vmx_msr_bitmap_legacy_x2apic,
 			vmx_msr_bitmap_legacy, PAGE_SIZE);
 	memcpy(vmx_msr_bitmap_longmode_x2apic,
-- 
1.7.1
