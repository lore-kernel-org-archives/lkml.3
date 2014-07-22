Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaGVA6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:58:52 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:50598 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaGVA6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:58:48 -0400
Date: Mon, 21 Jul 2014 17:58:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Max Filippov <jcmvbkbc@gmail.com>
cc: linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Subject: Re: [PATCH v2] mm/highmem: make kmap cache coloring aware
In-Reply-To: <1405616598-14798-1-git-send-email-jcmvbkbc@gmail.com>
Message-ID: <alpine.DEB.2.02.1407211754350.7042@chino.kir.corp.google.com>
References: <1405616598-14798-1-git-send-email-jcmvbkbc@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Max Filippov wrote:

> From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> 
> Provide hooks that allow architectures with aliasing cache to align
> mapping address of high pages according to their color. Such architectures
> may enforce similar coloring of low- and high-memory page mappings and
> reuse existing cache management functions to support highmem.
> 

Typically a change like this would be proposed along with a change to an 
architecture which would define this new ARCH_PKMAP_COLORING and have its 
own overriding definitions.  Based on who you sent this patch to, it looks 
like that would be mips and xtensa.  Now the only question is where are 
those patches to add the alternate definitions for those platforms?

> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> [ Max: extract architecture-independent part of the original patch, clean
>   up checkpatch and build warnings. ]
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
> Changes v1->v2:
> - fix description
> 
>  mm/highmem.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b32b70c..6898a8b 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -44,6 +44,14 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
>   */
>  #ifdef CONFIG_HIGHMEM
>  
> +#ifndef ARCH_PKMAP_COLORING
> +#define set_pkmap_color(pg, cl)		/* */

This is typically done with do {} while (0).

> +#define get_last_pkmap_nr(p, cl)	(p)
> +#define get_next_pkmap_nr(p, cl)	(((p) + 1) & LAST_PKMAP_MASK)
> +#define is_no_more_pkmaps(p, cl)	(!(p))

That's not gramatically proper.

> +#define get_next_pkmap_counter(c, cl)	((c) - 1)
> +#endif
> +
>  unsigned long totalhigh_pages __read_mostly;
>  EXPORT_SYMBOL(totalhigh_pages);
>  
> @@ -161,19 +169,24 @@ static inline unsigned long map_new_virtual(struct page *page)
>  {
>  	unsigned long vaddr;
>  	int count;
> +	int color __maybe_unused;
> +
> +	set_pkmap_color(page, color);
> +	last_pkmap_nr = get_last_pkmap_nr(last_pkmap_nr, color);
>  
>  start:
>  	count = LAST_PKMAP;
>  	/* Find an empty entry */
>  	for (;;) {
> -		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
> -		if (!last_pkmap_nr) {
> +		last_pkmap_nr = get_next_pkmap_nr(last_pkmap_nr, color);
> +		if (is_no_more_pkmaps(last_pkmap_nr, color)) {
>  			flush_all_zero_pkmaps();
>  			count = LAST_PKMAP;
>  		}
>  		if (!pkmap_count[last_pkmap_nr])
>  			break;	/* Found a usable entry */
> -		if (--count)
> +		count = get_next_pkmap_counter(count, color);

And that's not equivalent at all, --count decrements the auto variable and 
then tests it for being non-zero.  Your get_next_pkmap_counter() never 
decrements count.

> +		if (count > 0)
>  			continue;
>  
>  		/*
