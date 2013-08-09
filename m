Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030835Ab3HITZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:25:21 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53529 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030765Ab3HITZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:25:19 -0400
Date: Fri, 9 Aug 2013 12:25:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michael Brunner <mibru@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org
Subject: Re: [PATCH] gpio: Fix bit masking in Kontron PLD GPIO driver
Message-ID: <20130809192516.GB10417@roeck-us.net>
References: <20130809173326.75aed3b6@mail.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809173326.75aed3b6@mail.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 05:33:26PM +0200, Michael Brunner wrote:
> This patch fixes the bit masking within the GPIO driver. The masking is
> basically done twice which causes the wrong GPIOs to be addressed.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/gpio/gpio-kempld.c |   24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-kempld.c b/drivers/gpio/gpio-kempld.c
> index d3ed563..6118b66 100644
> --- a/drivers/gpio/gpio-kempld.c
> +++ b/drivers/gpio/gpio-kempld.c
> @@ -46,9 +46,9 @@ static void kempld_gpio_bitop(struct kempld_device_data *pld,
>  
>         status = kempld_read8(pld, reg);
>         if (val)
> -               status |= (1 << bit);
> +               status |= KEMPLD_GPIO_MASK(bit);
>         else
> -               status &= ~(1 << bit);
> +               status &= ~KEMPLD_GPIO_MASK(bit);
>         kempld_write8(pld, reg, status);
>  }
>  
> @@ -60,7 +60,7 @@ static int kempld_gpio_get_bit(struct kempld_device_data *pld, u8 reg, u8 bit)
>         status = kempld_read8(pld, reg);
>         kempld_release_mutex(pld);
>  
> -       return !!(status & (1 << bit));
> +       return !!(status & KEMPLD_GPIO_MASK(bit));
>  }
>  
>  static int kempld_gpio_get(struct gpio_chip *chip, unsigned offset)
> @@ -69,8 +69,7 @@ static int kempld_gpio_get(struct gpio_chip *chip, unsigned offset)
>                 = container_of(chip, struct kempld_gpio_data, chip);
>         struct kempld_device_data *pld = gpio->pld;
>  
> -       return kempld_gpio_get_bit(pld, KEMPLD_GPIO_LVL_NUM(offset),
> -                                  KEMPLD_GPIO_MASK(offset));
> +       return kempld_gpio_get_bit(pld, KEMPLD_GPIO_LVL_NUM(offset), offset);
>  }
>  
>  static void kempld_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> @@ -80,8 +79,7 @@ static void kempld_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>         struct kempld_device_data *pld = gpio->pld;
>  
>         kempld_get_mutex(pld);
> -       kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset),
> -                         KEMPLD_GPIO_MASK(offset), value);
> +       kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset), offset, value);
>         kempld_release_mutex(pld);
>  }
>  
> @@ -92,8 +90,7 @@ static int kempld_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>         struct kempld_device_data *pld = gpio->pld;
>  
>         kempld_get_mutex(pld);
> -       kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset),
> -                         KEMPLD_GPIO_MASK(offset), 0);
> +       kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset), offset, 0);
>         kempld_release_mutex(pld);
>  
>         return 0;
> @@ -107,10 +104,8 @@ static int kempld_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
>         struct kempld_device_data *pld = gpio->pld;
>  
>         kempld_get_mutex(pld);
> -       kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset),
> -                         KEMPLD_GPIO_MASK(offset), value);
> -       kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset),
> -                         KEMPLD_GPIO_MASK(offset), 1);
> +       kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset), offset, value);
> +       kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset), offset, 1);
>         kempld_release_mutex(pld);
>  
>         return 0;
> @@ -122,8 +117,7 @@ static int kempld_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
>                 = container_of(chip, struct kempld_gpio_data, chip);
>         struct kempld_device_data *pld = gpio->pld;
>  
> -       return kempld_gpio_get_bit(pld, KEMPLD_GPIO_DIR_NUM(offset),
> -                                  KEMPLD_GPIO_MASK(offset));
> +       return kempld_gpio_get_bit(pld, KEMPLD_GPIO_DIR_NUM(offset), offset);
>  }
>  
>  static int kempld_gpio_pincount(struct kempld_device_data *pld)
> 
