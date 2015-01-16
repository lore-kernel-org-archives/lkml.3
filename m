Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbbAPBQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:16:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbAPBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:16:04 -0500
Date: Thu, 15 Jan 2015 17:15:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, koct9i@gmail.com,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH RFC] page_writeback: cleanup mess around
 cancel_dirty_page()
Message-Id: <20150115171551.a2e6acb5.akpm@linux-foundation.org>
In-Reply-To: <20150115155731.31307.4414.stgit@buzz>
References: <20150115155731.31307.4414.stgit@buzz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 18:57:31 +0300 Konstantin Khebnikov <khlebnikov@yandex-team.ru> wrote:

> This patch replaces cancel_dirty_page() with helper account_page_cleared()
> which only updates counters. It's called from delete_from_page_cache()
> and from try_to_free_buffers() (hack for ext3). Page is locked in both cases.
> 
> Hugetlbfs has no dirty pages accounting, ClearPageDirty() is enough here.
> 
> cancel_dirty_page() in nfs_wb_page_cancel() is redundant. This is helper
> for nfs_invalidate_page() and it's called only in case complete invalidation.
> 
> Open-coded kludge at the end of __delete_from_page_cache() is redundant too.
> 
> This mess was started in v2.6.20, after commit 3e67c09 ("truncate: clear page
> dirtiness before running try_to_free_buffers()") reverted back in v2.6.25
> by commit a2b3456 ("Fix dirty page accounting leak with ext3 data=journal").
> Custom fixes were introduced between them. NFS in in v2.6.23 in commit
> 1b3b4a1 ("NFS: Fix a write request leak in nfs_invalidate_page()").
> Kludge __delete_from_page_cache() in v2.6.24, commit 3a692790 ("Do dirty
> page accounting when removing a page from the page cache").
> 
> It seems safe to leave dirty flag set on truncated page, free_pages_check()
> will clear it before returning page into buddy allocator.
> 

account_page_cleared() is not a good name - "clearing a page" means
filling it with zeroes.  account_page_cleaned(), perhaps?

I don't think your email cc'ed all the correct people?  lustre, nfs,
ext3?

>
> ...
>
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3243,8 +3243,8 @@ int try_to_free_buffers(struct page *page)
>  	 * to synchronise against __set_page_dirty_buffers and prevent the
>  	 * dirty bit from being lost.
>  	 */
> -	if (ret)
> -		cancel_dirty_page(page, PAGE_CACHE_SIZE);
> +	if (ret && TestClearPageDirty(page))
> +		account_page_cleared(page, mapping);

OK.

>  	spin_unlock(&mapping->private_lock);
>  out:
>  	if (buffers_to_free) {
>
> ...
>
> --- a/fs/nfs/write.c
> +++ b/fs/nfs/write.c
> @@ -1811,11 +1811,6 @@ int nfs_wb_page_cancel(struct inode *inode, struct page *page)
>  		 * request from the inode / page_private pointer and
>  		 * release it */
>  		nfs_inode_remove_request(req);
> -		/*
> -		 * In case nfs_inode_remove_request has marked the
> -		 * page as being dirty
> -		 */
> -		cancel_dirty_page(page, PAGE_CACHE_SIZE);

hm, if you say so..

>  		nfs_unlock_and_release_request(req);
>  	}
>  
>
> ...
>
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -201,18 +201,6 @@ void __delete_from_page_cache(struct page *page, void *shadow)
>  	if (PageSwapBacked(page))
>  		__dec_zone_page_state(page, NR_SHMEM);
>  	BUG_ON(page_mapped(page));
> -
> -	/*
> -	 * Some filesystems seem to re-dirty the page even after
> -	 * the VM has canceled the dirty bit (eg ext3 journaling).
> -	 *
> -	 * Fix it up by doing a final dirty accounting check after
> -	 * having removed the page entirely.
> -	 */
> -	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
> -		dec_zone_page_state(page, NR_FILE_DIRTY);
> -		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
> -	}
>  }
>  
>  /**
> @@ -230,6 +218,9 @@ void delete_from_page_cache(struct page *page)
>  
>  	BUG_ON(!PageLocked(page));
>  
> +	if (PageDirty(page))
> +		account_page_cleared(page, mapping);
> +

OK, but we lost the important comment - transplant that?

It's strange that we left the dirty bit set after accounting for its
clearing.  How does this work?  Presumably the offending fs dirtied the
page without accounting for it?  I have a bad feeling I wrote that code :(

>  	freepage = mapping->a_ops->freepage;
>  	spin_lock_irq(&mapping->tree_lock);
>  	__delete_from_page_cache(page, NULL);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 4da3cd5..f371522 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2106,6 +2106,25 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>  EXPORT_SYMBOL(account_page_dirtied);
>  
>  /*
> + * Helper function for deaccounting dirty page without doing writeback.
> + * Doing this should *normally* only ever be done when a page
> + * is truncated, and is not actually mapped anywhere at all. However,
> + * fs/buffer.c does this when it notices that somebody has cleaned
> + * out all the buffers on a page without actually doing it through
> + * the VM. Can you say "ext3 is horribly ugly"? Tought you could.

"Thought".

> + */
> +void account_page_cleared(struct page *page, struct address_space *mapping)
> +{
> +	if (mapping_cap_account_dirty(mapping)) {
> +		dec_zone_page_state(page, NR_FILE_DIRTY);
> +		dec_bdi_stat(mapping->backing_dev_info,
> +				BDI_RECLAIMABLE);
> +		task_io_account_cancelled_write(PAGE_CACHE_SIZE);
> +	}
> +}
> +EXPORT_SYMBOL(account_page_cleared);
>
> ...
>

