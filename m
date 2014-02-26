Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaBZMFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:05:31 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:50538 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaBZMF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:05:29 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 02/11] drivers: of: add initialization code for static reserved memory
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
In-Reply-To: <1392985527-6260-3-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com> < 1392985527-6260-3-git-send-email-m.szyprowski@samsung.com>
Date: Wed, 26 Feb 2014 12:05:19 +0000
Message-Id: <20140226120520.00CA9C40A89@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 13:25:18 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> This patch adds support for static (defined by 'reg' property) reserved
> memory regions declared in device tree.
> 
> Memory blocks can be reliably reserved only during early boot. This must
> happen before the whole memory management subsystem is initialized,
> because we need to ensure that the given contiguous blocks are not yet
> allocated by kernel. Also it must happen before kernel mappings for the
> whole low memory are created, to ensure that there will be no mappings
> (for reserved blocks). Typically, all this happens before device tree
> structures are unflattened, so we need to get reserved memory layout
> directly from fdt.
> 
> Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/fdt.c       |  125 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_fdt.h |    3 ++
>  2 files changed, 128 insertions(+)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 758b4f8b30b7..12809e20ef71 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -440,6 +440,113 @@ struct boot_param_header *initial_boot_params;
>  #ifdef CONFIG_OF_EARLY_FLATTREE
>  
>  /**
> + * res_mem_reserve_reg() - reserve all memory described in 'reg' property
> + */
> +static int __init __reserved_mem_reserve_reg(unsigned long node,
> +					     const char *uname)
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
> +	while (len > 0) {

This is safer: while (len >= t_len) {

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
> +	}
> +	return 0;
> +}
> +
> +static int __reserved_mem_check_root(unsigned long node)

Please document the purpose of this function. This function reflects a Linux
implementation limitation because it is easier than parsing a correctly
formed ranges property. Sometime in the future it may be fixed. It is
worth capturing all of that in a comment.

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
> +static int __init __fdt_scan_reserved_mem(unsigned long node, const char *uname,
> +					  int depth, void *data)
> +{
> +	static int found;
> +	const char *status;
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
> +	__reserved_mem_reserve_reg(node, uname);
> +
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
> +}

Looks good.

> +
> +/**
>   * of_scan_flat_dt - scan flattened tree blob and call callback on each.
>   * @it: callback function
>   * @data: context data pointer
> @@ -856,6 +963,16 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>  	memblock_add(base, size);
>  }
>  
> +int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
> +					phys_addr_t size, bool nomap)
> +{
> +	if (memblock_is_region_reserved(base, size))
> +		return -EBUSY;
> +	if (nomap)
> +		return memblock_remove(base, size);
> +	return memblock_reserve(base, size);
> +}
> +
>  /*
>   * called from unflatten_device_tree() to bootstrap devicetree itself
>   * Architectures can override this definition if memblock isn't used
> @@ -864,6 +981,14 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
>  {
>  	return __va(memblock_alloc(size, align));
>  }
> +#else
> +int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
> +					phys_addr_t size, bool nomap)
> +{
> +	pr_error("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
> +		  base, size, nomap ? " (nomap)" : "");
> +	return -ENOSYS;
> +}
>  #endif
>  
>  bool __init early_init_dt_scan(void *params)
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index 2b77058a7335..8610ad8d77d2 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -98,7 +98,10 @@ extern int early_init_dt_scan_chosen(unsigned long node, const char *uname,
>  				     int depth, void *data);
>  extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
>  				     int depth, void *data);
> +extern void early_init_fdt_scan_reserved_mem(void);
>  extern void early_init_dt_add_memory_arch(u64 base, u64 size);
> +extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
> +					     bool no_map);
>  extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
>  extern u64 dt_mem_next_cell(int s, __be32 **cellp);

I think I'm happy with this one. Address my comments above and add my
Acked-by (so I remember I was okay with this one when you repost it) :-)

Acked-by: Grant Likely <grant.likely@linaro.org>

>  
> -- 
> 1.7.9.5
> 

