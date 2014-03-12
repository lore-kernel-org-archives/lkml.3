Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaCLM75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:59:57 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:55428 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaCLM7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:59:55 -0400
Message-ID: <53205A46.6000304@gmail.com>
Date: Wed, 12 Mar 2014 13:59:50 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com
CC: plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com
Subject: Re: [PATCH v5 3/9] at91: pinctrl: don't request GPIOs used for interrupts
 but lock them as IRQ
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com> <1393841162-25339-4-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1393841162-25339-4-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

IIRC this patch was necessary for the DM9000 device, which is not defined
in this series anymore.
And, correct me if I'm wrong, but there's still a discussion about how
this should be fixed properly (https://lkml.org/lkml/2014/2/25/388).

As a result, shouldn't we remove this patch from this series ?

Best Regards,

Boris

Le 03/03/2014 11:05, Jean-Jacques Hiblot a écrit :
> During the xlate stage of the DT interrupt parsing, the at91 pinctrl driver
> requests the GPIOs that are described as interrupt sources. This prevents a
> driver to request the gpio later to get its electrical value.
> This patch replaces the gpio_request with a gpio_lock_as_irq to prevent the
> gpio to be set as an ouput while allowing a subsequent gpio_request to succeed
>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>   drivers/pinctrl/pinctrl-at91.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index d990e33..db55b96 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -1478,18 +1478,17 @@ static int at91_gpio_irq_domain_xlate(struct irq_domain *d,
>   {
>   	struct at91_gpio_chip *at91_gpio = d->host_data;
>   	int ret;
> -	int pin = at91_gpio->chip.base + intspec[0];
>   
>   	if (WARN_ON(intsize < 2))
>   		return -EINVAL;
>   	*out_hwirq = intspec[0];
>   	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
>   
> -	ret = gpio_request(pin, ctrlr->full_name);
> +	ret = gpio_lock_as_irq(&at91_gpio->chip, intspec[0]);
>   	if (ret)
>   		return ret;
>   
> -	ret = gpio_direction_input(pin);
> +	ret = at91_gpio_direction_input(&at91_gpio->chip, intspec[0]);
>   	if (ret)
>   		return ret;
>   

