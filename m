Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaGVTfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:35:23 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:50762 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaGVTfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:35:22 -0400
Message-ID: <53CEBCF3.9010208@imgtec.com>
Date: Tue, 22 Jul 2014 12:35:15 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: <linux-xtensa@linux-xtensa.org>, Chris Zankel <chris@zankel.net>,
        "Marc Gauthier" <marc@cadence.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-arch@vger.kernel.org>,
        <linux-mips@linux-mips.org>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 6/8] mm/highmem: make kmap cache coloring aware
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com> <1406055673-10100-7-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1406055673-10100-7-git-send-email-jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 12:01 PM, Max Filippov wrote:
> From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
>
> Provide hooks that allow architectures with aliasing cache to align
> mapping address of high pages according to their color. Such architectures
> may enforce similar coloring of low- and high-memory page mappings and
> reuse existing cache management functions to support highmem.
>
> Cc: linux-mm@kvack.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> [ Max: extract architecture-independent part of the original patch, clean
>    up checkpatch and build warnings. ]
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
> Changes since the initial version:
> - define set_pkmap_color(pg, cl) as do { } while (0) instead of /* */;
> - rename is_no_more_pkmaps to no_more_pkmaps;
> - change 'if (count > 0)' to 'if (count)' to better match the original
>    code behavior;
>
>   mm/highmem.c | 19 ++++++++++++++++---
>   1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b32b70c..88fb62e 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -44,6 +44,14 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
>    */
>   #ifdef CONFIG_HIGHMEM
>   
> +#ifndef ARCH_PKMAP_COLORING
> +#define set_pkmap_color(pg, cl)		do { } while (0)
> +#define get_last_pkmap_nr(p, cl)	(p)
> +#define get_next_pkmap_nr(p, cl)	(((p) + 1) & LAST_PKMAP_MASK)
> +#define no_more_pkmaps(p, cl)		(!(p))
> +#define get_next_pkmap_counter(c, cl)	((c) - 1)
> +#endif
> +
>   unsigned long totalhigh_pages __read_mostly;
>   EXPORT_SYMBOL(totalhigh_pages);
>   
> @@ -161,19 +169,24 @@ static inline unsigned long map_new_virtual(struct page *page)
>   {
>   	unsigned long vaddr;
>   	int count;
> +	int color __maybe_unused;
> +
> +	set_pkmap_color(page, color);
> +	last_pkmap_nr = get_last_pkmap_nr(last_pkmap_nr, color);
>   
>   start:
>   	count = LAST_PKMAP;
>   	/* Find an empty entry */
>   	for (;;) {
> -		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
> -		if (!last_pkmap_nr) {
> +		last_pkmap_nr = get_next_pkmap_nr(last_pkmap_nr, color);
> +		if (no_more_pkmaps(last_pkmap_nr, color)) {
>   			flush_all_zero_pkmaps();
>   			count = LAST_PKMAP;
>   		}
>   		if (!pkmap_count[last_pkmap_nr])
>   			break;	/* Found a usable entry */
> -		if (--count)
> +		count = get_next_pkmap_counter(count, color);
> +		if (count)
>   			continue;
>   
>   		/*
I would like to return back to "if (count >0)".

The reason is in easy way to jump through the same coloured pages - next 
element is calculated via decrementing by non "1" value of colours and 
it can easy become negative on last page available:

#define     get_next_pkmap_counter(c,cl)    (c - FIX_N_COLOURS)

where FIX_N_COLOURS is a max number of page colours.

Besides that it is a good practice in stopping cycle.

- Leonid.

