Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3FJIl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:41:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62356 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3FJIjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:39:47 -0400
Message-ID: <51B590C9.9080009@gmail.com>
Date: Mon, 10 Jun 2013 16:39:37 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130610075656.GY4725@redhat.com>
In-Reply-To: <20130610075656.GY4725@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 03:56 PM, Gleb Natapov wrote:
> On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:
>> Changelog:
>> V3:
>>   All of these changes are from Gleb's review:
>>   1) rename RET_MMIO_PF_EMU to RET_MMIO_PF_EMULATE.
>>   2) smartly adjust kvm generation number in kvm_current_mmio_generatio()
>>      to avoid kvm_memslots->generation overflow.
>>
>> V2:
>>   - rename kvm_mmu_invalid_mmio_spte to kvm_mmu_invalid_mmio_sptes
>>   - use kvm->memslots->generation as kvm global generation-number
>>   - fix comment and codestyle
>>   - init kvm generation close to mmio wrap-around value
>>   - keep kvm_mmu_zap_mmio_sptes
>>
>> The current way is holding hot mmu-lock and walking all shadow pages, this
>> is not scale. This patchset tries to introduce a very simple and scale way
>> to fast invalidate all mmio sptes - it need not walk any shadow pages and hold
>> any locks.
>>
>> The idea is simple:
>> KVM maintains a global mmio valid generation-number which is stored in
>> kvm->memslots.generation and every mmio spte stores the current global
>> generation-number into his available bits when it is created
>>
>> When KVM need zap all mmio sptes, it just simply increase the global
>> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
>> then it walks the shadow page table and get the mmio spte. If the
>> generation-number on the spte does not equal the global generation-number,
>> it will go to the normal #PF handler to update the mmio spte
>>
>> Since 19 bits are used to store generation-number on mmio spte, we zap all
>> mmio sptes when the number is round
>>
> Looks good to me, but doesn't tis obsolete kvm_mmu_zap_mmio_sptes() and
> sp->mmio_cached, so they should be removed as part of the patch series?

Yes, i agree, they should be removed. :)

There is the patch to do these things:

>From bc1bc36e2640059f06c4860af802ecc74e1f3d2d Mon Sep 17 00:00:00 2001
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Date: Mon, 10 Jun 2013 16:28:55 +0800
Subject: [PATCH 7/6] KVM: MMU: drop kvm_mmu_zap_mmio_sptes

Drop kvm_mmu_zap_mmio_sptes and use kvm_mmu_invalidate_zap_all_pages
instead to handle mmio generation number overflow

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu.c              | 22 +---------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 90d05ed..966f265 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -230,7 +230,6 @@ struct kvm_mmu_page {
 #endif

 	int write_flooding_count;
-	bool mmio_cached;
 };

 struct kvm_pio_request {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 35cd0b6..c87b19d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -246,13 +246,11 @@ static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
 static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
 			   unsigned access)
 {
-	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
 	unsigned int gen = kvm_current_mmio_generation(kvm);
 	u64 mask = generation_mmio_spte_mask(gen);

 	access &= ACC_WRITE_MASK | ACC_USER_MASK;
 	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;
-	sp->mmio_cached = true;

 	trace_mark_mmio_spte(sptep, gfn, access, gen);
 	mmu_spte_set(sptep, mask);
@@ -4362,24 +4360,6 @@ void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 }

-static void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
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
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 {
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
@@ -4395,7 +4375,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
 	 * when mark memslot invalid.
 	 */
 	if (unlikely(kvm_current_mmio_generation(kvm) >= (MMIO_MAX_GEN - 1)))
-		kvm_mmu_zap_mmio_sptes(kvm);
+		kvm_mmu_invalidate_zap_all_pages(kvm);
 }

 static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
-- 
1.8.1.4


