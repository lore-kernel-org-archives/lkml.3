Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743Ab3IEKbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:31:21 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52194 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935728Ab3IEK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:48 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 11/15] KVM: MMU: reintroduce kvm_mmu_isolate_page()
Date: Thu,  5 Sep 2013 18:29:14 +0800
Message-Id: <1378376958-27252-12-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-2000-0000-0000-00000D9913FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was removed by commit 834be0d83. Now we will need it to do lockless shadow
page walking protected by rcu, so reintroduce it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fe80019..2bf450a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1675,14 +1675,30 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+/*
+ * Remove the sp from shadow page cache, after call it,
+ * we can not find this sp from the cache, and the shadow
+ * page table is still valid.
+ *
+ * It should be under the protection of mmu lock.
+ */
+static void kvm_mmu_isolate_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
+
 	hlist_del(&sp->hash_link);
-	list_del(&sp->link);
-	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
+}
+
+/*
+ * Free the shadow page table and the sp, we can do it
+ * out of the protection of mmu lock.
+ */
+static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+{
+	list_del(&sp->link);
+	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -2361,6 +2377,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
+		kvm_mmu_isolate_page(sp);
 		kvm_mmu_free_page(sp);
 	}
 }
-- 
1.8.1.4

