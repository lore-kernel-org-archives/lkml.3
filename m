Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaFKXDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:03:46 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60437 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaFKXDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:03:45 -0400
Date: Wed, 11 Jun 2014 16:03:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Salter <msalter@redhat.com>, Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: fix MAX_ORDER for 64K pagesize
In-Reply-To: <1402522435-13884-1-git-send-email-msalter@redhat.com>
Message-ID: <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com>
References: <1402522435-13884-1-git-send-email-msalter@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Mark Salter wrote:

> With a kernel configured with ARM64_64K_PAGES && !TRANSPARENT_HUGEPAGE
> I get this at early boot:
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
> (HPAGE_SHIFT - PAGE_SHIFT) which is 13 for 64K pages. I worked around
> this by removing the THP test so FORCE_MAX_ZONEORDER is always 14 for
> ARM64_64K_PAGES.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 7295419..42a334e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -269,7 +269,7 @@ config XEN
>  
>  config FORCE_MAX_ZONEORDER
>  	int
> -	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
> +	default "14" if ARM64_64K_PAGES
>  	default "11"
>  
>  endmenu

Any reason to not switch this to

	ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE && CMA

instead?  If pageblock_order > MAX_ORDER because of 
HPAGE_SHIFT > PAGE_SHIFT, then cma is always going to be passing a 
too-large-order to free_pages_prepare() via this path.

Adding Michal and Marek to the cc.
