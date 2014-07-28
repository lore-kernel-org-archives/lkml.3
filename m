Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaG1OP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:15:29 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64095 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaG1OPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:15:25 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 RESEND 1/4] drivers: of: add automated assignment of
 reserved regions to client devices
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1405326487-15346-2-git-send-email-m.szyprowski@samsung.com>
References: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
	<1405326487-15346-2-git-send-email-m.szyprowski@samsung.com>
Date: Mon, 28 Jul 2014 08:15:16 -0600
Message-Id: <20140728141516.3CA98C408EA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 10:28:04 +0200, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> This patch adds code for automated assignment of reserved memory regions
> to struct device. reserved_mem->ops->device_init()/device_cleanup()
> callbacks are called to perform reserved memory driver specific
> initialization and cleanup
> 
> Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Applied, thanks

g.

> ---
>  drivers/of/of_reserved_mem.c    | 70 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_reserved_mem.h |  7 +++++
>  2 files changed, 77 insertions(+)
> 
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 632aae861375..59fb12e84e6b 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -206,8 +206,16 @@ void __init fdt_init_reserved_mem(void)
>  	for (i = 0; i < reserved_mem_count; i++) {
>  		struct reserved_mem *rmem = &reserved_mem[i];
>  		unsigned long node = rmem->fdt_node;
> +		int len;
> +		const __be32 *prop;
>  		int err = 0;
>  
> +		prop = of_get_flat_dt_prop(node, "phandle", &len);
> +		if (!prop)
> +			prop = of_get_flat_dt_prop(node, "linux,phandle", &len);
> +		if (prop)
> +			rmem->phandle = of_read_number(prop, len/4);
> +
>  		if (rmem->size == 0)
>  			err = __reserved_mem_alloc_size(node, rmem->name,
>  						 &rmem->base, &rmem->size);
> @@ -215,3 +223,65 @@ void __init fdt_init_reserved_mem(void)
>  			__reserved_mem_init_node(rmem);
>  	}
>  }
> +
> +static inline struct reserved_mem *__find_rmem(struct device_node *node)
> +{
> +	unsigned int i;
> +
> +	if (!node->phandle)
> +		return NULL;
> +
> +	for (i = 0; i < reserved_mem_count; i++)
> +		if (reserved_mem[i].phandle == node->phandle)
> +			return &reserved_mem[i];
> +	return NULL;
> +}
> +
> +/**
> + * of_reserved_mem_device_init() - assign reserved memory region to given device
> + *
> + * This function assign memory region pointed by "memory-region" device tree
> + * property to the given device.
> + */
> +void of_reserved_mem_device_init(struct device *dev)
> +{
> +	struct reserved_mem *rmem;
> +	struct device_node *np;
> +
> +	np = of_parse_phandle(dev->of_node, "memory-region", 0);
> +	if (!np)
> +		return;
> +
> +	rmem = __find_rmem(np);
> +	of_node_put(np);
> +
> +	if (!rmem || !rmem->ops || !rmem->ops->device_init)
> +		return;
> +
> +	rmem->ops->device_init(rmem, dev);
> +	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
> +}
> +
> +/**
> + * of_reserved_mem_device_release() - release reserved memory device structures
> + *
> + * This function releases structures allocated for memory region handling for
> + * the given device.
> + */
> +void of_reserved_mem_device_release(struct device *dev)
> +{
> +	struct reserved_mem *rmem;
> +	struct device_node *np;
> +
> +	np = of_parse_phandle(dev->of_node, "memory-region", 0);
> +	if (!np)
> +		return;
> +
> +	rmem = __find_rmem(np);
> +	of_node_put(np);
> +
> +	if (!rmem || !rmem->ops || !rmem->ops->device_release)
> +		return;
> +
> +	rmem->ops->device_release(rmem, dev);
> +}
> diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
> index 4669ddfdd5af..5b5efae09135 100644
> --- a/include/linux/of_reserved_mem.h
> +++ b/include/linux/of_reserved_mem.h
> @@ -8,6 +8,7 @@ struct reserved_mem_ops;
>  struct reserved_mem {
>  	const char			*name;
>  	unsigned long			fdt_node;
> +	unsigned long			phandle;
>  	const struct reserved_mem_ops	*ops;
>  	phys_addr_t			base;
>  	phys_addr_t			size;
> @@ -27,10 +28,16 @@ typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
>  	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
>  
>  #ifdef CONFIG_OF_RESERVED_MEM
> +void of_reserved_mem_device_init(struct device *dev);
> +void of_reserved_mem_device_release(struct device *dev);
> +
>  void fdt_init_reserved_mem(void);
>  void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
>  			       phys_addr_t base, phys_addr_t size);
>  #else
> +static inline void of_reserved_mem_device_init(struct device *dev) { }
> +static inline void of_reserved_mem_device_release(struct device *pdev) { }
> +
>  static inline void fdt_init_reserved_mem(void) { }
>  static inline void fdt_reserved_mem_save_node(unsigned long node,
>  		const char *uname, phys_addr_t base, phys_addr_t size) { }
> -- 
> 1.9.2
> 

