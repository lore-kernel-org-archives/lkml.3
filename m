Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3CQPCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab3CQPCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:02:44 -0400
Date: Sun, 17 Mar 2013 17:02:39 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: fast invalid all mmio sptes
Message-ID: <20130317150239.GM11223@redhat.com>
References: <51433D98.4050605@linux.vnet.ibm.com>
 <51433E71.2070107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51433E71.2070107@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 11:29:53PM +0800, Xiao Guangrong wrote:
> This patch tries to introduce a very simple and scale way to invalid all
> mmio sptes - it need not walk any shadow pages and hold mmu-lock
> 
> KVM maintains a global mmio invalid generation-number which is stored in
> kvm->arch.mmio_invalid_gen and every mmio spte stores the current global
> generation-number into his available bits when it is created
> 
> When KVM need zap all mmio sptes, it just simply increase the global
> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
> then it walks the shadow page table and get the mmio spte. If the
> generation-number on the spte does not equal the global generation-number,
> it will go to the normal #PF handler to update the mmio spte
> 
> Since 19 bits are used to store generation-number on mmio spte, the
> generation-number can be round after 33554432 times. It is large enough
> for nearly all most cases, but making the code be more strong, we zap all
> shadow pages when the number is round
> 
Very nice idea, but why drop Takuya patches instead of using
kvm_mmu_zap_mmio_sptes() when generation number overflows.


> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 +
>  arch/x86/kvm/mmu.c              |   61 +++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/mmutrace.h         |   17 +++++++++++
>  arch/x86/kvm/paging_tmpl.h      |    7 +++-
>  arch/x86/kvm/vmx.c              |    4 ++
>  arch/x86/kvm/x86.c              |    6 +--
>  6 files changed, 82 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ef7f4a5..572398e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -529,6 +529,7 @@ struct kvm_arch {
>  	unsigned int n_requested_mmu_pages;
>  	unsigned int n_max_mmu_pages;
>  	unsigned int indirect_shadow_pages;
> +	unsigned int mmio_invalid_gen;
Why invalid? Should be mmio_valid_gen or mmio_current_get.

>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>  	/*
>  	 * Hash table of struct kvm_mmu_page.
> @@ -765,6 +766,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
>  void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot,
>  				     gfn_t gfn_offset, unsigned long mask);
> +void kvm_mmu_invalid_mmio_spte(struct kvm *kvm);
Agree with Takuya that kvm_mmu_invalidate_mmio_sptes() is a better name.

>  void kvm_mmu_zap_all(struct kvm *kvm);
>  unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
>  void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 13626f4..7093a92 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -234,12 +234,13 @@ static unsigned int get_mmio_spte_generation(u64 spte)
>  static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
>  			   unsigned access)
>  {
> -	u64 mask = generation_mmio_spte_mask(0);
> +	unsigned int gen = ACCESS_ONCE(kvm->arch.mmio_invalid_gen);
> +	u64 mask = generation_mmio_spte_mask(gen);
> 
>  	access &= ACC_WRITE_MASK | ACC_USER_MASK;
>  	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;
> 
> -	trace_mark_mmio_spte(sptep, gfn, access, 0);
> +	trace_mark_mmio_spte(sptep, gfn, access, gen);
>  	mmu_spte_set(sptep, mask);
>  }
> 
> @@ -269,6 +270,34 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
>  	return false;
>  }
> 
> +static bool check_mmio_spte(struct kvm *kvm, u64 spte)
> +{
> +	return get_mmio_spte_generation(spte) ==
> +		ACCESS_ONCE(kvm->arch.mmio_invalid_gen);
> +}
> +
> +/*
> + * The caller should protect concurrent access on
> + * kvm->arch.mmio_invalid_gen. Currently, it is used by
> + * kvm_arch_commit_memory_region and protected by kvm->slots_lock.
> + */
> +void kvm_mmu_invalid_mmio_spte(struct kvm *kvm)
> +{
> +	/* Ensure update memslot has been completed. */
> +	smp_mb();
What barrier this one is paired with?

> +
> +	 trace_kvm_mmu_invalid_mmio_spte(kvm);
Something wrong with indentation.

> +
> +	/*
> +	 * The very rare case: if the generation-number is round,
> +	 * zap all shadow pages.
> +	 */
> +	if (unlikely(kvm->arch.mmio_invalid_gen++ == MAX_GEN)) {
> +		kvm->arch.mmio_invalid_gen = 0;
> +		return kvm_mmu_zap_all(kvm);
> +	}
> +}
> +
>  static inline u64 rsvd_bits(int s, int e)
>  {
>  	return ((1ULL << (e - s + 1)) - 1) << s;
> @@ -3183,9 +3212,12 @@ static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
>  }
> 
>  /*
> - * If it is a real mmio page fault, return 1 and emulat the instruction
> - * directly, return 0 to let CPU fault again on the address, -1 is
> - * returned if bug is detected.
> + * Return value:
> + * 2: invalid spte is detected then let the real page fault path
> + *    update the mmio spte.
> + * 1: it is a real mmio page fault, emulate the instruction directly.
> + * 0: let CPU fault again on the address.
> + * -1: bug is detected.
>   */
What about dropping spte and let guest re-fault instead of propagating
new return value up the call chain. If this is slow lets at least define
a enum with descriptive names.

>  int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  {
> @@ -3200,6 +3232,9 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  		gfn_t gfn = get_mmio_spte_gfn(spte);
>  		unsigned access = get_mmio_spte_access(spte);
> 
> +		if (unlikely(!check_mmio_spte(vcpu->kvm, spte)))
> +			return 2;
> +
>  		if (direct)
>  			addr = 0;
> 
> @@ -3241,8 +3276,12 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
> 
>  	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
> 
> -	if (unlikely(error_code & PFERR_RSVD_MASK))
> -		return handle_mmio_page_fault(vcpu, gva, error_code, true);
> +	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +		r = handle_mmio_page_fault(vcpu, gva, error_code, true);
> +
> +		if (likely(r != 2))
> +			return r;
> +	}
> 
>  	r = mmu_topup_memory_caches(vcpu);
>  	if (r)
> @@ -3318,8 +3357,12 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
>  	ASSERT(vcpu);
>  	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
> 
> -	if (unlikely(error_code & PFERR_RSVD_MASK))
> -		return handle_mmio_page_fault(vcpu, gpa, error_code, true);
> +	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +		r = handle_mmio_page_fault(vcpu, gpa, error_code, true);
> +
> +		if (likely(r != 2))
> +			return r;
> +	}
> 
>  	r = mmu_topup_memory_caches(vcpu);
>  	if (r)
> diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
> index f5b62a7..811254c 100644
> --- a/arch/x86/kvm/mmutrace.h
> +++ b/arch/x86/kvm/mmutrace.h
> @@ -276,6 +276,23 @@ TRACE_EVENT(
>  		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
>  	)
>  );
> +
> +TRACE_EVENT(
> +	kvm_mmu_invalid_mmio_spte,
> +	TP_PROTO(struct kvm *kvm),
> +	TP_ARGS(kvm),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, mmio_invalid_gen)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->mmio_invalid_gen = kvm->arch.mmio_invalid_gen;
> +	),
> +
> +	TP_printk("mmio_invalid_gen %x", __entry->mmio_invalid_gen
> +	)
> +);
>  #endif /* _TRACE_KVMMMU_H */
> 
>  #undef TRACE_INCLUDE_PATH
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 2c48e5f..c81f949 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -552,9 +552,12 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
> 
>  	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
> 
> -	if (unlikely(error_code & PFERR_RSVD_MASK))
> -		return handle_mmio_page_fault(vcpu, addr, error_code,
> +	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +		r = handle_mmio_page_fault(vcpu, addr, error_code,
>  					      mmu_is_nested(vcpu));
> +		if (likely(r != 2))
> +			return r;
> +	};
> 
>  	r = mmu_topup_memory_caches(vcpu);
>  	if (r)
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 54fdb76..ca8e9a3 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5159,6 +5159,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  	if (likely(ret == 1))
>  		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
>  					      EMULATE_DONE;
> +
> +	if (unlikely(ret == 2))
> +		return kvm_mmu_page_fault(vcpu, gpa, 0, NULL, 0);
> +
>  	if (unlikely(!ret))
>  		return 1;
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 81fb3c3..5b6d2a0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6996,10 +6996,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  	 * If memory slot is created, or moved, we need to clear all
>  	 * mmio sptes.
>  	 */
> -	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
> -		kvm_mmu_zap_all(kvm);
> -		kvm_reload_remote_mmus(kvm);
> -	}
> +	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE))
> +		kvm_mmu_invalid_mmio_spte(kvm);
>  }
> 
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
> -- 
> 1.7.7.6

--
			Gleb.
