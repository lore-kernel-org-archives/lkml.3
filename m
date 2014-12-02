Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaLBJTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:19:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbaLBJTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:19:42 -0500
Date: Tue, 2 Dec 2014 10:19:39 +0100
From: Jan Kara <jack@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: memory: merge shared-writable dirtying branches
 in do_wp_page()
Message-ID: <20141202091939.GC9092@quack.suse.cz>
References: <1417474682-29326-1-git-send-email-hannes@cmpxchg.org>
 <1417474682-29326-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417474682-29326-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-12-14 17:58:02, Johannes Weiner wrote:
> Whether there is a vm_ops->page_mkwrite or not, the page dirtying is
> pretty much the same.  Make sure the page references are the same in
> both cases, then merge the two branches.
> 
> It's tempting to go even further and page-lock the !page_mkwrite case,
> to get it in line with everybody else setting the page table and thus
> further simplify the model.  But that's not quite compelling enough to
> justify dropping the pte lock, then relocking and verifying the entry
> for filesystems without ->page_mkwrite, which notably includes tmpfs.
> Leave it for now and lock the page late in the !page_mkwrite case.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memory.c | 46 ++++++++++++++++------------------------------
>  1 file changed, 16 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2a2e3648ed65..ff92abfa5303 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
...
> @@ -2147,42 +2147,28 @@ reuse:
>  		pte_unmap_unlock(page_table, ptl);
>  		ret |= VM_FAULT_WRITE;
>  
> -		if (!dirty_page)
> -			return ret;
> -
> -		if (!page_mkwrite) {
> +		if (dirty_shared) {
>  			struct address_space *mapping;
>  			int dirtied;
>  
> -			lock_page(dirty_page);
> -			dirtied = set_page_dirty(dirty_page);
> -			mapping = dirty_page->mapping;
> -			unlock_page(dirty_page);
> +			if (!page_mkwrite)
> +				lock_page(old_page);
>  
> -			if (dirtied && mapping) {
> -				/*
> -				 * Some device drivers do not set page.mapping
> -				 * but still dirty their pages
> -				 */
> -				balance_dirty_pages_ratelimited(mapping);
> -			}
> +			dirtied = set_page_dirty(old_page);
> +			mapping = old_page->mapping;
> +			unlock_page(old_page);
> +			page_cache_release(old_page);
>  
> -			file_update_time(vma->vm_file);
> -		}
> -		put_page(dirty_page);
> -		if (page_mkwrite) {
> -			struct address_space *mapping = dirty_page->mapping;
> -
> -			set_page_dirty(dirty_page);
> -			unlock_page(dirty_page);
> -			page_cache_release(dirty_page);
> -			if (mapping)	{
> +			if ((dirtied || page_mkwrite) && mapping) {
  Why do we actually call balance_dirty_pages_ratelimited() even if we
didn't dirty the page when ->page_mkwrite() exists? Is it because
filesystem may dirty the page in ->page_mkwrite() and we don't want it to
deal with calling balance_dirty_pages_ratelimited()?

Otherwise the patch looks good to me.

								Honza

>  				/*
>  				 * Some device drivers do not set page.mapping
>  				 * but still dirty their pages
>  				 */
>  				balance_dirty_pages_ratelimited(mapping);
>  			}
> +
> +			if (!page_mkwrite)
> +				file_update_time(vma->vm_file);
>  		}
>  
>  		return ret;
> -- 
> 2.1.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
