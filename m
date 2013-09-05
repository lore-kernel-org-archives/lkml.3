Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757Ab3IEKbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:31:40 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43204 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935703Ab3IEK3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:47 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 10/15] KVM: MMU: initialize the pointers in pte_list_desc properly
Date: Thu,  5 Sep 2013 18:29:13 +0800
Message-Id: <1378376958-27252-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-4790-0000-0000-00000A28437B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pte_list_desc will be locklessly accessed we need to atomicly initialize
its pointers so that the lockless walker can not get the partial value from the
pointer

In this patch we use the way of assigning pointer to initialize its pointers
which is always atomic instead of using kmem_cache_zalloc

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3e1432f..fe80019 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -687,14 +687,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  struct kmem_cache *base_cache, int min)
+				  struct kmem_cache *base_cache, int min,
+				  gfp_t flags)
 {
 	void *obj;
 
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
+		obj = kmem_cache_alloc(base_cache, flags);
 		if (!obj)
 			return -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -741,14 +742,16 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	int r;
 
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				   pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
+				   pte_list_desc_cache, 8 + PTE_PREFETCH_NUM,
+				   GFP_KERNEL);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
-				   mmu_page_header_cache, 4);
+				   mmu_page_header_cache, 4,
+				   GFP_KERNEL | __GFP_ZERO);
 out:
 	return r;
 }
@@ -913,6 +916,17 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	return level - 1;
 }
 
+static void pte_list_desc_ctor(void *p)
+{
+	struct pte_list_desc *desc = p;
+	int i;
+
+	for (i = 0; i < PTE_LIST_EXT; i++)
+		desc->sptes[i] = NULL;
+
+	desc->more = NULL;
+}
+
 static void desc_mark_nulls(unsigned long *pte_list, struct pte_list_desc *desc)
 {
 	unsigned long marker;
@@ -1066,6 +1080,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 	 */
 	if (!first_desc->sptes[1] && desc_is_a_nulls(first_desc->more)) {
 		*pte_list = (unsigned long)first_desc->sptes[0];
+		first_desc->sptes[0] = NULL;
 		mmu_free_pte_list_desc(first_desc);
 	}
 }
@@ -4699,8 +4714,8 @@ static void mmu_destroy_caches(void)
 int kvm_mmu_module_init(void)
 {
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
-					    sizeof(struct pte_list_desc),
-					    0, SLAB_DESTROY_BY_RCU, NULL);
+				sizeof(struct pte_list_desc),
+				0, SLAB_DESTROY_BY_RCU, pte_list_desc_ctor);
 	if (!pte_list_desc_cache)
 		goto nomem;
 
-- 
1.8.1.4

