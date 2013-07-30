Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3G3NKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:10:36 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42738 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3G3NHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:07:50 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 10/12] KVM: MMU: allow locklessly access shadow page table out of vcpu thread
Date: Tue, 30 Jul 2013 21:02:08 +0800
Message-Id: <1375189330-24066-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073012-5490-0000-0000-000003E8A171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is easy if the handler is in the vcpu context, in that case we can use
walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() that
disable interrupt to stop shadow page be freed. But we are on the ioctl context
and the paths we are optimizing for have heavy workload, disabling interrupt is
not good for the system performance

We add a indicator into kvm struct (kvm->arch.rcu_free_shadow_page), then use
call_rcu() to free the shadow page if that indicator is set. Set/Clear the
indicator are protected by slot-lock, so it need not be atomic and does not
hurt the performance and the scalability

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/mmu.c              | 23 +++++++++++++++++++++++
 arch/x86/kvm/mmu.h              | 22 ++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 531f47c..dc842b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -226,7 +226,10 @@ struct kvm_mmu_page {
 	/* The page is obsolete if mmu_valid_gen != kvm->arch.mmu_valid_gen.  */
 	unsigned long mmu_valid_gen;
 
-	DECLARE_BITMAP(unsync_child_bitmap, 512);
+	union {
+		DECLARE_BITMAP(unsync_child_bitmap, 512);
+		struct rcu_head rcu;
+	};
 
 #ifdef CONFIG_X86_32
 	/*
@@ -545,6 +548,7 @@ struct kvm_arch {
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
+	bool rcu_free_shadow_page;
 
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f8fc0cc..7f3391f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2322,6 +2322,22 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	return ret;
 }
 
+static void free_pages_rcu(struct rcu_head *head)
+{
+	struct kvm_mmu_page *next, *sp;
+
+	sp = container_of(head, struct kvm_mmu_page, rcu);
+	while (sp) {
+		if (!list_empty(&sp->link))
+			next = list_first_entry(&sp->link,
+					      struct kvm_mmu_page, link);
+		else
+			next = NULL;
+		kvm_mmu_free_page(sp);
+		sp = next;
+	}
+}
+
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list)
 {
@@ -2342,6 +2358,13 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	 */
 	kvm_flush_remote_tlbs(kvm);
 
+	if (kvm->arch.rcu_free_shadow_page) {
+		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
+		list_del_init(invalid_list);
+		call_rcu(&sp->rcu, free_pages_rcu);
+		return;
+	}
+
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
 		kvm_mmu_free_page(sp);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 5b59c57..85405f1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -115,4 +115,26 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 }
 
 void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm);
+
+/*
+ * The caller should ensure that these two functions should be
+ * serially called.
+ */
+static inline void kvm_mmu_rcu_free_page_begin(struct kvm *kvm)
+{
+	rcu_read_lock();
+
+	kvm->arch.rcu_free_shadow_page = true;
+	/* Set the indicator before access shadow page. */
+	smp_mb();
+}
+
+static inline void kvm_mmu_rcu_free_page_end(struct kvm *kvm)
+{
+	/* Make sure that access shadow page has finished. */
+	smp_mb();
+	kvm->arch.rcu_free_shadow_page = false;
+
+	rcu_read_unlock();
+}
 #endif
-- 
1.8.1.4

