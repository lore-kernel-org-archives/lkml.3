Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaEXEKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 00:10:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:35395 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbaEXEKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 00:10:33 -0400
Message-ID: <1400904621.3958.11.camel@pasglop>
Subject: Re: [PATCH v2 2/2] of: Stop naming platform_device using dcr address
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Date: Sat, 24 May 2014 14:10:21 +1000
In-Reply-To: <1400801769-4506-3-git-send-email-grant.likely@linaro.org>
References: <1400801769-4506-1-git-send-email-grant.likely@linaro.org>
	 <1400801769-4506-3-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 08:36 +0900, Grant Likely wrote:
> There is now a way to ensure all platform devices get a unique name when
> populated from the device tree, and the DCR_NATIVE code path is broken
> anyway. PowerPC Cell (PS3) is the only platform that actually uses this
> path.  Most likely nobody will notice if it is killed. Remove the code
> and associated ugly #ifdef.
> 
> The user-visible impact of this patch is that any DCR device on Cell
> will get a new name in the /sys/devices hierarchy.

I don't understand. First DCR devices cover more than Cell (and not even
PS3). All 4xx embedded have some form of DCR based devices so I don't
know how much we use as "platform".

What do you mean by "the DCR_NATIVE" code path is broken anyway ?

Changing user visible platform device names has broken stuff in the
past, I'm not saying it is now but I'd like a better justification
for removing this.

Cheers,
Ben.


> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/include/asm/dcr-mmio.h |  4 ----
>  arch/powerpc/sysdev/dcr.c           |  6 +++---
>  drivers/of/platform.c               | 24 ------------------------
>  3 files changed, 3 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/dcr-mmio.h b/arch/powerpc/include/asm/dcr-mmio.h
> index acd491dbd45a..93a68b28e695 100644
> --- a/arch/powerpc/include/asm/dcr-mmio.h
> +++ b/arch/powerpc/include/asm/dcr-mmio.h
> @@ -51,10 +51,6 @@ static inline void dcr_write_mmio(dcr_host_mmio_t host,
>  	out_be32(host.token + ((host.base + dcr_n) * host.stride), value);
>  }
>  
> -extern u64 of_translate_dcr_address(struct device_node *dev,
> -				    unsigned int dcr_n,
> -				    unsigned int *stride);
> -
>  #endif /* __KERNEL__ */
>  #endif /* _ASM_POWERPC_DCR_MMIO_H */
>  
> diff --git a/arch/powerpc/sysdev/dcr.c b/arch/powerpc/sysdev/dcr.c
> index 1bd0eba4d355..e9056e438575 100644
> --- a/arch/powerpc/sysdev/dcr.c
> +++ b/arch/powerpc/sysdev/dcr.c
> @@ -152,9 +152,9 @@ EXPORT_SYMBOL_GPL(dcr_resource_len);
>  
>  #ifdef CONFIG_PPC_DCR_MMIO
>  
> -u64 of_translate_dcr_address(struct device_node *dev,
> -			     unsigned int dcr_n,
> -			     unsigned int *out_stride)
> +static u64 of_translate_dcr_address(struct device_node *dev,
> +				    unsigned int dcr_n,
> +				    unsigned int *out_stride)
>  {
>  	struct device_node *dp;
>  	const u32 *p;
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 95c133a0554b..52780a72d09d 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -51,10 +51,6 @@ struct platform_device *of_find_device_by_node(struct device_node *np)
>  }
>  EXPORT_SYMBOL(of_find_device_by_node);
>  
> -#if defined(CONFIG_PPC_DCR)
> -#include <asm/dcr.h>
> -#endif
> -
>  #ifdef CONFIG_OF_ADDRESS
>  /*
>   * The following routines scan a subtree and registers a device for
> @@ -78,26 +74,6 @@ void of_device_make_bus_id(struct device *dev)
>  	const __be32 *reg;
>  	u64 addr;
>  
> -#ifdef CONFIG_PPC_DCR
> -	/*
> -	 * If it's a DCR based device, use 'd' for native DCRs
> -	 * and 'D' for MMIO DCRs.
> -	 */
> -	reg = of_get_property(node, "dcr-reg", NULL);
> -	if (reg) {
> -#ifdef CONFIG_PPC_DCR_NATIVE
> -		dev_set_name(dev, "d%x.%s", *reg, node->name);
> -#else /* CONFIG_PPC_DCR_NATIVE */
> -		u64 addr = of_translate_dcr_address(node, *reg, NULL);
> -		if (addr != OF_BAD_ADDR) {
> -			dev_set_name(dev, "D%llx.%s",
> -				     (unsigned long long)addr, node->name);
> -			return;
> -		}
> -#endif /* !CONFIG_PPC_DCR_NATIVE */
> -	}
> -#endif /* CONFIG_PPC_DCR */
> -
>  	/* Construct the name, using parent nodes if necessary to ensure uniqueness */
>  	while (node->parent) {
>  		/*


