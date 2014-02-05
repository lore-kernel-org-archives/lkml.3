Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBELJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 06:09:39 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:47225 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaBELJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:09:37 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 3/5] drivers: of: implement reserved-memory handling for cma
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
In-Reply-To: <1391515773-6112-4-git-send-email-m.szyprowski@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com> < 1391515773-6112-4-git-send-email-m.szyprowski@samsung.com>
Date: Wed, 05 Feb 2014 11:09:22 +0000
Message-Id: <20140205110922.44DAAC40A89@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Feb 2014 13:09:31 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> From: Josh Cartwright <joshc@codeaurora.org>
> 
> Add support for handling 'shared-dma-pool' reserved-memory nodes using
> Contiguous Memory Allocator driver.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Laura Abbott <lauraa@codeaurora.org>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/Kconfig               |    7 ++++
>  drivers/of/Makefile              |    1 +
>  drivers/of/of_reserved_mem_cma.c |   75 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 83 insertions(+)
>  create mode 100644 drivers/of/of_reserved_mem_cma.c
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 7ac330473ec9..5dd3a80910d2 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -81,6 +81,13 @@ config OF_RESERVED_MEM
>  	help
>  	  Helpers to allow for reservation of memory regions
>  
> +config OF_RESERVED_MEM_CMA
> +	depends on OF_RESERVED_MEM
> +	depends on DMA_CMA
> +	def_bool y
> +	help
> +	  Helpers for reserving memory regions for DMA use
> +
>  config OF_RESERVED_MEM_DMA
>  	depends on OF_RESERVED_MEM
>  	depends on HAVE_GENERIC_DMA_COHERENT
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index 6142227ca854..49b9078637b8 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -10,4 +10,5 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
>  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
>  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
> +obj-$(CONFIG_OF_RESERVED_MEM_CMA) += of_reserved_mem_cma.o
>  obj-$(CONFIG_OF_RESERVED_MEM_DMA) += of_reserved_mem_dma.o
> diff --git a/drivers/of/of_reserved_mem_cma.c b/drivers/of/of_reserved_mem_cma.c
> new file mode 100644
> index 000000000000..601d80655102
> --- /dev/null
> +++ b/drivers/of/of_reserved_mem_cma.c
> @@ -0,0 +1,75 @@
> +/*
> + * Device tree based initialization code for DMA reserved regions.
> + *
> + * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + * Author: Marek Szyprowski <m.szyprowski@samsung.com>
> + * Author: Josh Cartwright <joshc@codeaurora.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License or (at your optional) any later version of the license.
> + */
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_platform.h>
> +#include <linux/mm.h>
> +#include <linux/sizes.h>
> +#include <linux/mm_types.h>
> +#include <linux/dma-contiguous.h>
> +#include <linux/of_reserved_mem.h>
> +
> +static void rmem_cma_device_init(struct reserved_mem *rmem,
> +				 struct device *dev,
> +				 struct of_phandle_args *args)
> +{
> +	struct cma *cma = rmem->priv;
> +	dev_set_cma_area(dev, cma);
> +}
> +
> +static const struct reserved_mem_ops rmem_cma_ops = {
> +	.device_init	= rmem_cma_device_init,
> +};
> +
> +static int __init rmem_cma_setup(struct reserved_mem *rmem,
> +				 unsigned long node,
> +				 const char *uname)
> +{
> +	struct cma *cma;
> +	int err;
> +
> +	if (!of_get_flat_dt_prop(node, "reusable", NULL))
> +		return -EINVAL;
> +
> +	err = of_parse_flat_dt_reg(node, uname, &rmem->base, &rmem->size);
> +	if (!err)
> +		goto out_done;
> +
> +	rmem->base = 0;
> +	err = of_parse_flat_dt_size(node, uname, &rmem->size);
> +	if (err)
> +		goto out_err;
> +
> +out_done:

Please restrict gotos for error handling. Why not the following:

	err = of_parse_flat_dt_reg(node, uname, &rmem->base, &rmem->size);
	if (err) {
		rmem->base = 0;
		err = of_parse_flat_dt_size(node, uname, &rmem->size);
		if (err)
			goto out_err;
	}

> +	err = dma_contiguous_reserve_area(rmem->size, rmem->base, 0,
> +					  &cma);
> +	if (err) {
> +		pr_err("Reserved memory: unable to setup CMA region\n");
> +		return err;
> +	}
> +
> +	if (of_get_flat_dt_prop(node, "linux,cma-default", NULL))
> +		dma_contiguous_set_default(cma);
> +
> +	rmem->ops = &rmem_cma_ops;
> +	rmem->priv = cma;
> +
> +	return 0;
> +out_err:
> +	pr_err("Reseved memory: malformed node '%s'.\n", uname);
> +	return err;
> +}
> +RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
> -- 
> 1.7.9.5
> 

