Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3KXX0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 18:26:49 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:39604 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3KXX0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:26:48 -0500
Date: Sun, 24 Nov 2013 18:26:45 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com
Subject: Re: [PATCH] ARM: pxa: Move iotable mapping inside vmalloc region
In-Reply-To: <1385296571-23599-1-git-send-email-ezequiel.garcia@free-electrons.com>
Message-ID: <alpine.LFD.2.10.1311241824380.9667@knanqh.ubzr>
References: <1385296571-23599-1-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Nov 2013, Ezequiel Garcia wrote:

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
> While at it, let's add some nicer defines to make the code
> more readable.
> 
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  arch/arm/mach-pxa/generic.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
> index 4225417..7c01095 100644
> --- a/arch/arm/mach-pxa/generic.c
> +++ b/arch/arm/mach-pxa/generic.c
> @@ -24,6 +24,7 @@
>  #include <mach/hardware.h>
>  #include <asm/mach/map.h>
>  #include <asm/mach-types.h>
> +#include <asm/pgtable.h>
>  
>  #include <mach/reset.h>
>  #include <mach/smemc.h>
> @@ -77,6 +78,11 @@ EXPORT_SYMBOL(get_clk_frequency_khz);
>   * Note: virtual 0xfffe0000-0xffffffff is reserved for the vector table
>   *       and cache flush area.
>   */
> +
> +#define UNCACHED_PHY	0x00000000
> +#define UNCACHED_SIZE	SZ_1M
> +#define UNCACHED_VIRT	(VMALLOC_END - UNCACHED_SIZE)
> +
>  static struct map_desc common_io_desc[] __initdata = {
>    	{	/* Devs */
>  		.virtual	=  0xf2000000,
> @@ -84,9 +90,9 @@ static struct map_desc common_io_desc[] __initdata = {
>  		.length		= 0x02000000,
>  		.type		= MT_DEVICE
>  	}, {	/* UNCACHED_PHYS_0 */
> -		.virtual	= 0xff000000,
> -		.pfn		= __phys_to_pfn(0x00000000),
> -		.length		= 0x00100000,
> +		.virtual	= UNCACHED_VIRT,
> +		.pfn		= __phys_to_pfn(UNCACHED_PHY),
> +		.length		= UNCACHED_SIZE,
>  		.type		= MT_DEVICE
>  	}
>  };

You might wish to change the virtual address for this mapping, but 
nowhere in your patch you are changing users of that virtual mapping.


Nicolas
