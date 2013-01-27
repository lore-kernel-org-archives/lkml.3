Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3A0WVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:21:33 -0500
Received: from blu0-omc1-s2.blu0.hotmail.com ([65.55.116.13]:59047 "EHLO
	blu0-omc1-s2.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580Ab3A0WVb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:21:31 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2013 17:21:31 EST
X-EIP: [g7N8ahPPRkAIgrbcns9OZCPbFzoMXrfXhG5f9ldvHPA=]
X-Originating-Email: [emilio@elopez.com.ar]
Message-ID: <BLU0-SMTP154F505F0F41A54AAAFAE888A190@phx.gbl>
Date: Sun, 27 Jan 2013 19:15:15 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
References: <1359192670-22543-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1359192670-22543-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Jan 2013 22:15:20.0997 (UTC) FILETIME=[CBBF6D50:01CDFCDB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maxime,

El 26/01/13 06:31, Maxime Ripard escribió:
> The IP responsible for the muxing on the Allwinner SoCs are also
> handling the GPIOs on the system. This patch adds the needed driver that
> relies on the pinctrl driver for most of its operations.
> 
> The number of pins available for GPIOs operations are already declared
> in the pinctrl driver, we only need to probe a generic driver to handle
> the banks available for each SoC.
> 
> This driver has been tested on a A13-Olinuxino.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
> Changes from v2:
>   - Removed the call to kzalloc to build the pin name
> 
>  drivers/pinctrl/pinctrl-sunxi.c |  134 ++++++++++++++++++++++++++++++++++++++-
>  drivers/pinctrl/pinctrl-sunxi.h |   25 +++++++-
>  2 files changed, 156 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
> index 6f02e34..4ed0e7e 100644
> --- a/drivers/pinctrl/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/pinctrl-sunxi.c
> @@ -11,6 +11,7 @@
>   */
>  
>  #include <linux/io.h>
> +#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> @@ -609,11 +610,53 @@ static int sunxi_pmx_enable(struct pinctrl_dev *pctldev,
>  	return 0;
>  }
>  
> +static int
> +sunxi_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> +			struct pinctrl_gpio_range *range,
> +			unsigned offset,
> +			bool input)
> +{
> +	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
> +	struct sunxi_desc_function *desc;
> +	char pin_name[SUNXI_PIN_NAME_MAX_LEN];
> +	char *func;
> +	u8 bank, pin;
> +	int ret;
> +
> +	bank = (offset) / PINS_PER_BANK;
> +	pin = (offset) % PINS_PER_BANK;
> +
> +	ret = sprintf(pin_name, "P%c%d", 'A' + bank, pin);
> +	if (!ret)
> +		goto error;
> +
> +	if (input)
> +		func = "gpio_in";
> +	else
> +		func = "gpio_out";
> +
> +	desc = sunxi_pinctrl_desc_find_function_by_name(pctl,
> +							pin_name,
> +							func);
> +	if (!desc) {
> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	sunxi_pmx_set(pctldev, offset, desc->muxval);
> +
> +	ret = 0;
> +
> +error:
> +	return ret;
> +}
> +
>  static struct pinmux_ops sunxi_pmx_ops = {
>  	.get_functions_count	= sunxi_pmx_get_funcs_cnt,
>  	.get_function_name	= sunxi_pmx_get_func_name,
>  	.get_function_groups	= sunxi_pmx_get_func_groups,
>  	.enable			= sunxi_pmx_enable,
> +	.gpio_set_direction	= sunxi_pmx_gpio_set_direction,
>  };
>  
>  static struct pinctrl_desc sunxi_pctrl_desc = {
> @@ -622,6 +665,60 @@ static struct pinctrl_desc sunxi_pctrl_desc = {
>  	.pmxops		= &sunxi_pmx_ops,
>  };
>  
> +static int sunxi_pinctrl_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	return pinctrl_request_gpio(chip->base + offset);
> +}
> +
> +static void sunxi_pinctrl_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +	pinctrl_free_gpio(chip->base + offset);
> +}
> +
> +static int sunxi_pinctrl_gpio_direction_input(struct gpio_chip *chip,
> +					unsigned offset)
> +{
> +	return pinctrl_gpio_direction_input(chip->base + offset);
> +}
> +
> +static int sunxi_pinctrl_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +
> +	u32 reg = sunxi_data_reg(offset);
> +	u8 index = sunxi_data_offset(offset);
> +	u32 val = (readl(pctl->membase + reg) >> index) & DATA_PINS_MASK;
> +
> +	return val;
> +}
> +
> +static int sunxi_pinctrl_gpio_direction_output(struct gpio_chip *chip,
> +					unsigned offset, int value)
> +{
> +	return pinctrl_gpio_direction_output(chip->base + offset);
> +}
> +
> +static void sunxi_pinctrl_gpio_set(struct gpio_chip *chip,
> +				unsigned offset, int value)
> +{
> +	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +	u32 reg = sunxi_data_reg(offset);
> +	u8 index = sunxi_data_offset(offset);
> +
> +	writel((value & DATA_PINS_MASK) << index, pctl->membase + reg);
> +}
> +
> +static struct gpio_chip sunxi_pinctrl_gpio_chip __devinitconst = {

__devinitconst got dropped on commit 54b956b9, "Remove __dev* markings
from init.h".

Thanks for the patches, I will be trying them on my A10 board soon.

--
Emilio
