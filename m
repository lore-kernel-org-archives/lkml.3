Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbbA2Fls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:41:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47251 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbA2Flq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:41:46 -0500
Date: Wed, 28 Jan 2015 23:41:43 -0600
From: Andy Gross <agross@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] soc: qcom: gsbi: Add support for ADM CRCI muxing
Message-ID: <20150129054143.GD13842@qualcomm.com>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
 <1422396644-21714-2-git-send-email-agross@codeaurora.org>
 <20150129021150.GC23506@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129021150.GC23506@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 06:11:50PM -0800, Stephen Boyd wrote:

<snip>

> >  Required properties:
> > -- compatible: must contain "qcom,gsbi-v1.0.0" for APQ8064/IPQ8064
> > +- compatible:	Should contain:
> > +		"qcom,gsbi-ipq8064" for IPQ8064
> > +		"qcom,gsbi-apq8064" for APQ8064
> > +		"qcom,gsbi-msm8960" for MSM8960
> > +		"qcom,gsbi-msm8660" for MSM8660
> 
> Hopefully this is not necessary, but if it is we should leave the
> old compatible here and say it's deprecated or something.

Right.  I went back and forth with the tcsr vs gsbi.  If change the compats I'll
put in a deprecated.

> >  - reg: Address range for GSBI registers
> >  - clocks: required clock
> >  - clock-names: must contain "iface" entry
> >  - qcom,mode : indicates MUX value for configuration of the serial interface.
> >    Please reference dt-bindings/soc/qcom,gsbi.h for valid mux values.
> > +- qcom,gsbi-num: indicates GSBI instance number
> 
> Why not use DT aliases for this? Then other drivers or more
> generic code can search for a gsbiN alias for the particular gsbi
> node. No qcom specific property.

Yeah thats cleaner.  I'll do that.

> 
> > +- syscon-tcsr: indicates phandle of TCSR syscon node
> 
> Make this optional but required if any child nodes use dma?

To enforce that I'd have to determine that a child has a dmas.  I guess that
isn't so bad.

<snip>

> >  static int gsbi_probe(struct platform_device *pdev)
> >  {
> >  	struct device_node *node = pdev->dev.of_node;
> > +	const struct of_device_id *match;
> >  	struct resource *res;
> >  	void __iomem *base;
> >  	struct gsbi_info *gsbi;
> > +	u32 gsbi_num, i, val;
> 
> i should be int
> 
> > +	struct crci_config *config;
> 
> const?

will fix both.

> >  
> >  	gsbi = devm_kzalloc(&pdev->dev, sizeof(*gsbi), GFP_KERNEL);
> >  
> > @@ -45,6 +152,20 @@ static int gsbi_probe(struct platform_device *pdev)
> >  	if (IS_ERR(base))
> >  		return PTR_ERR(base);
> >  
> > +	gsbi->tcsr = syscon_regmap_lookup_by_phandle(node, "syscon-tcsr");
> > +	if (IS_ERR(gsbi->tcsr))
> > +		return -EINVAL;
> > +
> > +	if (of_property_read_u32(node, "qcom,gsbi-num", &gsbi_num)) {
> > +		dev_err(&pdev->dev, "missing gsbi instance number\n");
> > +		return -EINVAL;
> > +	}
> 
> As said before, aliases would do the job the same and not require
> some qcom specific property.

Yup. will fix.

> > +
> > +	if (!gsbi_num || gsbi_num > MAX_GSBI) {
> > +		dev_err(&pdev->dev, "invalid gsbi number\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (of_property_read_u32(node, "qcom,mode", &gsbi->mode)) {
> >  		dev_err(&pdev->dev, "missing mode configuration\n");
> >  		return -EINVAL;
> > @@ -64,6 +185,26 @@ static int gsbi_probe(struct platform_device *pdev)
> >  	writel_relaxed((gsbi->mode << GSBI_PROTOCOL_SHIFT) | gsbi->crci,
> >  				base + GSBI_CTRL_REG);
> >  
> > +	/*
> > +	 * modify tcsr to reflect mode and ADM CRCI mux
> > +	 * Each gsbi contains a pair of bits, one for RX and one for TX
> > +	 * SPI mode requires both bits cleared, otherwise they are set
> > +	 */
> > +	match = of_match_node(gsbi_dt_match, node);
> 
> Why not match the config to the TCSR compatible string? Wouldn't
> that more accurately reflect that we need to set different bits
> depending on which type of TCSR we're using? The version of GSBI
> hardware is not actually changing in every different SoC so I
> don't see why we want to change the compatible there just because
> the TCSR register layout changed.

That is true.  However, with the gsbi compat, I avoid doing a match multiple
times and get the table I need immediately.  The alternative is N checks or
pulling the compat strings and comparing them to get the right table.

> > +	config = (struct crci_config *)match->data;
> 
> Cast shouldn't be necessary if config is const?

will check if that works

> > +
> > +	if (config)
> > +		for (i = 0; i < config->num_rows; i++) {
> > +			if (gsbi->mode == GSBI_PROT_SPI)
> 
> Doesn't I2C need the same treatment (anything in QUP really)?
> Maybe the logic could be changed to check for gsbi->crci ==
> GSBI_CRCI_QUP?

Nope.  I2C doesn't support DMA when ADM is the controller.  It's only SPI or
UART.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

