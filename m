Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3CTIdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:33:24 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46014 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3CTIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:33:20 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 6/7] KVM: MMU: fast zap all shadow pages
Date: Wed, 20 Mar 2013 16:30:26 +0800
Message-Id: <1363768227-4782-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032008-2000-0000-0000-00000B6A5967
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
walk and zap all shadow pages one by one, also it need to zap all guest
page's rmap and all shadow page's parent spte list. Particularly, things
become worse if guest uses more memory or vcpus. It is not good for
scalability.

Since all shadow page will be zapped, we can directly zap the mmu-cache
and rmap so that vcpu will fault on the new mmu-cache, after that, we can
directly free the memory used by old mmu-cache.

The root shadow page is little especial since they are currently used by
vcpus, we can not directly free them. So, we zap the root shadow pages and
re-add them into the new mmu-cache.

After this patch, kvm_mmu_zap_all can be faster 113% than before

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e880cdd..72e5bdb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4196,17 +4196,72 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
-	struct kvm_mmu_page *sp, *node;
+	LIST_HEAD(root_mmu_pages);
 	LIST_HEAD(invalid_list);
+	struct list_head pte_list_descs;
+	struct kvm_mmu_page *sp, *node;
+	struct pte_list_desc *desc, *ndesc;
+	int root_sp = 0;
 
 	spin_lock(&kvm->mmu_lock);
+
 restart:
+	/*
+	 * The root shadow pages are being used on vcpus that can not
+	 * directly removed, we filter them out and re-add them to the
+	 * new mmu cache.
+	 */
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
-			goto restart;
+		if (sp->root_count) {
+			int ret;
+
+			root_sp++;
+			ret = __kvm_mmu_prepare_zap_page(kvm, sp,
+							 &invalid_list);
+			list_move(&sp->link, &root_mmu_pages);
+			if (ret)
+				goto restart;
+		}
+
+	list_splice(&kvm->arch.active_mmu_pages, &invalid_list);
+	list_replace(&kvm->arch.pte_list_descs, &pte_list_descs);
+
+	/*
+	 * Reset the mmu cache so that later vcpu will fault on the new
+	 * mmu cache.
+	 */
+	kvm->arch.indirect_shadow_pages = 0;
+	/* Root shadow pages will be added to the new mmu cache. */
+	kvm_mod_used_mmu_pages(kvm,  -(kvm->arch.n_used_mmu_pages - root_sp));
+	memset(kvm->arch.mmu_page_hash, 0, sizeof(kvm->arch.mmu_page_hash));
+	kvm_mmu_cache_init(kvm);
+
+	/*
+	 * Now, the mmu cache has been reset, we can re-add the root shadow
+	 * pages into the cache.
+	 */
+	list_replace(&root_mmu_pages, &kvm->arch.active_mmu_pages);
+
+	/* Reset gfn's rmap and lpage info. */
+	kvm_clear_all_gfn_page_info(kvm);
+
+	/*
+	 * Notify all vcpus to reload and flush TLB if root shadow pages
+	 * were zapped (KVM_REQ_MMU_RELOAD forces TLB to be flushed).
+	 *
+	 * The TLB need not be flushed if no root shadow page was found
+	 * since no vcpu uses shadow page.
+	 */
+	if (root_sp)
+		kvm_reload_remote_mmus(kvm);
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
+
+	list_for_each_entry_safe(sp, node, &invalid_list, link)
+		kvm_mmu_free_page(sp);
+
+	list_for_each_entry_safe(desc, ndesc, &pte_list_descs, list)
+		mmu_free_pte_list_desc(desc);
 }
 
 void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
-- 
1.7.7.6

