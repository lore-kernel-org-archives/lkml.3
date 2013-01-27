Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3A0MHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:07:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab3A0MHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:07:03 -0500
Date: Sun, 27 Jan 2013 14:06:57 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/12] KVM: MMU: lazily drop large spte
Message-ID: <20130127120657.GA21650@redhat.com>
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 06:04:17PM +0800, Xiao Guangrong wrote:
> Do not drop large spte until it can be insteaded by small pages so that
> the guest can happliy read memory through it
> 
> The idea is from Avi:
> | As I mentioned before, write-protecting a large spte is a good idea,
> | since it moves some work from protect-time to fault-time, so it reduces
> | jitter.  This removes the need for the return value.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   21 ++++++---------------
>  1 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 9f628f7..0f90269 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1105,7 +1105,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
> 
>  /*
>   * Write-protect on the specified @sptep, @pt_protect indicates whether
> - * spte writ-protection is caused by protecting shadow page table.
> + * spte write-protection is caused by protecting shadow page table.
>   * @flush indicates whether tlb need be flushed.
>   *
>   * Note: write protection is difference between drity logging and spte
> @@ -1114,31 +1114,23 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>   *   its dirty bitmap is properly set.
>   * - for spte protection, the spte can be writable only after unsync-ing
>   *   shadow page.
> - *
> - * Return true if the spte is dropped.
>   */
> -static bool
> +static void
>  spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
Since return value is not longer used make the function return true if flush is needed
instead of returning it via pointer to a variable.

>  {
>  	u64 spte = *sptep;
> 
>  	if (!is_writable_pte(spte) &&
>  	      !(pt_protect && spte_is_locklessly_modifiable(spte)))
> -		return false;
> +		return;
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
>  	*flush |= mmu_spte_update(sptep, spte);
> -	return false;
>  }
> 
>  static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
> @@ -1150,11 +1142,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
> 
>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> -		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
> -			sptep = rmap_get_first(*rmapp, &iter);
> -			continue;
> -		}
> 
> +		spte_write_protect(kvm, sptep, &flush, pt_protect);
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

--
			Gleb.
