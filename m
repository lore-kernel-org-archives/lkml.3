Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3INAKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:10:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:22728 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab3INAKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:10:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,901,1371106800"; 
   d="scan'208";a="294685497"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Thread-Topic: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Thread-Index: AQHOsJQAl34IB1lxyU2PFiwcEyBhepnEW9mA
Date: Sat, 14 Sep 2013 00:10:37 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880246367A@SHSMSX101.ccr.corp.intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
 <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Mika Westerberg
> Sent: Friday, September 13, 2013 11:15 PM
> 
> GPIO operation regions is a new feature introduced in ACPI 5.0
> specification. In practise it means that now ASL code can toggle GPIOs with
> the help of the OS GPIO driver.
> 
> An imaginary example of such ASL code:
> 
> 	Device (\SB.GPIO)
> 	{
> 		// _REG is called when the operation region handler is
> 		// installed.
> 		Method (_REG)
> 		{
> 			...
> 		}
> 
> 		OperationRegion (GPOP, GeneralPurposeIo, 0, 0xc)
> 		Field (GPOP, ByteAcc, NoLock, Preserve)
> 		{
> 			Connection
> 			(
> 	                    GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
> 				    IoRestrictionOutputOnly, "\\_SB.GPIO",
> 				    0x00, ResourceConsumer,,)
> 				{
> 				    0x0005
> 				}
> 			),
> 			PWR0, 1
> 		}
> 
> 		...
> 	}
> 
> 	Device (\SB.DEV0)
> 	{
> 		...
> 
> 		Method (_PS0, 0, Serialized)
> 		{
> 			// Toggle the GPIO
> 			Store (1, \SB.GPIO.PWR0)
> 		}
> 
> 		Method (_PS3, 0, Serialized)
> 		{
> 			Store (0, \SB.GPIO.PRW0)
> 		}
> 	}
> 
> The device \SB.DEV0 is powered on by asserting \SB.GPIO.PWR0 GPIO line. So
> when the OS calls _PS0 or _PS3, that GPIO line should be set to 1 or 0 by
> the actual GPIO driver.
> 
> In order to support GPIO operation regions we install ACPI address space
> handler for the device (provided that it has an ACPI handle). This handler
> uses the standard GPIO APIs to toggle the pin according to what the ASL
> code does.
> 
> Since there is need to attach more data to the ACPI object, we create a new
> structure acpi_gpio_chip_data that contains data for both GPIO operation
> regions and for ACPI event handling and make the event handling code to use
> this new structure.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/gpio/gpiolib-acpi.c | 131 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 126 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index e12a08e..f52536a 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -24,6 +24,17 @@ struct acpi_gpio_evt_pin {
>  	unsigned int irq;
>  };
> 
> +struct acpi_gpio_chip_data {
> +	/*
> +	 * acpi_install_address_space_handler() wants to put the connection
> +	 * information at the start of the context structure we pass it, in
> +	 * case we are dealing with GPIO operation regions.
> +	 */
> +	struct acpi_connection_info ci;
> +	struct gpio_chip *chip;
> +	struct list_head *evt_pins;
> +};
> +
>  static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
>  {
>  	if (!gc->dev)
> @@ -86,7 +97,7 @@ static irqreturn_t acpi_gpio_irq_handler_evt(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
> 
> -static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
> +static void acpi_gpio_chip_dh(acpi_handle handle, void *data)
>  {
>  	/* The address of this function is used as a key. */
>  }
> @@ -127,12 +138,16 @@ static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
>  	if (ACPI_SUCCESS(status)) {
>  		evt_pins = kzalloc(sizeof(*evt_pins), GFP_KERNEL);
>  		if (evt_pins) {
> +			struct acpi_gpio_chip_data *data;
> +
>  			INIT_LIST_HEAD(evt_pins);
> -			status = acpi_attach_data(handle, acpi_gpio_evt_dh,
> -						  evt_pins);
> +			status = acpi_get_data(handle, acpi_gpio_chip_dh,
> +					       (void **)&data);
>  			if (ACPI_FAILURE(status)) {
>  				kfree(evt_pins);
>  				evt_pins = NULL;
> +			} else {
> +				data->evt_pins = evt_pins;
>  			}
>  		}
>  	}
> @@ -293,6 +308,7 @@ static void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
>  	acpi_status status;
>  	struct list_head *evt_pins;
>  	struct acpi_gpio_evt_pin *evt_pin, *ep;
> +	struct acpi_gpio_chip_data *data;
> 
>  	if (!chip->dev || !chip->to_irq)
>  		return;
> @@ -301,28 +317,133 @@ static void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
>  	if (!handle)
>  		return;
> 
> -	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
> +	status = acpi_get_data(handle, acpi_gpio_chip_dh, (void **)&data);
>  	if (ACPI_FAILURE(status))
>  		return;
> 
> +	evt_pins = data->evt_pins;
> +	data->evt_pins = NULL;
> +
>  	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
>  		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
>  		list_del(&evt_pin->node);
>  		kfree(evt_pin);
>  	}
> 
> -	acpi_detach_data(handle, acpi_gpio_evt_dh);
>  	kfree(evt_pins);
>  }
> 
> +static acpi_status
> +acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
> +			    u32 bits, u64 *value, void *handler_context,
> +			    void *reqion_context)
> +{
> +	struct acpi_gpio_chip_data *data = handler_context;
> +	struct gpio_chip *chip = data->chip;
> +	struct acpi_resource *ares;
> +	int ret, gpio = -EINVAL;
> +	unsigned long flags = 0;
> +	acpi_status status;
> +
> +	status = acpi_buffer_to_resource(data->ci.connection, data->ci.length,
> +					 &ares);
> +	if (ACPI_FAILURE(status))
> +		return status;
> +
> +	if (ares->type == ACPI_RESOURCE_TYPE_GPIO) {
> +		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
> +
> +		switch (agpio->io_restriction) {
> +		case ACPI_IO_RESTRICT_NONE:
> +			flags = GPIOF_DIR_IN | GPIOF_DIR_OUT;
> +			break;
> +		case ACPI_IO_RESTRICT_INPUT:
> +			flags = GPIOF_DIR_IN;
> +			break;
> +		case ACPI_IO_RESTRICT_OUTPUT:
> +			flags = GPIOF_DIR_OUT;
> +			break;
> +		}
> +
> +		gpio = acpi_get_gpio(agpio->resource_source.string_ptr,
> +				     agpio->pin_table[0]);
> +	}
> +
> +	ACPI_FREE(ares);
> +
> +	if (!gpio_is_valid(gpio)) {
> +		dev_err(chip->dev, "GpioOpReg: invalid GPIO resource\n");
> +		return AE_ERROR;
> +	}
> +
> +	ret = gpio_request_one(gpio, flags, "acpi_gpio_adr_space");
> +	if (ret) {
> +		dev_err(chip->dev, "GpioOpReg: failed to request GPIO\n");
> +		return AE_ERROR;
> +	}
> +
> +	if (function == ACPI_WRITE)
> +		gpio_set_value(gpio, (int)*value);
> +	else
> +		*value = gpio_get_value(gpio);
> +
> +	gpio_free(gpio);
> +	return AE_OK;
> +}
> +
>  void acpi_gpiochip_add(struct gpio_chip *chip)
>  {
> +	struct acpi_gpio_chip_data *data;
> +	acpi_handle handle;
> +	acpi_status status;
> +
> +	handle = ACPI_HANDLE(chip->dev);
> +	if (!handle)
> +		return;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return;
> +
> +	status = acpi_attach_data(handle, acpi_gpio_chip_dh, data);
> +	if (ACPI_FAILURE(status)) {
> +		kfree(data);
> +		return;
> +	}
> +
> +	data->chip = chip;
> +
> +	status = acpi_install_address_space_handler(handle, ACPI_ADR_SPACE_GPIO,
> +						    acpi_gpio_adr_space_handler,
> +						    NULL, data);

Is it possible to install the handler for ACPI_ROOT_OBJECT?
Can it be achieved by implementing a setup callback?
Maybe you can also eliminate acpi_attach_data usages by doing so.

> +	if (ACPI_FAILURE(status)) {
> +		acpi_detach_data(handle, acpi_gpio_chip_dh);
> +		kfree(data);
> +		return;
> +	}
> +
>  	acpi_gpiochip_request_interrupts(chip);
>  }
>  EXPORT_SYMBOL_GPL(acpi_gpiochip_add);
> 
>  void acpi_gpiochip_remove(struct gpio_chip *chip)
>  {
> +	struct acpi_gpio_chip_data *data;
> +	acpi_handle handle;
> +	acpi_status status;
> +
> +	handle = ACPI_HANDLE(chip->dev);
> +	if (!handle)
> +		return;
> +
> +	status = acpi_get_data(handle, acpi_gpio_chip_dh, (void **)&data);
> +	if (ACPI_FAILURE(status))
> +		return;
> +
>  	acpi_gpiochip_free_interrupts(chip);
> +	acpi_remove_address_space_handler(handle, ACPI_ADR_SPACE_GPIO,
> +					  acpi_gpio_adr_space_handler);
> +	acpi_detach_data(handle, acpi_gpio_chip_dh);
> +	kfree(data);
>  }
>  EXPORT_SYMBOL_GPL(acpi_gpiochip_remove);
> --
> 1.8.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
