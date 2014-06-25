Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaFYVM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:12:58 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37146 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbaFYVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:12:55 -0400
Message-ID: <53AB3B53.2080104@gmail.com>
Date: Wed, 25 Jun 2014 16:12:51 -0500
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: tthayer@altera.com, robherring2@gmail.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, tthayer.linux@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
Subject: Re: [PATCHv7 3/3] edac: altera: Add EDAC support for Altera SoC SDRAM
 Controller.
References: <1403730927-16163-1-git-send-email-tthayer@altera.com> <1403730927-16163-4-git-send-email-tthayer@altera.com>
In-Reply-To: <1403730927-16163-4-git-send-email-tthayer@altera.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thor,

On 06/25/2014 04:15 PM, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
>
> This patch adds support for the CycloneV and ArriaV SDRAM controllers. Correction and reporting of SBEs, Panic on DBEs.
>
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> ---
> v2: Use the SDRAM controller registers to calculate memory size
>      instead of the Device Tree. Update To & Cc list. Add maintainer
>      information.
>
> v3: EDAC driver cleanup based on comments from Mailing list.
>
> v4: Panic on DBE. Add macro around inject-error reads to prevent
>      them from being optimized out. Remove of_match_ptr since this
>      will always use Device Tree.
>
> v5: Addition of printk to trigger function to ensure read vars
>      are not optimized out.
>
> v6: Changes to split out shared SDRAM controller reg (offset 0x00)
>      as a syscon device and allocate ECC specific SDRAM registers
>      to EDAC.
>
> v7: No change. Bump version for consistency.
> ---
>   drivers/edac/Kconfig       |    9 +
>   drivers/edac/Makefile      |    2 +
>   drivers/edac/altera_edac.c |  448 ++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 459 insertions(+)
>   create mode 100644 drivers/edac/altera_edac.c
>
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..4f4d379 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -368,4 +368,13 @@ config EDAC_OCTEON_PCI
>   	  Support for error detection and correction on the
>   	  Cavium Octeon family of SOCs.
>
> +config EDAC_ALTERA_MC
> +	bool "Altera SDRAM Memory Controller EDAC"
> +	depends on EDAC_MM_EDAC && ARCH_SOCFPGA
> +	help
> +	  Support for error detection and correction on the
> +	  Altera SDRAM memory controller. Note that the
> +	  preloader must initialize the SDRAM before loading
> +	  the kernel.
> +
>   endif # EDAC
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index 4154ed6..9741336 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
>   obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>   obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>   obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
> +
> +obj-$(CONFIG_EDAC_ALTERA_MC)	        += altera_edac.o
> diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
> new file mode 100644
> index 0000000..e3fcd27
> --- /dev/null
> +++ b/drivers/edac/altera_edac.c
> @@ -0,0 +1,448 @@
> +/*
> + *  Copyright Altera Corporation (C) 2014. All rights reserved.
> + *  Copyright 2011-2012 Calxeda, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> +
> + *
> + * Adapted from the highbank_mc_edac driver
> + *
> + */
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/ctype.h>
> +#include <linux/edac.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/uaccess.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
>

Did you miss my comment to put these headers in alpabetical order?

Dinh
