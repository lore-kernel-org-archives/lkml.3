Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3EVT6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:58:17 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47138 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab3EVT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:19 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 05/11] KVM: x86: use the fast way to invalidate all pages
Date: Thu, 23 May 2013 03:55:54 +0800
Message-Id: <1369252560-11611-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-8878-0000-0000-000007387895
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kvm_mmu_zap_all by kvm_mmu_invalidate_zap_all_pages

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   15 ---------------
 arch/x86/kvm/x86.c |    4 ++--
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 688e755..c010ace 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4188,21 +4188,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
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
index 3758ff9..15e10f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7066,13 +7066,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_mmu_zap_all(kvm);
+	kvm_mmu_invalidate_zap_all_pages(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_mmu_invalidate_zap_all_pages(kvm);
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-- 
1.7.7.6

