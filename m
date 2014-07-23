Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbaGWVRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:17:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbaGWVRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:17:23 -0400
Date: Wed, 23 Jul 2014 14:17:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Subject: Re: [PATCH v2] mm/highmem: make kmap cache coloring aware
Message-Id: <20140723141721.d6a58555f124a7024d010067@linux-foundation.org>
In-Reply-To: <1405616598-14798-1-git-send-email-jcmvbkbc@gmail.com>
References: <1405616598-14798-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014 21:03:18 +0400 Max Filippov <jcmvbkbc@gmail.com> wrote:

> From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> 
> Provide hooks that allow architectures with aliasing cache to align
> mapping address of high pages according to their color. Such architectures
> may enforce similar coloring of low- and high-memory page mappings and
> reuse existing cache management functions to support highmem.
> 
> ...
>
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -44,6 +44,14 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
>   */
>  #ifdef CONFIG_HIGHMEM
>  
> +#ifndef ARCH_PKMAP_COLORING
> +#define set_pkmap_color(pg, cl)		/* */
> +#define get_last_pkmap_nr(p, cl)	(p)
> +#define get_next_pkmap_nr(p, cl)	(((p) + 1) & LAST_PKMAP_MASK)
> +#define is_no_more_pkmaps(p, cl)	(!(p))
> +#define get_next_pkmap_counter(c, cl)	((c) - 1)
> +#endif

This is the old-school way of doing things.  The new Linus-approved way is

#ifndef set_pkmap_color
#define set_pkmap_color ...
#define get_last_pkmap_nr ...
#endif

so we don't need to add yet another symbol and to avoid typos, etc.

Secondly, please identify which per-arch header file is responsible for
defining these symbols.  Document that here and make sure that
mm/highmem.c is directly including that file.  Otherwise we end up with
different architectures using different header files and it's all a big
mess.

Thirdly, macros are nasty things.  It would be nicer to do

#ifndef set_pkmap_color
static inline void set_pkmap_color(...)
{
	...
}
#define set_pkmap_color set_pkmap_color

...

#endif

Fourthly, please document these proposed interfaces with code comments.

Fifthly, it would be very useful to publish the performance testing
results for at least one architecture so that we can determine the
patchset's desirability.  And perhaps to motivate other architectures
to implement this.
