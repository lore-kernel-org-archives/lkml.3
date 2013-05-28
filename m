Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118Ab3E1NYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab3E1NYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:24:50 -0400
Date: Mon, 27 May 2013 21:36:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 10/11] KVM: MMU: collapse TLB flushes when zap all
 pages
Message-ID: <20130528003611.GA1958@amt.cnet>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1369252560-11611-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369252560-11611-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 03:55:59AM +0800, Xiao Guangrong wrote:
> kvm_zap_obsolete_pages uses lock-break technique to zap pages,
> it will flush tlb every time when it does lock-break
> 
> We can reload mmu on all vcpus after updating the generation
> number so that the obsolete pages are not used on any vcpus,
> after that we do not need to flush tlb when obsolete pages
> are zapped

After that point batching is also not relevant anymore?


Still concerned about a similar case mentioned earlier:

"
Note the account for pages freed step after pages are actually
freed: as discussed with Takuya, having pages freed and freed page
accounting out of sync across mmu_lock is potentially problematic:
kvm->arch.n_used_mmu_pages and friends do not reflect reality which can
cause problems for SLAB freeing and page allocation throttling.
"

This is a real problem, if you decrease n_used_mmu_pages at
kvm_mmu_prepare_zap_page, but only actually free pages later 
at kvm_mmu_commit_zap_page, there is the possibility of allowing
a huge number to be retained. There should be a maximum number of pages
at invalid_list.

(even higher possibility if you schedule without freeing pages reported
as released!).

> Note: kvm_mmu_commit_zap_page is still needed before free
> the pages since other vcpus may be doing locklessly shadow
> page walking
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   32 ++++++++++++++++++++++----------
>  1 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index e676356..5e34056 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4237,8 +4237,6 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>  restart:
>  	list_for_each_entry_safe_reverse(sp, node,
>  	      &kvm->arch.active_mmu_pages, link) {
> -		int ret;
> -
>  		/*
>  		 * No obsolete page exists before new created page since
>  		 * active_mmu_pages is the FIFO list.
> @@ -4254,21 +4252,24 @@ restart:
>  		if (sp->role.invalid)
>  			continue;
>  
> +		/*
> +		 * Need not flush tlb since we only zap the sp with invalid
> +		 * generation number.
> +		 */
>  		if (batch >= BATCH_ZAP_PAGES &&
> -		      (need_resched() || spin_needbreak(&kvm->mmu_lock))) {
> +		      cond_resched_lock(&kvm->mmu_lock)) {
>  			batch = 0;
> -			kvm_mmu_commit_zap_page(kvm, &invalid_list);
> -			cond_resched_lock(&kvm->mmu_lock);
>  			goto restart;
>  		}
>  
> -		ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> -		batch += ret;
> -
> -		if (ret)
> -			goto restart;
> +		batch += kvm_mmu_prepare_zap_obsolete_page(kvm, sp,
> +						      &invalid_list);
>  	}
>  
> +	/*
> +	 * Should flush tlb before free page tables since lockless-walking
> +	 * may use the pages.
> +	 */
>  	kvm_mmu_commit_zap_page(kvm, &invalid_list);
>  }
>  
> @@ -4287,6 +4288,17 @@ void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
>  	trace_kvm_mmu_invalidate_zap_all_pages(kvm);
>  	kvm->arch.mmu_valid_gen++;
>  
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
>  	kvm_zap_obsolete_pages(kvm);
>  	spin_unlock(&kvm->mmu_lock);
>  }
> -- 
> 1.7.7.6
