Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab3BSThe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:37:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44952 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515Ab3BSThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:37:32 -0500
Date: Tue, 19 Feb 2013 11:37:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Miller <davem@davemloft.net>
cc: mroos@ut.ee, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
In-Reply-To: <20130219.143320.1413047009797673492.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1302191134570.790@chino.kir.corp.google.com>
References: <alpine.SOC.1.00.1302191350280.10147@math.ut.ee> <alpine.SOC.1.00.1302191405140.10147@math.ut.ee> <20130219.143320.1413047009797673492.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, David Miller wrote:

> diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
> index 7f64743..338b406 100644
> --- a/arch/sparc/mm/tsb.c
> +++ b/arch/sparc/mm/tsb.c
> @@ -288,14 +288,13 @@ static unsigned long tsb_size_to_rss_limit(unsigned long new_size)
>   * the number of entries that the current TSB can hold at once.  Currently,
>   * we trigger when the RSS hits 3/4 of the TSB capacity.
>   */
> -void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
> +void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss, gfp_t gfp)
>  {
>  	unsigned long max_tsb_size = 1 * 1024 * 1024;
>  	unsigned long new_size, old_size, flags;
>  	struct tsb *old_tsb, *new_tsb;
>  	unsigned long new_cache_index, old_cache_index;
>  	unsigned long new_rss_limit;
> -	gfp_t gfp_flags;
>  
>  	if (max_tsb_size > (PAGE_SIZE << MAX_ORDER))
>  		max_tsb_size = (PAGE_SIZE << MAX_ORDER);
> @@ -312,12 +311,11 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
>  		new_rss_limit = ~0UL;
>  
>  retry_tsb_alloc:
> -	gfp_flags = GFP_KERNEL;
>  	if (new_size > (PAGE_SIZE * 2))
> -		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
> +		gfp = __GFP_NOWARN | __GFP_NORETRY;

The existing code here already looks buggy for a different reason, it 
should be gfp |= __GFP_NOWARN | __GFP_NORETRY;

I was wondering if you could get away with just a simple one-liner fix 
above by doing

	gfp_flags = rss ? GFP_KERNEL : GFP_NOWAIT;

but I agree this is more robust.
