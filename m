Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbaBFWIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:08:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36066 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBFWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:08:39 -0500
Message-ID: <52F407E5.5080806@codeaurora.org>
Date: Thu, 06 Feb 2014 14:08:37 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rob Herring <robh+dt@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Marc <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v2 1/5] drivers: of: add initialization code for reserved
 memory
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com> <1391515773-6112-2-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1391515773-6112-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2/4/2014 4:09 AM, Marek Szyprowski wrote:
...
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index efd05102c405..ed9660adad77 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
>   obj-$(CONFIG_OF_PCI)	+= of_pci.o
>   obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>   obj-$(CONFIG_OF_MTD)	+= of_mtd.o
> +obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> new file mode 100644
> index 000000000000..f17cd56e68d9
> --- /dev/null
> +++ b/drivers/of/of_reserved_mem.c
> @@ -0,0 +1,219 @@
> +/*
> + * Device tree based initialization code for reserved memory.
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
> +#include <linux/memblock.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_platform.h>
> +#include <linux/mm.h>
> +#include <linux/sizes.h>
> +#include <linux/of_reserved_mem.h>
> +
> +#define MAX_RESERVED_REGIONS	16

Make this a config option?

> +static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
> +static int reserved_mem_count;
> +
> +int __init of_parse_flat_dt_reg(unsigned long node, const char *uname,
> +				   phys_addr_t *base, phys_addr_t *size)
> +{
> +	unsigned long len;
> +	__be32 *prop;
> +
> +	prop = of_get_flat_dt_prop(node, "reg", &len);
> +	if (!prop)
> +		return -EINVAL;
> +
> +	if (len < (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32)) {
> +		pr_err("Reserved memory: invalid reg property in '%s' node.\n",
> +				uname);
> +		return -EINVAL;
> +	}
> +
> +	*base = dt_mem_next_cell(dt_root_addr_cells, &prop);
> +	*size = dt_mem_next_cell(dt_root_size_cells, &prop);
> +	return 0;
> +}
> +
> +int __init of_parse_flat_dt_size(unsigned long node, const char *uname,
> +				    phys_addr_t *size)
> +{
> +	unsigned long len;
> +	__be32 *prop;
> +
> +	prop = of_get_flat_dt_prop(node, "size", &len);
> +	if (!prop)
> +		return -EINVAL;
> +
> +	if (len < dt_root_size_cells * sizeof(__be32)) {
> +		pr_err("Reserved memory: invalid size property in '%s' node.\n",
> +				uname);
> +		return -EINVAL;
> +	}
> +
> +	*size = dt_mem_next_cell(dt_root_size_cells, &prop);
> +	return 0;
> +}
> +
> +static int __init rmem_default_early_setup(struct reserved_mem *rmem,
> +					   unsigned long node,
> +					   const char *uname)
> +{
> +	int err;
> +
> +	if (of_get_flat_dt_prop(node, "compatible", NULL))
> +		return -EINVAL;
> +
> +	err = of_parse_flat_dt_reg(node, uname, &rmem->base, &rmem->size);
> +	if (err)
> +		return err;
> +
> +	if (of_get_flat_dt_prop(node, "no-map", NULL))
> +		err = memblock_remove(rmem->base, rmem->size);
> +	else
> +		err = memblock_reserve(rmem->base, rmem->size);
> +

The CMA code aligns to pageblock size, do we need to do something 
similar here as well? With reserved it might not be much of an issue but 
we've hit issues before with non-pageblock aligned memblock_removed 
memory because the page structures are not initialized.

> +	if (err == 0)
> +		pr_info("Reserved memory: found '%s', memory base %pa, size %ld MiB\n",
> +			uname, &rmem->base, (unsigned long)rmem->size / SZ_1M);
> +
> +	return err;
> +}
> +
> +static const struct of_device_id rmem_default_id
> +	__used __section(__reservedmem_of_table_end) = {
> +	.data		= rmem_default_early_setup,
> +};
> +
> +static int __init fdt_scan_reserved_mem(unsigned long node, const char *uname,
> +					int depth, void *data)
> +{
> +	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
> +	extern const struct of_device_id __reservedmem_of_table[];
> +	const struct of_device_id *id;
> +	const char *status;
> +
> +	if (reserved_mem_count == ARRAY_SIZE(reserved_mem)) {
> +		pr_err("Reserved memory: not enough space all defined regions.\n");
> +		return -ENOSPC;
> +	}
> +
> +	status = of_get_flat_dt_prop(node, "status", NULL);
> +	if (status && strcmp(status, "okay") != 0)
> +		return 0;
> +

strncmp(status, "ok", 2) to handle alternate spellings

>

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
