Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaLBFV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:21:27 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:47257 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaLBFVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:21:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141201182611.GA4169@pd.tnic>
References: <a1c485c3bb214d5699fdbfc6180f96f8@BN1AFFO11FD044.protection.gbl>
	<20141201182611.GA4169@pd.tnic>
Date: Tue, 2 Dec 2014 10:51:22 +0530
X-Google-Sender-Auth: ajQO9Ir2GRuDhU2JFyns2m1L3eY
Message-ID: <CAGnW=BaRuZvFYCz0=s_ENn_sbH4YPxZiHt1x4GvRcUAyO0s+Jw@mail.gmail.com>
Subject: Re: [PATCH v6] edac: synps: Added EDAC support for zynq ddr ecc controller
From: punnaiah choudary kalluri <punnaia@xilinx.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        dougthompson@xmission.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Punnaiah Choudary <kpc528@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris

On Mon, Dec 1, 2014 at 11:56 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Dec 01, 2014 at 09:35:09PM +0530, Punnaiah Choudary Kalluri wrote:
>> Added EDAC support for reporting the ecc errors of synopsys ddr controller.
>> The ddr ecc controller corrects single bit errors and detects double bit
>> errors.
>>
>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>> ---
>> Changes for v6:
>> - Fixed indentation and typo errors
>> - Corrected the function and structure headers
>> Changes for v5:
>> - Removed dt binding info as already there is a binding info available
>>    under memorycontroller. so, updated ecc info there.
>> - corrected the ip version and function return types
>> Changes for v4:
>> - Shorten the macro definitions
>> - Corrected the ddr ip version
>> - Reverted the file name change
>> Changes for v3:
>> - Updated maintainer information
>> - Driver cleanup as per the review comments
>> - Shortened the prefix "sysnopsys" to "synps"
>> Changes for v2:
>> - Updated the commit header and message
>> - Renamed the filenames to synopsys_edac
>> - Corrected the compatilble string, commnets
>> - Renamed the macros,fucntions and data structures
>> ---
>>  MAINTAINERS                  |    1 +
>>  drivers/edac/Kconfig         |    7 +
>>  drivers/edac/Makefile        |    1 +
>>  drivers/edac/synopsys_edac.c |  542 ++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 551 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/edac/synopsys_edac.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0ff630d..7601298 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1556,6 +1556,7 @@ N:      xilinx
>>  F:   drivers/clocksource/cadence_ttc_timer.c
>>  F:   drivers/i2c/busses/i2c-cadence.c
>>  F:   drivers/mmc/host/sdhci-of-arasan.c
>> +F:   drivers/edac/synopsys_edac.c
>>
>>  ARM SMMU DRIVER
>>  M:   Will Deacon <will.deacon@arm.com>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 7072c28..c6d448e 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -385,4 +385,11 @@ config EDAC_ALTERA_MC
>>         preloader must initialize the SDRAM before loading
>>         the kernel.
>>
>> +config EDAC_SYNOPSYS
>> +     tristate "Synopsys DDR Memory Controller"
>> +     depends on EDAC_MM_EDAC && ARCH_ZYNQ
>> +     help
>> +       Support for EDAC on the ECC memory used with the Synopsys DDR
>> +       memory controller.
>
> Just like the other drivers:
>
> "Support for error detection and correction on the Synopsys DDR memory
> controller"
>
>> +
>>  endif # EDAC
>> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
>> index 359aa49..9b5a095 100644
>> --- a/drivers/edac/Makefile
>> +++ b/drivers/edac/Makefile
>> @@ -67,3 +67,4 @@ obj-$(CONFIG_EDAC_OCTEON_LMC)               += octeon_edac-lmc.o
>>  obj-$(CONFIG_EDAC_OCTEON_PCI)                += octeon_edac-pci.o
>>
>>  obj-$(CONFIG_EDAC_ALTERA_MC)         += altera_edac.o
>> +obj-$(CONFIG_EDAC_SYNOPSYS)          += synopsys_edac.o
>> diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
>> new file mode 100644
>> index 0000000..2a13a23
>> --- /dev/null
>> +++ b/drivers/edac/synopsys_edac.c
>> @@ -0,0 +1,542 @@
>> +/*
>> + * Synopsys DDR ECC Driver
>> + * This driver is based on ppc4xx_edac.c drivers
>> + *
>> + * Copyright (C) 2012 - 2014 Xilinx, Inc.
>> + *
>> + * This program is free software: you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation, either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file "COPYING" in the main directory of this archive
>> + * for more details
>> + */
>> +
>> +#include <linux/edac.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +
>> +#include "edac_core.h"
>> +
>> +/* Number of cs_rows needed per memory controller */
>> +#define SYNPS_EDAC_NR_CSROWS 1
>> +
>> +/* Number of channels per memory controller */
>> +#define SYNPS_EDAC_NR_CHANS  1
>> +
>> +/* Granularity of reported error in bytes */
>> +#define SYNPS_EDAC_ERR_GRAIN 1
>> +
>> +#define SYNPS_EDAC_MSG_SIZE  256
>> +
>> +#define SYNPS_EDAC_MOD_STRING        "synps_edac"
>> +#define SYNPS_EDAC_MOD_VER   "1"
>> +
>> +/* Synopsys DDR memory controller registers that are relevant to ECC */
>> +#define CTRL_OFST            0x0
>> +#define T_ZQ_OFST            0xA4
>> +
>> +/* ECC control register */
>> +#define ECC_CTRL_OFST                0xC4
>> +/* ECC log register */
>> +#define CE_LOG_OFST          0xC8
>> +/* ECC address register */
>> +#define CE_ADDR_OFST         0xCC
>> +/* ECC data[31:0] register */
>> +#define CE_DATA_31_0_OFST    0xD0
>> +
>> +/* Uncorrectable error info regsisters */
>> +#define UE_LOG_OFST          0xDC
>> +#define UE_ADDR_OFST         0xE0
>> +#define UE_DATA_31_0_OFST    0xE4
>> +
>> +#define STAT_OFST            0xF0
>> +#define SCRUB_OFST           0xF4
>> +
>> +/* Control regsiter bitfield definitions */
>> +#define CTRL_BW_MASK         0xC
>> +#define CTRL_BW_SHIFT                2
>> +
>> +#define DDRCTL_WDTH_16               1
>> +#define DDRCTL_WDTH_32               0
>> +
>> +/* ZQ register bitfield definitions */
>> +#define T_ZQ_DDRMODE_MASK    0x2
>> +
>> +/* ECC control register bitfield definitions */
>> +#define ECC_CTRL_CLR_CE_ERR  0x2
>> +#define ECC_CTRL_CLR_UE_ERR  0x1
>> +
>> +/* ECC correctable/uncorrectable error log register definitions */
>> +#define CE_LOG_VALID         0x1
>> +#define CE_LOG_BITPOS_MASK   0xFE
>> +#define CE_LOG_BITPOS_SHIFT  1
>> +
>> +/* ECC correctable/uncorrectable error address register definitions */
>> +#define ADDR_COL_MASK                0xFFF
>> +#define ADDR_ROW_MASK                0xFFFF000
>> +#define ADDR_ROW_SHIFT               12
>> +#define ADDR_BANK_MASK               0x70000000
>> +#define ADDR_BANK_SHIFT              28
>> +
>> +/* ECC statistic regsiter definitions */
>> +#define STAT_UECNT_MASK              0xFF
>> +#define STAT_CECNT_MASK              0xFF00
>> +#define STAT_CECNT_SHIFT     8
>> +
>> +/* ECC scrub regsiter definitions */
>> +#define SCRUB_MODE_MASK              0x7
>> +#define SCRUB_MODE_SECDED    0x4
>> +
>> +/**
>> + * struct ecc_error_info - ECC error log information
>> + * @row:     Row number
>> + * @col:     Column number
>> + * @bank:    Bank number
>> + * @bitpos:  Bit position
>> + * @data:    Data causing the error
>> + */
>> +struct ecc_error_info {
>> +     u32 row;
>> +     u32 col;
>> +     u32 bank;
>> +     u32 bitpos;
>> +     u32 data;
>> +};
>> +
>> +/**
>> + * struct synps_ecc_status - ECC status information to report
>> + * @ce_cnt:  Correctable error count
>> + * @ue_cnt:  Uncorrectable error count
>> + * @ceinfo:  Correctable error log information
>> + * @ueinfo:  Uncorrectable error log information
>> + */
>> +struct synps_ecc_status {
>> +     u32 ce_cnt;
>> +     u32 ue_cnt;
>> +     struct ecc_error_info ceinfo;
>> +     struct ecc_error_info ueinfo;
>> +};
>> +
>> +/**
>> + * struct synps_edac_priv - DDR memory controller private instance data
>> + * @baseaddr:                Base address of the DDR controller
>> + * @ce_cnt:          Correctable Error count
>> + * @ue_cnt:          Uncorrectable Error count
>> + */
>> +struct synps_edac_priv {
>> +     void __iomem *baseaddr;
>> +     u32 ce_cnt;
>> +     u32 ue_cnt;
>> +};
>> +
>> +/**
>> + * synps_edac_geterror_info - Get the current ecc error info
>> + * @base:    Pointer to the base address of the ddr memory controller
>> + * @p:               Pointer to the synopsys ecc status structure
>> + *
>> + * This routine determines there is any ecc error or not
>> + *
>> + * Return: one if there is no error otherwise returns zero
>> + */
>> +static int synps_edac_geterror_info(void __iomem *base,
>> +                                 struct synps_ecc_status *p)
>> +{
>> +     u32 regval;
>> +     u32 clearval = 0;
>
> Put them on a single line:
>
>         u32 regval, clearval = 0;
>
>> +
>> +     regval = readl(base + STAT_OFST) & (STAT_UECNT_MASK | STAT_CECNT_MASK);
>> +
>
> Superfluous newline.
>
>> +     if (!regval)
>> +             return 1;
>> +
>> +     memset(p, 0, sizeof(*p));
>
> See the comment below about when to memset this.
>
>> +
>> +     p->ce_cnt = (regval & STAT_CECNT_MASK) >> STAT_CECNT_SHIFT;
>> +     p->ue_cnt = regval & STAT_UECNT_MASK;
>
> This looks clumsy. Just do this instead:
>
>         int ret = 0;
>
>         regval    = readl(base + STAT_OFST);
>         p->ce_cnt = (regval & STAT_CECNT_MASK) >> STAT_CECNT_SHIFT;
>         p->ue_cnt =  regval & STAT_UECNT_MASK;
>
>         if (pe->ce_cnt ... ) {
>                 __assign_error_info(CE, ...);
>                 ret = 1;
>         }
>
>         if (pe->ue_cnt ...) {
>                 __assign_error_info(UE, ...);
>                 ret = 1;
>         }
>
>         ...
>
>         return ret;
>
> and __assign_error_info() gets the needed register values and does only
> the assignments according to the first argument which tells it what to
> assign - a CE or an UE.
>
>> +
>> +     regval = readl(base + CE_LOG_OFST);
>> +     if (!(p->ce_cnt && (regval & CE_LOG_VALID)))
>> +             goto ue_err;
>> +     p->ceinfo.bitpos = (regval & CE_LOG_BITPOS_MASK) >> CE_LOG_BITPOS_SHIFT;
>> +     regval = readl(base + CE_ADDR_OFST);
>> +     p->ceinfo.row = (regval & ADDR_ROW_MASK) >> ADDR_ROW_SHIFT;
>> +     p->ceinfo.col = regval & ADDR_COL_MASK;
>> +     p->ceinfo.bank = (regval & ADDR_BANK_MASK) >> ADDR_BANK_SHIFT;
>> +     p->ceinfo.data = readl(base + CE_DATA_31_0_OFST);
>
> Right so this [*]  ...
>
>> +     edac_dbg(3, "ce bitposition: %d data: %d\n", p->ceinfo.bitpos,
>> +              p->ceinfo.data);
>> +     clearval = ECC_CTRL_CLR_CE_ERR;
>> +
>> +ue_err:
>> +     regval = readl(base + UE_LOG_OFST);
>> +     if (!(p->ue_cnt && (regval & CE_LOG_VALID)))
>> +             goto out;
>
> This is funny: you do test CE_LOG_VALID here for UE and above for CE
> errors. If it is the same bit, just call it ERR_VALID so that it is
> clear.
>
>> +
>> +     regval = readl(base + UE_ADDR_OFST);
>> +     p->ueinfo.row = (regval & ADDR_ROW_MASK) >> ADDR_ROW_SHIFT;
>> +     p->ueinfo.col = regval & ADDR_COL_MASK;
>> +     p->ueinfo.bank = (regval & ADDR_BANK_MASK) >> ADDR_BANK_SHIFT;
>> +     p->ueinfo.data = readl(base + UE_DATA_31_0_OFST);
>
> ... [*] and this looks pretty similar and could be carved out in a
> __assign_error_info() function.
>
> Also, you can slim down struct synps_ecc_status by having a single
> struct ecc_error_info embedded in there and a flag which says what type
> of error this struct is carrying.
>
> Or is it technically possible to have both a CE and an UE coming out of
> the hardware so that you want to carry two errors at the same time?
>
> In any case, you can split this synps_edac_geterror_info() function into
> a helper which assigns to the different p-> fields and you hand-in only
> the regvals you've read before, i.e. the __assign_error_info() example
> above.
>
>> +     clearval |= ECC_CTRL_CLR_UE_ERR;
>> +
>> +out:
>> +     writel(clearval, base + ECC_CTRL_OFST);
>> +     writel(0x0, base + ECC_CTRL_OFST);
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * synps_edac_handle_error - Handle controller error types CE and UE
>> + * @mci:     Pointer to the edac memory controller instance
>> + * @p:               Pointer to the synopsys ecc status structure
>> + *
>> + * This routine handles the controller ECC correctable and un correctable
>> + * error.
>> + */
>> +static void synps_edac_handle_error(struct mem_ctl_info *mci,
>> +                                 struct synps_ecc_status *p)
>> +{
>> +     char message[SYNPS_EDAC_MSG_SIZE];
>
> You could preallocate this on driver init so you don't do relatively big
> stack allocations on the error reporting path and remain lean.
>
>> +     struct ecc_error_info *pinf;
>> +
>> +     if (p->ce_cnt) {
>> +             pinf = &p->ceinfo;
>> +             snprintf(message, SYNPS_EDAC_MSG_SIZE,
>> +                      "DDR ECC error type :%s Row %d Bank %d Col %d ",
>> +                      "CE", pinf->row, pinf->bank, pinf->col);
>> +             edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>> +                                  p->ce_cnt, 0, 0, 0, 0, 0, -1,
>> +                                  message, "");
>> +     }
>> +
>> +     if (p->ue_cnt) {
>> +             pinf = &p->ueinfo;
>> +             snprintf(message, SYNPS_EDAC_MSG_SIZE,
>> +                      "DDR ECC error type :%s Row %d Bank %d Col %d ",
>> +                      "UE", pinf->row, pinf->bank, pinf->col);
>> +             edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
>> +                                  p->ue_cnt, 0, 0, 0, 0, 0, -1,
>> +                                  message, "");
>> +     }
>
> If you memset(p, 0,...) here, after consumption, you don't need to do it
> anywhere else and be sure that *p would be always clean and ready for
> the next error.
>
>> +}
>> +
>> +/**
>> + * synps_edac_check - Check controller for ECC errors
>> + * @mci:     Pointer to the edac memory controller instance
>> + *
>> + * This routine is used to check and post ECC errors and is called by
>
> All those comments start with the boilerplate "This rounine is
> blabla...". Just write only the "blabla... " :) In this particular case:
>
> "Check and post ECC errors. Called by the polling thread."
>
> Much faster to read :)
>
>> + * the EDAC polling thread
>> + */
>> +static void synps_edac_check(struct mem_ctl_info *mci)
>> +{
>> +     struct synps_edac_priv *priv = mci->pvt_info;
>> +     struct synps_ecc_status stat;
>> +     int status;
>> +
>> +     status = synps_edac_geterror_info(priv->baseaddr, &stat);
>> +     if (status)
>> +             return;
>> +
>> +     priv->ce_cnt += stat.ce_cnt;
>> +     priv->ue_cnt += stat.ue_cnt;
>> +     synps_edac_handle_error(mci, &stat);
>> +
>> +     edac_dbg(3, "Total error count ce %d ue %d\n",
>> +              priv->ce_cnt, priv->ue_cnt);
>> +}
>> +
>> +/**
>> + * synps_edac_get_dtype - Return the controller memory width
>> + * @base:    Pointer to the ddr memory contoller base address
>> + *
>> + * This routine returns the EDAC device type width appropriate for the
>> + * current controller configuration.
>> + *
>> + * Return: a device type width enumeration.
>> + */
>> +static enum dev_type synps_edac_get_dtype(const void __iomem *base)
>> +{
>> +     enum dev_type dt;
>> +     u32 width;
>> +
>> +     width = readl(base + CTRL_OFST);
>> +     width = (width & CTRL_BW_MASK) >> CTRL_BW_SHIFT;
>> +
>> +     switch (width) {
>> +     case DDRCTL_WDTH_16:
>> +             dt = DEV_X2;
>> +             break;
>> +     case DDRCTL_WDTH_32:
>> +             dt = DEV_X4;
>> +             break;
>> +     default:
>> +             dt = DEV_UNKNOWN;
>> +     }
>> +
>> +     return dt;
>> +}
>> +
>> +/**
>> + * synps_edac_get_eccstate - Return the controller ecc enable/disable status
>> + * @base:    Pointer to the ddr memory contoller base address
>> + *
>> + * This routine returns the ECC enable/disable status for the controller
>> + *
>> + * Return: a ecc status boolean i.e true/false - enabled/disabled.
>> + */
>> +static bool synps_edac_get_eccstate(void __iomem *base)
>> +{
>> +     enum dev_type dt;
>> +     u32 ecctype;
>> +     bool state = false;
>> +
>> +     dt = synps_edac_get_dtype(base);
>> +     if (dt == DEV_UNKNOWN)
>> +             return state;
>> +
>> +     ecctype = readl(base + SCRUB_OFST) & SCRUB_MODE_MASK;
>> +
>> +     if ((ecctype == SCRUB_MODE_SECDED) && (dt == DEV_X2)) {
>> +             state = true;
>> +             writel(0x0, base + ECC_CTRL_OFST);
>
> Out of curiosity, why is that register write needed here? Maybe
> forgotten? It looks unbalanced...

This is needed to start capturing the correctable and uncorrectable errors.
Writing 1 to this register bits will clear the counters and writing 0 will start
the counters.

>
>> +     }
>> +
>> +     return state;
>> +}
>> +
>> +/**
>> + * synps_edac_get_memsize - reads the size of the attached memory device
>> + *
>> + * Return: the memory size in bytes
>> + */
>> +static u32 synps_edac_get_memsize(void)
>> +{
>> +     struct sysinfo inf;
>> +
>> +     si_meminfo(&inf);
>> +
>> +     return inf.totalram * inf.mem_unit;
>> +}
>> +
>> +/**
>> + * synps_edac_get_mtype - Returns controller memory type
>> + * @base:    pointer to the synopsys ecc status structure
>> + *
>> + * This routine returns the EDAC memory type appropriate for the
>> + * current controller configuration.
>> + *
>> + * Return: a memory type enumeration.
>> + */
>> +static enum mem_type synps_edac_get_mtype(const void __iomem *base)
>> +{
>> +     enum mem_type mt;
>> +     u32 memtype;
>> +
>> +     memtype = readl(base + T_ZQ_OFST);
>> +
>> +     if (memtype & T_ZQ_DDRMODE_MASK)
>> +             mt = MEM_DDR3;
>> +     else
>> +             mt = MEM_DDR2;
>> +
>> +     return mt;
>> +}
>> +
>> +/**
>> + * synps_edac_init_csrows - Initialize the cs row data
>> + * @mci:     Pointer to the edac memory controller instance
>> + *
>> + * This routine initializes the chip select rows associated
>> + * with the EDAC memory controller instance
>> + *
>> + * Return: Unconditionally 0.
>> + */
>> +static int synps_edac_init_csrows(struct mem_ctl_info *mci)
>> +{
>> +     struct csrow_info *csi;
>> +     struct dimm_info *dimm;
>> +     struct synps_edac_priv *priv = mci->pvt_info;
>> +     u32 size;
>> +     int row, j;
>> +
>> +     for (row = 0; row < mci->nr_csrows; row++) {
>> +             csi = mci->csrows[row];
>> +             size = synps_edac_get_memsize();
>> +
>> +             for (j = 0; j < csi->nr_channels; j++) {
>> +                     dimm = csi->channels[j]->dimm;
>> +                     dimm->edac_mode = EDAC_FLAG_SECDED;
>> +                     dimm->mtype = synps_edac_get_mtype(priv->baseaddr);
>> +                     dimm->nr_pages =
>> +                         (size >> PAGE_SHIFT) / csi->nr_channels;
>
> No need for the linebreak here, even if it sticks out of 80 cols. The
> break is uglier.

It is crossing 80 cols. so, there is line break here. I feel the other
way as the check patch
throws warning for this.

I will fix all the comments and send you the next version.Thanks for the review.

Regards,
Punnaiah

>
> You could even align on the "=" signs for even better readability.

>
>> +                     dimm->grain = SYNPS_EDAC_ERR_GRAIN;
>> +                     dimm->dtype = synps_edac_get_dtype(priv->baseaddr);
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * synps_edac_mc_init - Initialize driver instance
>> + * @mci:     Pointer to the edac memory controller instance
>> + * @pdev:    Pointer to the platform_device struct
>> + *
>> + * This routine performs initialization of the EDAC memory controller
>> + * instance and related driver-private data associated with the
>> + * memory controller the instance is bound to.
>> + *
>> + * Return: 0 if OK; otherwise, < 0 on error.
>
> Where do we even return < 0 since synps_edac_init_csrows() returns
> "Unconditionally 0." ?
>
>> + */
>> +static int synps_edac_mc_init(struct mem_ctl_info *mci,
>> +                              struct platform_device *pdev)
>> +{
>> +     int status;
>> +     struct synps_edac_priv *priv;
>> +
>> +     mci->pdev = &pdev->dev;
>> +     priv = mci->pvt_info;
>> +     platform_set_drvdata(pdev, mci);
>> +
>> +     /* Initialize controller capabilities and configuration */
>> +     mci->mtype_cap = MEM_FLAG_DDR3 | MEM_FLAG_DDR2;
>> +     mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
>> +     mci->scrub_cap = SCRUB_HW_SRC;
>> +     mci->scrub_mode = SCRUB_NONE;
>> +
>> +     mci->edac_cap = EDAC_FLAG_SECDED;
>> +     mci->ctl_name = "synps_ddr_controller";
>> +     mci->dev_name = SYNPS_EDAC_MOD_STRING;
>> +     mci->mod_name = SYNPS_EDAC_MOD_VER;
>> +     mci->mod_ver = "1";
>> +
>> +     edac_op_state = EDAC_OPSTATE_POLL;
>> +     mci->edac_check = synps_edac_check;
>> +     mci->ctl_page_to_phys = NULL;
>> +
>> +     /*
>> +      * Initialize the MC control structure 'csrows' table
>> +      * with the mapping and control information.
>> +      */
>
> That is too much and too obvious a comment.
>
>> +     status = synps_edac_init_csrows(mci);
>> +
>> +     return status;
>> +}
>> +
>> +/**
>> + * synps_edac_mc_probe - Check controller and bind driver
>> + * @pdev:    Pointer to the platform_device struct
>> + *
>> + * This routine probes a specific controller
>> + * instance for binding with the driver.
>
> Ditto.
>
>> + *
>> + * Return: 0 if the controller instance was successfully bound to the
>> + * driver; otherwise, < 0 on error.
>> + */
>> +static int synps_edac_mc_probe(struct platform_device *pdev)
>> +{
>> +     struct mem_ctl_info *mci;
>> +     struct edac_mc_layer layers[2];
>> +     struct synps_edac_priv *priv;
>> +     int rc;
>> +     struct resource *res;
>> +     void __iomem *baseaddr;
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     baseaddr = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(baseaddr))
>> +             return PTR_ERR(baseaddr);
>> +
>> +     if (synps_edac_get_eccstate(baseaddr) == false) {
>
>         if (!synps_edac_get_eccstate(...)) {
>
>> +             edac_printk(KERN_INFO, EDAC_MC, "ECC not enabled\n");
>> +             return -ENXIO;
>> +     }
>> +
>> +     layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
>> +     layers[0].size = SYNPS_EDAC_NR_CSROWS;
>> +     layers[0].is_virt_csrow = true;
>> +     layers[1].type = EDAC_MC_LAYER_CHANNEL;
>> +     layers[1].size = SYNPS_EDAC_NR_CHANS;
>> +     layers[1].is_virt_csrow = false;
>> +
>> +     mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
>> +                         sizeof(struct synps_edac_priv));
>> +     if (!mci) {
>> +             edac_printk(KERN_ERR, EDAC_MC,
>> +                         "Failed memory allocation for mc instance\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     priv = mci->pvt_info;
>> +     priv->baseaddr = baseaddr;
>> +     rc = synps_edac_mc_init(mci, pdev);
>> +     if (rc) {
>> +             edac_printk(KERN_ERR, EDAC_MC,
>> +                         "Failed to initialize instance\n");
>> +             goto free_edac_mc;
>> +     }
>> +
>> +     rc = edac_mc_add_mc(mci);
>> +     if (rc) {
>> +             edac_printk(KERN_ERR, EDAC_MC,
>> +                         "Failed to register with EDAC core\n");
>> +             goto del_edac_mc;
>
> This should be free_edac_mc as you do edac_mc_del_mc() only if
> edac_mc_add_mc() has succeeded.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
