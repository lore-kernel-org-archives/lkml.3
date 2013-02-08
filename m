Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947279Ab3BHVua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:50:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947234Ab3BHVtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:49:51 -0500
Date: Fri, 8 Feb 2013 19:35:34 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] KVM: MMU: introduce mmu_spte_establish
Message-ID: <20130208213534.GB26159@amt.cnet>
References: <5110C853.4080705@linux.vnet.ibm.com>
 <5110C87F.7020601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110C87F.7020601@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:53:19PM +0800, Xiao Guangrong wrote:
> There is little different between walking parent pte and walking ramp:
> all spte in rmap must be present but this is not true on parent pte list,
> in kvm_mmu_alloc_page, we always link the parent list before set the spte
> to present
> 
> This patch introduce mmu_spte_establish which set the spte before linking
> it to parent list to eliminates the different then it is possible to unify
> the code of walking pte list
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |   81 ++++++++++++++++++++++---------------------
>  arch/x86/kvm/paging_tmpl.h |   16 ++++-----
>  2 files changed, 48 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 8041454..68d4d5f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1482,9 +1482,6 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
>  static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
>  				    struct kvm_mmu_page *sp, u64 *parent_pte)
>  {
> -	if (!parent_pte)
> -		return;
> -
>  	pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
>  }
> 
> @@ -1502,7 +1499,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
>  }
> 
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
> -					       u64 *parent_pte, int direct)
> +					       int direct)
>  {
>  	struct kvm_mmu_page *sp;
>  	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> @@ -1512,7 +1509,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
>  	sp->parent_ptes = 0;
> -	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
>  	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
>  	return sp;
>  }
> @@ -1845,8 +1841,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  					     gva_t gaddr,
>  					     unsigned level,
>  					     int direct,
> -					     unsigned access,
> -					     u64 *parent_pte)
> +					     unsigned access)
>  {
>  	union kvm_mmu_page_role role;
>  	unsigned quadrant;
> @@ -1876,19 +1871,15 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  		if (sp->unsync && kvm_sync_page_transient(vcpu, sp))
>  			break;
> 
> -		mmu_page_add_parent_pte(vcpu, sp, parent_pte);
> -		if (sp->unsync_children) {
> +		if (sp->unsync_children)
>  			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> -			kvm_mmu_mark_parents_unsync(sp);
> -		} else if (sp->unsync)
> -			kvm_mmu_mark_parents_unsync(sp);
> 
>  		__clear_sp_write_flooding_count(sp);
>  		trace_kvm_mmu_get_page(sp, false);
>  		return sp;
>  	}
>  	++vcpu->kvm->stat.mmu_cache_miss;
> -	sp = kvm_mmu_alloc_page(vcpu, parent_pte, direct);
> +	sp = kvm_mmu_alloc_page(vcpu, direct);
>  	if (!sp)
>  		return sp;
>  	sp->gfn = gfn;
> @@ -1908,6 +1899,35 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	return sp;
>  }
> 
> +static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
> +{
> +	u64 spte;
> +
> +	spte = __pa(sp->spt) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
> +	       shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
> +
> +	mmu_spte_set(sptep, spte);
> +}
> +
> +static struct kvm_mmu_page *
> +mmu_spte_establish(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, gva_t gaddr,
> +		   unsigned level, int direct, unsigned access)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	WARN_ON(is_shadow_present_pte(*spte));
> +
> +	sp = kvm_mmu_get_page(vcpu, gfn, gaddr, level, direct, access);
> +
> +	link_shadow_page(spte, sp);
> +	mmu_page_add_parent_pte(vcpu, sp, spte);
> +
> +	if (sp->unsync_children || sp->unsync)
> +		kvm_mmu_mark_parents_unsync(sp);
> +
> +	return sp;
> +}
> +
>  static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
>  			     struct kvm_vcpu *vcpu, u64 addr)
>  {
> @@ -1957,16 +1977,6 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
>  	return __shadow_walk_next(iterator, *iterator->sptep);
>  }
> 
> -static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
> -{
> -	u64 spte;
> -
> -	spte = __pa(sp->spt) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
> -	       shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
> -
> -	mmu_spte_set(sptep, spte);
> -}
> -
>  static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  				   unsigned direct_access)
>  {
> @@ -2023,11 +2033,6 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
>  		mmu_page_zap_pte(kvm, sp, sp->spt + i);
>  }
> 
> -static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
> -{
> -	mmu_page_remove_parent_pte(sp, parent_pte);
> -}
> -
>  static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	u64 *sptep;
> @@ -2582,9 +2587,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  			bool prefault)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
> -	struct kvm_mmu_page *sp;
>  	int emulate = 0;
> -	gfn_t pseudo_gfn;
> 
>  	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
>  		if (iterator.level == level) {
> @@ -2602,12 +2605,11 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  			u64 base_addr = iterator.addr;
> 
>  			base_addr &= PT64_LVL_ADDR_MASK(iterator.level);
> -			pseudo_gfn = base_addr >> PAGE_SHIFT;
> -			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
> -					      iterator.level - 1,
> -					      1, ACC_ALL, iterator.sptep);
> +			mmu_spte_establish(vcpu, iterator.sptep,
> +					   gpa_to_gfn(base_addr),
> +					   iterator.addr, iterator.level - 1,
> +					   1, ACC_ALL);
> 
> -			link_shadow_page(iterator.sptep, sp);
>  		}
>  	}
>  	return emulate;
> @@ -2926,7 +2928,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  		spin_lock(&vcpu->kvm->mmu_lock);
>  		kvm_mmu_free_some_pages(vcpu);
>  		sp = kvm_mmu_get_page(vcpu, 0, 0, PT64_ROOT_LEVEL,
> -				      1, ACC_ALL, NULL);
> +				      1, ACC_ALL);
>  		++sp->root_count;
>  		spin_unlock(&vcpu->kvm->mmu_lock);
>  		vcpu->arch.mmu.root_hpa = __pa(sp->spt);
> @@ -2939,8 +2941,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  			kvm_mmu_free_some_pages(vcpu);
>  			sp = kvm_mmu_get_page(vcpu, i << (30 - PAGE_SHIFT),
>  					      i << 30,
> -					      PT32_ROOT_LEVEL, 1, ACC_ALL,
> -					      NULL);
> +					      PT32_ROOT_LEVEL, 1, ACC_ALL);
>  			root = __pa(sp->spt);
>  			++sp->root_count;
>  			spin_unlock(&vcpu->kvm->mmu_lock);
> @@ -2977,7 +2978,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  		spin_lock(&vcpu->kvm->mmu_lock);
>  		kvm_mmu_free_some_pages(vcpu);
>  		sp = kvm_mmu_get_page(vcpu, root_gfn, 0, PT64_ROOT_LEVEL,
> -				      0, ACC_ALL, NULL);
> +				      0, ACC_ALL);
>  		root = __pa(sp->spt);
>  		++sp->root_count;
>  		spin_unlock(&vcpu->kvm->mmu_lock);
> @@ -3012,7 +3013,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  		kvm_mmu_free_some_pages(vcpu);
>  		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
>  				      PT32_ROOT_LEVEL, 0,
> -				      ACC_ALL, NULL);
> +				      ACC_ALL);
>  		root = __pa(sp->spt);
>  		++sp->root_count;
>  		spin_unlock(&vcpu->kvm->mmu_lock);
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 105dd5b..3605ff7 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -434,8 +434,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  		sp = NULL;
>  		if (!is_shadow_present_pte(*it.sptep)) {
>  			table_gfn = gw->table_gfn[it.level - 2];
> -			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
> -					      false, access, it.sptep);
> +			sp = mmu_spte_establish(vcpu, it.sptep, table_gfn,
> +						addr, it.level-1, false,
> +						access);
>  		}
> 
>  		/*
> @@ -444,9 +445,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  		 */
>  		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
>  			goto out_gpte_changed;
> -
> -		if (sp)
> -			link_shadow_page(it.sptep, sp);
>  	}
> 
>  	for (;
> @@ -464,9 +462,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
> 
>  		direct_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
> 
> -		sp = kvm_mmu_get_page(vcpu, direct_gfn, addr, it.level-1,
> -				      true, direct_access, it.sptep);
> -		link_shadow_page(it.sptep, sp);
> +		mmu_spte_establish(vcpu, it.sptep, direct_gfn, addr,
 +				   it.level-1, true, direct_access);
>  	}
> 
>  	clear_sp_write_flooding_count(it.sptep);
> @@ -478,7 +475,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
> 
>  out_gpte_changed:
>  	if (sp)
> -		kvm_mmu_put_page(sp, it.sptep);
> +		drop_parent_pte(sp, it.sptep);
> +

Unclear why TLB flushing not necessary here (entry it could have been 
added to remote CPU's TLB since it has been linked).
