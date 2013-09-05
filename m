Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213Ab3IEK3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:29:51 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36492 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935730Ab3IEK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:48 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page table out of vcpu thread
Date: Thu,  5 Sep 2013 18:29:15 +0800
Message-Id: <1378376958-27252-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-6102-0000-0000-00000421C1A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is easy if the handler is in the vcpu context, in that case we can use
walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() that
disable interrupt to stop shadow page being freed. But we are on the ioctl
context and the paths we are optimizing for have heavy workload, disabling
interrupt is not good for the system performance

We add a indicator into kvm struct (kvm->arch.rcu_free_shadow_page), then
use call_rcu() to free the shadow page if that indicator is set. Set/Clear the
indicator are protected by slot-lock, so it need not be atomic and does not
hurt the performance and the scalability

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/mmu.c              | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu.h              | 22 ++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74..8e4ca0d 100644
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
@@ -554,6 +557,7 @@ struct kvm_arch {
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
+	bool rcu_free_shadow_page;
 
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2bf450a..f551fc7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2355,6 +2355,30 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	return ret;
 }
 
+static void kvm_mmu_isolate_pages(struct list_head *invalid_list)
+{
+	struct kvm_mmu_page *sp;
+
+	list_for_each_entry(sp, invalid_list, link)
+		kvm_mmu_isolate_page(sp);
+}
+
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
@@ -2375,6 +2399,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	 */
 	kvm_flush_remote_tlbs(kvm);
 
+	if (kvm->arch.rcu_free_shadow_page) {
+		kvm_mmu_isolate_pages(invalid_list);
+		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
+		list_del_init(invalid_list);
+		call_rcu(&sp->rcu, free_pages_rcu);
+		return;
+	}
+
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
 		kvm_mmu_isolate_page(sp);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 77e044a..61217f3 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -117,4 +117,26 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
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

