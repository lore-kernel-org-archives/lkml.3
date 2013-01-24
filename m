Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3AXKg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:36:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab3AXKgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:36:08 -0500
Date: Thu, 24 Jan 2013 12:36:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/12] KVM: MMU: introduce vcpu_adjust_access
Message-ID: <20130124103604.GW31120@redhat.com>
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
 <50FFB62C.4070808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFB62C.4070808@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 06:06:36PM +0800, Xiao Guangrong wrote:
> Introduce it to split the code of adjusting pte_access from the large
> function of set_spte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   63 +++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 40 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index af8bcb2..43b7e0c 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2324,25 +2324,18 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>  	return 0;
>  }
> 
> -static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> -		    unsigned pte_access, int level,
> -		    gfn_t gfn, pfn_t pfn, bool speculative,
> -		    bool can_unsync, bool host_writable)
> +/*
> + * Return -1 if a race condition is detected, 1 if @gfn need to be
> + * write-protected, otherwise 0 is returned.
> + */
That's a little bit crafty.

Isn't it better to handle race condition in set_spte() explicitly?
Something like do:

 if (host_writable && (pte_access & ACC_WRITE_MASK) &&
        level > PT_PAGE_TABLE_LEVEL && has_wrprotected_page(vcpu->kvm, gfn, level))
    return 0;

before calling vcpu_adjust_access() in set_spte()?

Or even do:

 if ((pte_access & ACC_WRITE_MASK) && level > PT_PAGE_TABLE_LEVEL &&
           has_wrprotected_page(vcpu->kvm, gfn, level))
    return 0;

After calling vcpu_adjust_access().

The later will create read only large page mapping where now it is not
created, but it shouldn't be a problem as far as I see.

> +static int vcpu_adjust_access(struct kvm_vcpu *vcpu, u64 *sptep,
> +			      unsigned *pte_access, int level, gfn_t gfn,
> +			      bool can_unsync, bool host_writable)
>  {
> -	u64 spte;
> -	int ret = 0;
> -
> -	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
> -		return 0;
> +	if (!host_writable)
> +		*pte_access &= ~ACC_WRITE_MASK;
> 
> -	spte = PT_PRESENT_MASK;
> -
> -	if (host_writable)
> -		spte |= SPTE_HOST_WRITEABLE;
> -	else
> -		pte_access &= ~ACC_WRITE_MASK;
> -
> -	if (pte_access & ACC_WRITE_MASK) {
> +	if (*pte_access & ACC_WRITE_MASK) {
>  		/*
>  		 * Other vcpu creates new sp in the window between
>  		 * mapping_level() and acquiring mmu-lock. We can
> @@ -2351,7 +2344,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		 */
>  		if (level > PT_PAGE_TABLE_LEVEL &&
>  		      has_wrprotected_page(vcpu->kvm, gfn, level))
> -			goto done;
> +			return -1;
> 
>  		/*
>  		 * Optimization: for pte sync, if spte was writable the hash
> @@ -2360,17 +2353,41 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		 * Same reasoning can be applied to dirty page accounting.
>  		 */
>  		if (!can_unsync && is_writable_pte(*sptep))
> -			goto out_access_adjust;
> +			return 0;
> 
>  		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
>  			pgprintk("%s: found shadow page for %llx, marking ro\n",
>  				 __func__, gfn);
> -			ret = 1;
> -			pte_access &= ~ACC_WRITE_MASK;
> +
> +			*pte_access &= ~ACC_WRITE_MASK;
> +			return 1;
>  		}
>  	}
> 
> -out_access_adjust:
> +	return 0;
> +}
> +
> +static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> +		    unsigned pte_access, int level,
> +		    gfn_t gfn, pfn_t pfn, bool speculative,
> +		    bool can_unsync, bool host_writable)
> +{
> +	u64 spte;
> +	int ret;
> +
> +	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
> +		return 0;
> +
> +	ret = vcpu_adjust_access(vcpu, sptep, &pte_access, level, gfn,
> +				 can_unsync, host_writable);
> +	if (ret < 0)
> +		return 0;
> +
> +	spte = PT_PRESENT_MASK;
> +
> +	if (host_writable)
> +		spte |= SPTE_HOST_WRITEABLE;
> +
>  	if (!speculative)
>  		spte |= shadow_accessed_mask;
> 
> @@ -2399,7 +2416,7 @@ out_access_adjust:
> 
>  	if (mmu_spte_update(sptep, spte))
>  		kvm_flush_remote_tlbs(vcpu->kvm);
> -done:
> +
>  	return ret;
>  }
> 
> -- 
> 1.7.7.6

--
			Gleb.
