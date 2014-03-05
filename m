Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaCEMTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:19:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33173 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaCEMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:19:43 -0500
Message-ID: <531722D9.9020904@ti.com>
Date: Wed, 5 Mar 2014 15:12:57 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, <linux-kernel@vger.kernel.org>
CC: <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
References: <5316FFCE.1060603@ti.com> <1394018461-757-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1394018461-757-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On 03/05/2014 01:21 PM, Alexander Holler wrote:
> The driver missed an of_xlate function to translate gpio numbers
> as found in the DT to the correct chip and number.
>
> While there I've set #gpio_cells to a fixed value of 2.
>
> I've used gpio-pxa.c as template for those changes and tested my changes
> successfully on a da850 board using entries for gpio-leds in a DT. So I didn't
> reinvent the wheel but just copied and tested stuff.
>
> Thanks to Grygorii Strashko for the hint to the existing code in gpio-pxa.
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Looks good to me now. Thanks.

> ---
>   drivers/gpio/gpio-davinci.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>
>   Changes in v2: replaced static variables by indirections.
>
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 7629b4f..92574a0 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -172,6 +172,27 @@ of_err:
>   	return NULL;
>   }
>
> +#ifdef CONFIG_OF_GPIO
> +static int davinci_gpio_of_xlate(struct gpio_chip *gc,
> +			     const struct of_phandle_args *gpiospec,
> +			     u32 *flags)
> +{
> +	struct davinci_gpio_controller *chips = dev_get_drvdata(gc->dev);
> +	struct davinci_gpio_platform_data *pdata = dev_get_platdata(gc->dev);
> +
> +	if (gpiospec->args[0] > pdata->ngpio)
> +		return -EINVAL;
> +
> +	if (gc != &chips[gpiospec->args[0] / 32].chip)
> +		return -EINVAL;
> +
> +	if (flags)
> +		*flags = gpiospec->args[1];
> +
> +	return gpiospec->args[0] % 32;
> +}
> +#endif
> +
>   static int davinci_gpio_probe(struct platform_device *pdev)
>   {
>   	int i, base;
> @@ -236,6 +257,9 @@ static int davinci_gpio_probe(struct platform_device *pdev)
>   			chips[i].chip.ngpio = 32;
>
>   #ifdef CONFIG_OF_GPIO
> +		chips[i].chip.of_gpio_n_cells = 2;
> +		chips[i].chip.of_xlate = davinci_gpio_of_xlate;
> +		chips[i].chip.dev = dev;
>   		chips[i].chip.of_node = dev->of_node;
>   #endif
>   		spin_lock_init(&chips[i].lock);
>

