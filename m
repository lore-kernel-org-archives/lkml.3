Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaLBI6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:58:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaLBI63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:58:29 -0500
Date: Tue, 2 Dec 2014 09:58:25 +0100
From: Jan Kara <jack@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: memory: remove ->vm_file check on shared
 writable vmas
Message-ID: <20141202085825.GA9092@quack.suse.cz>
References: <1417474682-29326-1-git-send-email-hannes@cmpxchg.org>
 <1417474682-29326-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417474682-29326-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-12-14 17:58:01, Johannes Weiner wrote:
> The only way a VMA can have shared and writable semantics is with a
> backing file.
  OK, one always learns :) After some digging I found that MAP_SHARED |
MAP_ANONYMOUS mappings are in fact mappings of a temporary file in tmpfs.
It would be worth to mention this in the changelog I believe. Otherwise
feel free to add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 73220eb6e9e3..2a2e3648ed65 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2167,9 +2167,7 @@ reuse:
>  				balance_dirty_pages_ratelimited(mapping);
>  			}
>  
> -			/* file_update_time outside page_lock */
> -			if (vma->vm_file)
> -				file_update_time(vma->vm_file);
> +			file_update_time(vma->vm_file);
>  		}
>  		put_page(dirty_page);
>  		if (page_mkwrite) {
> @@ -3025,8 +3023,7 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		balance_dirty_pages_ratelimited(mapping);
>  	}
>  
> -	/* file_update_time outside page_lock */
> -	if (vma->vm_file && !vma->vm_ops->page_mkwrite)
> +	if (!vma->vm_ops->page_mkwrite)
>  		file_update_time(vma->vm_file);
>  
>  	return ret;
> -- 
> 2.1.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
