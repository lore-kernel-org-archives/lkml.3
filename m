Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaLHK4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:56:47 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41965 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaLHK4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:56:46 -0500
Date: Mon, 8 Dec 2014 11:56:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Drake <drake@endlessm.com>, Minchan Kim <minchan@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [regression] Boot crash with: f7426b983a6a ("mm: cma: adjust
 address limit to avoid hitting low/high memory boundary")
Message-ID: <20141208105640.GA29431@gmail.com>
References: <20141117163903.GA17801@gmail.com>
 <20141127130556.GA4074@gmail.com>
 <20141128070220.GA11802@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128070220.GA11802@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> On Thu, Nov 27, 2014 at 02:05:56PM +0100, Ingo Molnar wrote:
> > 
> > Any replies to this regression after 10 days, or should I send a 
> > revert patch?
> 
> Hello, Ingo.
> 
> I can reproduce your problem and find root cause.
> If CONFIG_DEBUG_VIRTUAL is enabled, __pa() checks whether virtual
> address is valid or not. Because high_memory is not direct mapped
> address, error occurs. IMO, physical address of high_memory is
> useful to check phycal address of highmem boundary so do following
> workaround to avoid validation is reasonable. But, if there is
> a better solution, please let me know. I think that Marek will be
> better than me in this area.
> 
> Please check following change to fix your problem.
> If you agree following change, I will send it to Andrew with
> proper description.
> 
> Thanks.
> 
> ------->8-------------
> diff --git a/mm/cma.c b/mm/cma.c
> index ee3c3e0..45cd0a6 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -227,7 +227,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  			bool fixed, struct cma **res_cma)
>  {
>  	phys_addr_t memblock_end = memblock_end_of_DRAM();
> -	phys_addr_t highmem_start = __pa(high_memory);
> +	phys_addr_t highmem_start = __pa_nodebug(high_memory);
>  	int ret = 0;
>  
>  	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",

Looks like this patch solves my boot crash problem:

  Tested-by: Ingo Molnar <mingo@kernel.org>

I'll let you know if there's any problem left as I test it some 
more. Consider the bug fixed!

Thanks,

	Ingo
