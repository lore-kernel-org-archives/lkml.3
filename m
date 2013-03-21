Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3CUNOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab3CUNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:14:18 -0400
Date: Thu, 21 Mar 2013 15:14:09 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KVM: MMU: delete shadow page from hash list in
 kvm_mmu_prepare_zap_page
Message-ID: <20130321131409.GT3889@redhat.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1363768227-4782-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363768227-4782-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:30:24PM +0800, Xiao Guangrong wrote:
> Move deletion shadow page from the hash list from kvm_mmu_commit_zap_page to
> kvm_mmu_prepare_zap_page, we that we can free the shadow page out of mmu-lock.
> 
> Also, delete the invalid shadow page from the hash list since this page can
> not be reused anymore. This makes reset mmu-cache more easier - we do not need
> to care all hash entries after reset mmu-cache
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index dc37512..5578c91 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1472,7 +1472,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>  {
>  	ASSERT(is_empty_shadow_page(sp->spt));
> -	hlist_del(&sp->hash_link);
> +
>  	list_del(&sp->link);
>  	free_page((unsigned long)sp->spt);
>  	if (!sp->role.direct)
> @@ -1660,7 +1660,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  
>  #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
>  	for_each_gfn_sp(_kvm, _sp, _gfn)				\
> -		if ((_sp)->role.direct || (_sp)->role.invalid) {} else
> +		if ((_sp)->role.direct ||				\
> +		      ((_sp)->role.invalid && WARN_ON(1))) {} else
>  
>  /* @sp->gfn should be write-protected at the call site */
>  static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> @@ -2079,6 +2080,9 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		unaccount_shadowed(kvm, sp->gfn);
>  	if (sp->unsync)
>  		kvm_unlink_unsync_page(kvm, sp);
> +
> +	hlist_del_init(&sp->hash_link);
> +
Now we delete roots from hash, but leave it on active_mmu_pages list. Is
this OK?

>  	if (!sp->root_count) {
>  		/* Count self */
>  		ret++;
> -- 
> 1.7.7.6

--
			Gleb.
