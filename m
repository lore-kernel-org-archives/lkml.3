Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3JJPPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:15:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab3JJPPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:15:48 -0400
Date: Thu, 10 Oct 2013 18:15:39 +0300
From: Gleb Natapov <gleb@redhat.com>
To: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com, tangchen@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        guijianfeng@cn.fujitsu.com, chaiwen_0825@hotmail.com
Subject: Re: [RFC][PATCH] Drop FOLL_GET in GUP when doing async_pf in kvm
Message-ID: <20131010151539.GD15954@redhat.com>
References: <1381411215-23830-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381411215-23830-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:20:15PM +0800, chai wen wrote:
> Hi Gleb
> 
> Thanks for you explanation about async_pf in kvm.
> Page pinning is not mandatory in kvm async_pf processing and probably should
> be dropped later.this patch drops the FOLL_GET flag when doing GUP in async_pf
> and uses a bool (marking result of GUP) to replace the *page in kvm_async_pf
> structure to simplify some following async_pf check/clear processing.
Thanks, but the patch need to be on top of
git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue branch.

Some more comment bellow.

> Thanks.
> 
> Suggested-by:  gleb@redhat.com
> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
> ---
>  arch/x86/kvm/x86.c       |    5 ++---
>  include/linux/kvm_host.h |    2 +-
>  virt/kvm/async_pf.c      |   16 ++++++----------
>  3 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5ca72a..0ff7d02 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7282,8 +7282,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
>  
> -	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map) ||
> -	      is_error_page(work->page))
> +	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map))
>  		return;
>  
>  	r = kvm_mmu_reload(vcpu);
> @@ -7393,7 +7392,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  	struct x86_exception fault;
>  
>  	trace_kvm_async_pf_ready(work->arch.token, work->gva);
> -	if (is_error_page(work->page))
> +	if (!work->got_page)
>  		work->arch.token = ~0; /* broadcast wakeup */
>  	else
>  		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0fbbc7a..232a7d0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -189,7 +189,7 @@ struct kvm_async_pf {
>  	gva_t gva;
>  	unsigned long addr;
>  	struct kvm_arch_async_pf arch;
> -	struct page *page;
> +	bool got_page;
I would call it wakeup_all.

>  	bool done;
>  };
>  
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 8a39dda..0cafdc7 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -56,7 +56,7 @@ void kvm_async_pf_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  static void async_pf_execute(struct work_struct *work)
>  {
> -	struct page *page = NULL;
> +	long nrpages = 0;
>  	struct kvm_async_pf *apf =
>  		container_of(work, struct kvm_async_pf, work);
>  	struct mm_struct *mm = apf->mm;
> @@ -68,13 +68,13 @@ static void async_pf_execute(struct work_struct *work)
>  
>  	use_mm(mm);
>  	down_read(&mm->mmap_sem);
> -	get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
> +	nrpages = get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
>  	up_read(&mm->mmap_sem);
>  	unuse_mm(mm);
>  
>  	spin_lock(&vcpu->async_pf.lock);
>  	list_add_tail(&apf->link, &vcpu->async_pf.done);
> -	apf->page = page;
> +	apf->got_page = (1==nrpages);
Space before and after ==, but this is not needed at all.  It does
not matter if GUP failed or not here. We need to wake up guest process
that is waiting on a page, so just set wakeup_all to false in kvm_setup_async_pf().

>  	apf->done = true;
>  	spin_unlock(&vcpu->async_pf.lock);
>  
> @@ -114,8 +114,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  			list_entry(vcpu->async_pf.done.next,
>  				   typeof(*work), link);
>  		list_del(&work->link);
> -		if (!is_error_page(work->page))
> -			kvm_release_page_clean(work->page);
>  		kmem_cache_free(async_pf_cache, work);
>  	}
>  	spin_unlock(&vcpu->async_pf.lock);
> @@ -135,14 +133,12 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  		list_del(&work->link);
>  		spin_unlock(&vcpu->async_pf.lock);
>  
> -		if (work->page)
> +		if (work->got_page)
>  			kvm_arch_async_page_ready(vcpu, work);
>  		kvm_arch_async_page_present(vcpu, work);
>  
>  		list_del(&work->queue);
>  		vcpu->async_pf.queued--;
> -		if (!is_error_page(work->page))
> -			kvm_release_page_clean(work->page);
>  		kmem_cache_free(async_pf_cache, work);
>  	}
>  }
> @@ -165,7 +161,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
>  	if (!work)
>  		return 0;
>  
> -	work->page = NULL;
> +	work->got_page = false;
Sp here do:
	work->wakeup_all = false;

>  	work->done = false;
>  	work->vcpu = vcpu;
>  	work->gva = gva;
> @@ -206,7 +202,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	if (!work)
>  		return -ENOMEM;
>  
> -	work->page = KVM_ERR_PTR_BAD_PAGE;
> +	work->got_page = false;
And here:
	work->wakeup_all = true;
>  	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -- 
> 1.7.1

--
			Gleb.
