Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaEHWnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:43:53 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36592 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbaEHWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:43:51 -0400
Message-ID: <536C08B6.2080309@gmail.com>
Date: Thu, 08 May 2014 17:44:06 -0500
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: tthayer@altera.com, robherring2@gmail.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
References: <1399330337-16748-1-git-send-email-tthayer@altera.com> <1399330337-16748-4-git-send-email-tthayer@altera.com>
In-Reply-To: <1399330337-16748-4-git-send-email-tthayer@altera.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 5/5/14 5:52 PM, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
>
> ---
> v2: Use the SDRAM controller registers to calculate memory size
>     instead of the Device Tree. Update To & Cc list. Add maintainer
>     information.
>
> v3: EDAC driver cleanup based on comments from Mailing list.
>
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> ---
>  MAINTAINERS                |    5 +
>  drivers/edac/Kconfig       |    9 +
>  drivers/edac/Makefile      |    2 +
>  drivers/edac/altera_edac.c |  411 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 427 insertions(+)
>  create mode 100644 drivers/edac/altera_edac.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e67ea24..ecd1277 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1290,6 +1290,11 @@ M:	Dinh Nguyen <dinguyen@altera.com>
>  S:	Maintained
>  F:	drivers/clk/socfpga/
>  
> +ARM/SOCFPGA SDRAM EDAC SUPPORT
> +M:	Thor Thayer <tthayer@altera.com>
> +S:	Maintained
> +F:	drivers/edac/altera_edac.c
> +
>  ARM/STI ARCHITECTURE
>  M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
>  M:	Maxime Coquelin <maxime.coquelin@st.com>
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..4f4d379 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -368,4 +368,13 @@ config EDAC_OCTEON_PCI
>  	  Support for error detection and correction on the
>  	  Cavium Octeon family of SOCs.
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
>  endif # EDAC
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index 4154ed6..9741336 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
>  obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>  obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>  obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
> +
> +obj-$(CONFIG_EDAC_ALTERA_MC)	        += altera_edac.o
> diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
> new file mode 100644
> index 0000000..e8a3de7
> --- /dev/null
> +++ b/drivers/edac/altera_edac.c
> @@ -0,0 +1,411 @@
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
> +
> +#include "edac_core.h"
> +#include "edac_module.h"
> +
> +#define EDAC_MOD_STR		"altera_edac"
> +#define EDAC_VERSION		"1"
> +
> +/* SDRAM Controller CtrlCfg Register */
> +#define CTLCFG			0x00
> +
> +/* SDRAM Controller CtrlCfg Register Bit Masks */
> +#define CTLCFG_ECC_EN		0x400
> +#define CTLCFG_ECC_CORR_EN	0x800
> +#define CTLCFG_GEN_SB_ERR	0x2000
> +#define CTLCFG_GEN_DB_ERR	0x4000
> +
> +#define CTLCFG_ECC_AUTO_EN	(CTLCFG_ECC_EN | \
> +				 CTLCFG_ECC_CORR_EN)
> +
> +/* SDRAM Controller Address Width Register */
> +#define DRAMADDRW		0x2C
> +
> +/* SDRAM Controller Address Widths Field Register */
> +#define DRAMADDRW_COLBIT_MASK	0x001F
> +#define DRAMADDRW_COLBIT_LSB	0
> +#define DRAMADDRW_ROWBIT_MASK	0x03E0
> +#define DRAMADDRW_ROWBIT_LSB	5
> +#define DRAMADDRW_BANKBIT_MASK	0x1C00
> +#define DRAMADDRW_BANKBIT_LSB	10
> +#define DRAMADDRW_CSBIT_MASK	0xE000
> +#define DRAMADDRW_CSBIT_LSB	13
> +
> +/* SDRAM Controller Interface Data Width Register */
> +#define DRAMIFWIDTH		0x30
> +
> +/* SDRAM Controller Interface Data Width Defines */
> +#define DRAMIFWIDTH_16B_ECC	24
> +#define DRAMIFWIDTH_32B_ECC	40
> +
> +/* SDRAM Controller DRAM Status Register */
> +#define DRAMSTS		0x38
> +
> +/* SDRAM Controller DRAM Status Register Bit Masks */
> +#define DRAMSTS_SBEERR		0x04
> +#define DRAMSTS_DBEERR		0x08
> +#define DRAMSTS_CORR_DROP	0x10
> +
> +/* SDRAM Controller DRAM IRQ Register */
> +#define DRAMINTR		0x3C
> +
> +/* SDRAM Controller DRAM IRQ Register Bit Masks */
> +#define DRAMINTR_INTREN	0x01
> +#define DRAMINTR_SBEMASK	0x02
> +#define DRAMINTR_DBEMASK	0x04
> +#define DRAMINTR_CORRDROPMASK	0x08
> +#define DRAMINTR_INTRCLR	0x10
> +
> +/* SDRAM Controller Single Bit Error Count Register */
> +#define SBECOUNT		0x40
> +
> +/* SDRAM Controller Single Bit Error Count Register Bit Masks */
> +#define SBECOUNT_MASK		0x0F
> +
> +/* SDRAM Controller Double Bit Error Count Register */
> +#define DBECOUNT		0x44
> +
> +/* SDRAM Controller Double Bit Error Count Register Bit Masks */
> +#define DBECOUNT_MASK		0x0F
> +
> +/* SDRAM Controller ECC Error Address Register */
> +#define ERRADDR		0x48
> +
> +/* SDRAM Controller ECC Error Address Register Bit Masks */
> +#define ERRADDR_MASK		0xFFFFFFFF
> +
> +/* SDRAM Controller ECC Autocorrect Drop Count Register */
> +#define DROPCOUNT		0x4C
> +
> +/* SDRAM Controller ECC Autocorrect Drop Count Register Bit Masks */
> +#define DROPCOUNT_MASK		0x0F
> +
> +/* SDRAM Controller ECC AutoCorrect Address Register */
> +#define DROPADDR		0x50
> +
> +/* SDRAM Controller ECC AutoCorrect Error Address Register Bit Masks */
> +#define DROPADDR_MASK		0xFFFFFFFF
> +
> +/* Altera SDRAM Memory Controller data */
> +struct altr_sdram_mc_data {
> +	struct regmap *mc_vbase;
> +};
> +
> +static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
> +{
> +	struct mem_ctl_info *mci = dev_id;
> +	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
> +	u32 status = 0, err_count = 0, err_addr = 0;
> +
> +	/* Error Address is shared by both SBE & DBE */
> +	regmap_read(drvdata->mc_vbase, ERRADDR, &err_addr);
> +
> +	regmap_read(drvdata->mc_vbase, DRAMSTS, &status);
> +
> +	if (status & DRAMSTS_DBEERR) {
> +		regmap_read(drvdata->mc_vbase, DBECOUNT, &err_count);
> +		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, err_count,
> +				     err_addr >> PAGE_SHIFT,
> +				     err_addr & ~PAGE_MASK, 0,
> +				     0, 0, -1, mci->ctl_name, "");
> +	}
> +	if (status & DRAMSTS_SBEERR) {
> +		regmap_read(drvdata->mc_vbase, SBECOUNT, &err_count);
> +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,
> +				     err_addr >> PAGE_SHIFT,
> +				     err_addr & ~PAGE_MASK, 0,
> +				     0, 0, -1, mci->ctl_name, "");
> +	}
> +
> +	regmap_write(drvdata->mc_vbase,	DRAMINTR,
> +		     (DRAMINTR_INTRCLR | DRAMINTR_INTREN));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +#ifdef CONFIG_EDAC_DEBUG
> +static ssize_t altr_sdr_mc_err_inject_write(struct file *file,
> +					    const char __user *data,
> +					    size_t count, loff_t *ppos)
> +{
> +	struct mem_ctl_info *mci = file->private_data;
> +	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
> +	u32 *ptemp;
> +	dma_addr_t dma_handle;
> +	u32 reg, read_reg = 0;
> +
> +	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
> +	if (IS_ERR(ptemp)) {
> +		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "EDAC Inject: Buffer Allocation error\n");
> +		return -ENOMEM;
> +	}
> +
> +	regmap_read(drvdata->mc_vbase, CTLCFG, &read_reg);
> +	read_reg &= ~(CTLCFG_GEN_SB_ERR | CTLCFG_GEN_DB_ERR);
> +
> +	if (count == 3) {
> +		edac_printk(KERN_ALERT, EDAC_MC,
> +			    "EDAC Inject Double bit error\n");
> +		regmap_write(drvdata->mc_vbase, CTLCFG,
> +			     (read_reg | CTLCFG_GEN_DB_ERR));
> +	} else {
> +		edac_printk(KERN_ALERT, EDAC_MC,
> +			    "EDAC Inject Single bit error\n");
> +		regmap_write(drvdata->mc_vbase,	CTLCFG,
> +			     (read_reg | CTLCFG_GEN_SB_ERR));
> +	}
> +
> +	ptemp[0] = 0x5A5A5A5A;
> +	ptemp[1] = 0xA5A5A5A5;
> +	regmap_write(drvdata->mc_vbase,	CTLCFG, read_reg);
> +	/* Ensure it has been written out */
> +	wmb();
> +
> +	reg = ptemp[0];
> +	read_reg = ptemp[1];
> +	/* Force Read */
> +	rmb();
> +
> +	dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
> +
> +	return count;
> +}
> +
> +static const struct file_operations altr_sdr_mc_debug_inject_fops = {
> +	.open = simple_open,
> +	.write = altr_sdr_mc_err_inject_write,
> +	.llseek = generic_file_llseek,
> +};
> +
> +static void altr_sdr_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
> +{
> +	if (mci->debugfs)
> +		debugfs_create_file("inject_ctrl", S_IWUSR, mci->debugfs, mci,
> +				    &altr_sdr_mc_debug_inject_fops);
> +}
> +#else
> +static void altr_sdr_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
> +{}
> +#endif
> +
> +/* Get total memory size in bytes */
> +static u32 altr_sdram_get_total_mem_size(struct regmap *mc_vbase)
> +{
> +	u32 size;
> +	u32 read_reg, row, bank, col, cs, width;
> +
> +	if (regmap_read(mc_vbase, DRAMADDRW, &read_reg) < 0)
> +		return 0;
> +
> +	if (regmap_read(mc_vbase, DRAMIFWIDTH, &width) < 0)
> +		return 0;
> +
> +	col = (read_reg & DRAMADDRW_COLBIT_MASK) >>
> +		DRAMADDRW_COLBIT_LSB;
> +	row = (read_reg & DRAMADDRW_ROWBIT_MASK) >>
> +		DRAMADDRW_ROWBIT_LSB;
> +	bank = (read_reg & DRAMADDRW_BANKBIT_MASK) >>
> +		DRAMADDRW_BANKBIT_LSB;
> +	cs = (read_reg & DRAMADDRW_CSBIT_MASK) >>
> +		DRAMADDRW_CSBIT_LSB;
> +
> +	/* Correct for ECC as its not addressible */
> +	if (width == DRAMIFWIDTH_32B_ECC)
> +		width = 32;
> +	if (width == DRAMIFWIDTH_16B_ECC)
> +		width = 16;
> +
> +	/* calculate the SDRAM size base on this info */
> +	size = 1 << (row + bank + col);
> +	size = size * cs * (width / 8);
> +	return size;
> +}
> +
> +static int altr_sdram_probe(struct platform_device *pdev)
> +{
> +	struct edac_mc_layer layers[2];
> +	struct mem_ctl_info *mci;
> +	struct altr_sdram_mc_data *drvdata;
> +	struct regmap *mc_vbase;
> +	struct dimm_info *dimm;
> +	u32 read_reg, mem_size;
> +	int irq;
> +	int res = 0;
> +
> +	/* Validate the SDRAM controller has ECC enabled */
> +	/* Grab the register values from the sdr-ctl in device tree */
> +	mc_vbase = syscon_regmap_lookup_by_compatible("altr,sdr-ctl");
> +	if (IS_ERR(mc_vbase)) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "regmap for altr,sdr-ctl lookup failed.\n");
> +		return -ENODEV;
> +	}
> +
> +	if (regmap_read(mc_vbase, CTLCFG, &read_reg) ||
> +	    ((read_reg & CTLCFG_ECC_AUTO_EN) !=	CTLCFG_ECC_AUTO_EN)) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "No ECC/ECC disabled [0x%08X]\n", read_reg);
> +		return -ENODEV;
> +	}
> +
> +	/* Grab memory size from device tree. */
> +	mem_size = altr_sdram_get_total_mem_size(mc_vbase);
> +	if (mem_size <= 0) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "Unable to calculate memory size\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Ensure the SDRAM Interrupt is disabled and cleared */
> +	if (regmap_write(mc_vbase, DRAMINTR, DRAMINTR_INTRCLR)) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "Error clearing SDRAM ECC IRQ\n");
> +		return -ENODEV;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "No irq %d in DT\n", irq);
> +		return -ENODEV;
> +	}
> +
> +	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> +	layers[0].size = 1;
> +	layers[0].is_virt_csrow = true;
> +	layers[1].type = EDAC_MC_LAYER_CHANNEL;
> +	layers[1].size = 1;
> +	layers[1].is_virt_csrow = false;
> +	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
> +			    sizeof(struct altr_sdram_mc_data));
> +	if (!mci)
> +		return -ENOMEM;
> +
> +	mci->pdev = &pdev->dev;
> +	drvdata = mci->pvt_info;
> +	drvdata->mc_vbase = mc_vbase;
> +	platform_set_drvdata(pdev, mci);
> +
> +	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {
> +		res = -ENOMEM;
> +		goto free;
> +	}
> +
> +	mci->mtype_cap = MEM_FLAG_DDR3;
> +	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
> +	mci->edac_cap = EDAC_FLAG_SECDED;
> +	mci->mod_name = EDAC_MOD_STR;
> +	mci->mod_ver = EDAC_VERSION;
> +	mci->ctl_name = dev_name(&pdev->dev);
> +	mci->scrub_mode = SCRUB_SW_SRC;
> +	mci->dev_name = dev_name(&pdev->dev);
> +
> +	dimm = *mci->dimms;
> +	dimm->nr_pages = ((mem_size - 1) >> PAGE_SHIFT) + 1;
> +	dimm->grain = 8;
> +	dimm->dtype = DEV_X8;
> +	dimm->mtype = MEM_DDR3;
> +	dimm->edac_mode = EDAC_SECDED;
> +
> +	res = edac_mc_add_mc(mci);
> +	if (res < 0)
> +		goto err;
> +
> +	res = devm_request_irq(&pdev->dev, irq, altr_sdram_mc_err_handler,
> +			       0, dev_name(&pdev->dev), mci);
> +	if (res < 0) {
> +		edac_mc_printk(mci, KERN_ERR,
> +			       "Unable to request irq %d\n", irq);
> +		res = -ENODEV;
> +		goto err2;
> +	}
> +
> +	if (regmap_write(drvdata->mc_vbase, DRAMINTR,
> +			 (DRAMINTR_INTRCLR | DRAMINTR_INTREN))) {
> +		edac_mc_printk(mci, KERN_ERR,
> +			       "Error enabling SDRAM ECC IRQ\n");
> +		res = -ENODEV;
> +		goto err2;
> +	}
> +
> +	altr_sdr_mc_create_debugfs_nodes(mci);
> +
> +	devres_close_group(&pdev->dev, NULL);
> +
> +	return 0;
> +
> +err2er altr_sdram_edac_driver = {
> +	.probe = altr_sdram_probe,
> +	.remove = altr_sdram_remove,
> +	.driver = {
> +		.name = "altr_sdram_edac",
> +		.of_match_table = of_match_ptr(altr_sdram_ctrl_of_match),
I don't think you need of_match_ptr here for this platform as SOCFPGA is
only a DT platform. All that of_match_ptr() does for a CONFIG_OF platform
is just return the pointer.

Dinh
> +	},
> +};
> +
> +module_platform_driver(altr_sdram_edac_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Altera Corporation");
> +MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");

