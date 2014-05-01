Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaEAKGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:06:20 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49176 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaEAKGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 06:06:17 -0400
Date: Thu, 1 May 2014 03:06:12 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: Re: [PATCH v5 3/6] arm64: Add a description on 48-bit address space
 with 4KB pages
Message-ID: <20140501100612.GA2848@lvm>
References: <000301cf64e5$d27f9a20$777ece60$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301cf64e5$d27f9a20$777ece60$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 11:34:05AM +0900, Jungseok Lee wrote:
> This patch adds memory layout and translation lookup information
> about 48-bit address space with 4K pages. The description is based
> on 4 levels of translation tables.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Steve Capper <steve.capper@linaro.org>
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> ---
>  Documentation/arm64/memory.txt |   59 ++++++++++++++++++++++++++++++++++------
>  1 file changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
> index d50fa61..8142709 100644
> --- a/Documentation/arm64/memory.txt
> +++ b/Documentation/arm64/memory.txt
> @@ -8,10 +8,11 @@ This document describes the virtual memory layout used by the AArch64
>  Linux kernel. The architecture allows up to 4 levels of translation
>  tables with a 4KB page size and up to 3 levels with a 64KB page size.
>  
> -AArch64 Linux uses 3 levels of translation tables with the 4KB page
> -configuration, allowing 39-bit (512GB) virtual addresses for both user
> -and kernel. With 64KB pages, only 2 levels of translation tables are
> -used but the memory layout is the same.
> +AArch64 Linux uses 3 levels and 4 levels of translation tables with

uses either 3 or 4 levels of translation?

> +the 4KB page configuration, allowing 39-bit (512GB) and 48-bit (256TB)
> +virtual addresses, respectively, for both user and kernel. With 64KB
> +pages, only 2 levels of translation tables are used but the memory layout
> +is the same.

Perhaps it's worth clarifying that with 64KB and 2 levels of translation
tables we are limited to a 42-bit address space here.

>  
>  User addresses have bits 63:39 set to 0 while the kernel addresses have
>  the same bits set to 1. TTBRx selection is given by bit 63 of the
> @@ -21,7 +22,7 @@ The swapper_pgd_dir address is written to TTBR1 and never written to
>  TTBR0.
>  
>  
> -AArch64 Linux memory layout with 4KB pages:
> +AArch64 Linux memory layout with 4KB pages + 3 levels:
>  
>  Start			End			Size		Use
>  -----------------------------------------------------------------------
> @@ -48,7 +49,34 @@ ffffffbffc000000	ffffffbfffffffff	  64MB		modules
>  ffffffc000000000	ffffffffffffffff	 256GB		kernel logical memory map
>  
>  
> -AArch64 Linux memory layout with 64KB pages:
> +AArch64 Linux memory layout with 4KB pages + 4 levels:
> +
> +Start			End			Size		Use
> +-----------------------------------------------------------------------
> +0000000000000000	0000ffffffffffff	 256TB		user
> +
> +ffff000000000000	ffff7bfffffeffff	~124TB		vmalloc
> +
> +ffff7bffffff0000	ffff7bffffffffff	  64KB		[guard page]
> +
> +ffff7c0000000000	ffff7dffffffffff	   2TB		vmemmap
> +
> +ffff7e0000000000	ffff7ffffbbfffff	  ~2TB		[guard, future vmmemap]

hmm, I may be completely confused, but if VMALLOC_END is defined to be 
(PAGE_OFFSET - UL(0x400000000) - SZ_64K), how can we squeeze ~4TB into a 16 GB hole?

> +
> +ffff7ffffa000000	ffff7ffffaffffff	  16MB		PCI I/O space
> +
> +ffff7ffffb000000	ffff7ffffbbfffff	  12MB		[guard]
> +
> +ffff7ffffbc00000	ffff7ffffbdfffff	   2MB		earlyprintk device

shouldn't this be "fixed mappings" now?

> +
> +ffff7ffffbe00000	ffff7ffffbffffff	   2MB		[guard]
> +
> +ffff7ffffc000000	ffff7fffffffffff	  64MB		modules
> +
> +ffff800000000000	ffffffffffffffff	 128TB		kernel logical memory map
> +
> +
> +AArch64 Linux memory layout with 64KB pages + 2 levels:
>  
>  Start			End			Size		Use
>  -----------------------------------------------------------------------
> @@ -75,7 +103,7 @@ fffffdfffc000000	fffffdffffffffff	  64MB		modules
>  fffffe0000000000	ffffffffffffffff	   2TB		kernel logical memory map
>  
>  
> -Translation table lookup with 4KB pages:
> +Translation table lookup with 4KB pages + 3 levels:
>  
>  +--------+--------+--------+--------+--------+--------+--------+--------+
>  |63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
> @@ -90,7 +118,22 @@ Translation table lookup with 4KB pages:
>   +-------------------------------------------------> [63] TTBR0/1
>  
>  
> -Translation table lookup with 64KB pages:
> +Translation table lookup with 4KB pages + 4 levels:
> +
> ++--------+--------+--------+--------+--------+--------+--------+--------+
> +|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
> ++--------+--------+--------+--------+--------+--------+--------+--------+
> + |                 |         |         |         |         |
> + |                 |         |         |         |         v
> + |                 |         |         |         |   [11:0]  in-page offset
> + |                 |         |         |         +-> [20:12] L3 index
> + |                 |         |         +-----------> [29:21] L2 index
> + |                 |         +---------------------> [38:30] L1 index
> + |                 +-------------------------------> [47:39] L0 index
> + +-------------------------------------------------> [63] TTBR0/1
> +
> +
> +Translation table lookup with 64KB pages + 2 levels:
>  
>  +--------+--------+--------+--------+--------+--------+--------+--------+
>  |63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
> -- 
> 1.7.10.4
> 
> 
