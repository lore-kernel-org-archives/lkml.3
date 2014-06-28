Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaF1RIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:08:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44481 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaF1RIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:08:21 -0400
Date: Sat, 28 Jun 2014 19:08:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tthayer@altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tthayer.linux@gmail.com
Subject: Re: [PATCHv8 3/3] edac: altera: Add Altera SDRAM Controller EDAC
 support.
Message-ID: <20140628170812.GE23634@xo-6d-61-c0.localdomain>
References: <1403882819-24929-1-git-send-email-tthayer@altera.com>
 <1403882819-24929-4-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403882819-24929-4-git-send-email-tthayer@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> --- /dev/null
> +++ b/drivers/edac/altera_edac.c
> @@ -0,0 +1,449 @@
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

Delete the empty line.

> + * Adapted from the highbank_mc_edac driver
> + *
> + */

Probably delete the line with single star, append "." after "driver"?


> +/* SDRAM Controller Address Widths Field Register */
> +#define DRAMADDRW_COLBIT_MASK	0x001F
> +#define DRAMADDRW_COLBIT_LSB	0
> +#define DRAMADDRW_ROWBIT_MASK	0x03E0
> +#define DRAMADDRW_ROWBIT_LSB	5
> +#define DRAMADDRW_BANKBIT_MASK	0x1C00
> +#define DRAMADDRW_BANKBIT_LSB	10
> +#define DRAMADDRW_CSBIT_MASK	0xE000
> +#define DRAMADDRW_CSBIT_LSB	13

These defines make it harder to read, not easier. See below...

> +/* SDRAM Controller ECC AutoCorrect Error Address Register Bit Masks */
> +#define DROPADDR_MASK		0xFFFFFFFF

I'm not sure such mask is useful.

> +static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
> +{
> +	struct mem_ctl_info *mci = dev_id;
> +	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
> +	u32 status, err_count, err_addr;
> +
> +	/* Error Address is shared by both SBE & DBE */
> +	err_addr = readl(drvdata->mc_vecc_regs + ERRADDR);
> +
> +	status = readl(drvdata->mc_vecc_regs + DRAMSTS);
> +
> +	if (status & DRAMSTS_DBEERR) {
> +		err_count = readl(drvdata->mc_vecc_regs + DBECOUNT);
> +		panic("\nEDAC: [%d Uncorrectable errors @ 0x%08X]\n",
> +		      err_count, err_addr);
> +	}

Get rid of leading \n?

> +#ifdef CONFIG_EDAC_DEBUG
> +static ssize_t altr_sdr_mc_err_inject_write(struct file *file,
> +					    const char __user *data,
> +					    size_t count, loff_t *ppos)
> +{
> +	struct mem_ctl_info *mci = file->private_data;
> +	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
> +	u32 *ptemp;
> +	dma_addr_t dma_handle;
> +	u32 reg, read_reg;
> +
> +	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
> +	if (IS_ERR(ptemp)) {
> +		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "Inject: Buffer Allocation error\n");
> +		return -ENOMEM;
> +	}
> +
> +	regmap_read(drvdata->mc_vconfig, CTLCFG, &read_reg);
> +	read_reg &= ~(CTLCFG_GEN_SB_ERR | CTLCFG_GEN_DB_ERR);
> +
> +	if (count == 3) {
> +		dev_alert(mci->pdev, "EDAC Inject Double bit error\n");
> +		regmap_write(drvdata->mc_vconfig, CTLCFG,
> +			     (read_reg | CTLCFG_GEN_DB_ERR));
> +	} else {
> +		dev_alert(mci->pdev, "EDAC Inject Single bit error\n");
> +		regmap_write(drvdata->mc_vconfig,	CTLCFG,
> +			     (read_reg | CTLCFG_GEN_SB_ERR));
> +	}
> +
> +	ptemp[0] = 0x5A5A5A5A;
> +	ptemp[1] = 0xA5A5A5A5;
> +	/* Clear the error injection bits */
> +	regmap_write(drvdata->mc_vconfig, CTLCFG, read_reg);
> +	/* Ensure it has been written out */
> +	wmb();
> +
> +	/*
> +	 * To trigger the error, we need to read the data back
> +	 * (the data was written with errors above)
> +	 * The ACCESS_ONCE macros are used to prevent the
> +	 * compiler optimizing these reads out.
> +	 */
> +	reg = ACCESS_ONCE(ptemp[0]);
> +	read_reg = ACCESS_ONCE(ptemp[1]);
> +	/* Force Read */
> +	rmb();
> +
> +	edac_printk(KERN_ALERT, EDAC_MC, "Read Data [0x%X, 0x%X]\n",
> +		    reg, read_reg);
> +
> +	dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);

I don't get it. Neither the ptemp nor dma_handle are really used. Is that ok?

Would it be worth commenting what is going on?

> +	col = (read_reg & DRAMADDRW_COLBIT_MASK) >>
> +		DRAMADDRW_COLBIT_LSB;
> +	row = (read_reg & DRAMADDRW_ROWBIT_MASK) >>
> +		DRAMADDRW_ROWBIT_LSB;
> +	bank = (read_reg & DRAMADDRW_BANKBIT_MASK) >>
> +		DRAMADDRW_BANKBIT_LSB;
> +	cs = (read_reg & DRAMADDRW_CSBIT_MASK) >>
> +		DRAMADDRW_CSBIT_LSB;

This code would be pretty logical, but the defines mask what is going on, force you to
split the multilines, and if you got them wrong, it is now impossible to find out.

I'd suggest just opencoding the masks/shifts.

Otherwise

Acked-by: Pavel Machek <pavel@ucw.cz>

THanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
