Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3EaAi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:38:27 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47723 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3EaAg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:36:57 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 10/11] KVM: MMU: reclaim the zapped-obsolete page first
Date: Fri, 31 May 2013 08:36:29 +0800
Message-Id: <1369960590-14138-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-8256-0000-0000-000007B94962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Marcelo pointed out that
| "(retention of large number of pages while zapping)
| can be fatal, it can lead to OOM and host crash"

We introduce a list, kvm->arch.zapped_obsolete_pages, to link all
the pages which are deleted from the mmu cache but not actually
freed. When page reclaiming is needed, we always zap this kind of
pages first.

[
  Can we use this list to instead all of "invalid_list"? That may
  be interesting and will cause big change. Will do it separately
  if it is necessary.
]
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/mmu.c              |   21 +++++++++++++++++----
 arch/x86/kvm/x86.c              |    1 +
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bff7d46..1f98c1b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -536,6 +536,8 @@ struct kvm_arch {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct list_head zapped_obsolete_pages;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	int iommu_flags;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 674c044..79af88a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4211,7 +4211,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
-	LIST_HEAD(invalid_list);
 	int batch = 0;
 
 restart:
@@ -4244,7 +4243,8 @@ restart:
 			goto restart;
 		}
 
-		ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		ret = kvm_mmu_prepare_zap_page(kvm, sp,
+				&kvm->arch.zapped_obsolete_pages);
 		batch += ret;
 
 		if (ret)
@@ -4255,7 +4255,7 @@ restart:
 	 * Should flush tlb before free page tables since lockless-walking
 	 * may use the pages.
 	 */
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
 
 /*
@@ -4306,6 +4306,11 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
+{
+	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
+}
+
 static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct kvm *kvm;
@@ -4334,15 +4339,23 @@ static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
 		 * want to shrink a VM that only started to populate its MMU
 		 * anyway.
 		 */
-		if (!kvm->arch.n_used_mmu_pages)
+		if (!kvm->arch.n_used_mmu_pages &&
+		      !kvm_has_zapped_obsolete_pages(kvm))
 			continue;
 
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
 
+		if (kvm_has_zapped_obsolete_pages(kvm)) {
+			kvm_mmu_commit_zap_page(kvm,
+			      &kvm->arch.zapped_obsolete_pages);
+			goto unlock;
+		}
+
 		prepare_zap_oldest_mmu_page(kvm, &invalid_list);
 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
+unlock:
 		spin_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15e10f7..6402951 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6832,6 +6832,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-- 
1.7.7.6

