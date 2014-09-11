Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaIKFhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:37:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13147 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424AbaIKFhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:37:17 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35792889"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v5 7/7] kvm, mem-hotplug: Unpin and remove nested_vmx->apic_access_page.
Date: Thu, 11 Sep 2014 13:38:06 +0800
Message-ID: <1410413886-32213-8-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like we removed kvm_arch->apic_access_page, nested_vmx->apic_access_page
becomes useless for the same reason. This patch removes nested_vmx->apic_access_page,
and use gfn_to_page() to pin it in memory when we need it, and unpin it after then.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 058c373..4aa73cb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -374,11 +374,6 @@ struct nested_vmx {
 	u64 vmcs01_tsc_offset;
 	/* L2 must run next, and mustn't decide to exit to L1. */
 	bool nested_run_pending;
-	/*
-	 * Guest pages referred to in vmcs02 with host-physical pointers, so
-	 * we must keep them pinned while L2 runs.
-	 */
-	struct page *apic_access_page;
 	u64 msr_ia32_feature_control;
 
 	struct hrtimer preemption_timer;
@@ -6154,11 +6149,6 @@ static void free_nested(struct vcpu_vmx *vmx)
 	nested_release_vmcs12(vmx);
 	if (enable_shadow_vmcs)
 		free_vmcs(vmx->nested.current_shadow_vmcs);
-	/* Unpin physical memory we referred to in current vmcs02 */
-	if (vmx->nested.apic_access_page) {
-		nested_release_page(vmx->nested.apic_access_page);
-		vmx->nested.apic_access_page = 0;
-	}
 
 	nested_free_all_saved_vmcss(vmx);
 }
@@ -7983,28 +7973,31 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 			exec_control |= vmcs12->secondary_vm_exec_control;
 
 		if (exec_control & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) {
+			struct page *page;
 			/*
 			 * Translate L1 physical address to host physical
 			 * address for vmcs02. Keep the page pinned, so this
 			 * physical address remains valid. We keep a reference
 			 * to it so we can release it later.
 			 */
-			if (vmx->nested.apic_access_page) /* shouldn't happen */
-				nested_release_page(vmx->nested.apic_access_page);
-			vmx->nested.apic_access_page =
-				nested_get_page(vcpu, vmcs12->apic_access_addr);
+			page = nested_get_page(vcpu, vmcs12->apic_access_addr);
 			/*
 			 * If translation failed, no matter: This feature asks
 			 * to exit when accessing the given address, and if it
 			 * can never be accessed, this feature won't do
 			 * anything anyway.
 			 */
-			if (!vmx->nested.apic_access_page)
+			if (!page)
 				exec_control &=
 				  ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
 			else
 				vmcs_write64(APIC_ACCESS_ADDR,
-				  page_to_phys(vmx->nested.apic_access_page));
+					     page_to_phys(page));
+			/*
+			 * Do not pin nested vm's apic access page in memory so
+			 * that memory hotplug process is able to migrate it.
+			 */
+			put_page(page);
 		} else if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
 			struct page *page = gfn_to_page(vmx->vcpu.kvm,
 				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
@@ -8807,12 +8800,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	/* This is needed for same reason as it was needed in prepare_vmcs02 */
 	vmx->host_rsp = 0;
 
-	/* Unpin physical memory we referred to in vmcs02 */
-	if (vmx->nested.apic_access_page) {
-		nested_release_page(vmx->nested.apic_access_page);
-		vmx->nested.apic_access_page = 0;
-	}
-
 	/*
 	 * Do not call kvm_reload_apic_access_page() because we are now
 	 * running, mmu_notifier will force to reload the page's hpa for L2
-- 
1.8.3.1

