Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab3DAJ5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:57:08 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55998 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab3DAJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:57:04 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 3/6] KVM: MMU: make return value of mmio page fault handler more readable
Date: Mon,  1 Apr 2013 17:56:46 +0800
Message-Id: <1364810209-25954-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040109-8256-0000-0000-000006E20D11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define some meaningful names instead of raw code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   15 +++++----------
 arch/x86/kvm/mmu.h |   14 ++++++++++++++
 arch/x86/kvm/vmx.c |    4 ++--
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index be4f733..31c5586 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3182,17 +3182,12 @@ static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
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
+		return RET_MMIO_PF_EMU;
 
 	spte = walk_shadow_page_get_mmio_spte(vcpu, addr);
 
@@ -3205,7 +3200,7 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 
 		trace_handle_mmio_page_fault(addr, gfn, access);
 		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
-		return 1;
+		return RET_MMIO_PF_EMU;
 	}
 
 	/*
@@ -3213,13 +3208,13 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
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
 
@@ -3229,7 +3224,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr,
 	int ret;
 
 	ret = handle_mmio_page_fault_common(vcpu, addr, direct);
-	WARN_ON(ret < 0);
+	WARN_ON(ret == RET_MMIO_PF_BUG);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2adcbc2..6b4ba1e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,6 +52,20 @@
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
+
+/*
+ * Return values of handle_mmio_page_fault_common:
+ * RET_MMIO_PF_EMU: it is a real mmio page fault, emulate the instruction
+ *		    directly.
+ * RET_MMIO_PF_RETRY: let CPU fault again on the address.
+ * RET_MMIO_PF_BUG: bug is detected.
+ */
+enum {
+	RET_MMIO_PF_EMU = 1,
+	RET_MMIO_PF_RETRY = 0,
+	RET_MMIO_PF_BUG = -1
+};
+
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 915ef56..d0f2790 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5135,10 +5135,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 
 	ret = handle_mmio_page_fault_common(vcpu, gpa, true);
-	if (likely(ret == 1))
+	if (likely(ret == RET_MMIO_PF_EMU))
 		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
 					      EMULATE_DONE;
-	if (unlikely(!ret))
+	if (unlikely(ret == RET_MMIO_PF_RETRY))
 		return 1;
 
 	/* It is the real ept misconfig */
-- 
1.7.7.6

