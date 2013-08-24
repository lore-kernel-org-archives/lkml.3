Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3HXT54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 15:57:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53120 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3HXT5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 15:57:55 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52191041.7040505@roeck-us.net>
Date: Sat, 24 Aug 2013 12:57:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Santos <daniel.santos@pobox.com>
CC: danielfsantos@att.net, Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Fix crash when exporting non-existant gpio
References: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2013 11:48 AM, danielfsantos@att.net wrote:
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
> [  222.961384] Unable to handle kernel NULL pointer dereference at
> virtual address 00000044
> [  222.969486] pgd = d97d0000
> [  222.972190] [00000044] *pgd=1aaca831, *pte=00000000, *ppte=00000000
> [  222.978483] Internal error: Oops: 17 [#1] PREEMPT ARM
> ---
>   drivers/gpio/gpiolib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index d6413b2..e547f75f8b 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -136,7 +136,7 @@ static struct gpio_desc *gpio_to_desc(unsigned gpio)
>    */
>   static int desc_to_gpio(const struct gpio_desc *desc)
>   {
> -	return desc->chip->base + gpio_chip_hwgpio(desc);
> +	return desc->chip ?  desc->chip->base + gpio_chip_hwgpio(desc) : -1;
>   }
>

Looking into calling code, desc_to_gpio() is clearly not supposed to return an error,
and it will result in odd behavior if it returns -1. For example, the resulting debug
message of "gpio--1 (...) status ..." is not very useful.

It would make more sense to fix the calling code. You could for example
validate in affected functions if the gpio pin exists by not only
checking for desc but also for desc->chip. Another option might be
to have gpio_to_desc() return NULL if desc->chip is NULL.

Guenter


