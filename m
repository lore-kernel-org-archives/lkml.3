Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaI2OrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:47:25 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:43343 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaI2Oqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:46:44 -0400
Message-ID: <542970CF.6040405@linaro.org>
Date: Mon, 29 Sep 2014 15:46:39 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>, linux-kernel@vger.kernel.org
CC: Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: st: Fix Sparse error
References: <1411998499-20300-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1411998499-20300-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/14 14:48, Pramod Gurav wrote:
> This change fixes below sparse error,
> drivers/pinctrl/pinctrl-st.c:1515:31: error: incompatible types for operation (>)
> drivers/pinctrl/pinctrl-st.c:1515:31:    left side has type void [noderef] <asn:2>*irqmux_base
> drivers/pinctrl/pinctrl-st.c:1515:31:    right side has type int
>
> The fix is done by removing a check on info->irqmux_base as
> info->irqmux_base has already been checked  for error when allocating it.
> Hence there is no need to redo the check.
>
> Cc: Maxime Coquelin <maxime.coquelin@st.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>   drivers/pinctrl/pinctrl-st.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 5475374..ddeaeda 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1512,7 +1512,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
>   					     gpio_irq, st_gpio_irq_handler);
>   	}
>
> -	if (info->irqmux_base > 0 || gpio_irq > 0) {
> +	if (gpio_irq > 0) {
>   		err = gpiochip_irqchip_add(&bank->gpio_chip, &st_gpio_irqchip,
>   					   0, handle_simple_irq,
>   					   IRQ_TYPE_LEVEL_LOW);

This is not the correct fix. Please see why irqmux_base and gpio_irq are 
used in the driver.
You are breaking the logic here...

please read the below comment from the code.

	/**
	 * GPIO bank can have one of the two possible types of
	 * interrupt-wirings.
	 *
	 * First type is via irqmux, single interrupt is used by multiple
	 * gpio banks. This reduces number of overall interrupts numbers
	 * required. All these banks belong to a single pincontroller.
	 *		  _________
	 *		 |	   |----> [gpio-bank (n)    ]
	 *		 |	   |----> [gpio-bank (n + 1)]
	 *	[irqN]-- | irq-mux |----> [gpio-bank (n + 2)]
	 *		 |	   |----> [gpio-bank (...  )]
	 *		 |_________|----> [gpio-bank (n + 7)]
	 *
	 * Second type has a dedicated interrupt per each gpio bank.
	 *
	 *	[irqN]----> [gpio-bank (n)]
	 */


so irqmux_base is first type and gpio_irq is second type.
if you remove check for irqmux_base here you would end up NOT adding 
irqchip the gpiochip in first type so you break the existing logic here.


I think the correct fix is:

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 5475374..4060c30 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1512,7 +1512,7 @@ static int st_gpiolib_register_bank(struct 
st_pinctrl *info,
                                              gpio_irq, 
st_gpio_irq_handler);
         }

-       if (info->irqmux_base > 0 || gpio_irq > 0) {
+       if (!IS_ERR(info->irqmux_base) || gpio_irq > 0) {
                 err = gpiochip_irqchip_add(&bank->gpio_chip, 
&st_gpio_irqchip,
                                            0, handle_simple_irq,
                                            IRQ_TYPE_LEVEL_LOW);


Thanks,
srini
