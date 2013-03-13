Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3CME6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:58:44 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35405 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3CME6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:58:43 -0400
Message-ID: <5140077B.9020405@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 12:58:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/6] KVM: MMU: delete shadow page from hash list in kvm_mmu_prepare_zap_page
References: <514006AC.2020904@linux.vnet.ibm.com>
In-Reply-To: <514006AC.2020904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031304-9264-0000-0000-00000352685A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move deletion shadow page from the hash list from kvm_mmu_commit_zap_page to
kvm_mmu_prepare_zap_page, we that we can free the shadow page out of mmu-lock.

Also, delete the invalid shadow page from the hash list since this page can
not be reused anymore. This makes reset mmu-cache more easier - we do not need
to care all hash entries after reset mmu-cache

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4152766..e326099 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1469,7 +1469,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
+
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
@@ -1658,7 +1658,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,

 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
 	for_each_gfn_sp(_kvm, _sp, _gfn)				\
-		if ((_sp)->role.direct || (_sp)->role.invalid) {} else
+		if ((_sp)->role.direct ||				\
+		      ((_sp)->role.invalid && WARN_ON(1))) {} else

 /* @sp->gfn should be write-protected at the call site */
 static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
@@ -2079,6 +2080,9 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
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

