Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaBLQsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:48:01 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:54111 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBLQr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:47:58 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC/PATCH 1/3] of: Add early randomness hooks
To: Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Kees Cook <keescook@chromium.org>
In-Reply-To: <1392168805-14200-2-git-send-email-lauraa@codeaurora.org>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> < 1392168805-14200-2-git-send-email-lauraa@codeaurora.org>
Date: Wed, 12 Feb 2014 16:47:51 +0000
Message-Id: <20140212164751.703DFC407C9@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 17:33:23 -0800, Laura Abbott <lauraa@codeaurora.org> wrote:
> Until randomness is added to the kernel's pools, random
> numbers returned may not be truly 'random'. Randomness comes
> from a variety of sources in the kernel but much of the
> randomness comes from device related initialization. This
> means that any random numbers that are needed before drivers
> are initialized (e.g. stack canary) may not be truely random.
> Fix this by build a list of functions that can be used to add
> randomness to the kernel's pools very early. The functions are
> tied to particular compatible strings of devicetree nodes. The
> flattened devicetree is scanned and if the node is present the
> function is called. Note that this must happen on the flattened
> devicetree to ensure the randomness gets added to the pool
> early enough to make a difference.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Intriguing solution. Looks good to me, but some comments below...

> ---
>  drivers/of/Kconfig                |    7 ++++++
>  drivers/of/Makefile               |    1 +
>  drivers/of/fdt.c                  |    7 ++++++
>  drivers/of/of_randomness.c        |   43 +++++++++++++++++++++++++++++++++++++
>  include/asm-generic/vmlinux.lds.h |    5 ++++
>  include/linux/of_randomness.h     |   42 ++++++++++++++++++++++++++++++++++++
>  6 files changed, 105 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/of/of_randomness.c
>  create mode 100644 include/linux/of_randomness.h
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index c6973f1..6ae4a38 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -75,4 +75,11 @@ config OF_MTD
>  	depends on MTD
>  	def_bool y
>  
> +config OF_RANDOMNESS
> +	def_bool n

There should be the option to turn this off, particularly if it turns
out to be expensive in terms of boot time.

> +	depends on OF_FLATTREE && ARCH_WANT_OF_RANDOMNESS
> +        help
> +	  OpenFirmware hooks to scan for device randomness
> +	  via flat devicetree

Inconsistent whitespace

> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index efd0510..0ce02d1 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
>  obj-$(CONFIG_OF_PCI)	+= of_pci.o
>  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
> +obj-$(CONFIG_OF_RANDOMNESS)	+= of_randomness.o
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 758b4f8..c25960e 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
> +#include <linux/of_randomness.h>
>  #include <linux/string.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
> @@ -889,6 +890,12 @@ bool __init early_init_dt_scan(void *params)
>  	/* Setup memory, calling early_init_dt_add_memory_arch */
>  	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
>  
> +#ifdef CONFIG_OF_RANDOMNESS
> +	/* Add device randomness */
> +	of_scan_flat_dt(early_init_dt_scan_early_randomness, NULL);
> +#endif

Drop the #ifdef in fdt.c and use static inlines in the header file. One
that does the of_scan_flat_dt() call, and one empty stub for the
!CONFIG_OF_RANDOMNESS case.

I would also bypass the of_scan_flat_dt call entirely if the
__early_random_funcs list is empty.

> +
> +
>  	return true;
>  }
>  
> diff --git a/drivers/of/of_randomness.c b/drivers/of/of_randomness.c
> new file mode 100644
> index 0000000..9d23624
> --- /dev/null
> +++ b/drivers/of/of_randomness.c
> @@ -0,0 +1,43 @@
> +/* Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/random.h>
> +#include <linux/string.h>
> +#include <linux/of_randomness.h>
> +#include <linux/of_fdt.h>
> +
> +int __init early_init_dt_scan_early_randomness(unsigned long node,
> +					const char *uname,
> +					int depth, void *data)
> +{
> +	struct early_random_func *f;
> +	void *prop;
> +	unsigned long len;
> +
> +	prop = of_get_flat_dt_prop(node, "compatible", &len);
> +
> +	if (!prop)
> +		return 0;
> +
> +	for (f = __early_random_funcs_start;
> +	     f < __early_random_funcs_end;
> +	     f++) {
> +		pr_debug("Check compat %s addr %p against %s\n",
> +			f->compat_string, f->add_randomness, (char *)prop);
> +		if (strcmp(prop, f->compat_string) == 0)
> +			f->add_randomness(node);
> +	}
> +
> +	return 0;
> +}
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bc2121f..e5b8be9 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -645,6 +645,11 @@
>  		*(.security_initcall.init)				\
>  		VMLINUX_SYMBOL(__security_initcall_end) = .;
>  
> +#define EARLY_RANDOM_FUNCS						\
> +		VMLINUX_SYMBOL(__early_random_funcs_start) = .;		\
> +		*(.earlyrandom.init)					\
> +		VMLINUX_SYMBOL(__early_random_funcs_end) = .;
> +
>  #ifdef CONFIG_BLK_DEV_INITRD
>  #define INIT_RAM_FS							\
>  	. = ALIGN(4);							\
> diff --git a/include/linux/of_randomness.h b/include/linux/of_randomness.h
> new file mode 100644
> index 0000000..b8b4532
> --- /dev/null
> +++ b/include/linux/of_randomness.h
> @@ -0,0 +1,42 @@
> +/* Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#ifndef LINUX_OF_RANDOMNESS_H
> +#define LINUX_OF_RANDOMNESS_H
> +
> +extern int early_init_dt_scan_early_randomness(unsigned long node,
> +					  const char *uname,
> +					  int depth, void *data);
> +
> +#ifdef CONFIG_OF_RANDOMNESS
> +
> +struct early_random_func {
> +	char *compat_string;
> +	void (*add_randomness)(unsigned long fdt_node);
> +};
> +
> +extern struct early_random_func __early_random_funcs_start[];
> +extern struct early_random_func __early_random_funcs_end[];
> +
> +#define EARLY_RANDOM_FUNC(c, f)    \
> +static struct early_random_func __early_rand##f __used \
> +	__attribute((__section__(".earlyrandom.init"))) = { \
> +		.compat_string = c, \
> +		.add_randomness = f\
> +	} \
> +
> +#else
> +
> +#define EARLY_RANDOM_FUNC(f, e)
> +#endif
> +
> +#endif
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

