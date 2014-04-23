Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbaDWOys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:54:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39635 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbaDWOym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:54:42 -0400
Date: Wed, 23 Apr 2014 16:54:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: tthayer@altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, tthayer.linux@gmail.com,
        devicetree@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
Message-ID: <20140423145436.GC25378@pd.tnic>
References: <1397604610-20931-1-git-send-email-tthayer@altera.com>
 <1397604610-20931-5-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397604610-20931-5-git-send-email-tthayer@altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 06:30:10PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Added EDAC support for reporting ECC errors of CycloneV
> and ArriaV SDRAM controller.
> - The SDRAM Controller registers are used by the FPGA bridge so
>   these are accessed through the syscon interface.
> - The configuration of the SDRAM memory size for the EDAC framework
>   is discovered from the SDRAM Controller registers.
> - Documentation of the bindings in devicetree/bindings/arm/altera/
>   socfpga-sdram-edac.txt
> - Correction of single bit errors, detection of double bit errors.
> 
> ---
> v2: Use the SDRAM controller registers to calculate memory size
>     instead of the Device Tree. Update To & Cc list. Add maintainer 
>     information.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> To: Rob Herring <robherring2@gmail.com>
> To: Doug Thompson <dougthompson@xmission.com>
> To: Grant Likely <grant.likely@linaro.org>
> To: Pawel Moll <pawel.moll@arm.com>
> To: Mark Rutland <mark.rutland@arm.com>
> To: Ian Campbell <ijc+devicetree@hellion.org.uk>
> To: Kumar Gala <galak@codeaurora.org>
> To: Rob Landley <rob@landley.net>
> To: Russell King <linux@arm.linux.org.uk>
> To: Dinh Nguyen <dinguyen@altera.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: devicetree@vger.kernel.org
> Cc: linux-edac@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  MAINTAINERS                   |    5 +
>  drivers/edac/Kconfig          |    9 +
>  drivers/edac/Makefile         |    2 +
>  drivers/edac/altera_mc_edac.c |  393 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 409 insertions(+)
>  create mode 100644 drivers/edac/altera_mc_edac.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b8af16d..aee0746 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1249,6 +1249,11 @@ M:	Dinh Nguyen <dinguyen@altera.com>
>  S:	Maintained
>  F:	drivers/clk/socfpga/
>  
> +ARM/SOCFPGA SDRAM EDAC SUPPORT
> +M:	Thor Thayer <tthayer@altera.com>
> +S:	Maintained
> +F:	drivers/edac/altera_mc_edac.c
> +
>  ARM/STI ARCHITECTURE
>  M:	Srinivas Kandagatla <srinivas.kandagatla@st.com>
>  M:	Stuart Menefy <stuart.menefy@st.com>
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
> index 4154ed6..e15d05f 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
>  obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>  obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>  obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
> +
> +obj-$(CONFIG_EDAC_ALTERA_MC)	        += altera_mc_edac.o
> diff --git a/drivers/edac/altera_mc_edac.c b/drivers/edac/altera_mc_edac.c
> new file mode 100644
> index 0000000..811b712
> --- /dev/null
> +++ b/drivers/edac/altera_mc_edac.c
> @@ -0,0 +1,393 @@
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
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.

Please drop this boilerplate and point to COPYING in a single sentence
stating that it is licensed under GPLv2.

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
> +#define ALTR_EDAC_MOD_STR	"altera_edac"

and yet the filename is called altera_mc_edac.c. Please change it to
altera_edac.c too.

> +
> +/* SDRAM Controller CtrlCfg Register */
> +#define ALTR_SDR_CTLCFG			0x00
> +
> +/* SDRAM Controller CtrlCfg Register Bit Masks */
> +#define ALTR_SDR_CTLCFG_ECC_EN		0x400
> +#define ALTR_SDR_CTLCFG_ECC_CORR_EN	0x800
> +#define ALTR_SDR_CTLCFG_GEN_SB_ERR	0x2000
> +#define ALTR_SDR_CTLCFG_GEN_DB_ERR	0x4000
> +
> +#define ALTR_SDR_CTLCFG_ECC_AUTO_EN	(ALTR_SDR_CTLCFG_ECC_EN | \
> +					ALTR_SDR_CTLCFG_ECC_CORR_EN)
> +
> +/* SDRAM Controller Address Width Register */
> +#define ALTR_SDR_DRAMADDRW		0x2C
> +
> +/* SDRAM Controller Address Widths Field Register */
> +#define ALTR_SDR_DRAMADDRW_COLBIT_MASK	0x001F
> +#define ALTR_SDR_DRAMADDRW_COLBIT_LSB	0
> +#define ALTR_SDR_DRAMADDRW_ROWBIT_MASK	0x03E0
> +#define ALTR_SDR_DRAMADDRW_ROWBIT_LSB	5
> +#define ALTR_SDR_DRAMADDRW_BANKBIT_MASK	0x1C00
> +#define ALTR_SDR_DRAMADDRW_BANKBIT_LSB	10
> +#define ALTR_SDR_DRAMADDRW_CSBIT_MASK	0xE000
> +#define ALTR_SDR_DRAMADDRW_CSBIT_LSB	13
> +
> +/* SDRAM Controller Interface Data Width Register */
> +#define ALTR_SDR_DRAMIFWIDTH		0x30
> +
> +/* SDRAM Controller Interface Data Width Defines */
> +#define ALTR_SDR_DRAMIFWIDTH_16B_ECC	24
> +#define ALTR_SDR_DRAMIFWIDTH_32B_ECC	40
> +
> +/* SDRAM Controller DRAM Status Register */
> +#define ALTR_SDR_DRAMSTS		0x38
> +
> +/* SDRAM Controller DRAM Status Register Bit Masks */
> +#define ALTR_SDR_DRAMSTS_SBEERR		0x04
> +#define ALTR_SDR_DRAMSTS_DBEERR		0x08
> +#define ALTR_SDR_DRAMSTS_CORR_DROP	0x10
> +
> +/* SDRAM Controller DRAM IRQ Register */
> +#define ALTR_SDR_DRAMINTR		0x3C
> +
> +/* SDRAM Controller DRAM IRQ Register Bit Masks */
> +#define ALTR_SDR_DRAMINTR_INTREN	0x01
> +#define ALTR_SDR_DRAMINTR_SBEMASK	0x02
> +#define ALTR_SDR_DRAMINTR_DBEMASK	0x04
> +#define ALTR_SDR_DRAMINTR_CORRDROPMASK	0x08
> +#define ALTR_SDR_DRAMINTR_INTRCLR	0x10
> +
> +/* SDRAM Controller Single Bit Error Count Register */
> +#define ALTR_SDR_SBECOUNT		0x40
> +
> +/* SDRAM Controller Single Bit Error Count Register Bit Masks */
> +#define ALTR_SDR_SBECOUNT_MASK		0x0F
> +
> +/* SDRAM Controller Double Bit Error Count Register */
> +#define ALTR_SDR_DBECOUNT		0x44
> +
> +/* SDRAM Controller Double Bit Error Count Register Bit Masks */
> +#define ALTR_SDR_DBECOUNT_MASK		0x0F
> +
> +/* SDRAM Controller ECC Error Address Register */
> +#define ALTR_SDR_ERRADDR		0x48
> +
> +/* SDRAM Controller ECC Error Address Register Bit Masks */
> +#define ALTR_SDR_ERRADDR_MASK		0xFFFFFFFF
> +
> +/* SDRAM Controller ECC Autocorrect Drop Count Register */
> +#define ALTR_SDR_DROPCOUNT		0x4C
> +
> +/* SDRAM Controller ECC Autocorrect Drop Count Register Bit Masks */
> +#define ALTR_SDR_DROPCOUNT_MASK		0x0F
> +
> +/* SDRAM Controller ECC AutoCorrect Address Register */
> +#define ALTR_SDR_DROPADDR		0x50
> +
> +/* SDRAM Controller ECC AutoCorrect Error Address Register Bit Masks */
> +#define ALTR_SDR_DROPADDR_MASK		0xFFFFFFFF

Right, those defines are pefectly fine 'n all but they're used only
here, in thie file locally. So you probably could drop this "ALTR_SDR_"
prefix and thus make them substantially shorter and as a result, the
code more readable. It'll also shorten the code below, for example:

> +	regmap_write(drvdata->mc_vbase,	ALTR_SDR_DRAMINTR,
> +		     (ALTR_SDR_DRAMINTR_INTRCLR | ALTR_SDR_DRAMINTR_INTREN));

would become


	regmap_write(drvdata->mc_vbase,	DRAMINTR, (DRAMINTR_INTRCLR |
						   DRAMINTR_INTREN));

which one can read even with one eye opened. :-)

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
> +	regmap_read(drvdata->mc_vbase, ALTR_SDR_ERRADDR, &err_addr);
> +
> +	regmap_read(drvdata->mc_vbase, ALTR_SDR_DRAMSTS, &status);
> +
> +	if (status & ALTR_SDR_DRAMSTS_DBEERR) {
> +		regmap_read(drvdata->mc_vbase, ALTR_SDR_DBECOUNT, &err_count);
> +		panic("\nEDAC: [%d Uncorrectable errors @ 0x%08X]\n",
> +		      err_count, err_addr);
> +	}

Right, ok, I guess you know what you're doing here. I'm guessing there's
no more graceful recovery than panic when encountering UEs on this
platform...

> +	if (status & ALTR_SDR_DRAMSTS_SBEERR) {
> +		regmap_read(drvdata->mc_vbase, ALTR_SDR_SBECOUNT, &err_count);
> +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,
> +				     err_addr >> PAGE_SHIFT,
> +				     err_addr & ~PAGE_MASK, 0,
> +				     0, 0, -1, mci->ctl_name, "");
> +	}
> +
> +	regmap_write(drvdata->mc_vbase,	ALTR_SDR_DRAMINTR,
> +		     (ALTR_SDR_DRAMINTR_INTRCLR | ALTR_SDR_DRAMINTR_INTREN));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +#ifdef CONFIG_EDAC_DEBUG
> +static ssize_t altr_sdr_mc_err_inject_write(struct file *file,
> +					const char __user *data,
> +					size_t count, loff_t *ppos)
> +{

arg alignment.

> +	struct mem_ctl_info *mci = file->private_data;
> +	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
> +	u32 *ptemp;
> +	dma_addr_t dma_handle;
> +	u32 reg, read_reg = 0;
> +
> +	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
> +	if (IS_ERR(ptemp)) {
> +		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
> +		dev_err(mci->pdev, "**EDAC Inject: Buffer Allocation error\n");

We have our own edac_*_printk... Feel free to adjust them if they don't
do exactly what you want them to do.

> +		return -ENOMEM;
> +	}
> +
> +	regmap_read(drvdata->mc_vbase, ALTR_SDR_CTLCFG, &read_reg);
> +	read_reg &= ~(ALTR_SDR_CTLCFG_GEN_SB_ERR | ALTR_SDR_CTLCFG_GEN_DB_ERR);
> +
> +	if (count == 3) {
> +		dev_alert(mci->pdev, "** EDAC Inject Double bit error\n");
> +		regmap_write(drvdata->mc_vbase, ALTR_SDR_CTLCFG,
> +			     (read_reg | ALTR_SDR_CTLCFG_GEN_DB_ERR));
> +	} else {
> +		dev_alert(mci->pdev, "** EDAC Inject Single bit error\n");
> +		regmap_write(drvdata->mc_vbase,	ALTR_SDR_CTLCFG,
> +			     (read_reg | ALTR_SDR_CTLCFG_GEN_SB_ERR));
> +	}
> +
> +	ptemp[0] = 0x5A5A5A5A;
> +	ptemp[1] = 0xA5A5A5A5;
> +	regmap_write(drvdata->mc_vbase,	ALTR_SDR_CTLCFG, read_reg);
> +	/* Ensure it has been written out */
> +	wmb();
> +
> +	reg = ptemp[0];
> +	read_reg = ptemp[1];

Those two assignments to local variables seem useless.

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
> +	u32 retcode;
> +
> +	retcode = regmap_read(mc_vbase, ALTR_SDR_DRAMADDRW, &read_reg);
> +	if (retcode < 0)
> +		return 0;

It seems like you're using this retcode only once here. Either remove
it like in the second regmap_read() call below or use it consistently
throughout this function.

> +
> +	col = (read_reg & ALTR_SDR_DRAMADDRW_COLBIT_MASK) >>
> +		ALTR_SDR_DRAMADDRW_COLBIT_LSB;
> +	row = (read_reg & ALTR_SDR_DRAMADDRW_ROWBIT_MASK) >>
> +		ALTR_SDR_DRAMADDRW_ROWBIT_LSB;
> +	bank = (read_reg & ALTR_SDR_DRAMADDRW_BANKBIT_MASK) >>
> +		ALTR_SDR_DRAMADDRW_BANKBIT_LSB;
> +	cs = (read_reg & ALTR_SDR_DRAMADDRW_CSBIT_MASK) >>
> +		ALTR_SDR_DRAMADDRW_CSBIT_LSB;
> +
> +	if (regmap_read(mc_vbase, ALTR_SDR_DRAMIFWIDTH, &width) < 0)
> +		return 0;

You probably should do those regmap_read()s first, before you do all the
assignments so that you can save yourself the work if one of the reads
fails and you need to return.

> +
> +	/* Correct for ECC as its not addressible */
> +	if (width == ALTR_SDR_DRAMIFWIDTH_32B_ECC)
> +		width = 32;
> +	if (width == ALTR_SDR_DRAMIFWIDTH_16B_ECC)
> +		width = 16;
> +
> +	/* calculate the SDRAM size base on this info */
> +	size = 1 << (row + bank + col);
> +	size = size * cs * (width / 8);
> +	return size;
> +}
> +
> +static int altr_sdram_mc_probe(struct platform_device *pdev)
> +{
> +	struct edac_mc_layer layers[2];
> +	struct mem_ctl_info *mci;
> +	struct altr_sdram_mc_data *drvdata;
> +	struct dimm_info *dimm;
> +	u32 read_reg, mem_size;
> +	int irq;
> +	int res = 0, retcode;
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
> +	platform_set_drvdata(pdev, mci);
> +
> +	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {

goto free;

and add a label which does edac_mc_free.

> +		edac_mc_free(mci);
> +		return -ENOMEM;
> +	}
> +
> +	/* Grab the register values from the sdr-ctl in device tree */
> +	drvdata->mc_vbase = syscon_regmap_lookup_by_compatible("altr,sdr-ctl");
> +	if (IS_ERR(drvdata->mc_vbase)) {
> +		dev_err(&pdev->dev,
> +			"regmap for altr,sdr-ctl lookup failed.\n");

edac_*_printk.


> +		res = -ENODEV;
> +		goto err;
> +	}
> +
> +	retcode = regmap_read(drvdata->mc_vbase, ALTR_SDR_CTLCFG, &read_reg);
> +	if (retcode || ((read_reg & ALTR_SDR_CTLCFG_ECC_AUTO_EN) !=
> +		ALTR_SDR_CTLCFG_ECC_AUTO_EN)) {
> +		dev_err(&pdev->dev, "No ECC present / ECC disabled - 0x%08X\n",
> +			read_reg);

ditto.

> +		res = -ENODEV;
> +		goto err;
> +	}
> +
> +	mci->mtype_cap = MEM_FLAG_DDR3;
> +	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
> +	mci->edac_cap = EDAC_FLAG_SECDED;
> +	mci->mod_name = ALTR_EDAC_MOD_STR;

Calling it just EDAC_MOD_STR is fine.

> +	mci->mod_ver = "1";

use a #define.

> +	mci->ctl_name = dev_name(&pdev->dev);
> +	mci->scrub_mode = SCRUB_SW_SRC;
> +	mci->dev_name = dev_name(&pdev->dev);
> +
> +	/* Grab memory size from device tree. */
> +	mem_size = altr_sdram_get_total_mem_size(drvdata->mc_vbase);
> +	dimm = *mci->dimms;
> +	if (mem_size <= 0) {
> +		dev_err(&pdev->dev, "Unable to calculate memory size\n");
> +		res = -ENODEV;
> +		goto err;
> +	}
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
> +	retcode = regmap_write(drvdata->mc_vbase, ALTR_SDR_DRAMINTR,
> +			ALTR_SDR_DRAMINTR_INTRCLR);
> +	if (retcode) {
> +		dev_err(&pdev->dev, "Error clearing SDRAM ECC IRQ\n");
> +		res = -ENODEV;
> +		goto err;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	res = devm_request_irq(&pdev->dev, irq, altr_sdram_mc_err_handler,
> +				0, dev_name(&pdev->dev), mci);
> +	if (res < 0) {
> +		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
> +		res = -ENODEV;
> +		goto err;
> +	}
> +
> +	retcode = regmap_write(drvdata->mc_vbase, ALTR_SDR_DRAMINTR,
> +		(ALTR_SDR_DRAMINTR_INTRCLR | ALTR_SDR_DRAMINTR_INTREN));
> +	if (retcode) {
> +		dev_err(&pdev->dev, "Error enabling SDRAM ECC IRQ\n");
> +		res = -ENODEV;
> +		goto err2;
> +	}

Btw, you might want to restructure this function to do all your regmap
stuff, total memsize and other platform queries and once those succeed,
only then do edac_mc_alloc, edac_mc_add_mc, etc. This should save you a
lot of unwinding work in the error path.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
