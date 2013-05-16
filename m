Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3EPVN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:13:29 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56303 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3EPVNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:13:21 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v6 5/7] KVM: x86: use the fast way to invalidate all pages
Date: Fri, 17 May 2013 05:13:00 +0800
Message-Id: <1368738782-18649-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051621-1396-0000-0000-000002FBF04F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kvm_mmu_zap_all by kvm_mmu_invalidate_all_pages

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   15 ---------------
 arch/x86/kvm/x86.c |    6 +++---
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7ad0e50..89b51dc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4192,21 +4192,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 	spin_unlock(&kvm->mmu_lock);
 }
 
-void kvm_mmu_zap_all(struct kvm *kvm)
-{
-	struct kvm_mmu_page *sp, *node;
-	LIST_HEAD(invalid_list);
-
-	spin_lock(&kvm->mmu_lock);
-restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
-			goto restart;
-
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
-}
-
 #define BATCH_ZAP_PAGES	10
 static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d885418..30a990c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5528,7 +5528,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	 * to ensure that the updated hypercall appears atomically across all
 	 * VCPUs.
 	 */
-	kvm_mmu_zap_all(vcpu->kvm);
+	kvm_mmu_invalidate_all_pages(vcpu->kvm, false);
 
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
 
@@ -7073,13 +7073,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_mmu_zap_all(kvm);
+	kvm_mmu_invalidate_all_pages(kvm, true);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_mmu_invalidate_all_pages(kvm, true);
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-- 
1.7.7.6

