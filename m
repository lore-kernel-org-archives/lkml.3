Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233AbaFSSMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbaFSSMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:12:43 -0400
Message-ID: <1403201524.32688.62.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: fix MAX_ORDER for 64K pagesize
From: Mark Salter <msalter@redhat.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 14:12:04 -0400
In-Reply-To: <xa1t61jzwfo6.fsf@mina86.com>
References: <1402522435-13884-1-git-send-email-msalter@redhat.com>
	 <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com>
	 <xa1t61jzwfo6.fsf@mina86.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 20:32 +0200, Michal Nazarewicz wrote:
> On Wed, Jun 11 2014, David Rientjes wrote:
> > On Wed, 11 Jun 2014, Mark Salter wrote:
> >
> >> With a kernel configured with ARM64_64K_PAGES && !TRANSPARENT_HUGEPAGE
> >> I get this at early boot:
> >> 
> >>   SMP: Total of 8 processors activated.
> >>   devtmpfs: initialized
> >>   Unable to handle kernel NULL pointer dereference at virtual address 00000008
> >>   pgd = fffffe0000050000
> >>   [00000008] *pgd=00000043fba00003, *pmd=00000043fba00003, *pte=00e0000078010407
> >>   Internal error: Oops: 96000006 [#1] SMP
> >>   Modules linked in:
> >>   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc864k+ #44
> >>   task: fffffe03bc040000 ti: fffffe03bc080000 task.ti: fffffe03bc080000
> >>   PC is at __list_add+0x10/0xd4
> >>   LR is at free_one_page+0x270/0x638
> >>   ...
> >>   Call trace:
> >>   [<fffffe00003ee970>] __list_add+0x10/0xd4
> >>   [<fffffe000019c478>] free_one_page+0x26c/0x638
> >>   [<fffffe000019c8c8>] __free_pages_ok.part.52+0x84/0xbc
> >>   [<fffffe000019d5e8>] __free_pages+0x74/0xbc
> >>   [<fffffe0000c01350>] init_cma_reserved_pageblock+0xe8/0x104
> >>   [<fffffe0000c24de0>] cma_init_reserved_areas+0x190/0x1e4
> >>   [<fffffe0000090418>] do_one_initcall+0xc4/0x154
> >>   [<fffffe0000bf0a50>] kernel_init_freeable+0x204/0x2a8
> >>   [<fffffe00007520a0>] kernel_init+0xc/0xd4
> >> 
> >> This happens in this configuration because __free_one_page() is called
> >> with an order greater than MAX_ORDER, accesses past zone->free_list[]
> >> and passes a bogus list_head to list_add().
> >> 
> >> arch/arm64/Kconfig has:
> >> 
> >>   config FORCE_MAX_ZONEORDER
> >> 	int
> >> 	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
> >> 	default "11"
> >> 
> >> So with THP turned off MAX_ORDER == 11 but init_cma_reserved_pageblock()
> >> passes __free_pages() an order of pageblock_order which is based on
> >> (HPAGE_SHIFT - PAGE_SHIFT) which is 13 for 64K pages. I worked around
> >> this by removing the THP test so FORCE_MAX_ZONEORDER is always 14 for
> >> ARM64_64K_PAGES.
> >> 
> >> Signed-off-by: Mark Salter <msalter@redhat.com>
> >> ---
> >>  arch/arm64/Kconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> index 7295419..42a334e 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -269,7 +269,7 @@ config XEN
> >>  
> >>  config FORCE_MAX_ZONEORDER
> >>  	int
> >> -	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
> >> +	default "14" if ARM64_64K_PAGES
> >>  	default "11"
> >>  
> >>  endmenu
> >
> > Any reason to not switch this to
> >
> > 	ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE && CMA
> >
> > instead?  If pageblock_order > MAX_ORDER because of 
> > HPAGE_SHIFT > PAGE_SHIFT, then cma is always going to be passing a 
> > too-large-order to free_pages_prepare() via this path.
> >
> > Adding Michal and Marek to the cc.
> 
> The correct fix would be to change init_cma_reserved_pageblock such that
> it checks whether pageblock_order > MAX_ORDER and if so frees each max
> order page of the pageblock individually:
> 
> --------- >8 ---------------------------------------------------------
> From: Michal Nazarewicz <mina86@mina86.com>
> Subject: [PATCH] mm: cma: fix cases where pageblock is bigger then MAX_ORDER
> 
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
> This happens in this configuration because __free_one_page() is called
> with an order greater than MAX_ORDER, accesses past zone->free_list[]
> and passes a bogus list_head to list_add().
> 
> arch/arm64/Kconfig has:
> 
>   config FORCE_MAX_ZONEORDER
> 	int
> 	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
> 	default "11"
> 
> So with THP turned off MAX_ORDER == 11 but init_cma_reserved_pageblock()
> passes __free_pages() an order of pageblock_order which is based on
> (HPAGE_SHIFT - PAGE_SHIFT) which is 13 for 64K pages.
> 
> Fix the problem by changing init_cma_reserved_pageblock() such that it
> splits pageblock into individual MAX_ORDER pages if pageblock is
> bigger than a MAX_ORDER page.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Reported-by: Mark Salter <msalter@redhat.com>
> ---
>  mm/page_alloc.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5dba293..6e657ce 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -801,7 +801,15 @@ void __init init_cma_reserved_pageblock(struct page *page)
>  
>  	set_page_refcounted(page);
>  	set_pageblock_migratetype(page, MIGRATE_CMA);
> -	__free_pages(page, pageblock_order);
> +	if (pageblock_order > MAX_ORDER) {
> +		struct page *subpage = p;
> +		unsigned count = 1 << (pageblock_order - MAX_ORDER);
> +		do {
> +			__free_pages(subpage, pageblock_order);
                                               ^^^^^^^
                                               MAX_ORDER

> +		} while (subpage += MAX_ORDER_NR_PAGES, --count);
> +	} else {
> +		__free_pages(page, pageblock_order);
> +	}
>  	adjust_managed_page_count(page, pageblock_nr_pages);
>  }
>  #endif
> --------- >8 ---------------------------------------------------------
> 
> Thoughts?  This has not been tested and I think it may cause performance
> degradation in some cases since pageblock_order is not always
> a constant, so the comparison may end up not being stripped away even on
> systems where it's always false.
> 

This works with the above tweak. So it fixes the problm here, but I was
not sure if we'd get bitten elsewhere by pageblock_order > MAX_ORDER.
It will be slower, but does it only gets called a few time at most at
boot time, right?


