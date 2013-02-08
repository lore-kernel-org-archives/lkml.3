Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947264Ab3BHVtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:49:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947217Ab3BHVtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:49:50 -0500
Date: Fri, 8 Feb 2013 19:48:07 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] KVM: MMU: fast drop all spte on the pte_list
Message-ID: <20130208214807.GC26159@amt.cnet>
References: <5110C853.4080705@linux.vnet.ibm.com>
 <5110C909.1000502@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110C909.1000502@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:55:37PM +0800, Xiao Guangrong wrote:
> If a shadow page is being zapped or a host page is going to be freed, kvm
> will drop all the reverse-mappings on the shadow page or the gfn. Currently,
> it drops the reverse-mapping one by one - it deletes the first reverse mapping,
> then moves other reverse-mapping between the description-table. When the
> last description-table become empty, it will be freed.
> 
> It works well if we only have a few reverse-mappings, but some pte_lists are
> very long, during my tracking, i saw some gfns have more than 200 sptes listed
> on its pte-list (1G memory in guest on softmmu). Optimization for dropping such
> long pte-list is worthwhile, at lease it is good for deletion memslots and
> ksm/thp merge pages.
> 
> This patch introduce a better way to optimize for this case, it walks all the
> reverse-mappings and clear them, then free all description-tables together.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   36 +++++++++++++++++++++++++++---------
>  1 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 58f813a..aa7a887 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -945,6 +945,25 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
>  	}
>  }
> 
> +static void pte_list_destroy(unsigned long *pte_list)
> +{
> +	struct pte_list_desc *desc;
> +	unsigned long list_value = *pte_list;
> +
> +	*pte_list = 0;
> +
> +	if (!(list_value & 1))
> +		return;
> +
> +	desc = (struct pte_list_desc *)(list_value & ~1ul);
> +	while (desc) {
> +		struct pte_list_desc *next_desc = desc->more;
> +
> +		mmu_free_pte_list_desc(desc);
> +		desc = next_desc;
> +	}
> +}
> +
>  /*
>   * Used by the following functions to iterate through the sptes linked by a
>   * pte_list.  All fields are private and not assumed to be used outside.
> @@ -1183,17 +1202,17 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
>  static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
>  			   struct kvm_memory_slot *slot, unsigned long data)
>  {
> -	u64 *sptep;
>  	struct pte_list_iterator iter;
> +	u64 *sptep;
>  	int need_tlb_flush = 0;
> 
> -restart:
>  	for_each_spte_in_rmap(*rmapp, iter, sptep) {
> -		drop_spte(kvm, sptep);
> +		mmu_spte_clear_track_bits(sptep);
>  		need_tlb_flush = 1;
> -		goto restart;
>  	}
> 
> +	pte_list_destroy(rmapp);
> +
>  	return need_tlb_flush;
>  }
> 
> @@ -2016,11 +2035,10 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	u64 *sptep;
>  	struct pte_list_iterator iter;
> 
> -restart:
> -	for_each_spte_in_pte_list(sp->parent_ptes, iter, sptep) {
> -		drop_parent_pte(sp, sptep);
> -		goto restart;
> -	}
> +	for_each_spte_in_pte_list(sp->parent_ptes, iter, sptep)
> +		mmu_spte_clear_no_track(sptep);
> +
> +	pte_list_destroy(&sp->parent_ptes);
>  }

Do we lose the crash information of pte_list_remove? 
It has been shown to be useful in several cases.

