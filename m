Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3CME7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:59:22 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40388 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3CME7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:59:20 -0400
Message-ID: <514007A0.1040400@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 12:59:12 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/6] KVM: MMU: fast zap all shadow pages
References: <514006AC.2020904@linux.vnet.ibm.com>
In-Reply-To: <514006AC.2020904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031304-5140-0000-0000-000002E2633A
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
 arch/x86/kvm/mmu.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e326099..536d9ce 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4186,18 +4186,68 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)

 void kvm_mmu_zap_all(struct kvm *kvm)
 {
-	struct kvm_mmu_page *sp, *node;
+	LIST_HEAD(root_mmu_pages);
 	LIST_HEAD(invalid_list);
+	struct list_head pte_list_descs;
+	struct kvm_mmu_cache *cache = &kvm->arch.mmu_cache;
+	struct kvm_mmu_page *sp, *node;
+	struct pte_list_desc *desc, *ndesc;
+	int root_sp = 0;

 	spin_lock(&kvm->mmu_lock);
+
 restart:
-	list_for_each_entry_safe(sp, node,
-	      &kvm->arch.mmu_cache.active_mmu_pages, link)
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
-			goto restart;
+	/*
+	 * The root shadow pages are being used on vcpus that can not
+	 * directly removed, we filter them out and re-add them to the
+	 * new mmu cache.
+	 */
+	list_for_each_entry_safe(sp, node, &cache->active_mmu_pages, link)
+		if (sp->root_count) {
+			int ret;
+
+			root_sp++;
+			ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+			list_move(&sp->link, &root_mmu_pages);
+			if (ret)
+				goto restart;
+		}
+
+	list_splice(&cache->active_mmu_pages, &invalid_list);
+	list_replace(&cache->pte_list_descs, &pte_list_descs);
+
+	/*
+	 * Reset the mmu cache so that later vcpu will fault on the new
+	 * mmu cache.
+	 */
+	memset(cache, 0, sizeof(*cache));
+	kvm_mmu_init(kvm);
+
+	/*
+	 * Now, the mmu cache has been reset, we can re-add the root shadow
+	 * pages into the cache.
+	 */
+	list_replace(&root_mmu_pages, &cache->active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, root_sp);
+
+	/* Reset gfn's rmap and lpage info. */
+	kvm_clear_all_gfn_page_info(kvm);
+
+	/*
+	 * Flush all TLBs so that vcpu can not use the invalid mappings.
+	 * Do not disturb vcpus if root shadow pages have been zapped
+	 * since KVM_REQ_MMU_RELOAD will force TLB to be flushed.
+	 */
+	if (!root_sp && !list_empty(&invalid_list))
+		kvm_flush_remote_tlbs(kvm);

-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
+
+	list_for_each_entry_safe(sp, node, &invalid_list, link)
+		kvm_mmu_free_page(sp);
+
+	list_for_each_entry_safe(desc, ndesc, &pte_list_descs, list)
+		mmu_free_pte_list_desc(desc);
 }

 static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
-- 
1.7.7.6

