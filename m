Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIYCsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:48:04 -0400
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:55942
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbaIYCsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:48:02 -0400
X-Greylist: delayed 1886 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 22:48:00 EDT
Date: Thu, 25 Sep 2014 10:47:13 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <kernel@pengutronix.de>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpringlemeir@nbsps.com>
Subject: Re: [PATCH v2 2/5] pinctrl: imx: add gpio pinmux support for vf610
Message-ID: <20140925024712.GB6405@dragon>
References: <cover.1411492954.git.stefan@agner.ch>
 <bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: SIXPR01CA008.apcprd01.prod.exchangelabs.com (10.242.58.18)
 To BY2PR03MB346.namprd03.prod.outlook.com (10.141.139.15)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB346;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(85306004)(97756001)(95666004)(46102003)(42186005)(102836001)(19580405001)(107046002)(85852003)(92726001)(21056001)(66066001)(46406003)(110136001)(74502003)(81342003)(33656002)(83072002)(90102001)(97736003)(50466002)(101416001)(80022003)(76176999)(64706001)(83506001)(81542003)(79102003)(92566001)(77096002)(19580395003)(76482002)(105586002)(47776003)(20776003)(106356001)(87976001)(74662003)(33716001)(54356999)(23726002)(77982003)(86362001)(4396001)(99396003)(10300001)(83322001)(31966008)(50986999)(120916001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB346;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB238;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:37:54PM +0200, Stefan Agner wrote:
> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
> This is needed since direction configuration is not part of the
> GPIO module in Vybrid.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/pinctrl/pinctrl-imx.c   | 54 +++++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinctrl-imx.h   |  1 +
>  drivers/pinctrl/pinctrl-vf610.c |  2 +-
>  3 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index 0d4558b..64d1b59 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -294,10 +294,59 @@ static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
>  	return 0;
>  }
>  
> +static int imx_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
> +			struct pinctrl_gpio_range *range, unsigned offset)
> +{
> +	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
> +	const struct imx_pinctrl_soc_info *info = ipctl->info;
> +	const struct imx_pin_reg *pin_reg;
> +	u32 reg;
> +
> +	if (!(info->flags & GPIO_CONTROL))
> +		return -EINVAL;
> +
> +	pin_reg = &info->pin_regs[offset];
> +	if (pin_reg->mux_reg == -1)
> +		return -EINVAL;
> +
> +	reg = readl(ipctl->base + pin_reg->mux_reg);
> +	reg &= ~(0x7 << 20);
> +	writel(reg, ipctl->base + pin_reg->mux_reg);

Isn't this setup redundant at all, since imx_pmx_enable() already takes
care of setting mux register including GPIO mode?

> +
> +	return 0;
> +}
> +
> +static int imx_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> +	   struct pinctrl_gpio_range *range, unsigned offset, bool input)
> +{
> +	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
> +	const struct imx_pinctrl_soc_info *info = ipctl->info;
> +	const struct imx_pin_reg *pin_reg;
> +	u32 reg;
> +
> +	if (!(info->flags & GPIO_CONTROL))
> +		return -EINVAL;
> +
> +	pin_reg = &info->pin_regs[offset];
> +	if (pin_reg->mux_reg == -1)
> +		return -EINVAL;
> +
> +	reg = readl(ipctl->base + pin_reg->mux_reg);
> +	if (input)
> +		reg &= ~0x2;
> +	else
> +		reg |= 0x2;

This is all about Output Buffer Enable (OBE) bit.  What about Input
Buffer Enable (IBE) bit?  Don't we need to set or clear it as per GPIO
direction as well?

> +	writel(reg, ipctl->base + pin_reg->mux_reg);
> +
> +	return 0;
> +}
> +
>  static const struct pinmux_ops imx_pmx_ops = {
>  	.get_functions_count = imx_pmx_get_funcs_count,
>  	.get_function_name = imx_pmx_get_func_name,
>  	.get_function_groups = imx_pmx_get_groups,
> +	.gpio_request_enable = imx_pmx_gpio_request_enable,
> +	.gpio_set_direction = imx_pmx_gpio_set_direction,
>  	.enable = imx_pmx_enable,
>  };
>  
> @@ -579,6 +628,11 @@ int imx_pinctrl_probe(struct platform_device *pdev,
>  		dev_err(&pdev->dev, "wrong pinctrl info\n");
>  		return -EINVAL;
>  	}
> +
> +	/* GPIO control functions only intended for shared mux/conf register */
> +	if (info->flags & GPIO_CONTROL)
> +		BUG_ON(!(info->flags & SHARE_MUX_CONF_REG));
> +

If this is always true, why don't we just use flag SHARE_MUX_CONF_REG
and save GPIO_CONTROL?  This check doesn't make too much sense to me if
we choose to have a new flag for GPIO setup.  IMO, we should probably
either drop the GPIO_CONTROL flag or the check.

Shawn

>  	info->dev = &pdev->dev;
>  
>  	/* Create state holders etc for this driver */
> diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/pinctrl-imx.h
> index 49e55d3..8f37ca4 100644
> --- a/drivers/pinctrl/pinctrl-imx.h
> +++ b/drivers/pinctrl/pinctrl-imx.h
> @@ -84,6 +84,7 @@ struct imx_pinctrl_soc_info {
>  };
>  
>  #define SHARE_MUX_CONF_REG	0x1
> +#define GPIO_CONTROL		0x2
>  
>  #define NO_MUX		0x0
>  #define NO_PAD		0x0
> diff --git a/drivers/pinctrl/pinctrl-vf610.c b/drivers/pinctrl/pinctrl-vf610.c
> index b788e15..fdf5661 100644
> --- a/drivers/pinctrl/pinctrl-vf610.c
> +++ b/drivers/pinctrl/pinctrl-vf610.c
> @@ -299,7 +299,7 @@ static const struct pinctrl_pin_desc vf610_pinctrl_pads[] = {
>  static struct imx_pinctrl_soc_info vf610_pinctrl_info = {
>  	.pins = vf610_pinctrl_pads,
>  	.npins = ARRAY_SIZE(vf610_pinctrl_pads),
> -	.flags = SHARE_MUX_CONF_REG,
> +	.flags = SHARE_MUX_CONF_REG | GPIO_CONTROL,
>  };
>  
>  static struct of_device_id vf610_pinctrl_of_match[] = {
> -- 
> 2.1.0
> 
