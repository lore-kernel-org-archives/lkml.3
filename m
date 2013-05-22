Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3EVT5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:57:34 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60329 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab3EVT4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:23 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 09/11] KVM: MMU: introduce kvm_mmu_prepare_zap_obsolete_page
Date: Thu, 23 May 2013 03:55:58 +0800
Message-Id: <1369252560-11611-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-8256-0000-0000-0000079BF88E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only used to zap the obsolete page. Since the obsolete page
will not be used, we need not spend time to find its unsync children
out. Also, we delete the page from shadow page cache so that the page
is completely isolated after call this function.

The later patch will use it to collapse tlb flushes

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9b57faa..e676356 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
+	hlist_del_init(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
@@ -2069,14 +2069,19 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	return zapped;
 }
 
-static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-				    struct list_head *invalid_list)
+static int
+__kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			   bool zap_unsync_children,
+			   struct list_head *invalid_list)
 {
-	int ret;
+	int ret = 0;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
-	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
+
+	if (likely(zap_unsync_children))
+		ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
+
 	kvm_mmu_page_unlink_children(kvm, sp);
 	kvm_mmu_unlink_parents(kvm, sp);
 
@@ -2099,6 +2104,37 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	return ret;
 }
 
+/*
+ * The obsolete page will not be used, we need not spend time to find
+ * its unsync children out. Also, we delete the page from shadow page
+ * cache so that the page is completely isolated after call this
+ * function.
+ *
+ * Note: if we use this function in for_each_gfn_xxx macros, we should
+ * re-walk the list when it successfully zaps one page.
+ */
+static int
+kvm_mmu_prepare_zap_obsolete_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				  struct list_head *invalid_list)
+{
+	int ret;
+
+	WARN_ON(!is_obsolete_sp(kvm, sp));
+
+	ret = __kvm_mmu_prepare_zap_page(kvm, sp, false, invalid_list);
+	if (ret)
+		hlist_del_init(&sp->hash_link);
+
+	WARN_ON(ret > 1);
+	return ret;
+}
+
+static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				    struct list_head *invalid_list)
+{
+	return __kvm_mmu_prepare_zap_page(kvm, sp, true, invalid_list);
+}
+
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list)
 {
-- 
1.7.7.6

