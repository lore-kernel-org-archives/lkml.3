Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaD3IVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:21:45 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:49333 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaD3IVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:21:44 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2014 04:21:43 EDT
Message-ID: <5360B12C.8020602@prisktech.co.nz>
Date: Wed, 30 Apr 2014 20:15:40 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexey Charkov <alchark@gmail.com>, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: vt8500: Ensure value reg is updated when setting
 direction
References: <1398800520-18135-1-git-send-email-alchark@gmail.com>
In-Reply-To: <1398800520-18135-1-git-send-email-alchark@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30/04/14 07:42, Alexey Charkov wrote:
> Current code only touches the direction register when setting direction
> to output, which breaks logic like
>
> echo high > /sys/class/gpio/gpio0/direction
>
> which is expected to also set the value. This patch also adds a call
> to update the value register when setting direction to output.
>
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
>   drivers/pinctrl/vt8500/pinctrl-wmt.c | 23 ++++++++++++-----------
>   1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> index 9802b67..2c61281 100644
> --- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
> +++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> @@ -523,17 +523,6 @@ static int wmt_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
>   		return GPIOF_DIR_IN;
>   }
>   
> -static int wmt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> -{
> -	return pinctrl_gpio_direction_input(chip->base + offset);
> -}
> -
> -static int wmt_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
> -				     int value)
> -{
> -	return pinctrl_gpio_direction_output(chip->base + offset);
> -}
> -
>   static int wmt_gpio_get_value(struct gpio_chip *chip, unsigned offset)
>   {
>   	struct wmt_pinctrl_data *data = dev_get_drvdata(chip->dev);
> @@ -568,6 +557,18 @@ static void wmt_gpio_set_value(struct gpio_chip *chip, unsigned offset,
>   		wmt_clearbits(data, reg_data_out, BIT(bit));
>   }
>   
> +static int wmt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +	return pinctrl_gpio_direction_input(chip->base + offset);
> +}
> +
> +static int wmt_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
> +				     int value)
> +{
> +	wmt_gpio_set_value(chip, offset, value);
> +	return pinctrl_gpio_direction_output(chip->base + offset);
> +}
> +
>   static struct gpio_chip wmt_gpio_chip = {
>   	.label = "gpio-wmt",
>   	.owner = THIS_MODULE,

Acked-by: Tony Prisk <linux@prisktech.co.nz>

Didn't notice that this was an option in the gpio documentation but it 
makes obvious sense.
Regards
Tony P
