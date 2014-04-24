Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbaDXOES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:04:18 -0400
Received: from [157.56.111.140] ([157.56.111.140]:35702 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753204AbaDXOEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:04:14 -0400
Message-ID: <1398348486.17357.20.camel@dinh-ubuntu>
Subject: Re: [PATCHv2 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
From: Thor Thayer <tthayer@altera.com>
To: Borislav Petkov <bp@alien8.de>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>,
        <tthayer.linux@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 24 Apr 2014 09:08:06 -0500
In-Reply-To: <20140423145436.GC25378@pd.tnic>
References: <1397604610-20931-1-git-send-email-tthayer@altera.com>
	 <1397604610-20931-5-git-send-email-tthayer@altera.com>
	 <20140423145436.GC25378@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(51704005)(377424004)(52044002)(22564002)(24454002)(44976005)(84676001)(88136002)(77156001)(80976001)(19580395003)(87936001)(31966008)(50466002)(83322001)(19580405001)(76482001)(81342001)(42186004)(81542001)(23676002)(6806004)(80022001)(50226001)(4396001)(85852003)(83072002)(74662001)(92566001)(92726001)(93916002)(99396002)(2009001)(74502001)(33646001)(33716001)(16796002)(87286001)(89996001)(97736001)(77982001)(47776003)(46102001)(20776003)(79102001)(62966002)(86362001)(50986999)(76176999)(2004002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11HUB029;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E08DDDC9.97FA9181.7DF56E47.EC4BB71.20835;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01917B1794
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 16:54 +0200, Borislav Petkov wrote:
> On Tue, Apr 15, 2014 at 06:30:10PM -0500, tthayer@altera.com wrote:
> > From: Thor Thayer <tthayer@altera.com>
> > 
> > Added EDAC support for reporting ECC errors of CycloneV
> > and ArriaV SDRAM controller.
> > - The SDRAM Controller registers are used by the FPGA bridge so
> >   these are accessed through the syscon interface.
> > - The configuration of the SDRAM memory size for the EDAC framework
> >   is discovered from the SDRAM Controller registers.
> > - Documentation of the bindings in devicetree/bindings/arm/altera/
> >   socfpga-sdram-edac.txt
> > - Correction of single bit errors, detection of double bit errors.
> > 
> > ---
> > v2: Use the SDRAM controller registers to calculate memory size
> >     instead of the Device Tree. Update To & Cc list. Add maintainer 
> >     information.
> > 
> > Signed-off-by: Thor Thayer <tthayer@altera.com>

[snip]

> > @@ -0,0 +1,393 @@
> > +/*
> > + *  Copyright Altera Corporation (C) 2014. All rights reserved.
> > + *  Copyright 2011-2012 Calxeda, Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> 
> Please drop this boilerplate and point to COPYING in a single sentence
> stating that it is licensed under GPLv2.

Thank you for reviewing. This is the only review item that may be a
problem. 

> > + *
> > + * Adapted from the highbank_mc_edac driver
> > + *
> > + */
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/ctype.h>
> > +#include <linux/edac.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/regmap.h>
> > +
> > +#include "edac_core.h"
> > +#include "edac_module.h"
> > +
> > +#define ALTR_EDAC_MOD_STR	"altera_edac"
> 
> and yet the filename is called altera_mc_edac.c. Please change it to
> altera_edac.c too.
> 
> > +
> > +/* SDRAM Controller CtrlCfg Register */

[snip]

> > +
> > +/* SDRAM Controller ECC AutoCorrect Error Address Register Bit Masks */
> > +#define ALTR_SDR_DROPADDR_MASK		0xFFFFFFFF
> 
> Right, those defines are pefectly fine 'n all but they're used only
> here, in thie file locally. So you probably could drop this "ALTR_SDR_"
> prefix and thus make them substantially shorter and as a result, the
> code more readable. It'll also shorten the code below, for example:
> 
> > +	regmap_write(drvdata->mc_vbase,	ALTR_SDR_DRAMINTR,
> > +		     (ALTR_SDR_DRAMINTR_INTRCLR | ALTR_SDR_DRAMINTR_INTREN));
> 
> would become
> 
> 
> 	regmap_write(drvdata->mc_vbase,	DRAMINTR, (DRAMINTR_INTRCLR |
> 						   DRAMINTR_INTREN));
> 
> which one can read even with one eye opened. :-)
> 

Noted. I will make the change. Thanks.

> > +
> > +/* Altera SDRAM Memory Controller data */
> > +struct altr_sdram_mc_data {
> > +	struct regmap *mc_vbase;
> > +};
> > +
> > +static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
> > +{
> > +	struct mem_ctl_info *mci = dev_id;
> > +	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
> > +	u32 status = 0, err_count = 0, err_addr = 0;
> > +
> > +	/* Error Address is shared by both SBE & DBE */
> > +	regmap_read(drvdata->mc_vbase, ALTR_SDR_ERRADDR, &err_addr);
> > +
> > +	regmap_read(drvdata->mc_vbase, ALTR_SDR_DRAMSTS, &status);
> > +
> > +	if (status & ALTR_SDR_DRAMSTS_DBEERR) {
> > +		regmap_read(drvdata->mc_vbase, ALTR_SDR_DBECOUNT, &err_count);
> > +		panic("\nEDAC: [%d Uncorrectable errors @ 0x%08X]\n",
> > +		      err_count, err_addr);
> > +	}
> 
> Right, ok, I guess you know what you're doing here. I'm guessing there's
> no more graceful recovery than panic when encountering UEs on this
> platform...
> 

The concern is that we could execute invalid instructions. I noticed the
'edac_mc_panic_on_ue' module parameter but wanted this to be obvious. I
will revisit the module parameter though. Thank you.

> > +	if (status & ALTR_SDR_DRAMSTS_SBEERR) {
> > +		regmap_read(drvdata->mc_vbase, ALTR_SDR_SBECOUNT, &err_count);
> > +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,
> > +				     err_addr >> PAGE_SHIFT,
> > +				     err_addr & ~PAGE_MASK, 0,
> > +				     0, 0, -1, mci->ctl_name, "");
> > +	}
> > +
> > +	regmap_write(drvdata->mc_vbase,	ALTR_SDR_DRAMINTR,
> > +		     (ALTR_SDR_DRAMINTR_INTRCLR | ALTR_SDR_DRAMINTR_INTREN));
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +#ifdef CONFIG_EDAC_DEBUG
> > +static ssize_t altr_sdr_mc_err_inject_write(struct file *file,
> > +					const char __user *data,
> > +					size_t count, loff_t *ppos)
> > +{
> 
> arg alignment.
> 
Noted.
> > +	struct mem_ctl_info *mci = file->private_data;
> > +	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
> > +	u32 *ptemp;
> > +	dma_addr_t dma_handle;
> > +	u32 reg, read_reg = 0;
> > +
> > +	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
> > +	if (IS_ERR(ptemp)) {
> > +		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
> > +		dev_err(mci->pdev, "**EDAC Inject: Buffer Allocation error\n");
> 
> We have our own edac_*_printk... Feel free to adjust them if they don't
> do exactly what you want them to do.
> 
Noted. Thanks.
> > +		return -ENOMEM;
> > +	}
> > +
> > +	regmap_read(drvdata->mc_vbase, ALTR_SDR_CTLCFG, &read_reg);
> > +	read_reg &= ~(ALTR_SDR_CTLCFG_GEN_SB_ERR | ALTR_SDR_CTLCFG_GEN_DB_ERR);
> > +
> > +	if (count == 3) {
> > +		dev_alert(mci->pdev, "** EDAC Inject Double bit error\n");
> > +		regmap_write(drvdata->mc_vbase, ALTR_SDR_CTLCFG,
> > +			     (read_reg | ALTR_SDR_CTLCFG_GEN_DB_ERR));
> > +	} else {
> > +		dev_alert(mci->pdev, "** EDAC Inject Single bit error\n");
> > +		regmap_write(drvdata->mc_vbase,	ALTR_SDR_CTLCFG,
> > +			     (read_reg | ALTR_SDR_CTLCFG_GEN_SB_ERR));
> > +	}
> > +
> > +	ptemp[0] = 0x5A5A5A5A;
> > +	ptemp[1] = 0xA5A5A5A5;
> > +	regmap_write(drvdata->mc_vbase,	ALTR_SDR_CTLCFG, read_reg);
> > +	/* Ensure it has been written out */
> > +	wmb();
> > +
> > +	reg = ptemp[0];
> > +	read_reg = ptemp[1];
> 
> Those two assignments to local variables seem useless.
> 

This does seem useless but there is a reason.  A word containing 1 or 2
bit error is written out to memory and then this read from memory will
trigger the error condition.

> > +
> > +	dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
> > +
> > +	return count;
> > +}
> > +

[snip]

> > +/* Get total memory size in bytes */
> > +static u32 altr_sdram_get_total_mem_size(struct regmap *mc_vbase)
> > +{
> > +	u32 size;
> > +	u32 read_reg, row, bank, col, cs, width;
> > +	u32 retcode;
> > +
> > +	retcode = regmap_read(mc_vbase, ALTR_SDR_DRAMADDRW, &read_reg);
> > +	if (retcode < 0)
> > +		return 0;
> 
> It seems like you're using this retcode only once here. Either remove
> it like in the second regmap_read() call below or use it consistently
> throughout this function.
> 
Noted. I will make this change. I found a number of other places as
well. Thanks.
> > +
> > +	col = (read_reg & ALTR_SDR_DRAMADDRW_COLBIT_MASK) >>
> > +		ALTR_SDR_DRAMADDRW_COLBIT_LSB;
> > +	row = (read_reg & ALTR_SDR_DRAMADDRW_ROWBIT_MASK) >>
> > +		ALTR_SDR_DRAMADDRW_ROWBIT_LSB;
> > +	bank = (read_reg & ALTR_SDR_DRAMADDRW_BANKBIT_MASK) >>
> > +		ALTR_SDR_DRAMADDRW_BANKBIT_LSB;
> > +	cs = (read_reg & ALTR_SDR_DRAMADDRW_CSBIT_MASK) >>
> > +		ALTR_SDR_DRAMADDRW_CSBIT_LSB;
> > +
> > +	if (regmap_read(mc_vbase, ALTR_SDR_DRAMIFWIDTH, &width) < 0)
> > +		return 0;
> 
> You probably should do those regmap_read()s first, before you do all the
> assignments so that you can save yourself the work if one of the reads
> fails and you need to return.
> 
Noted.

> > +
> > +	/* Correct for ECC as its not addressible */
> > +	if (width == ALTR_SDR_DRAMIFWIDTH_32B_ECC)
> > +		width = 32;
> > +	if (width == ALTR_SDR_DRAMIFWIDTH_16B_ECC)
> > +		width = 16;
> > +
> > +	/* calculate the SDRAM size base on this info */
> > +	size = 1 << (row + bank + col);
> > +	size = size * cs * (width / 8);
> > +	return size;
> > +}
> > +
> > +static int altr_sdram_mc_probe(struct platform_device *pdev)
> > +{
> > +	struct edac_mc_layer layers[2];
> > +	struct mem_ctl_info *mci;
> > +	struct altr_sdram_mc_data *drvdata;
> > +	struct dimm_info *dimm;
> > +	u32 read_reg, mem_size;
> > +	int irq;
> > +	int res = 0, retcode;
> > +
> > +	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> > +	layers[0].size = 1;
> > +	layers[0].is_virt_csrow = true;
> > +	layers[1].type = EDAC_MC_LAYER_CHANNEL;
> > +	layers[1].size = 1;
> > +	layers[1].is_virt_csrow = false;
> > +	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
> > +			    sizeof(struct altr_sdram_mc_data));
> > +	if (!mci)
> > +		return -ENOMEM;
> > +
> > +	mci->pdev = &pdev->dev;
> > +	drvdata = mci->pvt_info;
> > +	platform_set_drvdata(pdev, mci);
> > +
> > +	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {
> 
> goto free;
> 
> and add a label which does edac_mc_free.
> 

Noted.

> > +		edac_mc_free(mci);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* Grab the register values from the sdr-ctl in device tree */
> > +	drvdata->mc_vbase = syscon_regmap_lookup_by_compatible("altr,sdr-ctl");
> > +	if (IS_ERR(drvdata->mc_vbase)) {
> > +		dev_err(&pdev->dev,
> > +			"regmap for altr,sdr-ctl lookup failed.\n");
> 
> edac_*_printk.
> 
> 
> > +		res = -ENODEV;
> > +		goto err;
> > +	}
> > +
> > +	retcode = regmap_read(drvdata->mc_vbase, ALTR_SDR_CTLCFG, &read_reg);
> > +	if (retcode || ((read_reg & ALTR_SDR_CTLCFG_ECC_AUTO_EN) !=
> > +		ALTR_SDR_CTLCFG_ECC_AUTO_EN)) {
> > +		dev_err(&pdev->dev, "No ECC present / ECC disabled - 0x%08X\n",
> > +			read_reg);
> 
> ditto.
> 
> > +		res = -ENODEV;
> > +		goto err;
> > +	}
> > +
> > +	mci->mtype_cap = MEM_FLAG_DDR3;
> > +	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
> > +	mci->edac_cap = EDAC_FLAG_SECDED;
> > +	mci->mod_name = ALTR_EDAC_MOD_STR;
> 
> Calling it just EDAC_MOD_STR is fine.
> 
> > +	mci->mod_ver = "1";
> 
> use a #define.
> 

Noted.

> > +	mci->ctl_name = dev_name(&pdev->dev);
> > +	mci->scrub_mode = SCRUB_SW_SRC;
> > +	mci->dev_name = dev_name(&pdev->dev);
> > +
> > +	/* Grab memory size from device tree. */
> > +	mem_size = altr_sdram_get_total_mem_size(drvdata->mc_vbase);
> > +	dimm = *mci->dimms;
> > +	if (mem_size <= 0) {
> > +		dev_err(&pdev->dev, "Unable to calculate memory size\n");
> > +		res = -ENODEV;
> > +		goto err;
> > +	}
> > +	dimm->nr_pages = ((mem_size - 1) >> PAGE_SHIFT) + 1;
> > +	dimm->grain = 8;
> > +	dimm->dtype = DEV_X8;
> > +	dimm->mtype = MEM_DDR3;
> > +	dimm->edac_mode = EDAC_SECDED;
> > +
> > +	res = edac_mc_add_mc(mci);
> > +	if (res < 0)
> > +		goto err;
> > +
> > +	retcode = regmap_write(drvdata->mc_vbase, ALTR_SDR_DRAMINTR,
> > +			ALTR_SDR_DRAMINTR_INTRCLR);
> > +	if (retcode) {
> > +		dev_err(&pdev->dev, "Error clearing SDRAM ECC IRQ\n");
> > +		res = -ENODEV;
> > +		goto err;
> > +	}
> > +
> > +	irq = platform_get_irq(pdev, 0);
> > +	res = devm_request_irq(&pdev->dev, irq, altr_sdram_mc_err_handler,
> > +				0, dev_name(&pdev->dev), mci);
> > +	if (res < 0) {
> > +		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
> > +		res = -ENODEV;
> > +		goto err;
> > +	}
> > +
> > +	retcode = regmap_write(drvdata->mc_vbase, ALTR_SDR_DRAMINTR,
> > +		(ALTR_SDR_DRAMINTR_INTRCLR | ALTR_SDR_DRAMINTR_INTREN));
> > +	if (retcode) {
> > +		dev_err(&pdev->dev, "Error enabling SDRAM ECC IRQ\n");
> > +		res = -ENODEV;
> > +		goto err2;
> > +	}
> 
> Btw, you might want to restructure this function to do all your regmap
> stuff, total memsize and other platform queries and once those succeed,
> only then do edac_mc_alloc, edac_mc_add_mc, etc. This should save you a
> lot of unwinding work in the error path.
> 

Hi Boris,

Thank you for reviewing and I'll make your changes. I will need to check
on the file header licensing change because our contributions are
dictated by our corporate policy.

Thor
