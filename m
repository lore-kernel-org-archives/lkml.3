Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3K2Shp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 13:37:45 -0500
Received: from ttcsn157-7.ttc.cz ([212.158.157.7]:58008 "EHLO ixit.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3K2Sho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 13:37:44 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Nov 2013 13:37:44 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Nov 2013 19:26:02 +0100
From: David Heidelberger <david.heidelberger@ixit.cz>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: pxa: Move iotable mapping inside vmalloc region
In-Reply-To: <1385683243-6688-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1385683243-6688-1-git-send-email-ezequiel.garcia@free-electrons.com>
Message-ID: <3851da8e73651372353201e697c0f55f@ixit.cz>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build fails with this patch with:
arch/arm/mach-pxa/standby.S:25: Error: missing ')'
arch/arm/mach-pxa/standby.S:25: Error: garbage following instruction -- 
`mov r3,#(0xff000000UL-0x00100000)'

After replace VMALLOC_END to 0xff000000 (without UL) it fails with:

arch/arm/mach-pxa/sleep.S:52: Error: invalid constant (fffffffffef00000) 
after fixup

it will probably fail everywhere in asm code, where is declared 
UNCACHED_PHYS_0

Thank you,
David

Dne 2013-11-29 01:00, Ezequiel Garcia napsal:
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
> 
>  arch/arm/mach-pxa/generic.c               | 6 ++++--
>  arch/arm/mach-pxa/include/mach/hardware.h | 5 +++--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
> index 4225417..3c1b4fa 100644
> --- a/arch/arm/mach-pxa/generic.c
> +++ b/arch/arm/mach-pxa/generic.c
> @@ -83,11 +83,13 @@ static struct map_desc common_io_desc[] __initdata 
> = {
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
> b/arch/arm/mach-pxa/include/mach/hardware.h
> index ccb06e4..b365a72 100644
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
