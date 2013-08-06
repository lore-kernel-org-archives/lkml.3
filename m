Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3HFM7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:59:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52007 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3HFM7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:59:03 -0400
Date: Tue, 6 Aug 2013 08:58:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 1/4] mm, rmap: do easy-job first in anon_vma_fork
Message-ID: <20130806125854.GG1845@cmpxchg.org>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:43:37PM +0900, Joonsoo Kim wrote:
> If we fail due to some errorous situation, it is better to quit
> without doing heavy work. So changing order of execution.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a149e3a..c2f51cb 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -278,19 +278,19 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  	if (!pvma->anon_vma)
>  		return 0;
>  
> +	/* First, allocate required objects */
> +	avc = anon_vma_chain_alloc(GFP_KERNEL);
> +	if (!avc)
> +		goto out_error;
> +	anon_vma = anon_vma_alloc();
> +	if (!anon_vma)
> +		goto out_error_free_avc;
> +
>  	/*
> -	 * First, attach the new VMA to the parent VMA's anon_vmas,
> +	 * Then attach the new VMA to the parent VMA's anon_vmas,
>  	 * so rmap can find non-COWed pages in child processes.
>  	 */
>  	if (anon_vma_clone(vma, pvma))
> -		return -ENOMEM;
> -
> -	/* Then add our own anon_vma. */
> -	anon_vma = anon_vma_alloc();
> -	if (!anon_vma)
> -		goto out_error;
> -	avc = anon_vma_chain_alloc(GFP_KERNEL);
> -	if (!avc)
>  		goto out_error_free_anon_vma;

Which heavy work?  anon_vma_clone() is anon_vma_chain_alloc() in a
loop.

Optimizing error paths only makes sense if they are common and you
actually could save something by reordering.  This matches neither.
