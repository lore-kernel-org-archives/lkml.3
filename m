Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3IRGNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:13:36 -0400
Received: from mail-ye0-f176.google.com ([209.85.213.176]:54063 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3IRGNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:32 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 19/28] arm: set initrd_start/initrd_end for fdt scan
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1379372965-22359-20-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-20-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 22:36:29 -0500
Message-Id: <20130918033629.0D236C42C83@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 18:09:15 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> In order to unify the initrd scanning for DT across architectures, make
> arm set initrd_start and initrd_end instead of the physical addresses.
> This is aligned with all other architectures.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  arch/arm/mm/init.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index febaee7..9eeb1cd 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -77,11 +77,11 @@ static int __init parse_tag_initrd2(const struct tag *tag)
>  
>  __tagtable(ATAG_INITRD2, parse_tag_initrd2);
>  
> -#ifdef CONFIG_OF_FLATTREE
> +#if defined(CONFIG_OF_FLATTREE) && defined(CONFIG_BLK_DEV_INITRD)
>  void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
>  {
> -	phys_initrd_start = start;
> -	phys_initrd_size = end - start;
> +	initrd_start = (unsigned long)__va(start);
> +	initrd_end = (unsigned long)__va(end);
>  }
>  #endif /* CONFIG_OF_FLATTREE */
>  
> @@ -351,6 +351,11 @@ void __init arm_memblock_init(struct meminfo *mi,
>  	memblock_reserve(__pa(_stext), _end - _stext);
>  #endif
>  #ifdef CONFIG_BLK_DEV_INITRD
> +	/* FDT scan will populate initrd_start */
> +	if (initrd_start) {
> +		phys_initrd_start = __virt_to_phys(initrd_start);
> +		phys_initrd_size = initrd_end - initrd_start;
> +	}
>  	if (phys_initrd_size &&
>  	    !memblock_is_region_memory(phys_initrd_start, phys_initrd_size)) {
>  		pr_err("INITRD: 0x%08llx+0x%08lx is not a memory region - disabling initrd\n",
> -- 
> 1.8.1.2
> 

