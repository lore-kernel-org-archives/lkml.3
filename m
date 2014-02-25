Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaBYOHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:07:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57858 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753131AbaBYOHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:07:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] gpio / ACPI: Allocate ACPI specific data directly in acpi_gpiochip_add()
Date: Tue, 25 Feb 2014 15:21:55 +0100
Message-ID: <8173498.UxWM4NERsQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393257611-18031-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com> <1393257611-18031-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 24, 2014 06:00:07 PM Mika Westerberg wrote:
> We are going to add more ACPI specific data to accompany GPIO chip so
> instead of allocating it per each use-case we allocate it once when
> acpi_gpiochip_add() is called and release it when acpi_gpiochip_remove() is
> called.
> 
> Doing this allows us to add more ACPI specific data by merely adding new
> fields to struct acpi_gpio_chip.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/gpio/gpiolib-acpi.c | 83 ++++++++++++++++++++++++++++++++-------------
>  1 file changed, 59 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index b7db098ba060..5f5f107c2099 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -26,6 +26,11 @@ struct acpi_gpio_evt_pin {
>  	unsigned int irq;
>  };
>  
> +struct acpi_gpio_chip {
> +	struct gpio_chip *chip;
> +	struct list_head *evt_pins;

Hmm.  Why exactly evt_pins has to be a pointer?

> +};
> +
>  static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
>  {
>  	if (!gc->dev)
> @@ -81,14 +86,14 @@ static irqreturn_t acpi_gpio_irq_handler_evt(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
> +static void acpi_gpio_chip_dh(acpi_handle handle, void *data)
>  {
>  	/* The address of this function is used as a key. */
>  }
>  
>  /**
>   * acpi_gpiochip_request_interrupts() - Register isr for gpio chip ACPI events
> - * @chip:      gpio chip
> + * @achip:      ACPI GPIO chip
>   *
>   * ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
>   * handled by ACPI event methods which need to be called from the GPIO
> @@ -96,9 +101,10 @@ static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
>   * gpio pins have acpi event methods and assigns interrupt handlers that calls
>   * the acpi event methods for those pins.
>   */
> -static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
> +static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *achip)

I would call the argument "acpi_gpio" instead of achip (and analogously below),
because the structure is a "chip plus some additional info".

>  {
>  	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
> +	struct gpio_chip *chip = achip->chip;
>  	struct acpi_resource *res;
>  	acpi_handle handle, evt_handle;
>  	struct list_head *evt_pins = NULL;
> @@ -123,12 +129,7 @@ static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
>  		evt_pins = kzalloc(sizeof(*evt_pins), GFP_KERNEL);
>  		if (evt_pins) {
>  			INIT_LIST_HEAD(evt_pins);
> -			status = acpi_attach_data(handle, acpi_gpio_evt_dh,
> -						  evt_pins);
> -			if (ACPI_FAILURE(status)) {
> -				kfree(evt_pins);
> -				evt_pins = NULL;
> -			}
> +			achip->evt_pins = evt_pins;

What about doing INIT_LIST_HEAD(&acpi_gpio->evt_pins) instead (if it's not a
pointer)?

>  		}
>  	}
>  
> @@ -197,30 +198,24 @@ static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
>  
>  /**
>   * acpi_gpiochip_free_interrupts() - Free GPIO _EVT ACPI event interrupts.
> - * @chip:      gpio chip
> + * @achip:      ACPI GPIO chip
>   *
>   * Free interrupts associated with the _EVT method for the given GPIO chip.
>   *
>   * The remaining ACPI event interrupts associated with the chip are freed
>   * automatically.
>   */
> -static void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
> +static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *achip)



>  {
> -	acpi_handle handle;
> -	acpi_status status;
>  	struct list_head *evt_pins;
>  	struct acpi_gpio_evt_pin *evt_pin, *ep;
> +	struct gpio_chip *chip = achip->chip;
>  
> -	if (!chip->dev || !chip->to_irq)
> -		return;
> -
> -	handle = ACPI_HANDLE(chip->dev);
> -	if (!handle)
> +	if (!chip->dev || !chip->to_irq || !achip->evt_pins)
>  		return;
>  
> -	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
> -	if (ACPI_FAILURE(status))
> -		return;
> +	evt_pins = achip->evt_pins;
> +	achip->evt_pins = NULL;
>  
>  	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
>  		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
> @@ -228,7 +223,6 @@ static void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
>  		kfree(evt_pin);
>  	}
>  
> -	acpi_detach_data(handle, acpi_gpio_evt_dh);
>  	kfree(evt_pins);
>  }
>  
> @@ -312,10 +306,51 @@ struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
>  
>  void acpi_gpiochip_add(struct gpio_chip *chip)
>  {
> -	acpi_gpiochip_request_interrupts(chip);
> +	struct acpi_gpio_chip *achip;
> +	acpi_handle handle;
> +	acpi_status status;
> +
> +	handle = ACPI_HANDLE(chip->dev);
> +	if (!handle)
> +		return;
> +
> +	achip = kzalloc(sizeof(*achip), GFP_KERNEL);
> +	if (!achip) {
> +		dev_err(chip->dev,
> +			"Failed to allocate memory for ACPI GPIO chip\n");
> +		return;
> +	}
> +
> +	achip->chip = chip;
> +
> +	status = acpi_attach_data(handle, acpi_gpio_chip_dh, achip);

To be honest, I'd prefer that to be associated with struct acpi_device rather
than with the handle, but that's not a big deal for now.

> +	if (ACPI_FAILURE(status)) {
> +		dev_err(chip->dev, "Failed to attach ACPI GPIO chip\n");
> +		kfree(achip);
> +		return;
> +	}
> +
> +	acpi_gpiochip_request_interrupts(achip);
>  }
>  
>  void acpi_gpiochip_remove(struct gpio_chip *chip)
>  {
> -	acpi_gpiochip_free_interrupts(chip);
> +	struct acpi_gpio_chip *achip;
> +	acpi_handle handle;
> +	acpi_status status;
> +
> +	handle = ACPI_HANDLE(chip->dev);
> +	if (!handle)
> +		return;
> +
> +	status = acpi_get_data(handle, acpi_gpio_chip_dh, (void **)&achip);
> +	if (ACPI_FAILURE(status)) {
> +		dev_warn(chip->dev, "Failed to retrieve ACPI GPIO chip\n");
> +		return;
> +	}
> +
> +	acpi_gpiochip_free_interrupts(achip);
> +
> +	acpi_detach_data(handle, acpi_gpio_chip_dh);
> +	kfree(achip);
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
