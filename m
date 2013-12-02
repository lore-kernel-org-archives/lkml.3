Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3LBUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:09:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab3LBUJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:09:53 -0500
Date: Mon, 02 Dec 2013 15:09:42 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Message-ID: <1386014982-lfutnpr2-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1385624926-28883-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1385624926-28883-6-git-send-email-iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 5/9] mm/rmap: extend rmap_walk_xxx() to cope with
 different cases
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:48:42PM +0900, Joonsoo Kim wrote:
> There are a lot of common parts in traversing functions, but there are
> also a little of uncommon parts in it. By assigning proper function
> pointer on each rmap_walker_control, we can handle these difference
> correctly.
> 
> Following are differences we should handle.
> 
> 1. difference of lock function in anon mapping case
> 2. nonlinear handling in file mapping case
> 3. prechecked condition:
> 	checking memcg in page_referenced(),
> 	checking VM_SHARE in page_mkclean()
> 	checking temporary vma in try_to_unmap()
> 4. exit condition:
> 	checking page_mapped() in try_to_unmap()
> 
> So, in this patch, I introduce 4 function pointers to
> handle above differences.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 0f65686..58624b4 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -239,6 +239,12 @@ struct rmap_walk_control {
>  	int (*main)(struct page *, struct vm_area_struct *,
>  					unsigned long, void *);
>  	void *arg;	/* argument to main function */
> +	int (*main_done)(struct page *page);	/* check exit condition */
> +	int (*file_nonlinear)(struct page *, struct address_space *,
> +					struct vm_area_struct *vma);
> +	struct anon_vma *(*anon_lock)(struct page *);
> +	int (*vma_skip)(struct vm_area_struct *, void *);

Can you add some comments about how these callbacks work and when it
should be set to for future users?  For example, anon_lock() are
used to override the default behavior and it's not trivial.

> +	void *skip_arg;	/* argument to vma_skip function */

I think that it's better to move this field into the structure pointed
to by arg (which can be defined by each caller in its own way) and pass
arg to *vma_skip().

Thanks,
Naoya Horiguchi
