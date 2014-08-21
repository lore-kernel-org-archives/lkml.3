Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaHULog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:44:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:61221 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbaHULof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:44:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="591294447"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v6 1/2] KVM: nVMX: introduce nested_get_vmcs12_pages
Date: Thu, 21 Aug 2014 19:46:49 +0800
Message-Id: <1408621610-9665-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce function nested_get_vmcs12_pages() to check the valid
of nested apic access page and virtual apic page earlier.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v5 -> v6:
 * replace the name apic_access_and_virtual_page_valid by nested_get_vmcs12_pages

 arch/x86/kvm/vmx.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 286c283..24380a9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7826,6 +7826,30 @@ static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
 		kvm_inject_page_fault(vcpu, fault);
 }
 
+static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu,
+					struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
+		if (!PAGE_ALIGNED(vmcs12->apic_access_addr))
+			/*TODO: Also verify bits beyond physical address width are 0*/
+			return false;
+
+		/*
+		 * Translate L1 physical address to host physical
+		 * address for vmcs02. Keep the page pinned, so this
+		 * physical address remains valid. We keep a reference
+		 * to it so we can release it later.
+		 */
+		if (vmx->nested.apic_access_page) /* shouldn't happen */
+			nested_release_page(vmx->nested.apic_access_page);
+		vmx->nested.apic_access_page =
+			nested_get_page(vcpu, vmcs12->apic_access_addr);
+	}
+	return true;
+}
+
 static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
@@ -7972,16 +7996,6 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 		if (exec_control & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) {
 			/*
-			 * Translate L1 physical address to host physical
-			 * address for vmcs02. Keep the page pinned, so this
-			 * physical address remains valid. We keep a reference
-			 * to it so we can release it later.
-			 */
-			if (vmx->nested.apic_access_page) /* shouldn't happen */
-				nested_release_page(vmx->nested.apic_access_page);
-			vmx->nested.apic_access_page =
-				nested_get_page(vcpu, vmcs12->apic_access_addr);
-			/*
 			 * If translation failed, no matter: This feature asks
 			 * to exit when accessing the given address, and if it
 			 * can never be accessed, this feature won't do
@@ -8187,8 +8201,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return 1;
 	}
 
-	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) &&
-			!PAGE_ALIGNED(vmcs12->apic_access_addr)) {
+	if (!nested_get_vmcs12_pages(vcpu, vmcs12)) {
 		/*TODO: Also verify bits beyond physical address width are 0*/
 		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 		return 1;
-- 
1.9.1

