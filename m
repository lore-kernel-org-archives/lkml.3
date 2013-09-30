Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3I3WkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:40:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab3I3WkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:40:19 -0400
Date: Mon, 30 Sep 2013 19:39:57 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 03/15] KVM: MMU: lazily drop large spte
Message-ID: <20130930223957.GA3262@amt.cnet>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1378376958-27252-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378376958-27252-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:29:06PM +0800, Xiao Guangrong wrote:
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
> This version has fixed the issue reported in 6b73a9606, the reason of that
> issue is that fast_page_fault() directly sets the readonly large spte to
> writable but only dirty the first page into the dirty-bitmap that means
> other pages are missed. Fixed it by only the normal sptes (on the
> PT_PAGE_TABLE_LEVEL level) can be fast fixed
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 36 ++++++++++++++++++++----------------
>  arch/x86/kvm/x86.c |  8 ++++++--
>  2 files changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 869f1db..88107ee 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1177,8 +1177,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>  
>  /*
>   * Write-protect on the specified @sptep, @pt_protect indicates whether
> - * spte writ-protection is caused by protecting shadow page table.
> - * @flush indicates whether tlb need be flushed.
> + * spte write-protection is caused by protecting shadow page table.
>   *
>   * Note: write protection is difference between drity logging and spte
>   * protection:
> @@ -1187,10 +1186,9 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
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
> @@ -1200,17 +1198,11 @@ spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
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

Is it necessary for kvm_mmu_unprotect_page to search for an entire range large 
page range now, instead of a 4k page?
