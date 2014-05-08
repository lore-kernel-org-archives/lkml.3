Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaEHMFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:05:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50751 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaEHMFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:05:33 -0400
Date: Thu, 8 May 2014 14:05:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: tthayer@altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tthayer.linux@gmail.com
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
Message-ID: <20140508120524.GF12548@pd.tnic>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
 <1399330337-16748-4-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399330337-16748-4-git-send-email-tthayer@altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 05:52:17PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>

Missing commit message.

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

I'm guessing your lawyers want this boilerplate after all?

...

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

So, are we setting edac_mc_panic_on_ue now or what are we planning to do
for uncorrectable errors?

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

You can remove the "EDAC " string from those printks above as
edac_printk already adds the prefix.

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

Have you checked whether those reads don't get optimized away by the
compiler? I know, you need them for triggering the error condition.

Also, you should add a comment here to explain why the reads are being
done.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
