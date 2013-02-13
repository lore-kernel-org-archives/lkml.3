Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965198Ab3BMWuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:50:07 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39895 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965142Ab3BMWuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:50:05 -0500
Message-ID: <511C187D.7040305@gmail.com>
Date: Thu, 14 Feb 2013 09:49:33 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 1/4] gpiolib: check descriptors validity before use
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com> <1360738983-22436-2-git-send-email-gnurou@gmail.com>
In-Reply-To: <1360738983-22436-2-git-send-email-gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/13 18:02, Alexandre Courbot wrote:
> From: Alexandre Courbot <acourbot@nvidia.com>
> 
> Some functions dereferenced their GPIO descriptor argument without
> checking its validity first, potentially leading to an oops when given
> an invalid argument.
> 
> This patch also makes gpio_get_value() more resilient when given an
> invalid GPIO, returning 0 instead of oopsing.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpio/gpiolib.c | 64 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index fff9786..8a2cf9c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -174,7 +174,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc)
>  /* caller holds gpio_lock *OR* gpio is marked as requested */
>  static struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc)
>  {
> -	return desc->chip;
> +	return desc ? desc->chip : NULL;
>  }
>  
>  struct gpio_chip *gpio_to_chip(unsigned gpio)
> @@ -653,7 +653,12 @@ static ssize_t export_store(struct class *class,
>  	if (status < 0)
>  		goto done;
>  
> +	status = -EINVAL;
> +
>  	desc = gpio_to_desc(gpio);
> +	/* reject invalid GPIOs */
> +	if (!desc)
> +		goto done;
>  
>  	/* No extra locking here; FLAG_SYSFS just signifies that the
>  	 * request and export were done by on behalf of userspace, so
> @@ -867,8 +872,8 @@ static int gpiod_export_link(struct device *dev, const char *name,
>  
>  done:
>  	if (status)
> -		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
> -			 status);
> +		pr_debug("%s: gpio%d status %d\n", __func__,
> +			 desc ? desc_to_gpio(desc) : -1, status);

Is it really useful to use the same pr_debug for the error case? Why not do:

	desc = gpio_to_desc(gpio);
	if (!desc) {
		pr_debug("%s - Invalid gpio %d\n", __func__, gpio);
		return -EINVAL;
	}
	
	...

At this point desc is known valid, though you could just use the gpio
number that was passed in (assuming that it is always the same as
desc_to_gpio).

	pr_debug("%s: gpio%d status %d\n", __func__,
		 desc_to_gpio(desc), status);
	return status;

That provides more information (the original gpio number and the reason
for the -EINVAL) if the gpio is not valid, and removes the ugly ternary
operator from the pr_debug. Same goes for the other functions.

~Ryan

