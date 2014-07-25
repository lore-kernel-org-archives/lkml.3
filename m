Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbaGYIHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:07:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53632 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818AbaGYIHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:07:42 -0400
Date: Fri, 25 Jul 2014 10:07:38 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, balbi@ti.com, p.zabel@pengutronix.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140725080738.GA9756@kwain>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405499166-6726-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140725021853.GA11052@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140725021853.GA11052@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Jul 25, 2014 at 10:18:54AM +0800, Peter Chen wrote:
> On Wed, Jul 16, 2014 at 10:26:01AM +0200, Antoine Ténart wrote:
> > Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> > and DMA mask, to support USB2 ChipIdea controllers that don't need
> > specific functions.
> 
> You may need to indicate it is a generic usb2 glue layer driver at both
> subject and context.

"USB2 ChipIdea driver for ci13xxx" seemed quite generic to me.

> > 
> > Needed for the Marvell Berlin SoCs USB controllers.
> 
> You can say it is tested at Marvell Berlin SoCs USB controllers.

Ok, I'll explicitly say it.

> > +
> > +static int ci_hdrc_usb2_dt_probe(struct device *dev,
> > +				    struct ci_hdrc_platform_data *ci_pdata,
> > +				    struct ci_hdrc_usb2_priv *priv)
> > +{
> > +	u32 mask;
> > +	int ret;
> > +
> > +	priv->clk = devm_clk_get(dev, NULL);
> > +	if (!IS_ERR(priv->clk)) {
> > +		ret = clk_prepare_enable(priv->clk);
> > +		if (ret) {
> > +			dev_err(dev, "failed to enable the clock: %d\n", ret);
> > +			return ret;
> > +		}
> > +	}
> 
> The clk API may be needed for both DT and non-DT cases.

Yes sure, I'll move this to the ci_hdrc_usb2_probe().

> 
> > +
> > +	ci_pdata->phy = of_phy_get(dev->of_node, 0);
> > +	if (IS_ERR(ci_pdata->phy)) {
> > +		if (PTR_ERR(ci_pdata->phy) == -EPROBE_DEFER)
> > +			return -EPROBE_DEFER;
> > +
> > +		/* PHY is optional */
> > +		ci_pdata->phy = NULL;
> > +	}
> > +
> > +	if (of_property_read_u32(dev->of_node, "dma-mask", &mask))
> > +		priv->dma_mask = mask;
> > +
> According to discussion, you may not need dma_mask in driver any more,
> and use below API for both DT and non-DT case.
> 
>         err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>         if (err)
>         	                handle error;

This would only be needed in non-dt cases, as the DMA mask is configured
in drivers/of/platform.c otherwise.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
