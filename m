Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3I3MwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 08:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3I3MwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 08:52:13 -0400
Date: Mon, 30 Sep 2013 15:51:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, chaiwen_0825@hotmail.com,
        pbonzini@redhat.com
Subject: Re: [RFC/query] kvm async_pf anon pined pages migration
Message-ID: <20130930125158.GA11993@redhat.com>
References: <1380535387-26237-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380535387-26237-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 06:03:07PM +0800, chai wen wrote:
> 
> Hi all
> 
> Async page fault in kvm currently pin user pages via get_user_pages.
> when doing page migration,the method can be found via
> page->mmapping->a_ops->migratepage to offline old pages and migrate to
> new pages. As to anonymous page there is no file mapping but a anon_vma.So
> the migration will fall back to some *default* migration method.Anon pages
> that have been pined in memory by some reasons could be failed in the migration
> processing because of some reasons like ref-count checking.
> (or I misunderstand some thing?)
> 
> Now we want to make these anon pages in async_pf can be migrated, I try some
> ways.But there are still many problems. The following is one that replaceing
> the mapping of anon page arbitrarily and doing some thing based on it.
> Kvm-based virtual machine can works on this patch,but have no experience of
> offline pages because of the limitaion of resouces.I'll check it later.
> 
> I don't know weather it is a right direction of this issue.
> All comments/criticize are welcomed.
The pinning is not mandatory and can (and probably should) be dropped, but
pinning that is done by async page faults is short lived. What problems
are you seeing that warrant the complexity of handling their migration?

> Thanks.
> 
> what the following patch doing is :
> 1.after async_pf pin page via GUP. change the page mapping
> to a given maping, and there is a designed page migrate method can be
> found via the mapping.
> 2.when doing check/clear async_pf work recover the mapping of these pages.
> 3.when doing *offline page* the designed page migrate methon can be called
> by the *migrate page* subsystem call sequence via page->mapping->migratepage.
> it will handle the refcount issue and recover the page original mapping then 
> do things like other page migrate method.
> 
> There will be some problems:
> 1.the page->mapping is replaced arbitrarily and the occasions to
> recover it is only async_pf check/clear/page offline. For anonymous pages,
> this will lead problems in page managemenet.
> 2.changing the page mapping arbitrarily will mislead the unmap processing in the
> early path of page offline processing.
> 
> 
> Signed-off-by: chaiwen <chaiw.fnst@cn.fujitsu.com>
> ---
>  mm/migrate.c        |    2 +
>  virt/kvm/async_pf.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 87 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 9c8d5f5..1dee7d4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -394,6 +394,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
>  
>  	return MIGRATEPAGE_SUCCESS;
>  }
> +EXPORT_SYMBOL(migrate_page_move_mapping);
>  
>  /*
>   * The expected number of remaining references is the same as that
> @@ -496,6 +497,7 @@ void migrate_page_copy(struct page *newpage, struct page *page)
>  	if (PageWriteback(newpage))
>  		end_page_writeback(newpage);
>  }
> +EXPORT_SYMBOL(migrate_page_copy);
>  
>  /************************************************************
>   *                    Migration functions
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 8a39dda..c458305 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -25,9 +25,58 @@
>  #include <linux/module.h>
>  #include <linux/mmu_context.h>
>  
> +#ifdef CONFIG_MIGRATION
> +#include <linux/migrate.h>
> +#endif
> +
>  #include "async_pf.h"
>  #include <trace/events/kvm.h>
>  
> +#ifdef CONFIG_MIGRATION
> +struct kvm_apf_ctx {
> +	struct address_space *ori_mapping;
> +	void *context;
> +};
> +
> +static int async_pf_migratepage( struct address_space *mapping,
> +				 struct page *new, struct page *old,
> +				 enum migrate_mode mode )
> +{
> +	int ret;
> +	struct kvm_apf_ctx *async_pf_ctx =
> +				(struct kvm_apf_ctx *)page_private(old);
> +	struct kvm_async_pf *apf =
> +				(struct kvm_async_pf *)async_pf_ctx->context;
> +	unsigned long flags;
> +
> +	BUG_ON( PageWriteback(old) );
> +	put_page( old );
> +	mapping = async_pf_ctx->ori_mapping;
> +	ret = migrate_page_move_mapping( mapping, new, old, NULL, mode );
> +	if( MIGRATEPAGE_SUCCESS != ret ) {
> +		get_page( old );
> +		return ret;
> +	}
> +
> +	get_page( new );
> +	spin_lock_irqsave( &apf->vcpu->async_pf.lock, flags );
> +	migrate_page_copy( new, old );
> +	new->mapping = async_pf_ctx->ori_mapping;
> +	apf->page = new;
> +	spin_unlock_irqrestore( &apf->vcpu->async_pf.lock, flags );
> +
> +	return ret;
> +}
> +
> +static const struct address_space_operations apf_ctx_aops = {
> +	.migratepage = async_pf_migratepage,
> +};
> +
> +static const struct address_space apf_mapping = {
> +	.a_ops = &apf_ctx_aops,
> +};
> +#endif
> +
>  static struct kmem_cache *async_pf_cache;
>  
>  int kvm_async_pf_init(void)
> @@ -63,12 +112,27 @@ static void async_pf_execute(struct work_struct *work)
>  	struct kvm_vcpu *vcpu = apf->vcpu;
>  	unsigned long addr = apf->addr;
>  	gva_t gva = apf->gva;
> +	long nrpages;
> +#ifdef CONFIG_MIGRATION
> +	struct kvm_apf_ctx *apf_ctx;
> +	apf_ctx = kzalloc( sizeof(*apf_ctx), GFP_KERNEL );
> +	if( !apf_ctx )
> +		return;
> +#endif
>  
>  	might_sleep();
>  
>  	use_mm(mm);
>  	down_read(&mm->mmap_sem);
> -	get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
> +	nrpages = get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
> +#ifdef CONFIG_MIGRATION
> +	if( (1==nrpages) && PageAnon(page) ) {
> +		apf_ctx->ori_mapping = page->mapping;
> +		apf_ctx->context = apf;
> +		set_page_private( page, (unsigned long)apf_ctx );
> +		page->mapping = &apf_mapping;
> +	}
> +#endif
>  	up_read(&mm->mmap_sem);
>  	unuse_mm(mm);
>  
> @@ -114,8 +178,17 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  			list_entry(vcpu->async_pf.done.next,
>  				   typeof(*work), link);
>  		list_del(&work->link);
> -		if (!is_error_page(work->page))
> +		if (!is_error_page(work->page)) {
> +#ifdef CONFIG_MIGRATION
> +			if( work->page->mapping == &apf_mapping ) {
> +				struct kvm_apf_ctx *apf_ctx =
> +				(struct kvm_apf_ctx *)page_private(work->page);
> +				work->page->mapping = apf_ctx->ori_mapping;
> +				kfree( apf_ctx );
> +			}
> +#endif
>  			kvm_release_page_clean(work->page);
> +		}
>  		kmem_cache_free(async_pf_cache, work);
>  	}
>  	spin_unlock(&vcpu->async_pf.lock);
> @@ -141,8 +214,17 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  
>  		list_del(&work->queue);
>  		vcpu->async_pf.queued--;
> -		if (!is_error_page(work->page))
> +		if (!is_error_page(work->page)) {
> +#ifdef CONFIG_MIGRATION
> +			if( work->page->mapping == &apf_mapping ) {
> +				struct kvm_apf_ctx *apf_ctx =
> +				(struct kvm_apf_ctx *)page_private(work->page);
> +				work->page->mapping = apf_ctx->ori_mapping;
> +				kfree( apf_ctx );
> +			}
> +#endif
>  			kvm_release_page_clean(work->page);
> +		}
>  		kmem_cache_free(async_pf_cache, work);
>  	}
>  }
> -- 
> 1.7.1

--
			Gleb.
