Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaBELFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 06:05:55 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:44236 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaBELFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:05:52 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/5] drivers: of: add initialization code for reserved memory
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
In-Reply-To: <1391515773-6112-2-git-send-email-m.szyprowski@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com> < 1391515773-6112-2-git-send-email-m.szyprowski@samsung.com>
Date: Wed, 05 Feb 2014 11:05:38 +0000
Message-Id: <20140205110538.99E47C40A89@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Feb 2014 13:09:29 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> This patch adds device tree support for contiguous and reserved memory
> regions defined in device tree.
> 
> Large memory blocks can be reliably reserved only during early boot.
> This must happen before the whole memory management subsystem is
> initialized, because we need to ensure that the given contiguous blocks
> are not yet allocated by kernel. Also it must happen before kernel
> mappings for the whole low memory are created, to ensure that there will
> be no mappings (for reserved blocks) or mapping with special properties
> can be created (for CMA blocks). This all happens before device tree
> structures are unflattened, so we need to get reserved memory layout
> directly from fdt.
> 
> Later, those reserved memory regions are assigned to devices on each
> device structure initialization.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Laura Abbott <lauraa@codeaurora.org>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> [joshc: rework to implement new DT binding, provide mechanism for
>  plugging in new reserved-memory node handlers via
>  RESERVEDMEM_OF_DECLARE]
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> [mszyprow: little code cleanup]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/Kconfig                |    6 +
>  drivers/of/Makefile               |    1 +
>  drivers/of/of_reserved_mem.c      |  219 +++++++++++++++++++++++++++++++++++++
>  drivers/of/platform.c             |    7 ++
>  include/asm-generic/vmlinux.lds.h |   11 ++
>  include/linux/of_reserved_mem.h   |   62 +++++++++++
>  6 files changed, 306 insertions(+)
>  create mode 100644 drivers/of/of_reserved_mem.c
>  create mode 100644 include/linux/of_reserved_mem.h
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index c6973f101a3e..aba13df56f3a 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -75,4 +75,10 @@ config OF_MTD
>  	depends on MTD
>  	def_bool y
>  
> +config OF_RESERVED_MEM
> +	depends on HAVE_MEMBLOCK
> +	def_bool y
> +	help
> +	  Helpers to allow for reservation of memory regions
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index efd05102c405..ed9660adad77 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
>  obj-$(CONFIG_OF_PCI)	+= of_pci.o
>  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
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
> +static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
> +static int reserved_mem_count;
> +
> +int __init of_parse_flat_dt_reg(unsigned long node, const char *uname,
> +				   phys_addr_t *base, phys_addr_t *size)

Useful utility function; move to drivers/of/fdt.c

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

This is /okay/ for an initial implementation, but it is naive. While I
suggested making #address-cells and #size-cells equal the root node
values for the purpose of simplicity, it should still be perfectly valid
to have different values if the ranges property is correctly formed.

> +
> +	*base = dt_mem_next_cell(dt_root_addr_cells, &prop);
> +	*size = dt_mem_next_cell(dt_root_size_cells, &prop);

Future enhancement; allow for parsing more than just the first reg
tuple.

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

More than that, the size should be dead on. '==' would be the correct
test I think.

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

This is the only dependency on memblock. Make it an arch hook, and
create a default __weak implementation:

#if defined(CONFIG_HAVE_MEMBLOCK)
int __init __weak early_init_dt_reserve_memory_arch(u64 base, u64 size, bool nomap)
{
	if (nomap)
		return memblock_remove(base, size);
	return memblock_reserve(base, size);
}
#else
int __init __weak early_init_dt_reserve_memory_arch(u64 base, u64 size, bool nomap)
{
	pr_error("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
		base, size, nomap ? " (nomap)" : "");
}
#endif

> +
> +	if (err == 0)
> +		pr_info("Reserved memory: found '%s', memory base %pa, size %ld MiB\n",
> +			uname, &rmem->base, (unsigned long)rmem->size / SZ_1M);

pr_info will be too chatty I think. pr_debug please.

> +
> +	return err;
> +}
> +
> +static const struct of_device_id rmem_default_id
> +	__used __section(__reservedmem_of_table_end) = {
> +	.data		= rmem_default_early_setup,
> +};

I was going to say this isn't very type safe and that the only reason to
use of_device_id is when using of_match_node() which will iterate a
table for you. But reading further I see you're handling type checking
in the macro so this is okay.

> +
> +static int __init fdt_scan_reserved_mem(unsigned long node, const char *uname,
> +					int depth, void *data)

Move this function to fdt.c. It should be treated as a fundamental part
of memory node parsing. It should also always be enabled, regardless of
the CONFIG_OF_RESERVED_MEMORY state because the region should always be
set aside even when the kernel doesn't know how to use it.

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

It is not okay to bail here. If a region is reserved, then the kernel
*MUST* honor it, even if drivers cannot make use of it. As a bare
minimum it should be removed from the memblock pool.

> +
> +	status = of_get_flat_dt_prop(node, "status", NULL);
> +	if (status && strcmp(status, "okay") != 0)
> +		return 0;
> +
> +	/*
> +	 * The default handler above ensures this section is terminated with a
> +	 * id whose compatible string is empty
> +	 */
> +	for (id = __reservedmem_of_table; id <= &rmem_default_id; id++) {
> +		reservedmem_of_init_fn initfn = id->data;
> +		const char *compat = id->compatible;
> +
> +		if (compat[0] && !of_flat_dt_is_compatible(node, compat))
> +			continue;
> +
> +		if (initfn(rmem, node, uname) == 0) {
> +			pr_info("Reserved memory: created %s node, compatible id %s\n",
> +				uname, compat);
> +			rmem->name = uname;
> +			reserved_mem_count++;
> +			break;
> +		}
> +	}

What would be the condition that a special setup hook is called, but the
memory is not removed from the memblock pool? I seems wrong to me that
memory blocks wouldn't always get removed from main memory; even if
special setup code is executed on them.

By calling out to extra setup functions it means that each one of them
needs to implement its own memory removal code and get it correct. There
is a strong possibility for bugs there.

> +
> +	return 0;
> +}
> +
> +static struct reserved_mem *find_rmem(struct device_node *np)
> +{
> +	const char *name;
> +	unsigned int i;
> +
> +	name = kbasename(np->full_name);
> +
> +	for (i = 0; i < reserved_mem_count; i++)
> +		if (strcmp(name, reserved_mem[i].name) == 0)
> +			return &reserved_mem[i];

This looks fragile. It needs to match on the full path, not just
kbasename(), but that is expensive. However, all reserved regions should
have a phandle. You can use that for matching.

> +
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
> +	struct device_node *np = dev->of_node;
> +	struct reserved_mem *rmem;
> +	struct of_phandle_args s;
> +	unsigned int i;
> +
> +	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
> +				"#memory-region-cells", i, &s) == 0; i++) {
> +
> +		rmem = find_rmem(s.np);
> +		if (!rmem || !rmem->ops || !rmem->ops->device_init) {
> +			of_node_put(s.np);
> +			continue;
> +		}
> +
> +		rmem->ops->device_init(rmem, dev, &s);
> +		dev_info(dev, "assigned reserved memory node %s\n",
> +			 rmem->name);
> +		of_node_put(s.np);
> +		break;
> +	}
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
> +	struct device_node *np = dev->of_node;
> +	struct reserved_mem *rmem;
> +	struct of_phandle_args s;
> +	unsigned int i;
> +
> +	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
> +				"#memory-region-cells", i, &s) == 0; i++) {
> +
> +		rmem = find_rmem(s.np);
> +		if (rmem && rmem->ops && rmem->ops->device_release)
> +			rmem->ops->device_release(rmem, dev);
> +
> +		of_node_put(s.np);
> +	}
> +}
> +
> +/**
> + * early_init_dt_scan_reserved_mem() - create reserved memory regions
> + *
> + * This function grabs memory from early allocator for device exclusive use
> + * defined in device tree structures. It should be called by arch specific code
> + * once the early allocator (memblock) has been activated and all other
> + * subsystems have already allocated/reserved memory.

As commented on patch 4, this should be called by common parsing code,
not arch code.

Why do you require other subsystems to allocate/reserve memory before
the reserved regions? I would think that the reserved regions declared
in the device tree would take precedence.

> + */
> +void __init early_init_dt_scan_reserved_mem(void)
> +{
> +	of_scan_flat_dt_by_path("/reserved-memory", fdt_scan_reserved_mem,
> +				NULL);
> +}
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1daebefa..3df0b1826e8b 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -21,6 +21,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_reserved_mem.h>
>  #include <linux/platform_device.h>
>  
>  const struct of_device_id of_default_bus_match_table[] = {
> @@ -220,6 +221,8 @@ static struct platform_device *of_platform_device_create_pdata(
>  	dev->dev.bus = &platform_bus_type;
>  	dev->dev.platform_data = platform_data;
>  
> +	of_reserved_mem_device_init(&dev->dev);
> +
>  	/* We do not fill the DMA ops for platform devices by default.
>  	 * This is currently the responsibility of the platform code
>  	 * to do such, possibly using a device notifier
> @@ -227,6 +230,7 @@ static struct platform_device *of_platform_device_create_pdata(
>  
>  	if (of_device_add(dev) != 0) {
>  		platform_device_put(dev);
> +		of_reserved_mem_device_release(&dev->dev);
>  		return NULL;
>  	}
>  
> @@ -282,6 +286,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  	else
>  		of_device_make_bus_id(&dev->dev);
>  
> +	of_reserved_mem_device_init(&dev->dev);
> +
>  	/* Allow the HW Peripheral ID to be overridden */
>  	prop = of_get_property(node, "arm,primecell-periphid", NULL);
>  	if (prop)
> @@ -308,6 +314,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  	return dev;
>  
>  err_free:
> +	of_reserved_mem_device_release(&dev->dev);
>  	amba_device_put(dev);
>  	return NULL;
>  }
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bc2121fa9132..f10f64fcc815 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -167,6 +167,16 @@
>  #define CLK_OF_TABLES()
>  #endif
>  
> +#ifdef CONFIG_OF_RESERVED_MEM
> +#define RESERVEDMEM_OF_TABLES()				\
> +	. = ALIGN(8);					\
> +	VMLINUX_SYMBOL(__reservedmem_of_table) = .;	\
> +	*(__reservedmem_of_table)			\
> +	*(__reservedmem_of_table_end)
> +#else
> +#define RESERVEDMEM_OF_TABLES()
> +#endif
> +
>  #define KERNEL_DTB()							\
>  	STRUCT_ALIGN();							\
>  	VMLINUX_SYMBOL(__dtb_start) = .;				\
> @@ -490,6 +500,7 @@
>  	TRACE_SYSCALLS()						\
>  	MEM_DISCARD(init.rodata)					\
>  	CLK_OF_TABLES()							\
> +	RESERVEDMEM_OF_TABLES()						\
>  	CLKSRC_OF_TABLES()						\
>  	KERNEL_DTB()							\
>  	IRQCHIP_OF_MATCH_TABLE()
> diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
> new file mode 100644
> index 000000000000..41f43828e1db
> --- /dev/null
> +++ b/include/linux/of_reserved_mem.h
> @@ -0,0 +1,62 @@
> +#ifndef __OF_RESERVED_MEM_H
> +#define __OF_RESERVED_MEM_H
> +
> +struct cma;
> +struct platform_device;
> +struct of_phandle_args;
> +struct reserved_mem_ops;
> +
> +struct reserved_mem {
> +	const char			*name;
> +	const struct reserved_mem_ops	*ops;
> +	phys_addr_t			base;
> +	phys_addr_t			size;
> +	void				*priv;
> +};
> +
> +struct reserved_mem_ops {
> +	void	(*device_init)(struct reserved_mem *rmem,
> +			       struct device *dev,
> +			       struct of_phandle_args *args);
> +	void	(*device_release)(struct reserved_mem *rmem,
> +				  struct device *dev);
> +};
> +
> +typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem,
> +				      unsigned long node, const char *uname);
> +
> +#ifdef CONFIG_OF_RESERVED_MEM
> +void of_reserved_mem_device_init(struct device *dev);
> +void of_reserved_mem_device_release(struct device *dev);
> +void early_init_dt_scan_reserved_mem(void);
> +
> +int of_parse_flat_dt_reg(unsigned long node, const char *uname,
> +			 phys_addr_t *base, phys_addr_t *size);
> +int of_parse_flat_dt_size(unsigned long node, const char *uname,
> +			  phys_addr_t *size);
> +
> +#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> +	static const struct of_device_id __reservedmem_of_table_##name	\
> +		__used __section(__reservedmem_of_table)		\
> +		 = { .compatible = compat,				\
> +		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
> +				init : init }

Clever type checking! I haven't known about doing it that way.

> +
> +#else
> +static inline void of_reserved_mem_device_init(struct device *dev) { }
> +
> +static inline
> +void of_reserved_mem_device_release(struct device *dev) { }
> +
> +static inline void early_init_dt_scan_reserved_mem(void) { }
> +
> +#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> +	static const struct of_device_id __reservedmem_of_table_##name	\
> +		__attribute__((unused))					\
> +		 = { .compatible = compat,				\
> +		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
> +				init : init }
> +
> +#endif
> +
> +#endif /* __OF_RESERVED_MEM_H */
> -- 
> 1.7.9.5
> 

