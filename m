Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3FONyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:54:37 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62802 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3FONyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:54:36 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/fdt: Add FDT address translation
To: Ley Foon Tan <lftan@altera.com>, Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Kenneth Tan <cytan@altera.com>,
        Walter Goossens <waltergoossens@home.nl>,
        Ley Foon Tan <lftan@altera.com>
In-Reply-To: <1369388190-16365-1-git-send-email-lftan@altera.com>
References: <1369388190-16365-1-git-send-email-lftan@altera.com>
Date: Sat, 15 Jun 2013 14:54:32 +0100
Message-Id: <20130615135432.BF1C53E0A2E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 17:36:30 +0800, Ley Foon Tan <lftan@altera.com> wrote:
> This patch adds address translation to fdt. It is needed when the early
> console is connected to a simple-bus (bridge) that has address translation
> enabled.
> 
> Walter Goossens have submitted first version of patch previously. This
> patch resolved the feedback from first submission and some enhancements
> on translation functions.
> 
> Reviewed-by: Walter Goossens <waltergoossens@home.nl>
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

Hi Ley,

Thanks for looking at this. Comments below. Also, I would like to see
the patch that uses this new API.

> ---
>  drivers/of/fdt.c       |  188 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_fdt.h |    2 +
>  2 files changed, 190 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 808be06..74cc1bc 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -695,6 +695,194 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
>  	/* break now */
>  	return 1;
>  }
> +/**
> + * flat_dt_translate_address - Translate an address using the ranges property
> + *
> + * This function converts address from "node address-space" to "parent address-
> + * space"
> + */
> +static int __init flat_dt_translate_address(unsigned long node,
> +		unsigned long parent, u64 *address)
> +{
> +	unsigned long size = 0;
> +	__be32 *prop;
> +	__be32 *ranges;
> +	int size_cells = 0;
> +	int addr_cells = 0;
> +	int paddr_cells = OF_ROOT_NODE_ADDR_CELLS_DEFAULT;
> +
> +	ranges = of_get_flat_dt_prop(node, "ranges", &size);
> +
> +	if (!ranges) {
> +		pr_warn("Address cannot be translated\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!size) {
> +		pr_debug("No translation possible/necessary\n");
> +		return 0;

This debug statement is misleading. An empty ranges property means
identity mapping. "Identity mapping, no translation necessary" would be
more accurate.

> +	}
> +
> +	prop = of_get_flat_dt_prop(node, "#size-cells", NULL);
> +	if (!prop)
> +		return -EINVAL;
> +	size_cells = be32_to_cpup(prop);
> +
> +	prop = of_get_flat_dt_prop(node, "#address-cells", NULL);
> +	if (!prop)
> +		return -EINVAL;
> +	addr_cells = be32_to_cpup(prop);
> +
> +	if (parent) {
> +		prop = of_get_flat_dt_prop(parent, "#address-cells", NULL);
> +		if (prop)
> +			paddr_cells = be32_to_cpup(prop);
> +	}
> +	if ((addr_cells <= 0) || (size_cells <= 0) ||
> +		(addr_cells > 2) || (size_cells > 2) || (paddr_cells > 2)) {
> +		pr_warn("Translation not possible in fdt. Invalid address.\n");

addr_cells or size_cells > 2 isn't necessarily an error, it just means
this simplistic function cannot parse them. The message is misleading.

> +		*address = 0;
> +		return -1;

Return a real error code here. -EOVERFLOW would be appropriate.

> +	}
> +
> +	while (size > 0) {

should be:
	while (size >= (addr_cells + size_cells + paddr_cells) * sizeof(u32))

Otherwise you risk overflowing the property.

> +		u64 from, to, tsize;
> +		from = be32_to_cpup(ranges++);
> +		size -= 4;
> +		if (addr_cells == 2) {
> +			from += (((u64)be32_to_cpup(ranges++)) << 32);
> +			size -= 4;
> +		}
> +		to = be32_to_cpup(ranges++);
> +		size -= 4;
> +		if (paddr_cells == 2) {
> +			to += (((u64)be32_to_cpup(ranges++)) << 32);
> +			size -= 4;
> +		}
> +		tsize = be32_to_cpup(ranges++);
> +		size -= 4;
> +		if (size_cells == 2) {
> +			tsize += (((u64)be32_to_cpup(ranges++)) << 32);
> +			size -= 4;
> +		}

All of the above looks backwards. The first cell is the MSB, not the
second. The parser needs to swap the cells around.

The following is cleaner and shorter:

		u64 from = 0, to = 0, tsize = 0;
		int i;

		for (i = 0; i < addr_cells; i++, size -= 4)
			from = (from << 32) | be32_to_cpup(ranges++);
		for (i = 0; i < paddr_cells; i++, size -= 4)
			to = (from << 32) | be32_to_cpup(ranges++);
		for (i = 0; i < size_cells; i++, size -= 4)
			tsize = (from << 32) | be32_to_cpup(ranges++);

> +		pr_debug("  From %llX To %llX Size %llX\n", from, to, tsize);
> +		if ((*address >= from) && (*address < (from + tsize)))
> +			*address += (to - from);
> +	}
> +	return 1;
> +}
> +
> +static int __init of_scan_flat_dt_ranges(unsigned long *pnode,
> +				unsigned long parent, unsigned long target,
> +				u64 *address, int ignore)
> +{
> +	int rc = 0;
> +	int depth = -1;
> +	const char *pathp;
> +	unsigned long p = *pnode;
> +	do {
> +		u32 tag = be32_to_cpup((__be32 *)p);
> +
> +		p += 4;
> +		if (tag == OF_DT_END_NODE) {
> +			if (depth--)
> +				break;
> +			else
> +				continue;
> +		}
> +		if (tag == OF_DT_NOP)
> +			continue;
> +		if (tag == OF_DT_END)
> +			break;
> +		if (tag == OF_DT_PROP) {
> +			u32 sz = be32_to_cpup((__be32 *)p);
> +			p += 8;
> +			if (be32_to_cpu(initial_boot_params->version) < 0x10)
> +				p = ALIGN(p, sz >= 8 ? 8 : 4);
> +			p += sz;
> +			p = ALIGN(p, 4);
> +			continue;
> +		}
> +		if (tag != OF_DT_BEGIN_NODE) {
> +			pr_err("Invalid tag %x in flat device tree!\n", tag);
> +			return -EINVAL;
> +		}
> +		pathp = (char *)p;
> +		p = ALIGN(p + strlen(pathp) + 1, 4);
> +		if ((*pathp) == '/')
> +			pathp = kbasename(pathp);
> +		if ((ignore == 0) && (p == target)) {
> +			rc = 1;
> +			ignore++;
> +			pr_debug("Found target. Start address translation\n");
> +		}
> +		if (depth) {
> +			int res;
> +			*pnode = p;
> +			res = of_scan_flat_dt_ranges(pnode, p, target,
> +							address, ignore);
> +			if (res < 0) {
> +				/* Something bad happened */
> +				return -1;
> +			} else if (res > 0) {
> +				/* Something good happened. Translate. */
> +				rc++;
> +				pr_debug("translate %08lX %s\n", p, pathp);
> +				if (flat_dt_translate_address(p, parent,
> +						address) < 0)
> +					return -1;
> +			}
> +			p = *pnode;
> +		} else
> +			depth++;
> +	} while (1);

This is quite a complicated function, and it is intermingling the
parsing of ranges with merely finding the parent of a node. Finding the
parent node is quite a useful activity, so I think it would be much
better to split that bit out into a separate function. Something like
"of_fdt_find_parent()".

Rather than reimplementing the entire flat tree parser,
of_fdt_find_parent() should be a wrapper around of_scan_flat_dt(). Use a
callback function and a state variable to keep track of each node.
Something like the following (incomplete; you'll need to work out the
details):

struct find_parent_data {
	unsigned long child;
	unsigned long parents[64]; /* arbitrary limit of 64 nodes deep */
	unsigned long result;
};
int check_parent(unsigned long node, const char *uname, int depth, void *__data)
{
	struct find_parent_data *data = __data;
	if (depth >= 64)
		return -EOVERFLOW;
	data->parents[depth] = node;
	if (node == data->child && depth > 0)) {
		data->result = parents[depth-1];
		return 1;
	}
	return 0;
}
unsigned long of_flat_dt_find_parent(unsigned long node)
{
	struct find_parent_data data;
	data.child = node;
	if (of_scan_flat_dt(check_parent, &data) == 1)
		return data.result;
	return 0;
}

> +
> +	*pnode = p;
> +	return rc;
> +}
> +/**
> + * of_get_flat_dt_address - get address from a node
> + * @node: targeted node
> + *
> + * Returns address or OF_BAD_ADDR if error.
> + */
> +u64 __init of_get_flat_dt_address(unsigned long node)
> +{
> +	__be32 *valp;
> +	u64 addr = OF_BAD_ADDR;
> +	unsigned long sz;
> +
> +	valp = of_get_flat_dt_prop(node, "reg", &sz);
> +	if (valp) {
> +		if (sz == 1)

This is buggy. The code cannot know the size of the address portion of
the reg property without reading #address-cells of the parent node. Plus
a reg property may have more than one address range.

> +			addr = be32_to_cpu(valp[0]);
> +		 else if (sz == 2)
> +			addr = (((u64)be32_to_cpu(valp[0]) << 32)) |
> +				be32_to_cpu(valp[1]);
> +	}
> +	return addr;
> +}
> +
> +/**
> + * of_get_flat_dt_translated_address - get translated address from a node
> + * @node: targeted node
> + *
> + * Returns translated address or OF_BAD_ADDR if error.
> + */
> +u64 __init of_get_flat_dt_translated_address(unsigned long node)
> +{
> +	unsigned long p = of_get_flat_dt_root();
> +	u64 addr64;
> +	int rc;
> +
> +	addr64 = of_get_flat_dt_address(node);
> +	if (addr64 != OF_BAD_ADDR) {
> +		rc = of_scan_flat_dt_ranges(&p, 0, node, &addr64, 0);
> +		if (rc > 0)
> +			return addr64;
> +	}
> +	return OF_BAD_ADDR;
> +}
>  
>  /**
>   * unflatten_device_tree - create tree of device_nodes from flat blob
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index ed136ad..48046ed 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -100,6 +100,8 @@ extern void early_init_dt_add_memory_arch(u64 base, u64 size);
>  extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
>  extern u64 dt_mem_next_cell(int s, __be32 **cellp);
>  
> +extern u64 __init of_get_flat_dt_address(unsigned long node);
> +extern u64 __init of_get_flat_dt_translated_address(unsigned long node);
>  /*
>   * If BLK_DEV_INITRD, the fdt early init code will call this function,
>   * to be provided by the arch code. start and end are specified as
> -- 
> 1.7.7.4
> 
> 

-- 
email sent from notmuch.vim plugin
