Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaJUAS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:18:56 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:54766 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaJUASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:18:55 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 216.239.45.75
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <eae3019318fe6cd237d9b2e446f5baa0>
X-DNS-TYPE: 0
Message-ID: <5445A665.9010905@rock-chips.com>
Date: Mon, 20 Oct 2014 17:18:45 -0700
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>
CC: Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pinctrl: rockchip: Don't call pinctrl_gpio_direction_output()
 in pin_config_set()
References: <1413847670-12245-1-git-send-email-dianders@chromium.org> <1413847670-12245-2-git-send-email-dianders@chromium.org>
In-Reply-To: <1413847670-12245-2-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/20/2014 04:27 PM, Doug Anderson wrote:
> The Rockchip pinctrl driver was calling
> rockchip_gpio_direction_output() in the pin_config_set() callback.
> This was just a shortcut for:
> * rockchip_gpio_set()
> * pinctrl_gpio_direction_output()
>
> Unfortunately it's not so good to call pinctrl_gpio_direction_output()
> from pin_config_set().  Specifically when initting hogs you'll get an
> error.
>
> Let's refactor a little so we can call
> _rockchip_pmx_gpio_set_direction() directly.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>   drivers/pinctrl/pinctrl-rockchip.c | 42 +++++++++++++++++++++++---------------
>   1 file changed, 26 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
> index 230d8f3..65efb88 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -856,22 +856,16 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
>    * leads to this function call (via the pinctrl_gpio_direction_{input|output}()
>    * function called from the gpiolib interface).
>    */
> -static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> -					      struct pinctrl_gpio_range *range,
> -					      unsigned offset, bool input)
> +static int _rockchip_pmx_gpio_set_direction(struct gpio_chip *gc,
> +					    unsigned offset, bool input)
>   {
> -	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
>   	struct rockchip_pin_bank *bank;
> -	struct gpio_chip *chip;
>   	int pin, ret;
> +	unsigned long flags;
>   	u32 data;
>   
> -	chip = range->gc;
> -	bank = gc_to_pin_bank(chip);
> -	pin = offset - chip->base;
> -
> -	dev_dbg(info->dev, "gpio_direction for pin %u as %s-%d to %s\n",
> -		 offset, range->name, pin, input ? "input" : "output");
> +	bank = gc_to_pin_bank(gc);
> +	pin = offset - gc->base;
>   
>   	ret = rockchip_set_mux(bank, pin, RK_FUNC_GPIO);
>   	if (ret < 0)
> @@ -888,6 +882,22 @@ static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
>   	return 0;
>   }
>   
> +static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> +					      struct pinctrl_gpio_range *range,
> +					      unsigned offset, bool input)
> +{
> +	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +	struct gpio_chip *chip;
> +	int pin;
> +
> +	chip = range->gc;
> +	pin = offset - chip->base;
> +	dev_dbg(info->dev, "gpio_direction for pin %u as %s-%d to %s\n",
> +		 offset, range->name, pin, input ? "input" : "output");
> +
> +	return _rockchip_pmx_gpio_set_direction(range->gc, offset, input);
> +}
> +
>   static const struct pinmux_ops rockchip_pmx_ops = {
>   	.get_functions_count	= rockchip_pmx_get_funcs_count,
>   	.get_function_name	= rockchip_pmx_get_func_name,
> @@ -917,8 +927,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
>   	return false;
>   }
>   
> -static int rockchip_gpio_direction_output(struct gpio_chip *gc,
> -					  unsigned offset, int value);
> +static void rockchip_gpio_set(struct gpio_chip *gc, unsigned offset, int value);
>   static int rockchip_gpio_get(struct gpio_chip *gc, unsigned offset);
>   
>   /* set the pin config settings for a specified pin */
> @@ -959,9 +968,10 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
>   				return rc;
>   			break;
>   		case PIN_CONFIG_OUTPUT:
> -			rc = rockchip_gpio_direction_output(&bank->gpio_chip,
> -							    pin - bank->pin_base,
> -							    arg);
> +			rockchip_gpio_set(&bank->gpio_chip,
> +					  pin - bank->pin_base, arg);
> +			rc = _rockchip_pmx_gpio_set_direction(&bank->gpio_chip,
> +					  pin - bank->pin_base, false);
>   			if (rc)
>   				return rc;
>   			break;
Tested-by: Chris Zhong <zyw@rock-chips.com>
