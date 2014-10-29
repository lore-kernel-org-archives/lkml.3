Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbaJ2Vu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:50:28 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52535 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757333AbaJ2VuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:50:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] gpio / ACPI: Add knowledge about pin controllers to acpi_get_gpiod()
Date: Wed, 29 Oct 2014 23:11 +0100
Message-ID: <2844522.H6KZbzGzjr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414397312-94609-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1414397312-94609-1-git-send-email-mika.westerberg@linux.intel.com> <1414397312-94609-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 27, 2014 10:08:29 AM Mika Westerberg wrote:
> The GPIO resources (GpioIo/GpioInt) used in ACPI contain a GPIO number
> which is relative to the hardware GPIO controller. Typically this number
> can be translated directly to Linux GPIO number because the mapping is
> pretty much 1:1.
> 
> However, when the GPIO driver is using pins exported by a pin controller
> driver via set of GPIO ranges, the mapping might not be 1:1 anymore and
> direct translation does not work.
> 
> In such cases we need to translate the ACPI GPIO number to be suitable for
> the GPIO controller driver in question by checking all the pin controller
> GPIO ranges under the given device and using those to get the proper GPIO
> number.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Rafael, are you OK with this change?

Yes, I am, so

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

And I have no idea how to do that in a more straightforward way.

Of course ->

> 
>  drivers/gpio/gpiolib-acpi.c | 62 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index 05c6275da224..4f2c4adccb8f 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -11,12 +11,14 @@
>   */
>  
>  #include <linux/errno.h>
> +#include <linux/gpio.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/gpio/driver.h>
>  #include <linux/export.h>
>  #include <linux/acpi.h>
>  #include <linux/interrupt.h>
>  #include <linux/mutex.h>
> +#include <linux/pinctrl/pinctrl.h>
>  
>  #include "gpiolib.h"
>  
> @@ -55,6 +57,58 @@ static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
>  	return ACPI_HANDLE(gc->dev) == data;
>  }
>  
> +#ifdef CONFIG_PINCTRL
> +/**
> + * acpi_gpiochip_pin_to_gpio_offset() - translates ACPI GPIO to Linux GPIO
> + * @chip: GPIO chip
> + * @pin: ACPI GPIO pin number from GpioIo/GpioInt resource
> + *
> + * Function takes ACPI GpioIo/GpioInt pin number as a parameter and
> + * translates it to a corresponding offset suitable to be passed to a
> + * GPIO controller driver.
> + *
> + * Typically the returned offset is same as @pin, but if the GPIO
> + * controller uses pin controller and the mapping is not contigous the
> + * offset might be different.
> + */
> +static int acpi_gpiochip_pin_to_gpio_offset(struct gpio_chip *chip, int pin)
> +{
> +	struct gpio_pin_range *pin_range;
> +
> +	/* If there are no ranges in this chip, use 1:1 mapping */
> +	if (list_empty(&chip->pin_ranges))
> +		return pin;
> +
> +	list_for_each_entry(pin_range, &chip->pin_ranges, node) {
> +		const struct pinctrl_gpio_range *range = &pin_range->range;
> +		int i;
> +
> +		if (range->pins) {
> +			for (i = 0; i < range->npins; i++) {
> +				if (range->pins[i] == pin)
> +					return range->base + i - chip->base;
> +			}
> +		} else {
> +			if (pin >= range->pin_base &&
> +			    pin < range->pin_base + range->npins) {
> +				unsigned gpio_base;
> +
> +				gpio_base = range->base - chip->base;
> +				return gpio_base + pin - range->pin_base;
> +			}
> +		}

-> this is only going to work if the pin mapping in chip->pin_ranges doesn't
change after it has returned the offset, but I'm assiming that this is the case.

> +	}
> +
> +	return -EINVAL;
> +}
> +#else
> +static inline int acpi_gpiochip_pin_to_gpio_offset(struct gpio_chip *chip,
> +						   int pin)
> +{
> +	return pin;
> +}
> +#endif
> +
>  /**
>   * acpi_get_gpiod() - Translate ACPI GPIO pin to GPIO descriptor usable with GPIO API
>   * @path:	ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
> @@ -69,6 +123,7 @@ static struct gpio_desc *acpi_get_gpiod(char *path, int pin)
>  	struct gpio_chip *chip;
>  	acpi_handle handle;
>  	acpi_status status;
> +	int offset;
>  
>  	status = acpi_get_handle(NULL, path, &handle);
>  	if (ACPI_FAILURE(status))
> @@ -78,10 +133,11 @@ static struct gpio_desc *acpi_get_gpiod(char *path, int pin)
>  	if (!chip)
>  		return ERR_PTR(-ENODEV);
>  
> -	if (pin < 0 || pin > chip->ngpio)
> -		return ERR_PTR(-EINVAL);
> +	offset = acpi_gpiochip_pin_to_gpio_offset(chip, pin);
> +	if (offset < 0)
> +		return ERR_PTR(offset);
>  
> -	return gpiochip_get_desc(chip, pin);
> +	return gpiochip_get_desc(chip, (u16)offset);

Silly question: Why do we need the explicit u16 cast now?

>  }
>  
>  static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
