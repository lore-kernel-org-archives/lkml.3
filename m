Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaLDIYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:24:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:14908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaLDIYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:24:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,514,1413270000"; 
   d="scan'208";a="642209506"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 4/4] kvm: vmx: fix VMfailValid when write vmcs02/vmcs01
Date: Thu,  4 Dec 2014 16:24:28 +0800
Message-Id: <1417681468-7165-4-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDM 30.3 VMWRITE

ELSIF secondary source operand does not correspond to any VMCS field
   THEN VMfailValid(VMREAD/VMWRITE from/to unsupported VMCS component);

We can't suppose L1 VMM expose MPX to L2 just if L0 support MPX. There 
will be VMfailValid if L0 doesn't support MPX and L1 expose MPX to L2
when L0 writes vmcs02/vmcs01, in addition, there is no need to read 
GUEST_BNDCFGS if L1 VMM doesn't expose it to L2. This patch fix it by 
both check L0 support xsaves and L1 expose MPX to L2.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/vmx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e5bc349..1233159 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8496,7 +8496,8 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	set_cr4_guest_host_mask(vmx);
 
-	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)
+	if (vmx_mpx_supported() &&
+		(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETING)
@@ -8992,7 +8993,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
 	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
 	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
-	if (vmx_mpx_supported())
+	if (vmx_mpx_supported() &&
+		(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 	if (nested_cpu_has_xsaves(vmcs12))
 		vmcs12->xss_exit_bitmap = vmcs_read64(XSS_EXIT_BITMAP);
@@ -9106,7 +9108,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	vmcs_writel(GUEST_GDTR_BASE, vmcs12->host_gdtr_base);
 
 	/* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
-	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
+	if (vmx_mpx_supported() &&
+		(vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS))
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
-- 
1.9.1

