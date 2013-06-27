Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3F0I33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:29:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3F0I3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:29:25 -0400
Date: Thu, 27 Jun 2013 11:29:00 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 4/6] KVM: MMU: fast invalidate all mmio sptes
Message-ID: <20130627082900.GD18508@redhat.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1370595088-3315-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370595088-3315-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:51:26PM +0800, Xiao Guangrong wrote:
> This patch tries to introduce a very simple and scale way to invalidate
> all mmio sptes - it need not walk any shadow pages and hold mmu-lock
> 
> KVM maintains a global mmio valid generation-number which is stored in
> kvm->memslots.generation and every mmio spte stores the current global
> generation-number into his available bits when it is created
> 
> When KVM need zap all mmio sptes, it just simply increase the global
> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
> then it walks the shadow page table and get the mmio spte. If the
> generation-number on the spte does not equal the global generation-number,
> it will go to the normal #PF handler to update the mmio spte
> 
> Since 19 bits are used to store generation-number on mmio spte, we zap all
> mmio sptes when the number is round
> 
So this commit makes Fedora 9 32 bit reboot during boot, Fedora 9 64
fails too, but I haven't checked what happens exactly.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu.c              | 54 +++++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/mmu.h              |  5 +++-
>  arch/x86/kvm/paging_tmpl.h      |  7 ++++--
>  arch/x86/kvm/vmx.c              |  4 +++
>  arch/x86/kvm/x86.c              |  3 +--
>  6 files changed, 61 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1f98c1b..90d05ed 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -773,7 +773,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot,
>  				     gfn_t gfn_offset, unsigned long mask);
>  void kvm_mmu_zap_all(struct kvm *kvm);
> -void kvm_mmu_zap_mmio_sptes(struct kvm *kvm);
> +void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm);
>  unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
>  void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
>  
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 044d8c0..bdc95bc 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -205,9 +205,11 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>  #define MMIO_SPTE_GEN_LOW_SHIFT		3
>  #define MMIO_SPTE_GEN_HIGH_SHIFT	52
>  
> +#define MMIO_GEN_SHIFT			19
>  #define MMIO_GEN_LOW_SHIFT		9
>  #define MMIO_GEN_LOW_MASK		((1 << MMIO_GEN_LOW_SHIFT) - 1)
> -#define MMIO_MAX_GEN			((1 << 19) - 1)
> +#define MMIO_GEN_MASK			((1 << MMIO_GEN_SHIFT) - 1)
> +#define MMIO_MAX_GEN			((1 << MMIO_GEN_SHIFT) - 1)
>  
>  static u64 generation_mmio_spte_mask(unsigned int gen)
>  {
> @@ -231,17 +233,23 @@ static unsigned int get_mmio_spte_generation(u64 spte)
>  	return gen;
>  }
>  
> +static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
> +{
> +	return kvm_memslots(kvm)->generation & MMIO_GEN_MASK;
> +}
> +
>  static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
>  			   unsigned access)
>  {
>  	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
> -	u64 mask = generation_mmio_spte_mask(0);
> +	unsigned int gen = kvm_current_mmio_generation(kvm);
> +	u64 mask = generation_mmio_spte_mask(gen);
>  
>  	access &= ACC_WRITE_MASK | ACC_USER_MASK;
>  	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;
>  	sp->mmio_cached = true;
>  
> -	trace_mark_mmio_spte(sptep, gfn, access, 0);
> +	trace_mark_mmio_spte(sptep, gfn, access, gen);
>  	mmu_spte_set(sptep, mask);
>  }
>  
> @@ -271,6 +279,12 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
>  	return false;
>  }
>  
> +static bool check_mmio_spte(struct kvm *kvm, u64 spte)
> +{
> +	return likely(get_mmio_spte_generation(spte) ==
> +			kvm_current_mmio_generation(kvm));
> +}
> +
>  static inline u64 rsvd_bits(int s, int e)
>  {
>  	return ((1ULL << (e - s + 1)) - 1) << s;
> @@ -3235,6 +3249,9 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  		gfn_t gfn = get_mmio_spte_gfn(spte);
>  		unsigned access = get_mmio_spte_access(spte);
>  
> +		if (!check_mmio_spte(vcpu->kvm, spte))
> +			return RET_MMIO_PF_INVALID;
> +
>  		if (direct)
>  			addr = 0;
>  
> @@ -3276,8 +3293,12 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
>  
>  	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
>  
> -	if (unlikely(error_code & PFERR_RSVD_MASK))
> -		return handle_mmio_page_fault(vcpu, gva, error_code, true);
> +	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +		r = handle_mmio_page_fault(vcpu, gva, error_code, true);
> +
> +		if (likely(r != RET_MMIO_PF_INVALID))
> +			return r;
> +	}
>  
>  	r = mmu_topup_memory_caches(vcpu);
>  	if (r)
> @@ -3353,8 +3374,12 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
>  	ASSERT(vcpu);
>  	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
>  
> -	if (unlikely(error_code & PFERR_RSVD_MASK))
> -		return handle_mmio_page_fault(vcpu, gpa, error_code, true);
> +	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +		r = handle_mmio_page_fault(vcpu, gpa, error_code, true);
> +
> +		if (likely(r != RET_MMIO_PF_INVALID))
> +			return r;
> +	}
>  
>  	r = mmu_topup_memory_caches(vcpu);
>  	if (r)
> @@ -4327,7 +4352,7 @@ void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
>  	spin_unlock(&kvm->mmu_lock);
>  }
>  
> -void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
> +static void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *sp, *node;
>  	LIST_HEAD(invalid_list);
> @@ -4350,6 +4375,19 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>  	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
>  }
>  
> +void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
> +{
> +	/*
> +	 * The very rare case: if the generation-number is round,
> +	 * zap all shadow pages.
> +	 *
> +	 * The max value is MMIO_MAX_GEN - 1 since it is not called
> +	 * when mark memslot invalid.
> +	 */
> +	if (unlikely(kvm_current_mmio_generation(kvm) >= (MMIO_MAX_GEN - 1)))
> +		kvm_mmu_zap_mmio_sptes(kvm);
> +}
> +
>  static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct kvm *kvm;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index ba6a19c..5b59c57 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -56,12 +56,15 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
>  /*
>   * Return values of handle_mmio_page_fault_common:
>   * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
> - *			 directly.
> + *			directly.
> + * RET_MMIO_PF_INVALID: invalid spte is detected then let the real page
> + *			fault path update the mmio spte.
>   * RET_MMIO_PF_RETRY: let CPU fault again on the address.
>   * RET_MMIO_PF_BUG: bug is detected.
>   */
>  enum {
>  	RET_MMIO_PF_EMULATE = 1,
> +	RET_MMIO_PF_INVALID = 2,
>  	RET_MMIO_PF_RETRY = 0,
>  	RET_MMIO_PF_BUG = -1
>  };
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index fb50fa6..7769699 100644
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
> +		if (likely(r != RET_MMIO_PF_INVALID))
> +			return r;
> +	};
>  
>  	r = mmu_topup_memory_caches(vcpu);
>  	if (r)
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 85c8d51..f4a5b3f 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5369,6 +5369,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  	if (likely(ret == RET_MMIO_PF_EMULATE))
>  		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
>  					      EMULATE_DONE;
> +
> +	if (unlikely(ret == RET_MMIO_PF_INVALID))
> +		return kvm_mmu_page_fault(vcpu, gpa, 0, NULL, 0);
> +
>  	if (unlikely(ret == RET_MMIO_PF_RETRY))
>  		return 1;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 54059ba..9e4afa7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7067,8 +7067,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  	 * If memory slot is created, or moved, we need to clear all
>  	 * mmio sptes.
>  	 */
> -	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE))
> -		kvm_mmu_zap_mmio_sptes(kvm);
> +	kvm_mmu_invalidate_mmio_sptes(kvm);
>  }
>  
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
> -- 
> 1.8.1.4

--
			Gleb.
