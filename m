Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab3BEJHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:07:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3BEJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:07:15 -0500
Date: Tue, 5 Feb 2013 11:05:31 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi.kivity@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: MMU: lazily drop large spte
Message-ID: <20130205090531.GA23213@redhat.com>
References: <5110B08D.9080600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110B08D.9080600@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 03:11:09PM +0800, Xiao Guangrong wrote:
> Currently, kvm zaps the large spte if write-protected is needed, the later
> read can fault on that spte. Actually, we can make the large spte readonly
> instead of making them un-present, the page fault caused by read access can
> be avoid
> 
> The idea is from Avi:
> | As I mentioned before, write-protecting a large spte is a good idea,
> | since it moves some work from protect-time to fault-time, so it reduces
> | jitter.  This removes the need for the return value.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Reviewed-by: Gleb Natapov <gleb@redhat.com>

> ---
> Changelog:
> v3:
> - address Gleb's comments, we make the function return true if flush is
>   needed instead of returning it via pointer to a variable
> - improve the changelog
> 
>  arch/x86/kvm/mmu.c |   23 +++++++----------------
>  1 files changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 42ba85c..ff2fc80 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1106,8 +1106,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
> 
>  /*
>   * Write-protect on the specified @sptep, @pt_protect indicates whether
> - * spte writ-protection is caused by protecting shadow page table.
> - * @flush indicates whether tlb need be flushed.
> + * spte write-protection is caused by protecting shadow page table.
>   *
>   * Note: write protection is difference between drity logging and spte
>   * protection:
> @@ -1116,10 +1115,9 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>   * - for spte protection, the spte can be writable only after unsync-ing
>   *   shadow page.
>   *
> - * Return true if the spte is dropped.
> + * Return true if tlb need be flushed.
>   */
> -static bool
> -spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool pt_protect)
>  {
>  	u64 spte = *sptep;
> 
> @@ -1129,17 +1127,11 @@ spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
> 
>  	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> 
> -	if (__drop_large_spte(kvm, sptep)) {
> -		*flush |= true;
> -		return true;
> -	}
> -
>  	if (pt_protect)
>  		spte &= ~SPTE_MMU_WRITEABLE;
>  	spte = spte & ~PT_WRITABLE_MASK;
> 
> -	*flush |= mmu_spte_update(sptep, spte);
> -	return false;
> +	return mmu_spte_update(sptep, spte);
>  }
> 
>  static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
> @@ -1151,11 +1143,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
> 
>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> -		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
> -			sptep = rmap_get_first(*rmapp, &iter);
> -			continue;
> -		}
> 
> +		flush |= spte_write_protect(kvm, sptep, pt_protect);
>  		sptep = rmap_get_next(&iter);
>  	}
> 
> @@ -2611,6 +2600,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  			break;
>  		}
> 
> +		drop_large_spte(vcpu, iterator.sptep);
> +
>  		if (!is_shadow_present_pte(*iterator.sptep)) {
>  			u64 base_addr = iterator.addr;
> 
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
