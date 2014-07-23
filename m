Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaGWLWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:22:10 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:53853 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbaGWLWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:22:09 -0400
Date: Wed, 23 Jul 2014 14:21:56 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v8 01/22] Fix XIP fault vs truncate race
Message-ID: <20140723112156.GA10317@node.dhcp.inet.fi>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <78c38d32aa62db1bb86315cf3e287b24be900c5e.1406058387.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78c38d32aa62db1bb86315cf3e287b24be900c5e.1406058387.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:47:49PM -0400, Matthew Wilcox wrote:
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

round_up() ?

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
