Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3FGIwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:52:02 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56105 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3FGIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:51:51 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 3/6] KVM: MMU: make return value of mmio page fault handler more readable
Date: Fri,  7 Jun 2013 16:51:25 +0800
Message-Id: <1370595088-3315-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060708-0260-0000-0000-0000031DA7FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define some meaningful names instead of raw code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 15 +++++----------
 arch/x86/kvm/mmu.h | 14 ++++++++++++++
 arch/x86/kvm/vmx.c |  4 ++--
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index eca91bd..044d8c0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3222,17 +3222,12 @@ static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
 	return spte;
 }
 
-/*
- * If it is a real mmio page fault, return 1 and emulat the instruction
- * directly, return 0 to let CPU fault again on the address, -1 is
- * returned if bug is detected.
- */
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 {
 	u64 spte;
 
 	if (quickly_check_mmio_pf(vcpu, addr, direct))
-		return 1;
+		return RET_MMIO_PF_EMULATE;
 
 	spte = walk_shadow_page_get_mmio_spte(vcpu, addr);
 
@@ -3245,7 +3240,7 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 
 		trace_handle_mmio_page_fault(addr, gfn, access);
 		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
-		return 1;
+		return RET_MMIO_PF_EMULATE;
 	}
 
 	/*
@@ -3253,13 +3248,13 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	 * it's a BUG if the gfn is not a mmio page.
 	 */
 	if (direct && !check_direct_spte_mmio_pf(spte))
-		return -1;
+		return RET_MMIO_PF_BUG;
 
 	/*
 	 * If the page table is zapped by other cpus, let CPU fault again on
 	 * the address.
 	 */
-	return 0;
+	return RET_MMIO_PF_RETRY;
 }
 EXPORT_SYMBOL_GPL(handle_mmio_page_fault_common);
 
@@ -3269,7 +3264,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr,
 	int ret;
 
 	ret = handle_mmio_page_fault_common(vcpu, addr, direct);
-	WARN_ON(ret < 0);
+	WARN_ON(ret == RET_MMIO_PF_BUG);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 922bfae..ba6a19c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,6 +52,20 @@
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
+
+/*
+ * Return values of handle_mmio_page_fault_common:
+ * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
+ *			 directly.
+ * RET_MMIO_PF_RETRY: let CPU fault again on the address.
+ * RET_MMIO_PF_BUG: bug is detected.
+ */
+enum {
+	RET_MMIO_PF_EMULATE = 1,
+	RET_MMIO_PF_RETRY = 0,
+	RET_MMIO_PF_BUG = -1
+};
+
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 78ee123..85c8d51 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5366,10 +5366,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 
 	ret = handle_mmio_page_fault_common(vcpu, gpa, true);
-	if (likely(ret == 1))
+	if (likely(ret == RET_MMIO_PF_EMULATE))
 		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
 					      EMULATE_DONE;
-	if (unlikely(!ret))
+	if (unlikely(ret == RET_MMIO_PF_RETRY))
 		return 1;
 
 	/* It is the real ept misconfig */
-- 
1.8.1.4

