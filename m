Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3COP1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:27:10 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:38962 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab3COP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:27:07 -0400
Message-ID: <51433DC3.1070404@linux.vnet.ibm.com>
Date: Fri, 15 Mar 2013 23:26:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/5] Revert "KVM: x86: Optimize mmio spte zapping when, creating/moving
 memslot"
References: <51433D98.4050605@linux.vnet.ibm.com>
In-Reply-To: <51433D98.4050605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031515-8256-0000-0000-000006A4F464
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 982b3394dd23eec6e5a2f7871238435a167b63cc.
This way is not scale, will use a simple and scale way to zap all
mmio sptes later

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/mmu.c              |   18 ------------------
 arch/x86/kvm/x86.c              |    2 +-
 3 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3f205c6c..9b75cae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -767,7 +767,6 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
-void kvm_mmu_zap_mmio_sptes(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c1a9b7b..de45ec1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4189,24 +4189,6 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }

-void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
-{
-	struct kvm_mmu_page *sp, *node;
-	LIST_HEAD(invalid_list);
-
-	spin_lock(&kvm->mmu_lock);
-restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
-		if (!sp->mmio_cached)
-			continue;
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
-			goto restart;
-	}
-
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
-}
-
 static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct kvm *kvm;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3c4787..61a5bb6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6991,7 +6991,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * mmio sptes.
 	 */
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
-		kvm_mmu_zap_mmio_sptes(kvm);

