Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbbA2Gpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:45:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50382 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbA2Gpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:45:39 -0500
Date: Wed, 28 Jan 2015 22:45:37 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] soc: qcom: gsbi: Add support for ADM CRCI muxing
Message-ID: <20150129064537.GD23506@codeaurora.org>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
 <1422396644-21714-2-git-send-email-agross@codeaurora.org>
 <20150129021150.GC23506@codeaurora.org>
 <20150129054143.GD13842@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129054143.GD13842@qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Andy Gross wrote:
> On Wed, Jan 28, 2015 at 06:11:50PM -0800, Stephen Boyd wrote:
> 
> > 
> > > +- syscon-tcsr: indicates phandle of TCSR syscon node
> > 
> > Make this optional but required if any child nodes use dma?
> 
> To enforce that I'd have to determine that a child has a dmas.  I guess that
> isn't so bad.

I don't think we need to write any code in the driver to enforce
this right now. As long as nobody gets it wrong bad things won't
happen and we can just assume that the DT is correct. Once we get
some bad DT we can go ahead and implement some DT parsing stuff.

> 
> 
> > > +
> > > +	if (!gsbi_num || gsbi_num > MAX_GSBI) {
> > > +		dev_err(&pdev->dev, "invalid gsbi number\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > >  	if (of_property_read_u32(node, "qcom,mode", &gsbi->mode)) {
> > >  		dev_err(&pdev->dev, "missing mode configuration\n");
> > >  		return -EINVAL;
> > > @@ -64,6 +185,26 @@ static int gsbi_probe(struct platform_device *pdev)
> > >  	writel_relaxed((gsbi->mode << GSBI_PROTOCOL_SHIFT) | gsbi->crci,
> > >  				base + GSBI_CTRL_REG);
> > >  
> > > +	/*
> > > +	 * modify tcsr to reflect mode and ADM CRCI mux
> > > +	 * Each gsbi contains a pair of bits, one for RX and one for TX
> > > +	 * SPI mode requires both bits cleared, otherwise they are set
> > > +	 */
> > > +	match = of_match_node(gsbi_dt_match, node);
> > 
> > Why not match the config to the TCSR compatible string? Wouldn't
> > that more accurately reflect that we need to set different bits
> > depending on which type of TCSR we're using? The version of GSBI
> > hardware is not actually changing in every different SoC so I
> > don't see why we want to change the compatible there just because
> > the TCSR register layout changed.
> 
> That is true.  However, with the gsbi compat, I avoid doing a match multiple
> times and get the table I need immediately.  The alternative is N checks or
> pulling the compat strings and comparing them to get the right table.

Sorry I'm not following. We always have to call of_match_node()
here and I'm just suggesting we replace gsbi_dt_match with
tcsr_dt_match and leave gsbi_dt_match like it was before. I don't
see how anything is avoided.

> 
> 
> > > +
> > > +	if (config)
> > > +		for (i = 0; i < config->num_rows; i++) {
> > > +			if (gsbi->mode == GSBI_PROT_SPI)
> > 
> > Doesn't I2C need the same treatment (anything in QUP really)?
> > Maybe the logic could be changed to check for gsbi->crci ==
> > GSBI_CRCI_QUP?
> 
> Nope.  I2C doesn't support DMA when ADM is the controller.  It's only SPI or
> UART.

Ok, I don't get it but I guess it doesn't matter if I2C doesn't
use it.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
