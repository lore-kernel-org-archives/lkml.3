Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3KLA01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:26:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab3KLA0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:26:18 -0500
Date: Mon, 11 Nov 2013 22:25:59 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 01/15] KVM: MMU: properly check last spte in
 fast_page_fault()
Message-ID: <20131112002559.GA8251@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534973-13197-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:29:19PM +0800, Xiao Guangrong wrote:
> Using sp->role.level instead of @level since @level is not got from the
> page table hierarchy
> 
> There is no issue in current code since the fast page fault currently only
> fixes the fault caused by dirty-log that is always on the last level
> (level = 1)
> 
> This patch makes the code more readable and avoids potential issue in the
> further development
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 40772ef..d2aacc2 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2798,9 +2798,9 @@ static bool page_fault_can_be_fast(u32 error_code)
>  }
>  
>  static bool
> -fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte)
> +fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> +			u64 *sptep, u64 spte)
>  {
> -	struct kvm_mmu_page *sp = page_header(__pa(sptep));
>  	gfn_t gfn;
>  
>  	WARN_ON(!sp->role.direct);
> @@ -2826,6 +2826,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
>  			    u32 error_code)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
> +	struct kvm_mmu_page *sp;
>  	bool ret = false;
>  	u64 spte = 0ull;
>  
> @@ -2846,7 +2847,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
>  		goto exit;
>  	}
>  
> -	if (!is_last_spte(spte, level))
> +	sp = page_header(__pa(iterator.sptep));
> +	if (!is_last_spte(spte, sp->role.level))
>  		goto exit;
>  
>  	/*
> @@ -2872,7 +2874,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
>  	 * the gfn is not stable for indirect shadow page.
>  	 * See Documentation/virtual/kvm/locking.txt to get more detail.
>  	 */
> -	ret = fast_pf_fix_direct_spte(vcpu, iterator.sptep, spte);
> +	ret = fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte);
>  exit:
>  	trace_fast_page_fault(vcpu, gva, error_code, iterator.sptep,
>  			      spte, ret);
> -- 
> 1.8.1.4


Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

