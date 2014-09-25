Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaIYHBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:01:23 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:50739 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIYHBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:01:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Sep 2014 09:00:41 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, kernel@pengutronix.de,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com
Subject: Re: [PATCH v2 2/5] pinctrl: imx: add gpio pinmux support for vf610
In-Reply-To: <20140925024712.GB6405@dragon>
References: <cover.1411492954.git.stefan@agner.ch>
 <bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
 <20140925024712.GB6405@dragon>
Message-ID: <1d3735aff5e0961c43d349d673a1c2b2@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-25 04:47, schrieb Shawn Guo:
> On Tue, Sep 23, 2014 at 07:37:54PM +0200, Stefan Agner wrote:
>> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
>> This is needed since direction configuration is not part of the
>> GPIO module in Vybrid.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  drivers/pinctrl/pinctrl-imx.c   | 54 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/pinctrl/pinctrl-imx.h   |  1 +
>>  drivers/pinctrl/pinctrl-vf610.c |  2 +-
>>  3 files changed, 56 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
>> index 0d4558b..64d1b59 100644
>> --- a/drivers/pinctrl/pinctrl-imx.c
>> +++ b/drivers/pinctrl/pinctrl-imx.c
>> @@ -294,10 +294,59 @@ static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
>>  	return 0;
>>  }
>>
>> +static int imx_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
>> +			struct pinctrl_gpio_range *range, unsigned offset)
>> +{
>> +	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
>> +	const struct imx_pinctrl_soc_info *info = ipctl->info;
>> +	const struct imx_pin_reg *pin_reg;
>> +	u32 reg;
>> +
>> +	if (!(info->flags & GPIO_CONTROL))
>> +		return -EINVAL;
>> +
>> +	pin_reg = &info->pin_regs[offset];
>> +	if (pin_reg->mux_reg == -1)
>> +		return -EINVAL;
>> +
>> +	reg = readl(ipctl->base + pin_reg->mux_reg);
>> +	reg &= ~(0x7 << 20);
>> +	writel(reg, ipctl->base + pin_reg->mux_reg);
> 
> Isn't this setup redundant at all, since imx_pmx_enable() already takes
> care of setting mux register including GPIO mode?
> 

Yes currently this is redundant, when a pinmux is actually applied. What
is the expected behaviour? Is a explicit pinmux necessary before we can
use GPIO? If not, maybe it would make more sense to use imx_pmx_enable
here to write all pinctrl settings?

>> +
>> +	return 0;
>> +}
>> +
>> +static int imx_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
>> +	   struct pinctrl_gpio_range *range, unsigned offset, bool input)
>> +{
>> +	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
>> +	const struct imx_pinctrl_soc_info *info = ipctl->info;
>> +	const struct imx_pin_reg *pin_reg;
>> +	u32 reg;
>> +
>> +	if (!(info->flags & GPIO_CONTROL))
>> +		return -EINVAL;
>> +
>> +	pin_reg = &info->pin_regs[offset];
>> +	if (pin_reg->mux_reg == -1)
>> +		return -EINVAL;
>> +
>> +	reg = readl(ipctl->base + pin_reg->mux_reg);
>> +	if (input)
>> +		reg &= ~0x2;
>> +	else
>> +		reg |= 0x2;
> 
> This is all about Output Buffer Enable (OBE) bit.  What about Input
> Buffer Enable (IBE) bit?  Don't we need to set or clear it as per GPIO
> direction as well?
> 

The leave the input buffer doesn't hurt, it allows to read back the
value which is actually "on the wire". If a pin is hard on GND, one can
actually see that.

>> +	writel(reg, ipctl->base + pin_reg->mux_reg);
>> +
>> +	return 0;
>> +}
>> +
>>  static const struct pinmux_ops imx_pmx_ops = {
>>  	.get_functions_count = imx_pmx_get_funcs_count,
>>  	.get_function_name = imx_pmx_get_func_name,
>>  	.get_function_groups = imx_pmx_get_groups,
>> +	.gpio_request_enable = imx_pmx_gpio_request_enable,
>> +	.gpio_set_direction = imx_pmx_gpio_set_direction,
>>  	.enable = imx_pmx_enable,
>>  };
>>
>> @@ -579,6 +628,11 @@ int imx_pinctrl_probe(struct platform_device *pdev,
>>  		dev_err(&pdev->dev, "wrong pinctrl info\n");
>>  		return -EINVAL;
>>  	}
>> +
>> +	/* GPIO control functions only intended for shared mux/conf register */
>> +	if (info->flags & GPIO_CONTROL)
>> +		BUG_ON(!(info->flags & SHARE_MUX_CONF_REG));
>> +
> 
> If this is always true, why don't we just use flag SHARE_MUX_CONF_REG
> and save GPIO_CONTROL?  This check doesn't make too much sense to me if
> we choose to have a new flag for GPIO setup.  IMO, we should probably
> either drop the GPIO_CONTROL flag or the check.
> 

Well, this is always true because the vf610 driver configures both
configs. But when somebody accidentally enables GPIO_CONFIG without
understanding the implications... This was more meant like "don't try to
use the GPIO_CONTROL just like that, its Vybird specific".

But I'm ok to remove this runtime check, maybe a comment describing the
flags is more appropriate..?

> Shawn
> 
>>  	info->dev = &pdev->dev;
>>
>>  	/* Create state holders etc for this driver */
>> diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/pinctrl-imx.h
>> index 49e55d3..8f37ca4 100644
>> --- a/drivers/pinctrl/pinctrl-imx.h
>> +++ b/drivers/pinctrl/pinctrl-imx.h
>> @@ -84,6 +84,7 @@ struct imx_pinctrl_soc_info {
>>  };
>>
>>  #define SHARE_MUX_CONF_REG	0x1
>> +#define GPIO_CONTROL		0x2
>>
>>  #define NO_MUX		0x0
>>  #define NO_PAD		0x0
>> diff --git a/drivers/pinctrl/pinctrl-vf610.c b/drivers/pinctrl/pinctrl-vf610.c
>> index b788e15..fdf5661 100644
>> --- a/drivers/pinctrl/pinctrl-vf610.c
>> +++ b/drivers/pinctrl/pinctrl-vf610.c
>> @@ -299,7 +299,7 @@ static const struct pinctrl_pin_desc vf610_pinctrl_pads[] = {
>>  static struct imx_pinctrl_soc_info vf610_pinctrl_info = {
>>  	.pins = vf610_pinctrl_pads,
>>  	.npins = ARRAY_SIZE(vf610_pinctrl_pads),
>> -	.flags = SHARE_MUX_CONF_REG,
>> +	.flags = SHARE_MUX_CONF_REG | GPIO_CONTROL,
>>  };
>>
>>  static struct of_device_id vf610_pinctrl_of_match[] = {
>> --
>> 2.1.0
>>
