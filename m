Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3IRXmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:42:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55354 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3IRXmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:42:32 -0400
Date: Thu, 19 Sep 2013 00:36:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Marko Katic <dromede@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: pxa: sharpsl_param.c: fix invalid memory access
Message-ID: <20130918233652.GY12758@n2100.arm.linux.org.uk>
References: <1379546319-29165-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379546319-29165-1-git-send-email-andrea.adami@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 01:18:39AM +0200, Andrea Adami wrote:
> After commit 72662e01088394577be4a3f14da94cf87bea2591
> ARM: head.S: only include __turn_mmu_on in the initial identity mapping
> 
> Zaurus PXA devices call sharpsl_save_param() during fixup and hang on
> boot because memcpy refers to physical addresses no longer valid if the
> MMU is setup.
> Zaurus collie (SA1100) is unaffected (function is called in init_machine).

Yes, moving that will have broken this, but that's only because this code
is making assumptions about stuff which we don't really "guarantee" will
be the case.  For PXA, moving it to use the virtual address is the right
solution, one which would've worked before the change too.

For SA11x0 - I suspect 0xe8ffc000 is a virtual address already (it
points into the main flash) so I think this is okay.

Some comments though:

> diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
> index d56c932..4dcd349 100644
> --- a/arch/arm/common/sharpsl_param.c
> +++ b/arch/arm/common/sharpsl_param.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <asm/mach/sharpsl_param.h>
> +#include <asm/memory.h>
>  
>  /*
>   * Certain hardware parameters determined at the time of device manufacture,
> @@ -23,6 +24,8 @@
>   * them early in the boot process, then pass them to the appropriate drivers.
>   * Not all devices use all parameters but the format is common to all.
>   */
> +
> +

Please be more careful about adding extraneous blank lines/spaces to files.

>  #ifdef CONFIG_ARCH_SA1100
>  #define PARAM_BASE	0xe8ffc000
>  #else
> @@ -41,7 +44,17 @@ EXPORT_SYMBOL(sharpsl_param);
>  
>  void sharpsl_save_param(void)
>  {
> -	memcpy(&sharpsl_param, (void *)PARAM_BASE, sizeof(struct sharpsl_param_info));
> +/* NOTE:
> + * Zaurus PXA devices call sharpsl_save_param() during fixup and the MMU
> + * is setup so we need to translate the physical address.
> + * Zaurus collie (SA1100) is unaffected (function is called in init_machine).
> + */
> +#ifdef CONFIG_ARCH_SA1100
> +	void *param_start = (void *)PARAM_BASE;
> +#else
> +	void *param_start = phys_to_virt(PARAM_BASE);
> +#endif
> +	memcpy(&sharpsl_param, param_start, sizeof(struct sharpsl_param_info));

I'd suggest moving the (void *) cast to the #defines above, and also the
phys_to_virt() too.  With a reasonable commit log, I don't think we need
the comments either.

> @@ -58,5 +71,3 @@ void sharpsl_save_param(void)
>  	if (sharpsl_param.adadj_keyword != AD_MAGIC)
>  		sharpsl_param.adadj=-1;
>  }
> -
> -

While removal of lines is a good thing, this isn't really part of this
patch, but I'd say in this case don't worry about that.

Thanks.
