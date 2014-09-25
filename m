Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaIYJIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:08:11 -0400
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:22307
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751237AbaIYJIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:08:04 -0400
X-Greylist: delayed 11536 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 05:08:04 EDT
Date: Thu, 25 Sep 2014 17:07:15 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <kernel@pengutronix.de>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpringlemeir@nbsps.com>
Subject: Re: [PATCH v2 2/5] pinctrl: imx: add gpio pinmux support for vf610
Message-ID: <20140925090714.GH6405@dragon>
References: <cover.1411492954.git.stefan@agner.ch>
 <bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
 <20140925024712.GB6405@dragon>
 <1d3735aff5e0961c43d349d673a1c2b2@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1d3735aff5e0961c43d349d673a1c2b2@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: SIXPR01CA010.apcprd01.prod.exchangelabs.com (10.242.58.20)
 To BLUPR03MB341.namprd03.prod.outlook.com (10.141.48.12)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB341;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377424004)(24454002)(199003)(51704005)(23726002)(54356999)(76176999)(83506001)(21056001)(33656002)(99396003)(97736003)(90102001)(50986999)(50466002)(102836001)(85852003)(110136001)(97756001)(107046002)(77096002)(86362001)(31966008)(19580395003)(19580405001)(4396001)(83322001)(92726001)(92566001)(105586002)(106356001)(76482002)(42186005)(85306004)(83072002)(46406003)(87976001)(93886004)(47776003)(101416001)(64706001)(81542003)(95666004)(74502003)(81342003)(80022003)(77982003)(74662003)(46102003)(79102003)(10300001)(20776003)(66066001)(33716001)(120916001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB341;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:00:41AM +0200, Stefan Agner wrote:
> Am 2014-09-25 04:47, schrieb Shawn Guo:
> > On Tue, Sep 23, 2014 at 07:37:54PM +0200, Stefan Agner wrote:
> >> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
> >> This is needed since direction configuration is not part of the
> >> GPIO module in Vybrid.
> >>
> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> >> ---
> >>  drivers/pinctrl/pinctrl-imx.c   | 54 +++++++++++++++++++++++++++++++++++++++++
> >>  drivers/pinctrl/pinctrl-imx.h   |  1 +
> >>  drivers/pinctrl/pinctrl-vf610.c |  2 +-
> >>  3 files changed, 56 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> >> index 0d4558b..64d1b59 100644
> >> --- a/drivers/pinctrl/pinctrl-imx.c
> >> +++ b/drivers/pinctrl/pinctrl-imx.c
> >> @@ -294,10 +294,59 @@ static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
> >>  	return 0;
> >>  }
> >>
> >> +static int imx_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
> >> +			struct pinctrl_gpio_range *range, unsigned offset)
> >> +{
> >> +	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
> >> +	const struct imx_pinctrl_soc_info *info = ipctl->info;
> >> +	const struct imx_pin_reg *pin_reg;
> >> +	u32 reg;
> >> +
> >> +	if (!(info->flags & GPIO_CONTROL))
> >> +		return -EINVAL;
> >> +
> >> +	pin_reg = &info->pin_regs[offset];
> >> +	if (pin_reg->mux_reg == -1)
> >> +		return -EINVAL;
> >> +
> >> +	reg = readl(ipctl->base + pin_reg->mux_reg);
> >> +	reg &= ~(0x7 << 20);
> >> +	writel(reg, ipctl->base + pin_reg->mux_reg);
> > 
> > Isn't this setup redundant at all, since imx_pmx_enable() already takes
> > care of setting mux register including GPIO mode?
> > 
> 
> Yes currently this is redundant, when a pinmux is actually applied. What
> is the expected behaviour? Is a explicit pinmux necessary before we can
> use GPIO? If not, maybe it would make more sense to use imx_pmx_enable
> here to write all pinctrl settings?

Okay, as per Documentation/pinctrl.txt, it's required that GPIO and
PINCTRL can be used as orthogonal.  That said, your code does the right
thing.  Sorry for the noisy comment.

> 
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int imx_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> >> +	   struct pinctrl_gpio_range *range, unsigned offset, bool input)
> >> +{
> >> +	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
> >> +	const struct imx_pinctrl_soc_info *info = ipctl->info;
> >> +	const struct imx_pin_reg *pin_reg;
> >> +	u32 reg;
> >> +
> >> +	if (!(info->flags & GPIO_CONTROL))
> >> +		return -EINVAL;
> >> +
> >> +	pin_reg = &info->pin_regs[offset];
> >> +	if (pin_reg->mux_reg == -1)
> >> +		return -EINVAL;
> >> +
> >> +	reg = readl(ipctl->base + pin_reg->mux_reg);
> >> +	if (input)
> >> +		reg &= ~0x2;
> >> +	else
> >> +		reg |= 0x2;
> > 
> > This is all about Output Buffer Enable (OBE) bit.  What about Input
> > Buffer Enable (IBE) bit?  Don't we need to set or clear it as per GPIO
> > direction as well?
> > 
> 
> The leave the input buffer doesn't hurt, it allows to read back the
> value which is actually "on the wire". If a pin is hard on GND, one can
> actually see that.

Okay.

> 
> >> +	writel(reg, ipctl->base + pin_reg->mux_reg);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static const struct pinmux_ops imx_pmx_ops = {
> >>  	.get_functions_count = imx_pmx_get_funcs_count,
> >>  	.get_function_name = imx_pmx_get_func_name,
> >>  	.get_function_groups = imx_pmx_get_groups,
> >> +	.gpio_request_enable = imx_pmx_gpio_request_enable,
> >> +	.gpio_set_direction = imx_pmx_gpio_set_direction,
> >>  	.enable = imx_pmx_enable,
> >>  };
> >>
> >> @@ -579,6 +628,11 @@ int imx_pinctrl_probe(struct platform_device *pdev,
> >>  		dev_err(&pdev->dev, "wrong pinctrl info\n");
> >>  		return -EINVAL;
> >>  	}
> >> +
> >> +	/* GPIO control functions only intended for shared mux/conf register */
> >> +	if (info->flags & GPIO_CONTROL)
> >> +		BUG_ON(!(info->flags & SHARE_MUX_CONF_REG));
> >> +
> > 
> > If this is always true, why don't we just use flag SHARE_MUX_CONF_REG
> > and save GPIO_CONTROL?  This check doesn't make too much sense to me if
> > we choose to have a new flag for GPIO setup.  IMO, we should probably
> > either drop the GPIO_CONTROL flag or the check.
> > 
> 
> Well, this is always true because the vf610 driver configures both
> configs. But when somebody accidentally enables GPIO_CONFIG without
> understanding the implications... This was more meant like "don't try to
> use the GPIO_CONTROL just like that, its Vybird specific".

But it will become a blocker if some day an i.MX controller (no flag
SHARE_MUX_CONF_REG) needs to use GPIO_CONFIG.

> But I'm ok to remove this runtime check, maybe a comment describing the
> flags is more appropriate..?

Sounds good.

Shawn
