Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaBTOBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:01:11 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:37889 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaBTOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:01:08 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/7] drivers: of: add initialization code for reserved memory
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1392893567-31623-2-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com> < 1392893567-31623-2-git-send-email-m.szyprowski@samsung.com>
Date: Thu, 20 Feb 2014 14:01:00 +0000
Message-Id: <20140220140100.5BD65C4050F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 11:52:41 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
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
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> [joshc: rework to implement new DT binding, provide mechanism for
>  plugging in new reserved-memory node handlers via
>  RESERVEDMEM_OF_DECLARE]
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> [mszyprow: added generic memory reservation code, refactored code to
>  put it directly into fdt.c]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/Kconfig                |    6 +
>  drivers/of/Makefile               |    1 +
>  drivers/of/fdt.c                  |  145 ++++++++++++++++++
>  drivers/of/of_reserved_mem.c      |  296 +++++++++++++++++++++++++++++++++++++
>  drivers/of/platform.c             |    7 +
>  include/asm-generic/vmlinux.lds.h |   11 ++
>  include/linux/of_reserved_mem.h   |   65 ++++++++
>  7 files changed, 531 insertions(+)
>  create mode 100644 drivers/of/of_reserved_mem.c
>  create mode 100644 include/linux/of_reserved_mem.h

Hi Marek,

There's a lot of moving parts in this patch. Can you split the patch up a bit please. There are parts that I'm not entierly comfortable with yet and it will help reviewing them if they are added separately. For instance, the attaching regions to devices is something that I want to have some discussion about, but the core reserving static ranges I think is pretty much ready to be merged. I can merge the later while still debating the former if they are split.

I would recommend splitting into four:
1) reservation of static regions without the support code for referencing them later
2) code to also do dynamic allocations of reserved regions - again without any driver references
3) add hooks to reference specific regions.
4) hooks into drivers/of/platform.c for wiring into the driver model.

Can you also make the binding doc the first patch?

> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index c6973f101a3e..30a7d87a8077 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -75,4 +75,10 @@ config OF_MTD
>  	depends on MTD
>  	def_bool y
>  
> +config OF_RESERVED_MEM
> +	depends on OF_EARLY_FLATTREE
> +	bool
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
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 758b4f8b30b7..04efe2ba736f 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
> +#include <linux/of_reserved_mem.h>
>  #include <linux/string.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
> @@ -438,6 +439,150 @@ int __initdata dt_root_size_cells;
>  struct boot_param_header *initial_boot_params;
>  
>  #ifdef CONFIG_OF_EARLY_FLATTREE
> +#if defined(CONFIG_HAVE_MEMBLOCK)
> +int __init __weak
> +early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
> +				  bool nomap)
> +{
> +	if (memblock_is_region_reserved(base, size))
> +		return -EBUSY;
> +	if (nomap)
> +		return memblock_remove(base, size);
> +	return memblock_reserve(base, size);
> +}
> +#else
> +int __init __weak
> +early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
> +				  bool nomap)
> +{
> +	pr_error("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
> +		  base, size, nomap ? " (nomap)" : "");
> +	return -ENOSYS;
> +}
> +#endif

Group the above with the early_init_dt_add_memory_arch() and
early_init_dt_alloc_memory_arch() hooks.

> +
> +/**
> + * res_mem_reserve_reg() - reserve all memory described in 'reg' property
> + */
> +static int __init
> +__reserved_mem_reserve_reg(unsigned long node, const char *uname,
> +		    phys_addr_t *res_base, phys_addr_t *res_size)

Nit: put the funciton name on the same line as "static int __init". It's
more grep friendly that way and is the style used by fdt.c

> +{
> +	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
> +	phys_addr_t base, size;
> +	unsigned long len;
> +	__be32 *prop;
> +	int nomap;
> +
> +	prop = of_get_flat_dt_prop(node, "reg", &len);
> +	if (!prop)
> +		return -ENOENT;
> +
> +	if (len && len % t_len != 0) {
> +		pr_err("Reserved memory: invalid reg property in '%s', skipping node.\n",
> +		       uname);
> +		return -EINVAL;
> +	}
> +
> +	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
> +
> +	/* store base and size values from the first reg tuple */
> +	*res_base = 0;
> +	while (len > 0) {
> +		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
> +		size = dt_mem_next_cell(dt_root_size_cells, &prop);
> +
> +		if (base && size &&
> +		    early_init_dt_reserve_memory_arch(base, size, nomap) == 0)
> +			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %ld MiB\n",
> +				uname, &base, (unsigned long)size / SZ_1M);
> +		else
> +			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %ld MiB\n",
> +				uname, &base, (unsigned long)size / SZ_1M);
> +
> +		len -= t_len;
> +
> +		if (!(*res_base)) {
> +			*res_base = base;
> +			*res_size = size;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int __reserved_mem_check_root(unsigned long node)
> +{
> +	__be32 *prop;
> +
> +	prop = of_get_flat_dt_prop(node, "#size-cells", NULL);
> +	if (prop && be32_to_cpup(prop) != dt_root_size_cells)
> +		return -EINVAL;
> +
> +	prop = of_get_flat_dt_prop(node, "#address-cells", NULL);
> +	if (prop && be32_to_cpup(prop) != dt_root_addr_cells)
> +		return -EINVAL;
> +
> +	prop = of_get_flat_dt_prop(node, "ranges", NULL);
> +	if (!prop)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/**
> + * fdt_scan_reserved_mem() - scan a single FDT node for reserved memory
> + */
> +static int __init
> +__fdt_scan_reserved_mem(unsigned long node, const char *uname, int depth,
> +		      void *data)
> +{
> +	phys_addr_t base = 0, size = 0;
> +	static int found;
> +	const char *status;
> +	int err;
> +
> +	if (!found && depth == 1 && strcmp(uname, "reserved-memory") == 0) {
> +		if (__reserved_mem_check_root(node) != 0) {
> +			pr_err("Reserved memory: unsupported node format, ignoring\n");
> +			/* break scan */
> +			return 1;
> +		}
> +		found = 1;
> +		/* scan next node */
> +		return 0;
> +	} else if (!found) {
> +		/* scan next node */
> +		return 0;
> +	} else if (found && depth < 2) {
> +		/* scanning of /reserved-memory has been finished */
> +		return 1;
> +	}
> +
> +	status = of_get_flat_dt_prop(node, "status", NULL);
> +	if (status && strcmp(status, "okay") != 0 && strcmp(status, "ok") != 0)
> +		return 0;
> +
> +	err = __reserved_mem_reserve_reg(node, uname, &base, &size);
> +	if (err == -ENOENT && of_get_flat_dt_prop(node, "size", NULL) == NULL)
> +		goto end;
> +
> +	fdt_reserved_mem_save_node(node, uname, base, size);

There is only one path here and the fdt_reserved_mem_save_node() call is
the only user of base,size. Why not move the hook directly into
__reserved_mem_reserve_reg() and drop the &base/&size arguments? I'm
finding the logic a little convoluted.

For that matter, why split it into a separate function at all?

Otherwise, all of the above code loks good to me. I like the way you've
done the early parsing. It will eventually hook neatly into
early_init_dt_scan().

(I am ignoring the question of whether child nodes should be processed.
that is a separate debate and the code can be extended later).

> +end:
> +	/* scan next node */
> +	return 0;
> +}
> +
> +/**
> + * early_init_fdt_scan_reserved_mem() - create reserved memory regions
> + *
> + * This function grabs memory from early allocator for device exclusive use
> + * defined in device tree structures. It should be called by arch specific code
> + * once the early allocator (i.e. memblock) has been fully activated.
> + */
> +void __init early_init_fdt_scan_reserved_mem(void)
> +{
> +	of_scan_flat_dt(__fdt_scan_reserved_mem, NULL);
> +	fdt_init_reserved_mem();
> +}
>  
>  /**
>   * of_scan_flat_dt - scan flattened tree blob and call callback on each.
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> new file mode 100644
> index 000000000000..cacf04810b87
> --- /dev/null
> +++ b/drivers/of/of_reserved_mem.c
> @@ -0,0 +1,296 @@
> +/*
> + * Device tree based initialization code for reserved memory.
> + *
> + * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
> + * Copyright (c) 2013,2014 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + * Author: Marek Szyprowski <m.szyprowski@samsung.com>
> + * Author: Josh Cartwright <joshc@codeaurora.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License or (at your optional) any later version of the license.
> + */
> +
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
> +#if defined(CONFIG_HAVE_MEMBLOCK)
> +#include <linux/memblock.h>
> +int __init __weak
> +early_init_dt_alloc_reserved_memory_arch(phys_addr_t size, phys_addr_t align,
> +					 phys_addr_t start, phys_addr_t end,
> +					 bool nomap, phys_addr_t *res_base)
> +{
> +	/*
> +	 * We use __memblock_alloc_base() since memblock_alloc_base() panic()s.
> +	 */

Why does it panic?

> +	phys_addr_t base = __memblock_alloc_base(size, align, end);
> +	if (!base)
> +		return -ENOMEM;
> +
> +	if (base < start) {

The above test could use an explanitory comment.

> +		memblock_free(base, size);
> +		return -ENOMEM;
> +	}
> +
> +	*res_base = base;
> +	if (nomap)
> +		return memblock_remove(base, size);
> +	return 0;
> +}
> +#else
> +int __init __weak
> +early_init_dt_alloc_reserved_memory_arch(phys_addr_t size, phys_addr_t align,
> +					 phys_addr_t start, phys_addr_t end,
> +					 bool nomap, phys_addr_t *res_base)
> +{
> +	pr_error("Reserved memory not supported, ignoring region 0x%llx%s\n",
> +		  size, nomap ? " (nomap)" : "");
> +	return -ENOSYS;
> +}
> +#endif
> +
> +/**
> + * res_mem_save_node() - save fdt node for second pass initialization
> + */
> +int __init fdt_reserved_mem_save_node(unsigned long node, const char *uname,
> +				      phys_addr_t base, phys_addr_t size)

The return code is never used. Return void instead.

> +{
> +	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
> +
> +	if (reserved_mem_count == ARRAY_SIZE(reserved_mem)) {
> +		pr_err("Reserved memory: not enough space all defined regions.\n");
> +		return -ENOSPC;
> +	}
> +
> +	rmem->fdt_node = node;
> +	rmem->name = uname;
> +	rmem->base = base;
> +	rmem->size = size;
> +
> +	reserved_mem_count++;
> +	return 0;
> +}
> +
> +/**
> + * res_mem_alloc_size() - allocate reserved memory described by 'size', 'align'
> + *			  and 'alloc-ranges' properties
> + */
> +static int __init
> +__reserved_mem_alloc_size(unsigned long node, const char *uname,
> +			  phys_addr_t *res_base, phys_addr_t *res_size)
> +{
> +	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
> +	phys_addr_t start = 0, end = 0;
> +	phys_addr_t base = 0, align = 0, size;
> +	unsigned long len;
> +	__be32 *prop;
> +	int nomap;
> +	int ret;
> +
> +	prop = of_get_flat_dt_prop(node, "size", &len);
> +	if (!prop)
> +		return -EINVAL;
> +
> +	if (len != dt_root_size_cells * sizeof(__be32)) {
> +		pr_err("Reserved memory: invalid size property in '%s' node.\n",
> +				uname);
> +		return -EINVAL;
> +	}
> +	size = dt_mem_next_cell(dt_root_size_cells, &prop);
> +
> +	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
> +
> +	prop = of_get_flat_dt_prop(node, "align", &len);
> +	if (prop) {
> +		if (len != dt_root_addr_cells * sizeof(__be32)) {
> +			pr_err("Reserved memory: invalid align property in '%s' node.\n",
> +				uname);
> +			return -EINVAL;
> +		}
> +		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
> +	}
> +
> +	prop = of_get_flat_dt_prop(node, "alloc-ranges", &len);
> +	if (prop) {
> +
> +		if (len % t_len != 0) {
> +			pr_err("Reserved memory: invalid alloc-ranges property in '%s', skipping node.\n",
> +			       uname);
> +			return -EINVAL;
> +		}
> +
> +		base = 0;
> +
> +		while (len > 0) {
> +			start = dt_mem_next_cell(dt_root_addr_cells, &prop);
> +			end = start + dt_mem_next_cell(dt_root_size_cells,
> +						       &prop);
> +
> +			ret = early_init_dt_alloc_reserved_memory_arch(size,
> +					align, start, end, nomap, &base);
> +			if (ret == 0) {
> +				pr_debug("Reserved memory: allocated memory for '%s' node: base %pa, size %ld MiB\n",
> +					uname, &base,
> +					(unsigned long)size / SZ_1M);
> +				break;
> +			}
> +			len -= t_len;
> +		}
> +
> +	} else {
> +		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
> +							0, 0, nomap, &base);
> +		if (ret == 0)
> +			pr_debug("Reserved memory: allocated memory for '%s' node: base %pa, size %ld MiB\n",
> +				uname, &base, (unsigned long)size / SZ_1M);
> +	}
> +
> +	if (base == 0) {
> +		pr_info("Reserved memory: failed to allocate memory for node '%s'\n",
> +			uname);
> +		return -ENOMEM;
> +	}

<off topic> Wow, the flattree parsing code has to be really verbose. We really need better
flat tree parsing functions and helpers.

> +
> +	*res_base = base;
> +	*res_size = size;
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id __rmem_of_table_sentinel
> +	__used __section(__reservedmem_of_table_end);
> +
> +/**
> + * res_mem_init_node() - call region specific reserved memory init code
> + */
> +static int __init __reserved_mem_init_node(struct reserved_mem *rmem)
> +{
> +	extern const struct of_device_id __reservedmem_of_table[];
> +	const struct of_device_id *i;
> +
> +	for (i = __reservedmem_of_table; i < &__rmem_of_table_sentinel; i++) {
> +		reservedmem_of_init_fn initfn = i->data;
> +		const char *compat = i->compatible;
> +
> +		if (!of_flat_dt_is_compatible(rmem->fdt_node, compat))
> +			continue;

What if two entries both match the compatible list? Ideally score would
be taken into account. (I won't block on this issue, it can be a future
enhancement)

> +
> +		if (initfn(rmem, rmem->fdt_node, rmem->name) == 0) {
> +			pr_info("Reserved memory: initialized node %s, compatible id %s\n",
> +				rmem->name, compat);
> +			return 0;
> +		}
> +	}
> +	return -ENOENT;
> +}
> +
> +/**
> + * fdt_init_reserved_mem - allocate and init all saved reserved memory regions
> + */
> +void __init fdt_init_reserved_mem(void)
> +{
> +	int i;
> +	for (i = 0; i < reserved_mem_count; i++) {
> +		struct reserved_mem *rmem = &reserved_mem[i];
> +		unsigned long node = rmem->fdt_node;
> +		unsigned long len;
> +		__be32 *prop;
> +		int err = 0;
> +
> +		prop = of_get_flat_dt_prop(node, "phandle", &len);
> +		if (!prop)
> +			prop = of_get_flat_dt_prop(node, "linux,phandle", &len);
> +		if (prop)
> +			rmem->phandle = of_read_number(prop, len/4);
> +
> +		if (rmem->size == 0)
> +			err = __reserved_mem_alloc_size(node, rmem->name,
> +						 &rmem->base, &rmem->size);
> +		if (err == 0)
> +			__reserved_mem_init_node(rmem);
> +	}
> +}
> +
> +static inline struct reserved_mem *__find_rmem(struct device_node *node)
> +{
> +	unsigned int len, phandle_val;
> +	const __be32 *prop;
> +	unsigned int i;
> +
> +	prop = of_get_property(node, "phandle", &len);
> +	if (!prop)
> +		prop = of_get_property(node, "linux,phandle", &len);
> +	if (!prop || len < sizeof(__be32))
> +		return NULL;
> +
> +	phandle_val = be32_to_cpup(prop);

The above gymnastics aren't needed. phandle is already stored in
node->phandle. You still need to check for a 0 phandle though.

> +	for (i = 0; i < reserved_mem_count; i++)
> +		if (reserved_mem[i].phandle == phandle_val)
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
> +	struct device_node *np = dev->of_node;
> +	struct reserved_mem *rmem;
> +	struct of_phandle_args s;
> +	unsigned int i;
> +
> +	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
> +				"#memory-region-cells", i, &s) == 0; i++) {
> +
> +		rmem = __find_rmem(s.np);
> +		if (!rmem || !rmem->ops || !rmem->ops->device_init) {
> +			of_node_put(s.np);
> +			continue;
> +		}
> +
> +		rmem->ops->device_init(rmem, dev, &s);
> +		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
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
> +		rmem = __find_rmem(s.np);
> +		if (rmem && rmem->ops && rmem->ops->device_release)
> +			rmem->ops->device_release(rmem, dev);
> +
> +		of_node_put(s.np);
> +	}
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
> index 000000000000..0bbec4bf23ce
> --- /dev/null
> +++ b/include/linux/of_reserved_mem.h
> @@ -0,0 +1,65 @@
> +#ifndef __OF_RESERVED_MEM_H
> +#define __OF_RESERVED_MEM_H
> +
> +struct cma;
> +struct device;
> +struct of_phandle_args;
> +struct reserved_mem_ops;
> +
> +struct reserved_mem {
> +	const char			*name;
> +	unsigned long			fdt_node;
> +	unsigned long			phandle;
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
> +
> +void fdt_init_reserved_mem(void);
> +void early_init_fdt_scan_reserved_mem(void);

The early_init_fdt_scan_reserved_mem() stub should be in of_fdt.h

> +int fdt_reserved_mem_save_node(unsigned long node, const char *uname,
> +			       phys_addr_t base, phys_addr_t size);
> +
> +#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> +	static const struct of_device_id __reservedmem_of_table_##name	\
> +		__used __section(__reservedmem_of_table)		\
> +		 = { .compatible = compat,				\
> +		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
> +				init : init }
> +
> +#else
> +static inline void of_reserved_mem_device_init(struct device *dev) { }
> +static inline void of_reserved_mem_device_release(struct device *pdev) { }
> +
> +static inline void fdt_init_reserved_mem(void) { }
> +static inline void early_init_fdt_scan_reserved_mem(void) { }

early_init_fdt_scan_reserved_mem() should not have an empty stub.

> +static inline int
> +fdt_reserved_mem_save_node(unsigned long node, const char *uname,
> +			       phys_addr_t base, phys_addr_t size) { }
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

