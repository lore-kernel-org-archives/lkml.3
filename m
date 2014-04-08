Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaDHUlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:41:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56217 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbaDHUkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:40:55 -0400
Date: Tue, 8 Apr 2014 22:40:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sorenb@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        punnaia@xilinx.com
Subject: Re: [RFC PATCH v2] edac: synopsys: Added EDAC support for zynq ddr
 ecc controller
Message-ID: <20140408204047.GQ30077@pd.tnic>
References: <1220b715-6fc2-42ed-8393-b9859fc0deb9@TX2EHSMHS021.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1220b715-6fc2-42ed-8393-b9859fc0deb9@TX2EHSMHS021.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 10:53:44AM +0530, Punnaiah Choudary Kalluri wrote:
> Added EDAC support for reporting the ecc errors of synopsys ddr controller.
> The ddr ecc controller corrects single bit errors and detects double bit
> errors
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
> Changes for v2:
> - Updated the commit header and message
> - Renamed the filenames to synopsys_edac
> - Corrected the compatilble string, commnets
> - Renamed the macros,fucntions and data structures
> ---
>  .../devicetree/bindings/edac/synopsys_edac.txt     |   18 +
>  drivers/edac/Kconfig                               |    7 +
>  drivers/edac/Makefile                              |    1 +
>  drivers/edac/synopsys_edac.c                       |  614 ++++++++++++++++++++
>  4 files changed, 640 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/edac/synopsys_edac.txt
>  create mode 100644 drivers/edac/synopsys_edac.c
> 
> diff --git a/Documentation/devicetree/bindings/edac/synopsys_edac.txt b/Documentation/devicetree/bindings/edac/synopsys_edac.txt
> new file mode 100644
> index 0000000..c4a559b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/edac/synopsys_edac.txt
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
> +
> +Synopsys EDAC driver detects the DDR ECC enable state by reading the appropriate
> +control register.
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..58b69b1 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -368,4 +368,11 @@ config EDAC_OCTEON_PCI
>  	  Support for error detection and correction on the
>  	  Cavium Octeon family of SOCs.
>  
> +config EDAC_SYNOPSYS
> +	tristate "Synopsys DDR Memory Controller"
> +	depends on EDAC_MM_EDAC && ARCH_ZYNQ
> +	help
> +	  This enables support for EDAC on the ECC memory used
> +	  with the Synopsys DDR memory controller.

s/This enables s/S/

> +
>  endif # EDAC
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index 4154ed6..5628a6f 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -64,3 +64,4 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
>  obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>  obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>  obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
> +obj-$(CONFIG_EDAC_SYNOPSYS)		+= synopsys_edac.o
> diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
> new file mode 100644
> index 0000000..7cec331
> --- /dev/null
> +++ b/drivers/edac/synopsys_edac.c
> @@ -0,0 +1,614 @@
> +/*
> + * Synopsys DDR ECC Driver
> + * This driver is based on ppc4xx_edac.c drivers
> + *
> + * Copyright (C) 2012 - 2014 Xilinx, Inc.

The same question to you: are you going to maintain this driver? If so,
please consider adding yourself to the MAINTAINERS file so that people
reporting issues with it can send you a note.

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
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */

Please drop the GPL boilerplate - simply refer to the COPYING file in
the kernel source repository instead.

> +
> +#include <linux/edac.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +#include "edac_core.h"
> +
> +/* Number of cs_rows needed per memory controller */
> +#define SYNOPSYS_EDAC_NR_CSROWS	1
> +
> +/* Number of channels per memory controller */
> +#define SYNOPSYS_EDAC_NR_CHANS	1
> +
> +/* Granularity of reported error in bytes */
> +#define SYNOPSYS_EDAC_ERROR_GRAIN	1
> +
> +#define SYNOPSYS_EDAC_MESSAGE_SIZE	256
> +
> +/* Synopsys DDR memory controller registers that are relevant to ECC */
> +#define SYNOPSYS_DDRC_CONTROL_REG_OFFSET	0x0 /* Control regsieter */
> +#define SYNOPSYS_DDRC_T_ZQ_REG_OFFSET	0xA4 /* ZQ register */
> +
> +/* ECC control register */
> +#define SYNOPSYS_DDRC_ECC_CONTROL_REG_OFFSET	0xC4
> +/* ECC log register */
> +#define SYNOPSYS_DDRC_ECC_CE_LOG_REG_OFFSET		0xC8
> +/* ECC address register */
> +#define SYNOPSYS_DDRC_ECC_CE_ADDR_REG_OFFSET	0xCC
> +/* ECC data[31:0] register */
> +#define SYNOPSYS_DDRC_ECC_CE_DATA_31_0_REG_OFFSET	0xD0
> +
> +/* Uncorrectable error info regsisters */
> +#define SYNOPSYS_DDRC_ECC_UE_LOG_REG_OFFSET	0xDC /* ECC log register */
> +#define SYNOPSYS_DDRC_ECC_UE_ADDR_REG_OFFSET	0xE0 /* ECC address register */
> +#define SYNOPSYS_DDRC_ECC_UE_DATA_31_0_REG_OFFSET	0xE4 /* ECC data reg */
> +
> +#define SYNOPSYS_DDRC_ECC_STAT_REG_OFFSET	0xF0 /* ECC stats register */
> +#define SYNOPSYS_DDRC_ECC_SCRUB_REG_OFFSET	0xF4 /* ECC scrub register */
> +
> +/* Control regsiter bitfield definitions */
> +#define SYNOPSYS_DDRC_CTRLREG_BUSWIDTH_MASK	0xC
> +#define SYNOPSYS_DDRC_CTRLREG_BUSWIDTH_SHIFT	2
> +
> +#define SYNOPSYS_DDRCTL_WDTH_16	1
> +#define SYNOPSYS_DDRCTL_WDTH_32	0
> +
> +/* ZQ register bitfield definitions */
> +#define SYNOPSYS_DDRC_T_ZQ_REG_DDRMODE_MASK	0x2
> +
> +/* ECC control register bitfield definitions */
> +#define SYNOPSYS_DDRC_ECCCTRL_CLR_CE_ERR	0x2
> +#define SYNOPSYS_DDRC_ECCCTRL_CLR_UE_ERR	0x1
> +
> +/* ECC correctable/uncorrectable error log register definitions */
> +#define SYNOPSYS_DDRC_ECC_CE_LOGREG_VALID		0x1
> +#define SYNOPSYS_DDRC_ECC_CE_LOGREG_BITPOS_MASK		0xFE
> +#define SYNOPSYS_DDRC_ECC_CE_LOGREG_BITPOS_SHIFT	1
> +
> +/* ECC correctable/uncorrectable error address register definitions */
> +#define SYNOPSYS_DDRC_ECC_ADDRREG_COL_MASK		0xFFF
> +#define SYNOPSYS_DDRC_ECC_ADDRREG_ROW_MASK		0xFFFF000
> +#define SYNOPSYS_DDRC_ECC_ADDRREG_ROW_SHIFT		12
> +#define SYNOPSYS_DDRC_ECC_ADDRREG_BANK_MASK		0x70000000
> +#define SYNOPSYS_DDRC_ECC_ADDRREG_BANK_SHIFT	28
> +
> +/* ECC statistic regsiter definitions */
> +#define SYNOPSYS_DDRC_ECC_STATREG_UECOUNT_MASK	0xFF
> +#define SYNOPSYS_DDRC_ECC_STATREG_CECOUNT_MASK	0xFF00
> +#define SYNOPSYS_DDRC_ECC_STATREG_CECOUNT_SHIFT	8
> +
> +/* ECC scrub regsiter definitions */
> +#define SYNOPSYS_DDRC_ECC_SCRUBREG_ECC_MODE_MASK	0x7
> +#define SYNOPSYS_DDRC_ECC_SCRUBREG_ECCMODE_SECDED	0x4

Those defines and their values could use better alignment. Also see
below the note about slimming down those names in general.

> +/**
> + * struct ecc_error_info - ECC error log information
> + * @row:	Row number
> + * @col:	Column number
> + * @bank:	Bank number
> + * @bitpos:	Bit position
> + * @data:	Data causing the error
> + */
> +struct ecc_error_info {
> +	u32 row;
> +	u32 col;
> +	u32 bank;
> +	u32 bitpos;
> +	u32 data;
> +};
> +
> +/**
> + * struct synopsys_ecc_status - ECC status information to report
> + * @ce_count:	Correctable error count
> + * @ue_count:	Uncorrectable error count
> + * @ceinfo:	Correctable error log information
> + * @ueinfo:	Uncorrectable error log information
> + */
> +struct synopsys_ecc_status {
> +	u32 ce_count;
> +	u32 ue_count;
> +	struct ecc_error_info ceinfo;
> +	struct ecc_error_info ueinfo;
> +};
> +
> +/**
> + * struct synopsys_edac_priv - DDR memory controller private instance data
> + * @baseaddr:		Base address of the DDR controller
> + * @ce_count:		Correctable Error count
> + * @ue_count:		Uncorrectable Error count
> + */
> +struct synopsys_edac_priv {
> +	void __iomem *baseaddr;
> +	u32 ce_count;
> +	u32 ue_count;
> +};
> +
> +/**

Why do we need the kernel-doc annotation for all those static functions?

Also, drop the "synopsys_edac_" prefix of all static functions - that'll
slim up the code even further.

> + * synopsys_edac_geterror_info - Get the current ecc error info
> + * @base:	Pointer to the base address of the ddr memory controller
> + * @perrstatus:	Pointer to the synopsys ecc status structure
> + *
> + * This routine determines there is any ecc error or not
> + *
> + * Return: zero if there is no error otherwise returns 1
> + */
> +static int synopsys_edac_geterror_info(void __iomem *base,

That base is an arg to readl, so it should be "const volatile void
__iomem *base", no?

> +		struct synopsys_ecc_status *perrstatus)

Please align function args at the opening brace "("

> +{
> +	u32 regval;
> +	u32 clearval = 0;
> +
> +	regval = readl(base + SYNOPSYS_DDRC_ECC_STAT_REG_OFFSET) &
> +			(SYNOPSYS_DDRC_ECC_STATREG_UECOUNT_MASK |
> +			SYNOPSYS_DDRC_ECC_STATREG_CECOUNT_MASK);

All your macro definitions start with "SYNOPSYS_DDRC" even though
they're only local to this file. Which makes the code very unreadable
due to their size.

You could slim them up by dropping the prefix and doing:

	regval = readl(base + STAT_REG_OFFSET) &
			(STATREG_UECOUNT_MASK | STATREG_CECOUNT_MASK);

which is much better IMO.

The same is true for struct names like synopsys_ecc_status and the like.
Shortening them too would slim down your code considerably.

> +
> +	if (regval == 0)
> +		return 0;

	if (!regval)

> +
> +	memset(perrstatus, 0, sizeof(struct synopsys_ecc_status));

That perrstatus could also be shortened to errstat and make the whole
code shorter:

	memset(errstat, 0, sizeof(*errstat));

and so on...

> +
> +	perrstatus->ce_count =
> +			   (regval & SYNOPSYS_DDRC_ECC_STATREG_CECOUNT_MASK) >>
> +			    SYNOPSYS_DDRC_ECC_STATREG_CECOUNT_SHIFT;
> +	perrstatus->ue_count =
> +			   (regval & SYNOPSYS_DDRC_ECC_STATREG_UECOUNT_MASK);
> +
> +	if (perrstatus->ce_count) {
> +		regval = readl(base + SYNOPSYS_DDRC_ECC_CE_LOG_REG_OFFSET);
> +		if (regval & SYNOPSYS_DDRC_ECC_CE_LOGREG_VALID) {
> +			perrstatus->ceinfo.bitpos = (regval &
> +				SYNOPSYS_DDRC_ECC_CE_LOGREG_BITPOS_MASK) >>
> +				SYNOPSYS_DDRC_ECC_CE_LOGREG_BITPOS_SHIFT;
> +			regval = readl(base +
> +					SYNOPSYS_DDRC_ECC_CE_ADDR_REG_OFFSET);
> +			perrstatus->ceinfo.row = (regval &
> +					SYNOPSYS_DDRC_ECC_ADDRREG_ROW_MASK) >>
> +					SYNOPSYS_DDRC_ECC_ADDRREG_ROW_SHIFT;
> +			perrstatus->ceinfo.col = (regval &
> +					SYNOPSYS_DDRC_ECC_ADDRREG_COL_MASK);
> +			perrstatus->ceinfo.bank = (regval &
> +					SYNOPSYS_DDRC_ECC_ADDRREG_BANK_MASK) >>
> +					SYNOPSYS_DDRC_ECC_ADDRREG_BANK_SHIFT;
> +			perrstatus->ceinfo.data = readl(base +
> +				SYNOPSYS_DDRC_ECC_CE_DATA_31_0_REG_OFFSET);
> +			edac_dbg(3, "ce bitposition: %d data: %d\n",
> +					perrstatus->ceinfo.bitpos,
> +					perrstatus->ceinfo.data);
> +		}
> +		clearval = SYNOPSYS_DDRC_ECCCTRL_CLR_CE_ERR;
> +	}
> +
> +	if (perrstatus->ue_count) {
> +		regval = readl(base + SYNOPSYS_DDRC_ECC_UE_LOG_REG_OFFSET);
> +		if (regval & SYNOPSYS_DDRC_ECC_CE_LOGREG_VALID) {
> +			regval = readl(base +
> +					SYNOPSYS_DDRC_ECC_UE_ADDR_REG_OFFSET);
> +			perrstatus->ueinfo.row = (regval &
> +					SYNOPSYS_DDRC_ECC_ADDRREG_ROW_MASK) >>
> +					SYNOPSYS_DDRC_ECC_ADDRREG_ROW_SHIFT;
> +			perrstatus->ueinfo.col = (regval &
> +					SYNOPSYS_DDRC_ECC_ADDRREG_COL_MASK);
> +			perrstatus->ueinfo.bank = (regval &
> +					SYNOPSYS_DDRC_ECC_ADDRREG_BANK_MASK) >>
> +					SYNOPSYS_DDRC_ECC_ADDRREG_BANK_SHIFT;
> +			perrstatus->ueinfo.data = readl(base +
> +				    SYNOPSYS_DDRC_ECC_UE_DATA_31_0_REG_OFFSET);

All those assignments could be much shorter:

			p->ueinfo.row = (regval & ADDRREG_ROW_MASK) >> ADDRREG_ROW_SHIFT;

Also, you can save yourself two indentation levels by flipping the
logic:

	if (!(p->ce_count && (regval & CE_LOGREG_VALID)))
		goto ue_error;

	/* CE assignments */

	...

 ue_error:

	if (!(p->ue_count && (regval & UE_LOGREG_VALID)))
		goto out;

	/* UE assignments */

	...

 out:

	writel(...);
	writel(...);


> +		}
> +		clearval |= SYNOPSYS_DDRC_ECCCTRL_CLR_UE_ERR;
> +	}
> +
> +	writel(clearval, base + SYNOPSYS_DDRC_ECC_CONTROL_REG_OFFSET);
> +	writel(0x0, base + SYNOPSYS_DDRC_ECC_CONTROL_REG_OFFSET);
> +
> +	return 1;
> +}
> +
> +/**
> + * synopsys_edac_generate_message - Generate interpreted ECC status message
> + * @mci:	Pointer to the edac memory controller instance
> + * @perrstatus:	Pointer to the synopsys ecc status structure
> + * @buffer:	Pointer to the buffer in which to generate the
> + *		message
> + * @size:	The size, in bytes, of space available in buffer
> + *
> + * This routine generates to the provided buffer the portion of the
> + * driver-unique report message associated with the ECC register of
> + * the specified ECC status.
> + */
> +static void synopsys_edac_generate_message(const struct mem_ctl_info *mci,
> +			struct synopsys_ecc_status *perrstatus, char *buffer,
> +			size_t size)
> +{
> +	struct ecc_error_info *pinfo = NULL;
> +
> +	if (perrstatus->ce_count > 0)
> +		pinfo = &perrstatus->ceinfo;
> +	else
> +		pinfo = &perrstatus->ueinfo;
> +
> +	snprintf(buffer, SYNOPSYS_EDAC_MESSAGE_SIZE,
> +		 "DDR ECC error type :%s Row %d Bank %d Col %d ",
> +		 (perrstatus->ce_count > 0) ? "CE" : "UE", pinfo->row,
> +		 pinfo->bank, pinfo->col);
> +}

This function can be part of synopsys_edac_handle_error() below instead
as it is simple enough and called only once there - no need for a
separate function.

> +
> +/**
> + * synopsys_edac_handle_error - Handle controller error types CE and UE
> + * @mci:	Pointer to the edac memory controller instance
> + * @perrstatus:	Pointer to the synopsys ecc status structure
> + *
> + * This routine handles the controller ECC correctable error.

It handles also UC errors.

> + */
> +static void synopsys_edac_handle_error(struct mem_ctl_info *mci,
> +			struct synopsys_ecc_status *perrstatus)
> +{
> +	char message[SYNOPSYS_EDAC_MESSAGE_SIZE];
> +
> +	synopsys_edac_generate_message(mci, perrstatus, &message[0],
> +				   SYNOPSYS_EDAC_MESSAGE_SIZE);
> +
> +	if (perrstatus->ce_count)
> +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +				     perrstatus->ce_count, 0, 0, 0, 0, 0, -1,
> +				     &message[0], "");

string_array == &string_array[0]

> +	else
> +		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +				     perrstatus->ue_count, 0, 0, 0, 0, 0, -1,
> +				     &message[0], "");

Ditto.

> +}
> +
> +/**
> + * synopsys_edac_check - Check controller for ECC errors
> + * @mci:	Pointer to the edac memory controller instance
> + *
> + * This routine is used to check and post ECC errors and is called by
> + * the EDAC polling thread
> + */
> +static void synopsys_edac_check(struct mem_ctl_info *mci)
> +{
> +	struct synopsys_edac_priv *priv = mci->pvt_info;
> +	struct synopsys_ecc_status errstatus;
> +	int status;
> +
> +	status = synopsys_edac_geterror_info(priv->baseaddr, &errstatus);
> +	if (status) {

Save an indentation level:

	if (!status)
		return;

	priv->ce_count += ...
	...

> +		priv->ce_count += errstatus.ce_count;
> +		priv->ue_count += errstatus.ue_count;
> +
> +		if (errstatus.ce_count) {
> +			synopsys_edac_handle_error(mci, &errstatus);
> +			errstatus.ce_count = 0;
> +		}
> +		if (errstatus.ue_count) {
> +			synopsys_edac_handle_error(mci, &errstatus);
> +			errstatus.ue_count = 0;
> +		}
> +		edac_dbg(3, "total error count ce %d ue %d\n",
> +			 priv->ce_count, priv->ue_count);
> +	}
> +}
> +
> +/**
> + * synopsys_edac_get_dtype - Return the controller memory width
> + * @base:	Pointer to the ddr memory contoller base address
> + *
> + * This routine returns the EDAC device type width appropriate for the
> + * current controller configuration.
> + *
> + * Return: a device type width enumeration.
> + */
> +static enum dev_type synopsys_edac_get_dtype(void __iomem *base)
> +{
> +	enum dev_type dt;
> +	u32 width;
> +
> +	width = readl(base + SYNOPSYS_DDRC_CONTROL_REG_OFFSET);
> +	width = (width & SYNOPSYS_DDRC_CTRLREG_BUSWIDTH_MASK) >>
> +			SYNOPSYS_DDRC_CTRLREG_BUSWIDTH_SHIFT;
> +
> +	switch (width) {
> +	case SYNOPSYS_DDRCTL_WDTH_16:
> +		dt = DEV_X2;
> +		break;
> +	case SYNOPSYS_DDRCTL_WDTH_32:
> +		dt = DEV_X4;
> +		break;
> +	default:
> +		dt = DEV_UNKNOWN;
> +	}
> +
> +	return dt;
> +}
> +
> +/**
> + * synopsys_edac_get_eccstate - Return the controller ecc enable/disable status
> + * @base:	Pointer to the ddr memory contoller base address
> + *
> + * This routine returns the ECC enable/diable status for the controller
> + *
> + * Return: a ecc status boolean i.e true/false - enabled/disabled.
> + */
> +static bool synopsys_edac_get_eccstate(void __iomem *base)
> +{
> +	enum dev_type dt;
> +	u32 ecctype;
> +	bool state = false;
> +
> +	dt = synopsys_edac_get_dtype(base);

Shouldn't you handle the error case where it returns DEV_UNKNOWN type?

> +
> +	ecctype = (readl(base + SYNOPSYS_DDRC_ECC_SCRUB_REG_OFFSET) &
> +			SYNOPSYS_DDRC_ECC_SCRUBREG_ECC_MODE_MASK);
> +
> +	if ((ecctype == SYNOPSYS_DDRC_ECC_SCRUBREG_ECCMODE_SECDED)
> +			&& (dt == DEV_X2)) {
> +		state = true;
> +		writel(0x0, base + SYNOPSYS_DDRC_ECC_CONTROL_REG_OFFSET);
> +	} else {
> +		state = false;

Why that else branch? state is already initialized to false at function
entry time.

> +	}
> +
> +	return state;
> +}
> +
> +/**
> + * synopsys_edac_get_memsize - reads the size of the attached memory device
> + *
> + * Return: the memory size in bytes
> + *
> + * This routine returns the size of the system memory by reading the sysinfo
> + * information
> + */

No need for that comment.

> +static u32 synopsys_edac_get_memsize(void)
> +{
> +	struct sysinfo inf;
> +
> +	/* Reading the system memory size from the global meminfo structure */

Same here.

For simple functions where it is paramount what the function does, you
don't need to comment every line.

> +	si_meminfo(&inf);
> +
> +	return inf.totalram * inf.mem_unit;
> +}
> +
> +/**
> + * synopsys_edac_get_mtype - Returns controller memory type
> + * @base:	pointer to the synopsys ecc status structure
> + *
> + * This routine returns the EDAC memory type appropriate for the
> + * current controller configuration.
> + *
> + * Return: a memory type enumeration.
> + */
> +static enum mem_type synopsys_edac_get_mtype(void __iomem *base)
> +{
> +	enum mem_type mt;
> +	u32 memtype;
> +
> +	memtype = readl(base + SYNOPSYS_DDRC_T_ZQ_REG_OFFSET);
> +
> +	if (memtype & SYNOPSYS_DDRC_T_ZQ_REG_DDRMODE_MASK)
> +		mt = MEM_DDR3;
> +	else
> +		mt = MEM_DDR2;
> +
> +	return mt;
> +}
> +
> +/**
> + * synopsys_edac_init_csrows - Initialize the cs row data
> + * @mci:	Pointer to the edac memory controller instance
> + *
> + * This routine initializes the chip select rows associated
> + * with the EDAC memory controller instance
> + *
> + * Return: 0 if OK; otherwise, -EINVAL if the memory bank size

Where is that -EINVAL being returned?

> + * configuration cannot be determined.
> + */
> +static int synopsys_edac_init_csrows(struct mem_ctl_info *mci)
> +{
> +	struct csrow_info *csi;
> +	struct dimm_info *dimm;
> +	struct synopsys_edac_priv *priv = mci->pvt_info;
> +	u32 size;
> +	int row, j;
> +
> +	for (row = 0; row < mci->nr_csrows; row++) {
> +		csi = mci->csrows[row];
> +		size = synopsys_edac_get_memsize();
> +
> +		for (j = 0; j < csi->nr_channels; j++) {
> +			dimm = csi->channels[j]->dimm;
> +			dimm->edac_mode = EDAC_FLAG_SECDED;
> +			dimm->mtype = synopsys_edac_get_mtype(priv->baseaddr);
> +			dimm->nr_pages =
> +			    (size >> PAGE_SHIFT) / csi->nr_channels;
> +			dimm->grain = SYNOPSYS_EDAC_ERROR_GRAIN;
> +			dimm->dtype = synopsys_edac_get_dtype(priv->baseaddr);
> +		}
> +
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * synopsys_edac_mc_init - Initialize driver instance
> + * @mci:	Pointer to the edac memory controller instance
> + * @pdev:	Pointer to the platform_device struct
> + *
> + * This routine performs initialization of the EDAC memory controller
> + * instance and related driver-private data associated with the
> + * memory controller the instance is bound to.
> + *
> + * Return: 0 if OK; otherwise, < 0 on error.
> + */
> +static int synopsys_edac_mc_init(struct mem_ctl_info *mci,
> +			struct platform_device *pdev)
> +{
> +	int status;
> +	struct synopsys_edac_priv *priv;
> +
> +	/* Initial driver pointers and private data */

Useless comment.

> +	mci->pdev = &pdev->dev;
> +	priv = mci->pvt_info;
> +	platform_set_drvdata(pdev, mci);
> +
> +	/* Initialize controller capabilities and configuration */
> +	mci->mtype_cap = MEM_FLAG_DDR3 | MEM_FLAG_DDR2;
> +	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
> +	mci->scrub_cap = SCRUB_HW_SRC;
> +	/* Check the scrub setting from the controller */

Useless comment.

> +	mci->scrub_mode = SCRUB_NONE;
> +
> +	mci->edac_cap = EDAC_FLAG_SECDED;
> +	/* Initialize strings */

Useless comment.

> +	mci->ctl_name = "synopsys_ddr_controller";
> +	mci->dev_name = dev_name(&pdev->dev);
> +	mci->mod_name = "synopsys_edac";

Do a

#define EDAC_MOD_STR	"synopsys_edac"

like the other drivers do and use that here and below.

> +	mci->mod_ver = "1";
> +
> +	/* Initialize callbacks */

Useless comment.

> +	edac_op_state = EDAC_OPSTATE_POLL;
> +	mci->edac_check = synopsys_edac_check;
> +	mci->ctl_page_to_phys = NULL;
> +
> +	/*
> +	 * Initialize the MC control structure 'csrows' table
> +	 * with the mapping and control information.
> +	 */
> +	status = synopsys_edac_init_csrows(mci);
> +	if (status)
> +		pr_err("Failed to initialize rows!\n");

edac_printk

> +
> +	return status;
> +}
> +
> +/**
> + * synopsys_edac_mc_probe - Check controller and bind driver
> + * @pdev:	Pointer to the platform_device struct
> + *
> + * This routine probes a specific controller
> + * instance for binding with the driver.
> + *
> + * Return: 0 if the controller instance was successfully bound to the
> + * driver; otherwise, < 0 on error.
> + */
> +static int synopsys_edac_mc_probe(struct platform_device *pdev)
> +{
> +	struct mem_ctl_info *mci;
> +	struct edac_mc_layer layers[2];
> +	struct synopsys_edac_priv *priv;
> +	int rc;
> +	struct resource *res;
> +	void __iomem *baseaddr;
> +
> +	/* Get the data from the platform device */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

You're not handling the case where this function returns NULL.

> +	baseaddr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(baseaddr))
> +		return PTR_ERR(baseaddr);
> +
> +	/* Check for the ecc enable status */
> +	if (synopsys_edac_get_eccstate(baseaddr) == false) {

	if (!get_eccstate(...))

> +		dev_err(&pdev->dev, "ecc not enabled\n");

edac_printk pls.

> +		return -ENXIO;
> +	}
> +
> +	/*
> +	 * At this point, we know ECC is enabled, allocate an EDAC
> +	 * controller instance and perform the appropriate
> +	 * initialization.
> +	 */
> +	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> +	layers[0].size = SYNOPSYS_EDAC_NR_CSROWS;
> +	layers[0].is_virt_csrow = true;
> +	layers[1].type = EDAC_MC_LAYER_CHANNEL;
> +	layers[1].size = SYNOPSYS_EDAC_NR_CHANS;
> +	layers[1].is_virt_csrow = false;
> +
> +	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
> +			    sizeof(struct synopsys_edac_priv));
> +	if (mci == NULL) {

	if (!mci)

> +		pr_err("Failed memory allocation for mci instance!\n");

edac_printk

Before you return, devm_iounmap(... baseaddr). Just do it with nice goto
labels.

> +		return -ENOMEM;
> +	}
> +
> +	priv = mci->pvt_info;
> +	priv->baseaddr = baseaddr;
> +	rc = synopsys_edac_mc_init(mci, pdev);
> +	if (rc) {
> +		pr_err("Failed to initialize instance!\n");

edac_printk

> +		goto free_edac_mc;
> +	}
> +
> +	/*
> +	 * We have a valid, initialized EDAC instance bound to the
> +	 * controller. Attempt to register it with the EDAC subsystem
> +	 */
> +	rc = edac_mc_add_mc(mci);
> +	if (rc) {
> +		dev_err(&pdev->dev, "failed to register with EDAC core\n");

Ditto.

> +		goto del_edac_mc;
> +	}
> +
> +	return rc;
> +
> +del_edac_mc:
> +	edac_mc_del_mc(&pdev->dev);
> +free_edac_mc:
> +	edac_mc_free(mci);
> +
> +	return rc;
> +}
> +
> +/**
> + * synopsys_edac_mc_remove - Unbind driver from controller
> + * @pdev:	Pointer to the platform_device struct
> + *
> + * This routine unbinds the EDAC memory controller instance associated
> + * with the specified controller described by the
> + * OpenFirmware device tree node passed as a parameter.
> + *
> + * Return: Unconditionally 0
> + */

No need for that whole comment at all.

> +static int synopsys_edac_mc_remove(struct platform_device *pdev)
> +{
> +	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
> +
> +	edac_mc_del_mc(&pdev->dev);
> +	edac_mc_free(mci);
> +
> +	return 0;
> +}
> +
> +/* Device tree node type and compatible tuples this driver can match on */

Ditto.

> +static struct of_device_id synopsys_edac_match[] = {
> +	{ .compatible = "xlnx,zynq-ddrc-1.04", },
> +	{ /* end of table */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, synopsys_edac_match);
> +
> +static struct platform_driver synopsys_edac_mc_driver = {
> +	.driver = {
> +		   .name = "synopsys-edac",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = synopsys_edac_match,
> +		   },
> +	.probe = synopsys_edac_mc_probe,
> +	.remove = synopsys_edac_mc_remove,
> +};
> +
> +module_platform_driver(synopsys_edac_mc_driver);
> +
> +MODULE_AUTHOR("Xilinx, Inc.");
> +MODULE_DESCRIPTION("Synopsys DDR ECC driver");
> +MODULE_LICENSE("GPL v2");

Ok, that should be it so far, more review with the next submission.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
