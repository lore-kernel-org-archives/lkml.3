Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaJPI65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:58:57 -0400
Received: from mail.efficios.com ([78.47.125.74]:34504 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaJPI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:58:54 -0400
Date: Thu, 16 Oct 2014 10:56:42 +0200
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 03/21] mm: Fix XIP fault vs truncate race
Message-ID: <20141016085642.GB19075@thinkos.etherlink>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-4-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411677218-29146-4-git-send-email-matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-Sep-2014 04:33:20 PM, Matthew Wilcox wrote:
> Pagecache faults recheck i_size after taking the page lock to ensure that
> the fault didn't race against a truncate.  We don't have a page to lock
> in the XIP case, so use the i_mmap_mutex instead.  It is locked in the
> truncate path in unmap_mapping_range() after updating i_size.  So while
> we hold it in the fault path, we are guaranteed that either i_size has
> already been updated in the truncate path, or that the truncate will
> subsequently call zap_page_range_single() and so remove the mapping we
> have just inserted.
> 
> There is a window of time in which i_size has been reduced and the
> thread has a mapping to a page which will be removed from the file,
> but this is harmless as the page will not be allocated to a different
> purpose before the thread's access to it is revoked.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
>  mm/filemap_xip.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
> index d8d9fe3..c8d23e9 100644
> --- a/mm/filemap_xip.c
> +++ b/mm/filemap_xip.c
> @@ -260,8 +260,17 @@ again:
>  		__xip_unmap(mapping, vmf->pgoff);
>  
>  found:
> +		/* We must recheck i_size under i_mmap_mutex */
> +		mutex_lock(&mapping->i_mmap_mutex);
> +		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
> +							PAGE_CACHE_SHIFT;
> +		if (unlikely(vmf->pgoff >= size)) {
> +			mutex_unlock(&mapping->i_mmap_mutex);
> +			return VM_FAULT_SIGBUS;
> +		}
>  		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
>  							xip_pfn);
> +		mutex_unlock(&mapping->i_mmap_mutex);
>  		if (err == -ENOMEM)
>  			return VM_FAULT_OOM;
>  		/*
> @@ -285,16 +294,27 @@ found:
>  		}
>  		if (error != -ENODATA)
>  			goto out;
> +
> +		/* We must recheck i_size under i_mmap_mutex */
> +		mutex_lock(&mapping->i_mmap_mutex);
> +		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
> +							PAGE_CACHE_SHIFT;
> +		if (unlikely(vmf->pgoff >= size)) {
> +			ret = VM_FAULT_SIGBUS;
> +			goto unlock;
> +		}
>  		/* not shared and writable, use xip_sparse_page() */
>  		page = xip_sparse_page();
>  		if (!page)
> -			goto out;
> +			goto unlock;
>  		err = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
>  							page);
>  		if (err == -ENOMEM)
> -			goto out;
> +			goto unlock;
>  
>  		ret = VM_FAULT_NOPAGE;
> +unlock:
> +		mutex_unlock(&mapping->i_mmap_mutex);
>  out:
>  		write_seqcount_end(&xip_sparse_seq);
>  		mutex_unlock(&xip_sparse_mutex);
> -- 
> 2.1.0
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
Key fingerprint: 2A0B 4ED9 15F2 D3FA 45F5  B162 1728 0A97 8118 6ACF
