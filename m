Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3FJNoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:44:00 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43289 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3FJNn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:43:57 -0400
Date: Mon, 10 Jun 2013 22:43:52 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
Message-Id: <20130610224352.0a769838745b294fc43f7823@gmail.com>
In-Reply-To: <51B590C9.9080009@gmail.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<20130610075656.GY4725@redhat.com>
	<51B590C9.9080009@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013 16:39:37 +0800
Xiao Guangrong <xiaoguangrong.eric@gmail.com> wrote:

> On 06/10/2013 03:56 PM, Gleb Natapov wrote:
> > On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:

> > Looks good to me, but doesn't tis obsolete kvm_mmu_zap_mmio_sptes() and
> > sp->mmio_cached, so they should be removed as part of the patch series?
> 
> Yes, i agree, they should be removed. :)

I'm fine with removing it but please make it clear that you all agree
on the same basis.

Last time, Paolo mentioned the possibility to use some bits of spte for
other things.  The suggestion there was to keep sp->mmio_cached code
for the time we would need to reduce the bits for generation numbers.

Do you think that zap_all() is now preemptible and can treat the
situation reasonably well as the current kvm_mmu_zap_mmio_sptes()?

One downside is the need to zap unrelated shadow pages, but if this case
is really very rare, yes I agree, it should not be a problem: it depends
on how many bits we can use.

Just please reconfirm.

	Takuya

> 
> There is the patch to do these things:
> 
> From bc1bc36e2640059f06c4860af802ecc74e1f3d2d Mon Sep 17 00:00:00 2001
> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Date: Mon, 10 Jun 2013 16:28:55 +0800
> Subject: [PATCH 7/6] KVM: MMU: drop kvm_mmu_zap_mmio_sptes
> 
> Drop kvm_mmu_zap_mmio_sptes and use kvm_mmu_invalidate_zap_all_pages
> instead to handle mmio generation number overflow
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu.c              | 22 +---------------------
>  2 files changed, 1 insertion(+), 22 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 90d05ed..966f265 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -230,7 +230,6 @@ struct kvm_mmu_page {
>  #endif
> 
>  	int write_flooding_count;
> -	bool mmio_cached;
>  };
> 
>  struct kvm_pio_request {
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 35cd0b6..c87b19d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -246,13 +246,11 @@ static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
>  static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
>  			   unsigned access)
>  {
> -	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
>  	unsigned int gen = kvm_current_mmio_generation(kvm);
>  	u64 mask = generation_mmio_spte_mask(gen);
> 
>  	access &= ACC_WRITE_MASK | ACC_USER_MASK;
>  	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;
> -	sp->mmio_cached = true;
> 
>  	trace_mark_mmio_spte(sptep, gfn, access, gen);
>  	mmu_spte_set(sptep, mask);
> @@ -4362,24 +4360,6 @@ void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
>  	spin_unlock(&kvm->mmu_lock);
>  }
> 
> -static void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
> -{
> -	struct kvm_mmu_page *sp, *node;
> -	LIST_HEAD(invalid_list);
> -
> -	spin_lock(&kvm->mmu_lock);
> -restart:
> -	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
> -		if (!sp->mmio_cached)
> -			continue;
> -		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> -			goto restart;
> -	}
> -
> -	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> -	spin_unlock(&kvm->mmu_lock);
> -}
> -
>  static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>  {
>  	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
> @@ -4395,7 +4375,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
>  	 * when mark memslot invalid.
>  	 */
>  	if (unlikely(kvm_current_mmio_generation(kvm) >= (MMIO_MAX_GEN - 1)))
> -		kvm_mmu_zap_mmio_sptes(kvm);
> +		kvm_mmu_invalidate_zap_all_pages(kvm);
>  }
> 
>  static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
> -- 
> 1.8.1.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
