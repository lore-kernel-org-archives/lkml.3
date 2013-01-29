Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3A2Nd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:33:27 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35370 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3A2NdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:33:21 -0500
Message-ID: <5107CDD3.3050502@gmail.com>
Date: Tue, 29 Jan 2013 07:25:39 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 32/71] ARC: [DeviceTree] Basic support
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-15-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1359024639-21915-15-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 04:50 AM, Vineet Gupta wrote:
> This is minimal infrastructure needed for devicetree work.
> It uses an a sample "skeleton" devicetree - embedded in kernel image -
> to print the board, manufacturer by parsing the top-level "compatible"
> string.
> 
> As of now we don't need any additional "board" specific "machine_desc".
> 
> TODO: support interpreting the command line as boot-loader passed dtb
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Rob Herring <rob.herring@calxeda.com>

One minor thing below, otherwise:

Reviewed-by: Rob Herring <rob.herring@calxeda.com>


> diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
> new file mode 100644
> index 0000000..229f78e
> --- /dev/null
> +++ b/arch/arc/kernel/devtree.c
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
> + *
> + * Based on highly stipped down version of METAG
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +
> +#include <linux/init.h>
> +#include <linux/export.h>
> +#include <linux/errno.h>

Is this include needed?

> +#include <linux/types.h>
> +#include <linux/reboot.h>

And this?

> +#include <linux/memblock.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_irq.h>

And this?

> +#include <linux/of_platform.h>

And this?

> +#include <asm/prom.h>
> +
> +/* called from unflatten_device_tree() to bootstrap devicetree itself */
> +void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
> +{
> +	return __va(memblock_alloc(size, align));
> +}
> +
> +/**
> + * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
> + * @dt:		virtual address pointer to dt blob
> + *
> + * If a dtb was passed to the kernel, then use it to choose the correct
> + * machine_desc and to setup the system.
> + */
> +int __init setup_machine_fdt(void *dt)
> +{
> +	struct boot_param_header *devtree = dt;
> +	unsigned long dt_root;
> +	char *model, *compat;
> +	char manufacturer[16];
> +
> +	/* check device tree validity */
> +	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
> +		return 1;
> +
> +	/* Search the mdescs for the 'best' compatible value match */
> +	initial_boot_params = devtree;
> +	dt_root = of_get_flat_dt_root();
> +
> +	/* compat = "<manufacturer>,<model>" */
> +	compat = of_get_flat_dt_prop(dt_root, "compatible", NULL);
> +	if (!compat)
> +		compat = "<unknown>";
> +
> +	model = strchr(compat, ',');
> +	if (model)
> +		model++;
> +
> +	strlcpy(manufacturer, compat, model ? model - compat : strlen(compat));
> +
> +	pr_info("Board \"%s\" from %s (Manufacturer)\n", model, manufacturer);
> +
> +	/* Retrieve various information from the /chosen node */
> +	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
> +
> +	return 0;
> +}
> diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
> index 82ac206..27aebd6 100644
> --- a/arch/arc/kernel/setup.c
> +++ b/arch/arc/kernel/setup.c
> @@ -13,6 +13,8 @@
>  #include <linux/console.h>
>  #include <linux/module.h>
>  #include <linux/cpu.h>
> +#include <linux/of_fdt.h>
> +#include <asm/sections.h>
>  #include <asm/arcregs.h>
>  #include <asm/tlb.h>
>  #include <asm/cache.h>
> @@ -20,6 +22,7 @@
>  #include <asm/page.h>
>  #include <asm/irq.h>
>  #include <asm/arcregs.h>
> +#include <asm/prom.h>
>  
>  #define FIX_PTR(x)  __asm__ __volatile__(";" : "+r"(x))
>  
> @@ -57,6 +60,8 @@ void __init __attribute__((weak)) arc_platform_early_init(void)
>  
>  void __init setup_arch(char **cmdline_p)
>  {
> +	int rc;
> +
>  #ifdef CONFIG_CMDLINE_UBOOT
>  	/* Make sure that a whitespace is inserted before */
>  	strlcat(command_line, " ", sizeof(command_line));
> @@ -71,6 +76,8 @@ void __init setup_arch(char **cmdline_p)
>  	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
>  	*cmdline_p = command_line;
>  
> +	rc = setup_machine_fdt(__dtb_start);
> +
>  	/* To force early parsing of things like mem=xxx */
>  	parse_early_param();
>  
> @@ -81,6 +88,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	setup_arch_memory();
>  
> +	unflatten_device_tree();
> +
>  	/* Can be issue if someone passes cmd line arg "ro"
>  	 * But that is unlikely so keeping it as it is
>  	 */
> diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
> index 63da347..682cf57 100644
> --- a/arch/arc/mm/init.c
> +++ b/arch/arc/mm/init.c
> @@ -39,6 +39,11 @@ static int __init setup_mem_sz(char *str)
>  }
>  early_param("mem", setup_mem_sz);
>  
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +	pr_err("%s(%llx, %llx)\n", __func__, base, size);
> +}
> +
>  /*
>   * First memory setup routine called from setup_arch()
>   * 1. setup swapper's mm @init_mm
> @@ -169,3 +174,11 @@ void __init free_initrd_mem(unsigned long start, unsigned long end)
>  	free_init_pages("initrd memory", start, end);
>  }
>  #endif
> +
> +#ifdef CONFIG_OF_FLATTREE
> +void __init early_init_dt_setup_initrd_arch(unsigned long start,
> +					    unsigned long end)
> +{
> +	pr_err("%s(%lx, %lx)\n", __func__, start, end);
> +}
> +#endif /* CONFIG_OF_FLATTREE */
> 
