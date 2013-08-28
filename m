Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3H1JUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:20:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3H1JUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:20:16 -0400
Date: Wed, 28 Aug 2013 12:20:01 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130828092001.GQ22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:02:07PM +0800, Xiao Guangrong wrote:
> The basic idea is from nulls list which uses a nulls to indicate
> whether the desc is moved to different pte-list
> 
> Thanks to SLAB_DESTROY_BY_RCU, the desc can be quickly reused
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 36caf6a..f8fc0cc 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1010,6 +1010,14 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  		desc->sptes[0] = (u64 *)*pte_list;
>  		desc->sptes[1] = spte;
>  		desc_mark_nulls(pte_list, desc);
> +
> +		/*
> +		 * Esure the old spte has been updated into desc, so
> +		 * that the another side can not get the desc from pte_list
> +		 * but miss the old spte.
> +		 */
> +		smp_wmb();
> +
>  		*pte_list = (unsigned long)desc | 1;
>  		return 1;
>  	}
> @@ -1131,6 +1139,47 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
>  	WARN_ON(desc_get_nulls_value(desc) != pte_list);
>  }
>  
> +/* The caller should hold rcu lock. */
> +typedef void (*pte_list_walk_lockless_fn) (u64 *spte, int level);
> +static void pte_list_walk_lockless(unsigned long *pte_list,
> +				   pte_list_walk_lockless_fn fn, int level)
> +{
> +	struct pte_list_desc *desc;
> +	unsigned long pte_list_value;
> +	int i;
> +
> +restart:
> +	pte_list_value = ACCESS_ONCE(*pte_list);
> +	if (!pte_list_value)
> +		return;
> +
> +	if (!(pte_list_value & 1))
> +		return fn((u64 *)pte_list_value, level);
> +
> +	/*
> +	 * fetch pte_list before read sptes in the desc, see the comments
> +	 * in pte_list_add().
> +	 *
> +	 * There is the data dependence since the desc is got from pte_list.
> +	 */
> +	smp_read_barrier_depends();
> +
> +	desc = (struct pte_list_desc *)(pte_list_value & ~1ul);
> +	while (!desc_is_a_nulls(desc)) {
> +		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
> +			fn(desc->sptes[i], level);
> +
> +		desc = ACCESS_ONCE(desc->more);
> +
> +		/* It is being initialized. */
> +		if (unlikely(!desc))
> +			goto restart;
> +	}
> +
> +	if (unlikely(desc_get_nulls_value(desc) != pte_list))
> +		goto restart;
So is it really enough to guaranty safety and correctness? What if desc
is moved to another rmap while we walking it so fn() is called on
incorrect sptes? Or what if desc is moved to another rmap, but then it
is moved back to initial rmap (but another place in the desc list) so
the check here will not catch that we need to restart walking?


> +}
> +
>  static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
>  				    struct kvm_memory_slot *slot)
>  {
> @@ -4557,7 +4606,7 @@ int kvm_mmu_module_init(void)
>  {
>  	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
>  					    sizeof(struct pte_list_desc),
> -					    0, 0, NULL);
> +					    0, SLAB_DESTROY_BY_RCU, NULL);
>  	if (!pte_list_desc_cache)
>  		goto nomem;
>  
> -- 
> 1.8.1.4

--
			Gleb.
