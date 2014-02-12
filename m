Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaBLRrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:47:33 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:40443 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaBLRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:47:32 -0500
Message-ID: <52FBB3A4.8020706@atmel.com>
Date: Wed, 12 Feb 2014 18:47:16 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, <b.brezillon@overkiz.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v4 2/8] at91: pinctrl: don't request GPIOs used for interrupts
 but lock them as IRQ
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com> <1392199607-27452-3-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1392199607-27452-3-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 11:06, Jean-Jacques Hiblot :
> During the xlate stage of the DT interrupt parsing, the at91 pinctrl driver
> requests the GPIOs that are described as interrupt sources. This prevents a
> driver to request the gpio later to get its electrical value.
> This patch replaces the gpio_request with a gpio_lock_as_irq to prevent the
> gpio to be set as an ouput while allowing a subsequent gpio_request to succeed
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

But I suspect it may go through another patch: the pinctrl one: add
Linux W. to the recipient list please.

Thanks,

> ---
>  drivers/pinctrl/pinctrl-at91.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index d990e33..db55b96 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -1478,18 +1478,17 @@ static int at91_gpio_irq_domain_xlate(struct irq_domain *d,
>  {
>  	struct at91_gpio_chip *at91_gpio = d->host_data;
>  	int ret;
> -	int pin = at91_gpio->chip.base + intspec[0];
>  
>  	if (WARN_ON(intsize < 2))
>  		return -EINVAL;
>  	*out_hwirq = intspec[0];
>  	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
>  
> -	ret = gpio_request(pin, ctrlr->full_name);
> +	ret = gpio_lock_as_irq(&at91_gpio->chip, intspec[0]);
>  	if (ret)
>  		return ret;
>  
> -	ret = gpio_direction_input(pin);
> +	ret = at91_gpio_direction_input(&at91_gpio->chip, intspec[0]);
>  	if (ret)
>  		return ret;
>  
> 


-- 
Nicolas Ferre
