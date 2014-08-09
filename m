Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaHIAZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:25:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaHIAZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:25:14 -0400
Message-ID: <53E56A67.7040303@codeaurora.org>
Date: Fri, 08 Aug 2014 17:25:11 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] drivers: dma-coherent: add initialization from
 device tree
References: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com> <1405321966-28184-4-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1405321966-28184-4-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 12:12 AM, Marek Szyprowski wrote:
> Add support for handling 'shared-dma-pool' reserved-memory device tree
> nodes.
> 
> Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/base/dma-coherent.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
> index 7d6e84a51424..b20cbe095d86 100644
> --- a/drivers/base/dma-coherent.c
> +++ b/drivers/base/dma-coherent.c
> @@ -218,3 +218,43 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
>  	return 0;
>  }
>  EXPORT_SYMBOL(dma_mmap_from_coherent);
> +
> +/*
> + * Support for reserved memory regions defined in device tree
> + */
> +#ifdef CONFIG_OF_RESERVED_MEM
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_reserved_mem.h>
> +
> +static void rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
> +{
> +	dma_declare_coherent_memory(dev, rmem->base, rmem->base,
> +		rmem->size, DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> +}
> +
> +static void rmem_dma_device_release(struct reserved_mem *rmem,
> +				    struct device *dev)
> +{
> +	dma_release_declared_memory(dev);
> +}
> +
> +static const struct reserved_mem_ops rmem_dma_ops = {
> +	.device_init	= rmem_dma_device_init,
> +	.device_release	= rmem_dma_device_release,
> +};
> +
> +static int __init rmem_dma_setup(struct reserved_mem *rmem)
> +{
> +	unsigned long node = rmem->fdt_node;
> +
> +	if (of_get_flat_dt_prop(node, "reusable", NULL))
> +		return -EINVAL;
> +

Can we add a check for 'no-map' property here? At least on ARM, the
lack of the no-map property causes the ioremap to fail.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
