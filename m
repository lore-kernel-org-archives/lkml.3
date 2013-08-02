Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3HBOz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3HBOz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:55:58 -0400
Date: Fri, 2 Aug 2013 11:55:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 03/12] KVM: MMU: lazily drop large spte
Message-ID: <20130802145524.GA3501@amt.cnet>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375189330-24066-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:02:01PM +0800, Xiao Guangrong wrote:
> Currently, kvm zaps the large spte if write-protected is needed, the later
> read can fault on that spte. Actually, we can make the large spte readonly
> instead of making them un-present, the page fault caused by read access can
> be avoided
> 
> The idea is from Avi:
> | As I mentioned before, write-protecting a large spte is a good idea,
> | since it moves some work from protect-time to fault-time, so it reduces
> | jitter.  This removes the need for the return value.
> 
> [
>   It has fixed the issue reported in 6b73a9606 by stopping fast page fault
>   marking the large spte to writable
> ]

Xiao,

Can you please write a comment explaining why are the problems 
with shadow vs large read-only sptes (can't recall anymore),
and then why it is now safe to do it.

Comments below.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index cf163ca..35d4b50 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1181,8 +1181,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>  
>  /*
>   * Write-protect on the specified @sptep, @pt_protect indicates whether
> - * spte writ-protection is caused by protecting shadow page table.
> - * @flush indicates whether tlb need be flushed.
> + * spte write-protection is caused by protecting shadow page table.
>   *
>   * Note: write protection is difference between drity logging and spte
>   * protection:
> @@ -1191,10 +1190,9 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
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
> @@ -1204,17 +1202,11 @@ spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
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
> @@ -1226,11 +1218,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
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
> @@ -2701,6 +2690,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  			break;
>  		}
>  
> +		drop_large_spte(vcpu, iterator.sptep);
> +
>  		if (!is_shadow_present_pte(*iterator.sptep)) {
>  			u64 base_addr = iterator.addr;
>  
> @@ -2855,7 +2846,7 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   * - false: let the real page fault path to fix it.
>   */
>  static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
> -			    u32 error_code)
> +			    u32 error_code, bool force_pt_level)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
>  	struct kvm_mmu_page *sp;
> @@ -2884,6 +2875,13 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
>  		goto exit;
>  
>  	/*
> +	 * Can not map the large spte to writable if the page is dirty
> +	 * logged.
> +	 */
> +	if (sp->role.level > PT_PAGE_TABLE_LEVEL && force_pt_level)
> +		goto exit;
> +

It is not safe to derive slot->dirty_bitmap like this: 
since dirty log is enabled via RCU update, "is dirty bitmap enabled"
info could be stale by the time you check it here via the parameter,
so you can instantiate a large spte (because force_pt_level == false),
while you should not.


