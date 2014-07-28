Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaG1Ley (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:34:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbaG1Leu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:34:50 -0400
Date: Mon, 28 Jul 2014 13:34:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: dougthompson@xmission.com, robh+dt@kernel.org, pawel.moll@arm.com,
        michal.simek@xilinx.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, anirudh@xilinx.com,
        svemula@xilinx.com, Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20140728113446.GA5350@pd.tnic>
References: <64d65965-45a3-41c3-9b04-9743b8b1e49c@BL2FFO11FD025.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <64d65965-45a3-41c3-9b04-9743b8b1e49c@BL2FFO11FD025.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 12:10:52AM +0530, Punnaiah Choudary Kalluri wrote:
> Added EDAC support for reporting the ecc errors of synopsys ddr controller.
> The ddr ecc controller corrects single bit errors and detects double bit
> errors.
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
> Changes for v3:
> - Updated maintainer information
> - Driver cleanup as per the review comments
> - Shortened the prefix "sysnopsys" to "synps"

This is not a good idea, IMO. "synopsys" is much more understandable
instead of "synps". And synopsys-edac is just fine.

> Changes for v2:
> - Updated the commit header and message
> - Renamed the filenames to synopsys_edac
> - Corrected the compatilble string, commnets
> - Renamed the macros,fucntions and data structures
> ---
> 
>  .../devicetree/bindings/edac/synps_edac.txt        |   18 +
>  MAINTAINERS                                        |    1 +
>  drivers/edac/Kconfig                               |    7 +
>  drivers/edac/Makefile                              |    1 +
>  drivers/edac/synps_edac.c                          |  554 ++++++++++++++++++++
>  5 files changed, 581 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/edac/synps_edac.txt
>  create mode 100644 drivers/edac/synps_edac.c
> 
> diff --git a/Documentation/devicetree/bindings/edac/synps_edac.txt b/Documentation/devicetree/bindings/edac/synps_edac.txt
> new file mode 100644
> index 0000000..c4a559b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/edac/synps_edac.txt
> @@ -0,0 +1,18 @@
> +Synopsys EDAC driver, it does reports the DDR ECC single bit errors that are
> +corrected and double bit ecc errors that are detected by the DDR ECC controller.
> +ECC support for DDR is available in half-bus width(16 bit) configuration only.
> +
> +Required properties:
> +- compatible: Should be "xlnx,zynq-ddrc-1.04"
> +- reg: Should contain DDR controller registers location and length.
> +
> +Example:
> +++++++++
> +
> +ddrc0: ddrc@f8006000 {
> +	compatible = "xlnx,zynq-ddrc-1.04";
> +	reg = <0xf8006000 0x1000>;
> +};

I'd need an ack from device tree people about the DT bits.

> +
> +Synopsys EDAC driver detects the DDR ECC enable state by reading the appropriate
> +control register.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d76e077..984b5a7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1479,6 +1479,7 @@ N:	xilinx
>  F:	drivers/clocksource/cadence_ttc_timer.c
>  F:	drivers/i2c/busses/i2c-cadence.c
>  F:	drivers/mmc/host/sdhci-of-arasan.c
> +F:	drivers/edac/synps_edac.c
>  
>  ARM SMMU DRIVER
>  M:	Will Deacon <will.deacon@arm.com>
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..f628a2b 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -368,4 +368,11 @@ config EDAC_OCTEON_PCI
>  	  Support for error detection and correction on the
>  	  Cavium Octeon family of SOCs.
>  
> +config EDAC_SYNPS
> +	tristate "Synopsys DDR Memory Controller"
> +	depends on EDAC_MM_EDAC && ARCH_ZYNQ
> +	help
> +	  Support for EDAC on the ECC memory used with the Synopsys DDR
> +	  memory controller.
> +
>  endif # EDAC
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index 4154ed6..0af900f 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -64,3 +64,4 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
>  obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>  obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>  obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
> +obj-$(CONFIG_EDAC_SYNPS)		+= synps_edac.o
> diff --git a/drivers/edac/synps_edac.c b/drivers/edac/synps_edac.c
> new file mode 100644
> index 0000000..a9417fe
> --- /dev/null
> +++ b/drivers/edac/synps_edac.c
> @@ -0,0 +1,554 @@
> +/*
> + * Synopsys DDR ECC Driver
> + * This driver is based on ppc4xx_edac.c drivers
> + *
> + * Copyright (C) 2012 - 2014 Xilinx, Inc.
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details
> + */
> +
> +#include <linux/edac.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +#include "edac_core.h"
> +
> +/* Number of cs_rows needed per memory controller */
> +#define SYNPS_EDAC_NR_CSROWS	1
> +
> +/* Number of channels per memory controller */
> +#define SYNPS_EDAC_NR_CHANS	1
> +
> +/* Granularity of reported error in bytes */
> +#define SYNPS_EDAC_ERR_GRAIN	1
> +
> +#define SYNPS_EDAC_MSG_SIZE	256
> +
> +#define SYNPS_EDAC_MOD_STRING	"synps_edac"
> +#define SYNPS_EDAC_MOD_VER	"1"
> +
> +/* Synopsys DDR memory controller registers that are relevant to ECC */
> +#define SYNPS_DDRC_CTRL_REG_OFST	0x0
> +#define SYNPS_DDRC_T_ZQ_REG_OFST	0xA4
> +
> +/* ECC control register */
> +#define SYNPS_DDRC_ECC_CTRL_REG_OFST		0xC4
> +/* ECC log register */
> +#define SYNPS_DDRC_ECC_CE_LOG_REG_OFST		0xC8
> +/* ECC address register */
> +#define SYNPS_DDRC_ECC_CE_ADDR_REG_OFST		0xCC
> +/* ECC data[31:0] register */
> +#define SYNPS_DDRC_ECC_CE_DATA_31_0_REG_OFST	0xD0
> +
> +/* Uncorrectable error info regsisters */
> +#define SYNPS_DDRC_ECC_UE_LOG_REG_OFST		0xDC
> +#define SYNPS_DDRC_ECC_UE_ADDR_REG_OFST		0xE0
> +#define SYNPS_DDRC_ECC_UE_DATA_31_0_REG_OFST	0xE4
> +
> +#define SYNPS_DDRC_ECC_STAT_REG_OFST		0xF0
> +#define SYNPS_DDRC_ECC_SCRUB_REG_OFST		0xF4
> +
> +/* Control regsiter bitfield definitions */
> +#define SYNPS_DDRC_CTRLREG_BUSWIDTH_MASK	0xC
> +#define SYNPS_DDRC_CTRLREG_BUSWIDTH_SHIFT	2
> +
> +#define SYNPS_DDRCTL_WDTH_16	1
> +#define SYNPS_DDRCTL_WDTH_32	0
> +
> +/* ZQ register bitfield definitions */
> +#define SYNPS_DDRC_T_ZQ_REG_DDRMODE_MASK	0x2
> +
> +/* ECC control register bitfield definitions */
> +#define SYNPS_DDRC_ECCCTRL_CLR_CE_ERR		0x2
> +#define SYNPS_DDRC_ECCCTRL_CLR_UE_ERR		0x1
> +
> +/* ECC correctable/uncorrectable error log register definitions */
> +#define SYNPS_DDRC_ECC_CE_LOGREG_VALID		0x1
> +#define SYNPS_DDRC_ECC_CE_LOGREG_BITPOS_MASK	0xFE
> +#define SYNPS_DDRC_ECC_CE_LOGREG_BITPOS_SHIFT	1
> +
> +/* ECC correctable/uncorrectable error address register definitions */
> +#define SYNPS_DDRC_ECC_ADDRREG_COL_MASK		0xFFF
> +#define SYNPS_DDRC_ECC_ADDRREG_ROW_MASK		0xFFFF000
> +#define SYNPS_DDRC_ECC_ADDRREG_ROW_SHIFT	12
> +#define SYNPS_DDRC_ECC_ADDRREG_BANK_MASK	0x70000000
> +#define SYNPS_DDRC_ECC_ADDRREG_BANK_SHIFT	28
> +
> +/* ECC statistic regsiter definitions */
> +#define SYNPS_DDRC_ECC_STATREG_UECNT_MASK	0xFF
> +#define SYNPS_DDRC_ECC_STATREG_CECNT_MASK	0xFF00
> +#define SYNPS_DDRC_ECC_STATREG_CECNT_SHIFT	8
> +
> +/* ECC scrub regsiter definitions */
> +#define SYNPS_DDRC_ECC_SCRUBREG_ECC_MODE_MASK	0x7
> +#define SYNPS_DDRC_ECC_SCRUBREG_ECCMODE_SECDED	0x4

Now those are certainly too long: having the
SYNPS_EDAC/SYNPS_DDRC{,_ECC}* prefix for defines used only in this file
is certainly making the code unreadable. Here's what it could look like,
for example:

     regval = readl(base + STAT_OFST) & (STAT_UECNT_MASK | STAT_CECNT_MASK);

so you have STAT which is the register name, followed by a name of the
bit or bits. I think this is perfectly fine instead of those heavy names
which all start with the same prefix and you have to go look at the end
to find out what they actually are.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
