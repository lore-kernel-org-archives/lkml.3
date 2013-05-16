Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3EPVNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:13:24 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50128 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3EPVNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:13:20 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v6 2/7] KVM: MMU: delete shadow page from hash list in kvm_mmu_prepare_zap_page
Date: Fri, 17 May 2013 05:12:57 +0800
Message-Id: <1368738782-18649-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051621-2674-0000-0000-000009008070
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move deletion shadow page from the hash list from kvm_mmu_commit_zap_page to
kvm_mmu_prepare_zap_page so that we can call kvm_mmu_commit_zap_page
once for multiple kvm_mmu_prepare_zap_page that can help us to avoid
unnecessary TLB flush

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 40d7b2d..682ecb4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
+
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
@@ -1655,7 +1655,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
 	for_each_gfn_sp(_kvm, _sp, _gfn)				\
-		if ((_sp)->role.direct || (_sp)->role.invalid) {} else
+		if ((_sp)->role.direct ||				\
+		      ((_sp)->role.invalid && WARN_ON(1))) {} else
 
 /* @sp->gfn should be write-protected at the call site */
 static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
@@ -2074,6 +2075,9 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 		unaccount_shadowed(kvm, sp->gfn);
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
+
+	hlist_del_init(&sp->hash_link);
+
 	if (!sp->root_count) {
 		/* Count self */
 		ret++;
-- 
1.7.7.6

