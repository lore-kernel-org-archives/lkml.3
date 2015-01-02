Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbbABKuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:50:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50694 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbABKuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:50:12 -0500
Date: Fri, 2 Jan 2015 11:50:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: dougthompson@xmission.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, punnaia@xilinx.com
Subject: Re: [PATCH v7] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20150102105008.GA31364@pd.tnic>
References: <d71411fd1be84d99af5936138cbcc9c7@BL2FFO11FD014.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d71411fd1be84d99af5936138cbcc9c7@BL2FFO11FD014.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 09:52:20AM +0530, Punnaiah Choudary Kalluri wrote:
> +/**
> + * synps_edac_handle_error - Handle controller error types CE and UE
> + * @mci:	Pointer to the edac memory controller instance
> + * @p:		Pointer to the synopsys ecc status structure
> + *
> + * Handles the controller ECC correctable and un correctable error.
> + */
> +static void synps_edac_handle_error(struct mem_ctl_info *mci,
> +				    struct synps_ecc_status *p)
> +{
> +	char message[SYNPS_EDAC_MSG_SIZE];

This is still on the stack. My previous comment:

"You could preallocate this on driver init so you don't do relatively
big stack allocations on the error reporting path and remain lean."

> +	struct ecc_error_info *pinf;
> +
> +	if (p->ce_cnt) {
> +		pinf = &p->ceinfo;
> +		snprintf(message, SYNPS_EDAC_MSG_SIZE,
> +			 "DDR ECC error type :%s Row %d Bank %d Col %d ",
> +			 "CE", pinf->row, pinf->bank, pinf->col);
> +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +				     p->ce_cnt, 0, 0, 0, 0, 0, -1,
> +				     message, "");
> +	}
> +
> +	if (p->ue_cnt) {
> +		pinf = &p->ueinfo;
> +		snprintf(message, SYNPS_EDAC_MSG_SIZE,
> +			 "DDR ECC error type :%s Row %d Bank %d Col %d ",
> +			 "UE", pinf->row, pinf->bank, pinf->col);
> +		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +				     p->ue_cnt, 0, 0, 0, 0, 0, -1,
> +				     message, "");
> +	}

>From the previous review:

"If you memset(p, 0,...) here, after consumption, you don't need to do
it anywhere else and be sure that *p would be always clean and ready for
the next error."

Looks like you've missed those two points.

> +static int synps_edac_mc_probe(struct platform_device *pdev)
> +{
> +	struct mem_ctl_info *mci;
> +	struct edac_mc_layer layers[2];
> +	struct synps_edac_priv *priv;
> +	int rc;
> +	struct resource *res;
> +	void __iomem *baseaddr;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	baseaddr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(baseaddr))
> +		return PTR_ERR(baseaddr);
> +
> +	if (!synps_edac_get_eccstate(baseaddr)) {
> +		edac_printk(KERN_INFO, EDAC_MC, "ECC not enabled\n");
> +		return -ENXIO;
> +	}
> +
> +	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> +	layers[0].size = SYNPS_EDAC_NR_CSROWS;
> +	layers[0].is_virt_csrow = true;
> +	layers[1].type = EDAC_MC_LAYER_CHANNEL;
> +	layers[1].size = SYNPS_EDAC_NR_CHANS;
> +	layers[1].is_virt_csrow = false;
> +
> +	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
> +			    sizeof(struct synps_edac_priv));
> +	if (!mci) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "Failed memory allocation for mc instance\n");
> +		return -ENOMEM;
> +	}
> +
> +	priv = mci->pvt_info;
> +	priv->baseaddr = baseaddr;
> +	rc = synps_edac_mc_init(mci, pdev);
> +	if (rc) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "Failed to initialize instance\n");
> +		goto free_edac_mc;
> +	}
> +
> +	rc = edac_mc_add_mc(mci);
> +	if (rc) {
> +		edac_printk(KERN_ERR, EDAC_MC,
> +			    "Failed to register with EDAC core\n");
> +		goto free_edac_mc;
> +	}

With all the more or less redundant commenting in this driver, the *one*
line which definitely needs a comment is without one:

	/*
	 * Start capturing the correctable and uncorrectable errors. A write of
	 * 0 starts the counters.
	 */
> +	writel(0x0, baseaddr + ECC_CTRL_OFST);
> +	return rc;
> +
> +free_edac_mc:
> +	edac_mc_free(mci);
> +
> +	return rc;
> +}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
