Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3JHBYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:24:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3JHBYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:24:18 -0400
Date: Mon, 7 Oct 2013 22:23:55 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page
 table out of vcpu thread
Message-ID: <20131008012355.GA3588@amt.cnet>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1378376958-27252-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378376958-27252-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:29:15PM +0800, Xiao Guangrong wrote:
> It is easy if the handler is in the vcpu context, in that case we can use
> walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() that
> disable interrupt to stop shadow page being freed. But we are on the ioctl
> context and the paths we are optimizing for have heavy workload, disabling
> interrupt is not good for the system performance
> 
> We add a indicator into kvm struct (kvm->arch.rcu_free_shadow_page), then
> use call_rcu() to free the shadow page if that indicator is set. Set/Clear the
> indicator are protected by slot-lock, so it need not be atomic and does not
> hurt the performance and the scalability
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 +++++-
>  arch/x86/kvm/mmu.c              | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu.h              | 22 ++++++++++++++++++++++
>  3 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c76ff74..8e4ca0d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -226,7 +226,10 @@ struct kvm_mmu_page {
>  	/* The page is obsolete if mmu_valid_gen != kvm->arch.mmu_valid_gen.  */
>  	unsigned long mmu_valid_gen;
>  
> -	DECLARE_BITMAP(unsync_child_bitmap, 512);
> +	union {
> +		DECLARE_BITMAP(unsync_child_bitmap, 512);
> +		struct rcu_head rcu;
> +	};
>  
>  #ifdef CONFIG_X86_32
>  	/*
> @@ -554,6 +557,7 @@ struct kvm_arch {
>  	 */
>  	struct list_head active_mmu_pages;
>  	struct list_head zapped_obsolete_pages;
> +	bool rcu_free_shadow_page;
>  
>  	struct list_head assigned_dev_head;
>  	struct iommu_domain *iommu_domain;
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2bf450a..f551fc7 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2355,6 +2355,30 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  	return ret;
>  }
>  
> +static void kvm_mmu_isolate_pages(struct list_head *invalid_list)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	list_for_each_entry(sp, invalid_list, link)
> +		kvm_mmu_isolate_page(sp);
> +}
> +
> +static void free_pages_rcu(struct rcu_head *head)
> +{
> +	struct kvm_mmu_page *next, *sp;
> +
> +	sp = container_of(head, struct kvm_mmu_page, rcu);
> +	while (sp) {
> +		if (!list_empty(&sp->link))
> +			next = list_first_entry(&sp->link,
> +					      struct kvm_mmu_page, link);
> +		else
> +			next = NULL;
> +		kvm_mmu_free_page(sp);
> +		sp = next;
> +	}
> +}
> +
>  static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  				    struct list_head *invalid_list)
>  {
> @@ -2375,6 +2399,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  	 */
>  	kvm_flush_remote_tlbs(kvm);
>  
> +	if (kvm->arch.rcu_free_shadow_page) {
> +		kvm_mmu_isolate_pages(invalid_list);
> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
> +		list_del_init(invalid_list);
> +		call_rcu(&sp->rcu, free_pages_rcu);
> +		return;
> +	}

This is unbounded (there was a similar problem with early fast page fault
implementations):

>From RCU/checklist.txt:

"        An especially important property of the synchronize_rcu()
        primitive is that it automatically self-limits: if grace periods
        are delayed for whatever reason, then the synchronize_rcu()
        primitive will correspondingly delay updates.  In contrast,
        code using call_rcu() should explicitly limit update rate in
        cases where grace periods are delayed, as failing to do so can
        result in excessive realtime latencies or even OOM conditions.
"

Moreover, freeing pages differently depending on some state should 
be avoided.

Alternatives:

- Disable interrupts at write protect sites.
- Rate limit the number of pages freed via call_rcu
per grace period.
- Some better alternative.


