Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaFWVKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbaFWVKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:10:43 -0400
Message-ID: <1403557803.755.53.camel@deneb.redhat.com>
Subject: Re: [PATCHv3] mm: page_alloc: fix CMA area initialisation when
 pageblock > MAX_ORDER
From: Mark Salter <msalter@redhat.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Jun 2014 17:10:03 -0400
In-Reply-To: <xa1tegyfv2gw.fsf@mina86.com>
References: <1402522435-13884-1-git-send-email-msalter@redhat.com>
	 <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com>
	 <xa1t61jzwfo6.fsf@mina86.com> <1403201524.32688.62.camel@deneb.redhat.com>
	 <xa1tfvj01z57.fsf@mina86.com> <1403285834.755.39.camel@deneb.redhat.com>
	 <xa1tegyfv2gw.fsf@mina86.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 21:40 +0200, Michal Nazarewicz wrote:
> With a kernel configured with ARM64_64K_PAGES && !TRANSPARENT_HUGEPAGE,
> the following is triggered at early boot:
> 
>   SMP: Total of 8 processors activated.
>   devtmpfs: initialized
>   Unable to handle kernel NULL pointer dereference at virtual address 00000008
>   pgd = fffffe0000050000
>   [00000008] *pgd=00000043fba00003, *pmd=00000043fba00003, *pte=00e0000078010407
>   Internal error: Oops: 96000006 [#1] SMP
>   Modules linked in:
>   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc864k+ #44
>   task: fffffe03bc040000 ti: fffffe03bc080000 task.ti: fffffe03bc080000
>   PC is at __list_add+0x10/0xd4
>   LR is at free_one_page+0x270/0x638
>   ...
>   Call trace:
>   [<fffffe00003ee970>] __list_add+0x10/0xd4
>   [<fffffe000019c478>] free_one_page+0x26c/0x638
>   [<fffffe000019c8c8>] __free_pages_ok.part.52+0x84/0xbc
>   [<fffffe000019d5e8>] __free_pages+0x74/0xbc
>   [<fffffe0000c01350>] init_cma_reserved_pageblock+0xe8/0x104
>   [<fffffe0000c24de0>] cma_init_reserved_areas+0x190/0x1e4
>   [<fffffe0000090418>] do_one_initcall+0xc4/0x154
>   [<fffffe0000bf0a50>] kernel_init_freeable+0x204/0x2a8
>   [<fffffe00007520a0>] kernel_init+0xc/0xd4
> 
> This happens because init_cma_reserved_pageblock() calls
> __free_one_page() with pageblock_order as page order but it is bigger
> han MAX_ORDER.  This in turn causes accesses past zone->free_list[].
> 
> Fix the problem by changing init_cma_reserved_pageblock() such that it
> splits pageblock into individual MAX_ORDER pages if pageblock is
> bigger than a MAX_ORDER page.
> 
> In cases where !CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, which is all
> architectures expect for ia64, powerpc and tile at the moment, the
> “pageblock_order > MAX_ORDER” condition will be optimised out since
> both sides of the operator are constants.  In cases where pageblock
> size is variable, the performance degradation should not be
> significant anyway since init_cma_reserved_pageblock() is called
> only at boot time at most MAX_CMA_AREAS times which by default is
> eight.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Reported-by: Mark Salter <msalter@redhat.com>
> Tested-by: Christopher Covington <cov@codeaurora.org>
> ---
>  mm/page_alloc.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
>  Mark Salter wrote:
>  > I ended up needing this (on top of your patch) to get the system to
>  > boot.  Each MAX_ORDER-1 group needs the refcount and migratetype set
>  > so that __free_pages does the right thing.
>  >
>  > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>  > index 02fb1ed..a7ca6cc 100644
>  > --- a/mm/page_alloc.c
>  > +++ b/mm/page_alloc.c
>  > @@ -799,17 +799,18 @@ void __init init_cma_reserved_pageblock(struct page *page)
>  >  		set_page_count(p, 0);
>  >  	} while (++p, --i);
>  >  
>  > -	set_page_refcounted(page);
>  > -	set_pageblock_migratetype(page, MIGRATE_CMA);
>  > -
>  > -	if (pageblock_order > MAX_ORDER) {
>  > -		i = pageblock_order - MAX_ORDER;
>  > +	if (pageblock_order >= MAX_ORDER) {
>  > +		i = pageblock_order - MAX_ORDER + 1;
>  >  		i = 1 << i;
>  >  		p = page;
>  >  		do {
>  > -			__free_pages(p, MAX_ORDER);
>  > +			set_page_refcounted(p);
>  > +			set_pageblock_migratetype(p, MIGRATE_CMA);
>  > +			__free_pages(p, MAX_ORDER - 1);
>  >  		} while (p += MAX_ORDER_NR_PAGES, --i);
>  >  	} else {
>  > +		set_page_refcounted(page);
>  > +		set_pageblock_migratetype(page, MIGRATE_CMA);
>  >  		__free_pages(page, pageblock_order);
>  >  	}
> 
>  This is kinda embarrassing, dunno how I missed that.
> 
>  But each page actually does not need to have migratetype set, does it?
>  All of those pages are in a single pageblock so a single call
>  suffices.  If you track set_pageblock_migratetype down to pfn_to_bitidx
>  there is:
> 
> 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
> 
>  so for pfns inside of a pageblock, they get truncated.  Or did I miss
>  yet another thing?

Nope, my turn to miss something. You only need to set migrate type
once per pageblock.

> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee92384..fef9614 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -816,9 +816,21 @@ void __init init_cma_reserved_pageblock(struct page *page)
>  		set_page_count(p, 0);
>  	} while (++p, --i);
>  
> -	set_page_refcounted(page);
>  	set_pageblock_migratetype(page, MIGRATE_CMA);
> -	__free_pages(page, pageblock_order);
> +
> +	if (pageblock_order >= MAX_ORDER) {
> +		i = pageblock_nr_pages;
> +		p = page;
> +		do {
> +			set_page_refcounted(p);
> +			__free_pages(p, MAX_ORDER - 1);
> +			p += MAX_ORDER_NR_PAGES;
> +		} while (i -= MAX_ORDER_NR_PAGES);
> +	} else {
> +		set_page_refcounted(page);
> +		__free_pages(page, pageblock_order);
> +	}
> +
>  	adjust_managed_page_count(page, pageblock_nr_pages);
>  }
>  #endif

This version works for me. Thanks.


