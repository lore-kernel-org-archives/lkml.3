Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948AbaDIQYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:24:44 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:37097 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720AbaDIQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:24:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        haojian.zhuang@gmail.com,
        David Heidelberger <david.heidelberger@ixit.cz>, eric.y.miao@gmail.com
Subject: Re: [PATCH v2] ARM: pxa: Move iotable mapping inside vmalloc region
Date: Wed, 09 Apr 2014 18:26:51 +0200
Message-ID: <2638213.3rVdlp7YXW@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1385683243-6688-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1385683243-6688-1-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ezequiel,

On Thursday 28 November 2013 21:00:43 Ezequiel Garcia wrote:
> In order to remove the following ugly message:
> 
>   BUG: mapping for 0x00000000 at 0xff000000 out of vmalloc space
> 
> the iotable mappings should be re-located inside the vmalloc
> region. Such move was introduced at commit:
> 
> commit 0536bdf33faff4d940ac094c77998cfac368cfff
> Author: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date:   Thu Aug 25 00:35:59 2011 -0400
> 
>     ARM: move iotable mappings within the vmalloc region
> 
> While at it, condition the mapping to PXA25x and PXA27x, which
> are the only platforms where it's used.
> 
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: David Heidelberger <david.heidelberger@ixit.cz>
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
> David,
> 
> Is it possible for you to give this a try on your board?

I'm running into the same issue on a PXA270 system.

UNCACHED_PHYS_0 is used as an immediate operand to a mov instruction, and thus 
needs to be encoded as a shifted 8-bit value. One simple solution would be to 
hardcode it to 0xfd000000 (0xfe000000 is already used for the IMEMC mapping).

Another solution would be to keep the UNCACHED_PHYS_0 mapping at the end of 
the vmalloc area (with a fix for the UL problem due to VMALLOC_END) and modify 
pxa2[57]x_finish_suspend and pm_enter_standby_start to use an ldr instruction 
instead of a move instruction to load the address.

As a side note, the IMEMC mapping seems unused, maybe we could thus reclaim it 
and use 0xfe000000 for UNCACHED_PHYS_0.

Do you plan to submit a v3 of this patch ?

>  arch/arm/mach-pxa/generic.c               | 6 ++++--
>  arch/arm/mach-pxa/include/mach/hardware.h | 5 +++--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
> index 4225417..3c1b4fa 100644
> --- a/arch/arm/mach-pxa/generic.c
> +++ b/arch/arm/mach-pxa/generic.c
> @@ -83,11 +83,13 @@ static struct map_desc common_io_desc[] __initdata = {
>  		.pfn		= __phys_to_pfn(0x40000000),
>  		.length		= 0x02000000,
>  		.type		= MT_DEVICE
> +#if defined(CONFIG_PXA25x) || defined(CONFIG_PXA27x)
>  	}, {	/* UNCACHED_PHYS_0 */
> -		.virtual	= 0xff000000,
> +		.virtual	= UNCACHED_PHYS_0,
>  		.pfn		= __phys_to_pfn(0x00000000),
> -		.length		= 0x00100000,
> +		.length		= UNCACHED_SIZE,
>  		.type		= MT_DEVICE
> +#endif
>  	}
>  };
> 
> diff --git a/arch/arm/mach-pxa/include/mach/hardware.h
> b/arch/arm/mach-pxa/include/mach/hardware.h index ccb06e4..b365a72 100644
> --- a/arch/arm/mach-pxa/include/mach/hardware.h
> +++ b/arch/arm/mach-pxa/include/mach/hardware.h
> @@ -14,13 +14,14 @@
>  #define __ASM_ARCH_HARDWARE_H
> 
>  #include <mach/addr-map.h>
> +#include <asm/pgtable.h>
> 
>  /*
>   * Workarounds for at least 2 errata so far require this.
>   * The mapping is set in mach-pxa/generic.c.
>   */
> -#define UNCACHED_PHYS_0		0xff000000
> -#define UNCACHED_ADDR		UNCACHED_PHYS_0
> +#define UNCACHED_PHYS_0		(VMALLOC_END - UNCACHED_SIZE)
> +#define UNCACHED_SIZE		SZ_1M
> 
>  /*
>   * Intel PXA2xx internal register mapping:

-- 
Regards,

Laurent Pinchart

