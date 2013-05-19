Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3ESKEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 06:04:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3ESKEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 06:04:45 -0400
Date: Sun, 19 May 2013 13:04:39 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/7] KVM: MMU: fast invalidate all pages
Message-ID: <20130519100439.GD4725@redhat.com>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1368738782-18649-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368738782-18649-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 05:12:58AM +0800, Xiao Guangrong wrote:
> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
> walk and zap all shadow pages one by one, also it need to zap all guest
> page's rmap and all shadow page's parent spte list. Particularly, things
> become worse if guest uses more memory or vcpus. It is not good for
> scalability
> 
> In this patch, we introduce a faster way to invalidate all shadow pages.
> KVM maintains a global mmu invalid generation-number which is stored in
> kvm->arch.mmu_valid_gen and every shadow page stores the current global
> generation-number into sp->mmu_valid_gen when it is created
> 
> When KVM need zap all shadow pages sptes, it just simply increase the
> global generation-number then reload root shadow pages on all vcpus.
> Vcpu will create a new shadow page table according to current kvm's
> generation-number. It ensures the old pages are not used any more.
> Then the invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
> are zapped by using lock-break technique
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 +
>  arch/x86/kvm/mmu.c              |  103 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu.h              |    1 +
>  3 files changed, 106 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3741c65..bff7d46 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -222,6 +222,7 @@ struct kvm_mmu_page {
>  	int root_count;          /* Currently serving as active root */
>  	unsigned int unsync_children;
>  	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
> +	unsigned long mmu_valid_gen;
>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
>  
>  #ifdef CONFIG_X86_32
> @@ -529,6 +530,7 @@ struct kvm_arch {
>  	unsigned int n_requested_mmu_pages;
>  	unsigned int n_max_mmu_pages;
>  	unsigned int indirect_shadow_pages;
> +	unsigned long mmu_valid_gen;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>  	/*
>  	 * Hash table of struct kvm_mmu_page.
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 682ecb4..891ad2c 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1839,6 +1839,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
>  	__clear_sp_write_flooding_count(sp);
>  }
>  
> +static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> +}
> +
>  static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  					     gfn_t gfn,
>  					     gva_t gaddr,
> @@ -1865,6 +1870,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  		role.quadrant = quadrant;
>  	}
>  	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
> +		if (is_obsolete_sp(vcpu->kvm, sp))
> +			continue;
> +
>  		if (!need_sync && sp->unsync)
>  			need_sync = true;
>  
> @@ -1901,6 +1909,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  
>  		account_shadowed(vcpu->kvm, gfn);
>  	}
> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>  	init_shadow_page_table(sp);
>  	trace_kvm_mmu_get_page(sp, true);
>  	return sp;
> @@ -2071,8 +2080,10 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>  	kvm_mmu_page_unlink_children(kvm, sp);
>  	kvm_mmu_unlink_parents(kvm, sp);
> +
>  	if (!sp->role.invalid && !sp->role.direct)
>  		unaccount_shadowed(kvm, sp->gfn);
> +
>  	if (sp->unsync)
>  		kvm_unlink_unsync_page(kvm, sp);
>  
> @@ -4196,6 +4207,98 @@ restart:
>  	spin_unlock(&kvm->mmu_lock);
>  }
>  
> +static void kvm_zap_obsolete_pages(struct kvm *kvm)
> +{
> +	struct kvm_mmu_page *sp, *node;
> +	LIST_HEAD(invalid_list);
> +
> +restart:
> +	list_for_each_entry_safe_reverse(sp, node,
> +	      &kvm->arch.active_mmu_pages, link) {
> +		/*
> +		 * No obsolete page exists before new created page since
> +		 * active_mmu_pages is the FIFO list.
> +		 */
> +		if (!is_obsolete_sp(kvm, sp))
> +			break;
> +
> +		/*
> +		 * Do not repeatedly zap a root page to avoid unnecessary
> +		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
> +		 * progress:
> +		 *    vcpu 0                        vcpu 1
> +		 *                         call vcpu_enter_guest():
> +		 *                            1): handle KVM_REQ_MMU_RELOAD
> +		 *                                and require mmu-lock to
> +		 *                                load mmu
> +		 * repeat:
> +		 *    1): zap root page and
> +		 *        send KVM_REQ_MMU_RELOAD
> +		 *
> +		 *    2): if (cond_resched_lock(mmu-lock))
> +		 *
> +		 *                            2): hold mmu-lock and load mmu
> +		 *
> +		 *                            3): see KVM_REQ_MMU_RELOAD bit
> +		 *                                on vcpu->requests is set
> +		 *                                then return 1 to call
> +		 *                                vcpu_enter_guest() again.
> +		 *            goto repeat;
> +		 *
> +		 */
I am not sure why the above scenario will prevent us from progressing.
There is finite number of root pages with invalid generation number, so
eventually we will zap them all and vcpu1 will stop seeing KVM_REQ_MMU_RELOAD
request.

This check here prevent unnecessary KVM_REQ_MMU_RELOAD as you say, but
this races the question, why don't we check for sp->role.invalid in
kvm_mmu_prepare_zap_page before calling kvm_reload_remote_mmus()?
Something like this:

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 40d7b2d..d2ae3a4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2081,7 +2081,8 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 		kvm_mod_used_mmu_pages(kvm, -1);
 	} else {
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
-		kvm_reload_remote_mmus(kvm);
+		if (!sp->role.invalid)
+			kvm_reload_remote_mmus(kvm);
 	}
 
 	sp->role.invalid = 1;

Actually we can add check for is_obsolete_sp() there too since
kvm_mmu_invalidate_all_pages() already calls kvm_reload_remote_mmus()
after incrementing mmu_valid_gen.

Or do I miss something?

> +		if (sp->role.invalid)
> +			continue;
> +		/*
> +		 * Need not flush tlb since we only zap the sp with invalid
> +		 * generation number.
> +		 */
> +		if (cond_resched_lock(&kvm->mmu_lock))
> +			goto restart;
> +
> +		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> +			goto restart;
> +	}
> +
> +	/*
> +	 * Should flush tlb before free page tables since lockless-walking
> +	 * may use the pages.
> +	 */
> +	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> +}
> +
> +/*
> + * Fast invalidate all shadow pages.
> + *
> + * @zap_obsolete_pages indicates whether all the obsolete pages should
> + * be zapped. This is required when memslot is being deleted or VM is
> + * being destroyed, in these cases, we should ensure that KVM MMU does
> + * not use any resource of the being-deleted slot or all slots after
> + * calling the function.
> + *
> + * @zap_obsolete_pages == false means the caller just wants to flush all
> + * shadow page tables.
> + */
> +void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
> +{
> +	spin_lock(&kvm->mmu_lock);
> +	kvm->arch.mmu_valid_gen++;
> +
> +	/*
> +	 * Notify all vcpus to reload its shadow page table
> +	 * and flush TLB. Then all vcpus will switch to new
> +	 * shadow page table with the new mmu_valid_gen.
> +	 *
> +	 * Note: we should do this under the protection of
> +	 * mmu-lock, otherwise, vcpu would purge shadow page
> +	 * but miss tlb flush.
> +	 */
> +	kvm_reload_remote_mmus(kvm);
> +
> +	if (zap_obsolete_pages)
> +		kvm_zap_obsolete_pages(kvm);
> +	spin_unlock(&kvm->mmu_lock);
> +}
> +
>  void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *sp, *node;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 2adcbc2..123d703 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -97,4 +97,5 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
>  	return (mmu->permissions[pfec >> 1] >> pte_access) & 1;
>  }
>  
> +void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages);
>  #endif
> -- 
> 1.7.7.6

--
			Gleb.
