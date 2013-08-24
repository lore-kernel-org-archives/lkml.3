Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3HXVvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:51:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60070 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3HXVvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:51:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52192AEB.3070607@roeck-us.net>
Date: Sat, 24 Aug 2013 14:51:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Santos <daniel.santos@pobox.com>
CC: danielfsantos@att.net, Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Fix crash when exporting non-existant gpio
References: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com> <1377377305-11695-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1377377305-11695-1-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2013 01:48 PM, danielfsantos@att.net wrote:
> I got this on an RPi and I can't find anything specific to that.
> Besides, it's clearly wrong to try to access desc->chip when we have
> just tested that it may be NULL at drivers/gpio/gpiolib.c:1409:
>
> 	chip = desc->chip;
> 	if (chip == NULL)
> 		goto done;
>
> ....
>
> done:
> 	if (status)
> 		pr_debug("_gpio_request: gpio-%d (%s) status %d\n",
> 			 desc_to_gpio(desc), label ? : "?", status);
>
> To reproduce, just pick an invalid gpio nubmer and:
>
> echo -n 248 > /sys/class/gpio/export
>
> However, I wasn't able to reproduce it on my laptop, maybe because I
> don't have any real gpio chips there, not sure.  More info on RPi bug
> report: https://github.com/raspberrypi/linux/issues/364
>
> This fix makes sure that gpio_to_desc() only returns non-NULL if the
> specified gpio really has a chip, and not just if it's within the ranged
> of gpios for the arch.
>
> [  222.961384] Unable to handle kernel NULL pointer dereference at
> virtual address 00000044
> [  222.969486] pgd = d97d0000
> [  222.972190] [00000044] *pgd=1aaca831, *pte=00000000, *ppte=00000000
> [  222.978483] Internal error: Oops: 17 [#1] PREEMPT ARM
> ---
>   drivers/gpio/gpiolib.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index d6413b2..db7c6bb 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -123,7 +123,8 @@ static int gpio_chip_hwgpio(const struct gpio_desc *desc)
>    */
>   static struct gpio_desc *gpio_to_desc(unsigned gpio)
>   {
> -	if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
> +	if (WARN(!gpio_is_valid(gpio) || !gpio_desc[gpio].chip,
> +			"invalid GPIO %d\n", gpio))

I think this triggers a WARN if someone requests an invalid gpio pin from userspace.
Is this really a good idea ?

[ and then export_store and unexport_store complain again with pr_warn ]

May be a separate patch, but if the WARN is useful it might make sense to introduce
gpio_to_desc_silent() which doesn't produce the WARN if it fails.

Looking further into the code, I suspect there may be some race condition
where desc->chip is not (yet) set and export_store is called. So we will
see a WARNING instead of a crash, as the underlying condition still exists.

>   		return NULL;
>   	else
>   		return &gpio_desc[gpio];
> @@ -1406,8 +1407,7 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
>   	spin_lock_irqsave(&gpio_lock, flags);
>
>   	chip = desc->chip;
> -	if (chip == NULL)
> -		goto done;
> +	BUG_ON(!chip);
>
... which in turn means we might see this one. If so, this code might replace
an invalid memory access crash with a BUG crash. Is this really desirable, or
should this better be a WARN ?

Guenter


>   	if (!try_module_get(chip->owner))
>   		goto done;
>

