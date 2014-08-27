Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbaH0KR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:17:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13793 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933623AbaH0KQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:16:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,409,1406563200"; 
   d="scan'208";a="35139149"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v4 5/6] kvm, mem-hotplug: Reload L1's apic access page on migration when L2 is running.
Date: Wed, 27 Aug 2014 18:17:40 +0800
Message-ID: <1409134661-27916-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only handle "L1 and L2 vm share one apic access page" situation.

When L1 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all the vcpus' vmcs (which is done by patch 5/6). And when it enters L2 vm, L2's vmcs
will be updated in prepare_vmcs02() called by nested_vm_run(). So we need to do
nothing.

When L2 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all L2 vmcs. And this patch requests apic access page reload in L2->L1 vmexit.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx.c              | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  3 +++
 virt/kvm/kvm_main.c             |  1 +
 5 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 514183e..13fbb62 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -740,6 +740,7 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
 	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
+	void (*set_nested_apic_page_migrated)(struct kvm_vcpu *vcpu, bool set);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f2eacc4..da88646 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3624,6 +3624,11 @@ static void svm_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
 	return;
 }
 
+static void svm_set_nested_apic_page_migrated(struct kvm_vcpu *vcpu, bool set)
+{
+	return;
+}
+
 static int svm_vm_has_apicv(struct kvm *kvm)
 {
 	return 0;
@@ -4379,6 +4384,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
 	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
+	.set_nested_apic_page_migrated = svm_set_nested_apic_page_migrated,
 	.vm_has_apicv = svm_vm_has_apicv,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index da6d55d..9035fd1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -379,6 +379,16 @@ struct nested_vmx {
 	 * we must keep them pinned while L2 runs.
 	 */
 	struct page *apic_access_page;
+	/*
+	 * L1's apic access page can be migrated. When L1 and L2 are sharing
+	 * the apic access page, after the page is migrated when L2 is running,
+	 * we have to reload it to L1 vmcs before we enter L1.
+	 *
+	 * When the shared apic access page is migrated in L1 mode, we don't
+	 * need to do anything else because we reload apic access page each
+	 * time when entering L2 in prepare_vmcs02().
+	 */
+	bool apic_access_page_migrated;
 	u64 msr_ia32_feature_control;
 
 	struct hrtimer preemption_timer;
@@ -7098,6 +7108,12 @@ static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
 	vmcs_write64(APIC_ACCESS_ADDR, hpa);
 }
 
+static void vmx_set_nested_apic_page_migrated(struct kvm_vcpu *vcpu, bool set)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	vmx->nested.apic_access_page_migrated = set;
+}
+
 static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
 {
 	u16 status;
@@ -8796,6 +8812,21 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	}
 
 	/*
+	 * When shared (L1 & L2) apic access page is migrated during L2 is
+	 * running, mmu_notifier will force to reload the page's hpa for L2
+	 * vmcs. Need to reload it for L1 before entering L1.
+	 */
+	if (vmx->nested.apic_access_page_migrated) {
+		/*
+		 * Do not call kvm_reload_apic_access_page() because we are now
+		 * in L2. We should not call make_all_cpus_request() to exit to
+		 * L0, otherwise we will reload for L2 vmcs again.
+		 */
+		kvm_reload_apic_access_page(vcpu->kvm);
+		vmx->nested.apic_access_page_migrated = false;
+	}
+
+	/*
 	 * Exiting from L2 to L1, we're now back to L1 which thinks it just
 	 * finished a VMLAUNCH or VMRESUME instruction, so we need to set the
 	 * success or failure flag accordingly.
@@ -8916,6 +8947,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
+	.set_nested_apic_page_migrated = vmx_set_nested_apic_page_migrated,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 96f4188..131b6e8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6000,6 +6000,9 @@ static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
 				page_to_phys(vcpu->kvm->arch.apic_access_page));
+
+	if (is_guest_mode(vcpu))
+		kvm_x86_ops->set_nested_apic_page_migrated(vcpu, true);
 }
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d8280de..784127e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -214,6 +214,7 @@ void kvm_reload_apic_access_page(struct kvm *kvm)
 {
 	make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
+EXPORT_SYMBOL_GPL(kvm_reload_apic_access_page);
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
-- 
1.8.3.1

