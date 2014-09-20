Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaITKq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:46:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20742 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755093AbaITKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:46:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,559,1406563200"; 
   d="scan'208";a="36212237"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v7 4/9] kvm: Add interface to check if secondary exec virtualzed apic accesses is enabled.
Date: Sat, 20 Sep 2014 18:47:46 +0800
Message-ID: <1411210071-14727-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wants to migrate apic access page pinned by guest (L1 and L2) to make memory
hotplug available.

There are two situations need to be handled for apic access page used by L2 vm:
1. L1 prepares a separate apic access page for L2.

   L2 pins a lot of pages in memory. Even if we can migrate apic access page,
   memory hotplug is not available when L2 is running. So do not handle this
   now. Migrate apic access page only.

2. L1 and L2 share one apic access page.

   Since we will migrate L1's apic access page, we should do some handling when
   migration happens in the following situations:

   1) when L0 is running: Update L1's vmcs in the next L0->L1 entry and L2's
      vmcs in the next L1->L2 entry.

   2) when L1 is running: Force a L1->L0 exit, update L1's vmcs in the next
      L0->L1 entry and L2's vmcs in the next L1->L2 entry.

   3) when L2 is running: Force a L2->L0 exit, update L2's vmcs in the next
      L0->L2 entry and L1's vmcs in the next L2->L1 exit.

Since we don't handle L1 ans L2 have separate apic access pages situation,
when we update vmcs, we need to check if we are in L2 and if L2's secondary
exec virtualzed apic accesses is enabled.

This patch adds an interface to check if L2's secondary exec virtualzed apic
accesses is enabled, because vmx cannot be accessed outside vmx.c.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/vmx.c              | 9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35171c7..69fe032 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -739,6 +739,7 @@ struct kvm_x86_ops {
 	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
+	bool (*has_secondary_apic_access)(struct kvm_vcpu *vcpu);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1d941ad..9c8ae32 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3619,6 +3619,11 @@ static void svm_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
 	return;
 }
 
+static bool svm_has_secondary_apic_access(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static int svm_vm_has_apicv(struct kvm *kvm)
 {
 	return 0;
@@ -4373,6 +4378,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
+	.has_secondary_apic_access = svm_has_secondary_apic_access,
 	.vm_has_apicv = svm_vm_has_apicv,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 72a0470..0b541d9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7090,6 +7090,14 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
 	vmx_set_msr_bitmap(vcpu);
 }
 
+static bool vmx_has_secondary_apic_access(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return (vmx->nested.current_vmcs12->secondary_vm_exec_control &
+		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
+}
+
 static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
 {
 	u16 status;
@@ -8909,6 +8917,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
+	.has_secondary_apic_access = vmx_has_secondary_apic_access,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
-- 
1.8.3.1

