Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3IESfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:35:13 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:56446 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3IESfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:35:10 -0400
Message-ID: <5228CEDB.1090306@gmail.com>
Date: Thu, 05 Sep 2013 13:35:07 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, gnurou@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com> <1378351680-14696-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1378351680-14696-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 10:27 PM, Alexandre Courbot wrote:
> Trusted Foundations is a TrustZone-based secure monitor for ARM that
> can be invoked  using a consistent SMC-based API on all supported
> platforms. This patch adds initial basic support for Trusted
> Foundations using the ARM firmware API. Current features are limited
> to the ability to boot secondary processors.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
>  .../arm/firmware/tl,trusted-foundations.txt        | 17 +++++
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  arch/arm/Kconfig                                   |  2 +
>  arch/arm/Makefile                                  |  1 +
>  arch/arm/firmware/Kconfig                          | 25 +++++++
>  arch/arm/firmware/Makefile                         |  1 +
>  arch/arm/firmware/trusted_foundations.c            | 82 ++++++++++++++++++++++
>  arch/arm/include/asm/trusted_foundations.h         | 53 ++++++++++++++
>  8 files changed, 182 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>  create mode 100644 arch/arm/firmware/Kconfig
>  create mode 100644 arch/arm/firmware/Makefile
>  create mode 100644 arch/arm/firmware/trusted_foundations.c
>  create mode 100644 arch/arm/include/asm/trusted_foundations.h
> 
> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
> new file mode 100644
> index 0000000..3954bbd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
> @@ -0,0 +1,17 @@
> +Trusted Foundations
> +
> +Boards that use the Trusted Foundations secure monitor can signal its
> +presence by declaring a node compatible with "tl,trusted-foundations"
> +under the root node.
> +
> +Required properties:
> +- compatible : "tl,trusted-foundations"
> +- version-major : major version number of Trusted Foundations firmware
> +- version-minor: minor version number of Trusted Foundations firmware
> +
> +Example:
> +	firmware {
> +		compatible = "tl,trusted-foundations";
> +		version-major = <2>;
> +		version-minor = <8>;
> +	};

I'm wondering how we fit this in with PSCI bindings? Both are pieces of
firmware functionality and may co-exist. There's nothing incompatible
here, but there should be some commonality. Will future versions of
Trusted Foundations follow the SMC calling conventions doc? What about
armv8 support.

Rob


> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 366ce9b..20d61f3 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -63,6 +63,7 @@ ste	ST-Ericsson
>  stericsson	ST-Ericsson
>  toumaz	Toumaz
>  ti	Texas Instruments
> +tl	Trusted Logic
>  toshiba	Toshiba Corporation
>  v3	V3 Semiconductor
>  via	VIA Technologies, Inc.
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 43594d5..7fbe800 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1074,6 +1074,8 @@ config ARM_TIMER_SP804
>  	select CLKSRC_MMIO
>  	select CLKSRC_OF if OF
>  
> +source "arch/arm/firmware/Kconfig"
> +
>  source arch/arm/mm/Kconfig
>  
>  config ARM_NR_BANKS
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 6fd2cea..a48de17 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -267,6 +267,7 @@ core-$(CONFIG_KVM_ARM_HOST) 	+= arch/arm/kvm/
>  core-y				+= arch/arm/kernel/ arch/arm/mm/ arch/arm/common/
>  core-y				+= arch/arm/net/
>  core-y				+= arch/arm/crypto/
> +core-y				+= arch/arm/firmware/
>  core-y				+= $(machdirs) $(platdirs)
>  
>  drivers-$(CONFIG_OPROFILE)      += arch/arm/oprofile/
> diff --git a/arch/arm/firmware/Kconfig b/arch/arm/firmware/Kconfig
> new file mode 100644
> index 0000000..ccf44c8
> --- /dev/null
> +++ b/arch/arm/firmware/Kconfig
> @@ -0,0 +1,25 @@
> +config ARCH_SUPPORTS_FIRMWARE
> +	bool
> +
> +config ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
> +	bool
> +	select ARCH_SUPPORTS_FIRMWARE
> +
> +menu "Firmware options"
> +	depends on ARCH_SUPPORTS_FIRMWARE
> +
> +config TRUSTED_FOUNDATIONS
> +	bool "Trusted Foundations secure monitor support"
> +	depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
> +	help
> +	  Some devices are booted with the Trusted Foundations secure monitor
> +	  active, requiring some core operations to be performed by the secure
> +	  monitor instead of the kernel.
> +
> +	  This option allows the kernel to invoke the secure monitor whenever
> +	  required on devices using Trusted Foundations. See
> +	  arch/arm/include/asm/trusted_foundations.h or the
> +	  tl,trusted-foundations device tree binding documentation for details
> +	  on how to use it.
> +
> +endmenu
> diff --git a/arch/arm/firmware/Makefile b/arch/arm/firmware/Makefile
> new file mode 100644
> index 0000000..a71f165
> --- /dev/null
> +++ b/arch/arm/firmware/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_TRUSTED_FOUNDATIONS)	+= trusted_foundations.o
> diff --git a/arch/arm/firmware/trusted_foundations.c b/arch/arm/firmware/trusted_foundations.c
> new file mode 100644
> index 0000000..210ef83
> --- /dev/null
> +++ b/arch/arm/firmware/trusted_foundations.c
> @@ -0,0 +1,82 @@
> +/*
> + * Trusted Foundations support for ARM CPUs
> + *
> + * Copyright (c) 2013, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/of.h>
> +#include <asm/firmware.h>
> +#include <asm/trusted_foundations.h>
> +
> +#define TF_SET_CPU_BOOT_ADDR_SMC 0xfffff200
> +
> +static void __naked tf_generic_smc(u32 type, u32 subtype, u32 arg)
> +{
> +	asm volatile(
> +		".arch_extension	sec\n\t"
> +		"stmfd	sp!, {r4 - r11, lr}\n\t"
> +		__asmeq("%0", "r0")
> +		__asmeq("%1", "r1")
> +		__asmeq("%2", "r2")
> +		"mov	r3, #0\n\t"
> +		"mov	r4, #0\n\t"
> +		"smc	#0\n\t"
> +		"ldmfd	sp!, {r4 - r11, pc}"
> +		:
> +		: "r" (type), "r" (subtype), "r" (arg)
> +		: "memory");
> +}
> +
> +static int tf_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
> +{
> +	tf_generic_smc(TF_SET_CPU_BOOT_ADDR_SMC, boot_addr, 0);
> +
> +	return 0;
> +}
> +
> +static const struct firmware_ops trusted_foundations_ops = {
> +	.set_cpu_boot_addr = tf_set_cpu_boot_addr,
> +};
> +
> +void register_trusted_foundations(struct trusted_foundations_platform_data *pd)
> +{
> +	/* we are not using version information for now since currently
> +	 * supported SMCs are compatible with all TF releases */
> +	register_firmware_ops(&trusted_foundations_ops);
> +}
> +
> +#if IS_ENABLED(CONFIG_OF)
> +
> +void of_register_trusted_foundations(void)
> +{
> +	struct device_node *node;
> +	struct trusted_foundations_platform_data pdata;
> +	int err;
> +
> +	node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
> +
> +	if (!node)
> +		return;
> +
> +	err = of_property_read_u32(node, "version-major", &pdata.version_major);
> +	if (err != 0)
> +		panic("Trusted Foundation: missing version-major property\n");
> +	err = of_property_read_u32(node, "version-minor", &pdata.version_minor);
> +	if (err != 0)
> +		panic("Trusted Foundation: missing version-minor property\n");
> +	register_trusted_foundations(&pdata);
> +}
> +
> +#endif /* CONFIG_OF */
> diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
> new file mode 100644
> index 0000000..558f616
> --- /dev/null
> +++ b/arch/arm/include/asm/trusted_foundations.h
> @@ -0,0 +1,53 @@
> +/*
> + * Copyright (c) 2013, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#ifndef __ASM_ARM_TRUSTED_FOUNDATIONS_H
> +#define __ASM_ARM_TRUSTED_FOUNDATIONS_H
> +
> +#include <linux/kconfig.h>
> +
> +struct trusted_foundations_platform_data {
> +	unsigned int version_major;
> +	unsigned int version_minor;
> +};
> +
> +#if IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS)
> +void register_trusted_foundations(struct trusted_foundations_platform_data *pd);
> +#if IS_ENABLED(CONFIG_OF)
> +void of_register_trusted_foundations(void);
> +#endif
> +
> +#else /* CONFIG_TRUSTED_FOUNDATIONS */
> +
> +#include <linux/printk.h>
> +#include <linux/of.h>
> +#include <asm/bug.h>
> +
> +static inline void register_trusted_foundations(
> +				   struct trusted_foundations_platform_data *pd)
> +{
> +	panic("No support for Trusted Foundations, stopping...\n");
> +}
> +
> +#if IS_ENABLED(CONFIG_OF)
> +static inline void of_register_trusted_foundations(void)
> +{
> +	if (of_find_compatible_node(NULL, NULL, "tl,trusted-foundations"))
> +		register_trusted_foundations(NULL);
> +}
> +#endif
> +
> +#endif /* CONFIG_TRUSTED_FOUNDATIONS */
> +
> +#endif
> 

