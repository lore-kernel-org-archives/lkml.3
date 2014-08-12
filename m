Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaHLOrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:47:48 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:36817 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaHLOro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:47:44 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 12 Aug 2014 16:46:25 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: gregkh@linuxfoundation.org, jhovold@gmail.com, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140812144625.GB9799@localhost>
References: <20140809052828.GA28307@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809052828.GA28307@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 01:28:28PM +0800, Wang YanQing wrote:
> PL2303 USB Serial devices always has GPIOs,

Always? Are you sure? It's probably better to write "might have" as they
are unlikely to be accessible even if the pins exist.

> this patch add
> generic gpio support interfaces for pl2303 USB Serial devices
> in pl2303_type_data and pl2303_serial_private, then use them

No need to mention these implementation details.

> to add GPIOs support for one type of them, PL2303HXA.
> 
> Known issue:
> If gpios are in use(export to userspace through sysfs interface, etc),
> then call pl2303_release(unplug usb-serial convertor, modprobe -r, etc),
> will cause trouble, so we need to make sure there is no gpio user before
> call pl2303_release.

This is a real problem that we need to address. gpiolib isn't really
able to handle devices that just disappear. In fact, it's API claims that
we must not call gpiochip_remove with requested gpios and this is
exactly what you might do in pl2303hx_gpio_release below.

As I mentioned earlier, this crashes the kernel when a new gpiochip is
later added (the gpiochip data structures are likely corrupted and we
get a NULL pointer deref in gpiochip_find_base).

Linus, any thoughts on this?

> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  Changes 
>  v6-v7:
>  1: add generic gpio support interfaces for pl2303 USB Serial devices
>     in pl2303_type_data and pl2303_serial_private suggested by Andreas Mohr.
>  2: drop different label names for different pl2303 instance suggested by Johan Hovold.
>  3: fix missing lock corrected by Johan Hovold.
>  4: use prefix pl2303hx_gpio instead pl2303_gpio, pl2303_gpio is over generic for current code,
>     and now we move gpio_startup|gpio_release into type-specified data structure, so pl2303hx_gpio
>     is a better prefix.

I'm not sure that was such a good idea. More below.

>  5: make words in Kconfig a little more useful and clarified.
>  6: many misc code quality enhancement suggested by Johan Hovold.
> 
>  v5-v6:
>  1: fix typo error in Kconfig reported by Andreas Mohr 
>  2: add const qulification to gpio_dir_mask and gpio_value_mask suggested by Andreas Mohr
> 
>  v4-v5:
>  1: fix gpio_chip.lable been overwrited by template_chip. 
>  2: use idr to manage minor instead of crude monotonous atomic increment. 
> 
>  v3-v4:
>  1: fix missing static for gpio_dir_mask and gpio_value_mask 
>  2: reduce unneeded compile macro defined suggested by gnomes@lxorguk.ukuu.org.uk 
>  3: use true instead of 1 corrected by Linus Walleij
>  4: ignore return value of gpiochip_remove suggested by Linus Walleij
>  5: fix multi gpio_chips registered by pl2303 can't be distinguished in kernel space. 
> 
>  v2-v3:
>  1: fix errors and warnings reported by Daniele Forsi checked with checkpatch.pl 
>  2: fix missing GPIOLIB dependence in Kconfig 
>  3: fix pl2303_gpio_get can't work 
> 
>  v1-v2:  
>  1:drop gpio-pl2303.c and relation stuff 
>  2:hang gpio stuff off of pl2303.c  
> 
>  drivers/usb/serial/Kconfig  |  10 +++
>  drivers/usb/serial/pl2303.c | 202 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 212 insertions(+)
> 
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> index 3ce5c74..008ec57 100644
> --- a/drivers/usb/serial/Kconfig
> +++ b/drivers/usb/serial/Kconfig
> @@ -516,6 +516,16 @@ config USB_SERIAL_PL2303
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called pl2303.
>  
> +config USB_SERIAL_PL2303_GPIO
> +	bool "USB Prolific 2303 Single Port GPIOs support"
> +	depends on USB_SERIAL_PL2303 && GPIOLIB
> +	---help---
> +	  Say Y here if you want to use GPIOs on PL2303 USB Serial single port
> +	  adapter from Prolific.
> +
> +	  It supports 2 dedicated GPIOs on PL2303HXA only currently.
> +	  If unsure, say N.
> +
>  config USB_SERIAL_OTI6858
>  	tristate "USB Ours Technology Inc. OTi-6858 USB To RS232 Bridge Controller"
>  	help
> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> index b3d5a35..edbe634 100644
> --- a/drivers/usb/serial/pl2303.c
> +++ b/drivers/usb/serial/pl2303.c
> @@ -28,6 +28,8 @@
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
>  #include <asm/unaligned.h>
> +#include <linux/gpio.h>
> +#include <linux/mutex.h>
>  #include "pl2303.h"
>  
>  
> @@ -131,6 +133,8 @@ MODULE_DEVICE_TABLE(usb, id_table);
>  #define UART_OVERRUN_ERROR		0x40
>  #define UART_CTS			0x80
>  
> +#define PL2303HX_REG_GPIO_CONTROL	0x01
> +#define PL2303HX_REG_GPIO_STATE	0x81
>  
>  enum pl2303_type {
>  	TYPE_01,	/* Type 0 and 1 (difference unknown) */
> @@ -141,11 +145,15 @@ enum pl2303_type {
>  struct pl2303_type_data {
>  	speed_t max_baud_rate;
>  	unsigned long quirks;
> +	u16 ngpio;

u8 should be enough.

> +	int (*gpio_startup)(struct usb_serial *serial);
> +	void (*gpio_release)(struct usb_serial *serial);

This isn't the right place for this abstraction. Most of the setup code
would be common for any device type with GPIOs.

Just keep the generic gpio_startup and release from v6, and verify that
ngpio > 0. Any further abstraction should only be added once we know how
the other types handles GPIOs.

>  };
>  
>  struct pl2303_serial_private {
>  	const struct pl2303_type_data *type;
>  	unsigned long quirks;
> +	void *gpio;

No void pointers, please.

>  };
>  
>  struct pl2303_private {
> @@ -156,11 +164,24 @@ struct pl2303_private {
>  	u8 line_settings[7];
>  };
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +static int pl2303hx_gpio_startup(struct usb_serial *serial);
> +static void pl2303hx_gpio_release(struct usb_serial *serial);
> +#else
> +static inline int pl2303hx_gpio_startup(struct usb_serial *serial) { return 0; }
> +static inline void pl2303hx_gpio_release(struct usb_serial *serial) {}
> +#endif

So rename these back to pl2303_gpio_startup/release again.

Drop the hx suffix you just added from all functions until we have a
need to differentiate the types.

> +
>  static const struct pl2303_type_data pl2303_type_data[TYPE_COUNT] = {
>  	[TYPE_01] = {
>  		.max_baud_rate =	1228800,
>  		.quirks =		PL2303_QUIRK_LEGACY,
>  	},
> +	[TYPE_HX] = {
> +		.ngpio = 2,
> +		.gpio_startup = pl2303hx_gpio_startup,
> +		.gpio_release = pl2303hx_gpio_release,
> +	}
>  };
>  
>  static int pl2303_vendor_read(struct usb_serial *serial, u16 value,
> @@ -213,6 +234,176 @@ static int pl2303_probe(struct usb_serial *serial,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +struct pl2303hx_gpio_data {
> +	/*
> +	 * 0..3: unknown (zero)
> +	 * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
> +	 * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
> +	 * 6: gp0 pin value
> +	 * 7: gp1 pin value
> +	 */
> +	u8 index;

Perhaps index isn't the most descriptive name of this shadow register.
Why not call it ctrl_reg, or similar.

> +	struct mutex lock;
> +	struct usb_serial *serial;
> +	struct gpio_chip gpio_chip;
> +};
> +
> +static inline struct pl2303hx_gpio_data *to_pl2303hx_gpio_data(struct gpio_chip *chip)
> +{
> +	return container_of(chip, struct pl2303hx_gpio_data, gpio_chip);
> +}
> +
> +static u8 pl2303hx_gpio_dir_mask(unsigned offset)
> +{
> +	switch(offset)
> +	{
> +	case 0:
> +		return 0x10;
> +	case 1:
> +		return 0x20;
> +	default:
> +		break;
> +	};
> +	return 0;
> +}
> +
> +static u8 pl2303hx_gpio_value_mask(unsigned offset)
> +{
> +	switch(offset)
> +	{
> +	case 0:
> +		return 0x40;
> +	case 1:
> +		return 0x80;
> +	default:
> +		break;
> +	};
> +	return 0;
> +}

Use bitshifts rather than switch statements. Perhaps you don't even need
the helpers if you add temporary mask variables.

> +
> +static int pl2303hx_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct pl2303hx_gpio_data *gpio = to_pl2303hx_gpio_data(chip);
> +	int ret;
> +
> +	mutex_lock(&gpio->lock);
> +	gpio->index &= ~pl2303hx_gpio_dir_mask(offset);
> +	ret = pl2303_vendor_write(gpio->serial, PL2303HX_REG_GPIO_CONTROL, gpio->index);

This line is too long.

Apparently you did not run checkpatch on v7 because there are a whole
bunch of warning and errors now.

> +	mutex_unlock(&gpio->lock);
> +
> +	return ret;
> +}
> +
> +static int pl2303hx_gpio_direction_out(struct gpio_chip *chip,
> +				unsigned offset, int value)
> +{
> +	struct pl2303hx_gpio_data *gpio = to_pl2303hx_gpio_data(chip);
> +	int ret;
> +
> +	mutex_lock(&gpio->lock);
> +	gpio->index |= pl2303hx_gpio_dir_mask(offset);
> +	if (value)
> +		gpio->index |= pl2303hx_gpio_value_mask(offset);
> +	else
> +		gpio->index &= ~pl2303hx_gpio_value_mask(offset);
> +
> +	ret = pl2303_vendor_write(gpio->serial, PL2303HX_REG_GPIO_CONTROL, gpio->index);
> +	mutex_unlock(&gpio->lock);
> +
> +	return ret;
> +}
> +
> +static void pl2303hx_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct pl2303hx_gpio_data *gpio = to_pl2303hx_gpio_data(chip);
> +
> +	mutex_lock(&gpio->lock);
> +	if (value)
> +		gpio->index |= pl2303hx_gpio_value_mask(offset);
> +	else
> +		gpio->index &= ~pl2303hx_gpio_value_mask(offset);
> +
> +	pl2303_vendor_write(gpio->serial, PL2303HX_REG_GPIO_CONTROL, gpio->index);
> +	mutex_unlock(&gpio->lock);
> +}
> +
> +static int pl2303hx_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct pl2303hx_gpio_data *gpio = to_pl2303hx_gpio_data(chip);
> +	unsigned char *buf;
> +	int value = 0;

No need to initialise.

> +
> +	buf = kmalloc(1, GFP_KERNEL);
> +	if (!buf) {
> +		return -ENOMEM;
> +	}

No braces.

> +
> +	mutex_lock(&gpio->lock);
> +	if (pl2303_vendor_read(gpio->serial, PL2303HX_REG_GPIO_STATE, buf)) {

Please use a temporary variable for the returned status (e.g. int res)
rather than calling vendor read from within the if construct.

> +		mutex_unlock(&gpio->lock);
> +		return -EIO;
> +	}
> +
> +	value = buf[0] & pl2303hx_gpio_value_mask(offset);
> +	mutex_unlock(&gpio->lock);
> +	kfree(buf);
> +
> +	return value;
> +}
> +
> +static int pl2303hx_gpio_startup(struct usb_serial *serial)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +	struct pl2303hx_gpio_data *gpio;
> +	int ret;
> +
> +	gpio = kzalloc(sizeof(struct pl2303hx_gpio_data), GFP_KERNEL);
> +	if (!gpio) {
> +		dev_err(&serial->interface->dev,
> +			"Failed to allocate pl2303_gpio_data\n");

No need to print an error message on failed allocations as this has
already been taken care of.

> +		return -ENOMEM;
> +	}
> +
> +	gpio->index = 0x00;
> +	gpio->serial = serial;
> +	mutex_init(&gpio->lock);
> +
> +	gpio->gpio_chip.label = "pl2303";
> +	gpio->gpio_chip.owner = THIS_MODULE;
> +	gpio->gpio_chip.direction_input = pl2303hx_gpio_direction_in;
> +	gpio->gpio_chip.get = pl2303hx_gpio_get;
> +	gpio->gpio_chip.direction_output = pl2303hx_gpio_direction_out;
> +	gpio->gpio_chip.set = pl2303hx_gpio_set;
> +	gpio->gpio_chip.can_sleep  = true;
                                  ^
Runaway whitespace.

> +	gpio->gpio_chip.ngpio = spriv->type->ngpio;
> +	gpio->gpio_chip.base = -1;
> +	gpio->gpio_chip.dev = &serial->interface->dev;
> +
> +	/* initialize GPIOs, input mode as default */
> +	pl2303_vendor_write(gpio->serial, PL2303HX_REG_GPIO_CONTROL, gpio->index);
> +
> +	ret = gpiochip_add(&gpio->gpio_chip);
> +	if (ret < 0) {
> +		dev_err(&serial->interface->dev,
> +			"Could not register gpiochip, %d\n", ret);
> +		kfree(gpio);
> +		return ret;
> +	}
> +	spriv->gpio = gpio;
> +	return 0;
> +}
> +
> +static void pl2303hx_gpio_release(struct usb_serial *serial)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +	struct pl2303hx_gpio_data *gpio = (struct pl2303hx_gpio_data *)spriv->gpio;
> +
> +	gpiochip_remove(&gpio->gpio_chip);

So this will corrupt the gpiolib structures if there are requested /
exported gpios.

> +	kfree(gpio);
> +}
> +#endif
> +
>  static int pl2303_startup(struct usb_serial *serial)
>  {
>  	struct pl2303_serial_private *spriv;
> @@ -262,6 +453,15 @@ static int pl2303_startup(struct usb_serial *serial)
>  
>  	kfree(buf);
>  
> +	if (spriv->type->ngpio > 0) {
> +		int ret;

Please declare all variables at the start of the function.

> +
> +		ret = spriv->type->gpio_startup(serial);

So call pl2303_gpio_startup() here and check ngpio in that function.

> +		if (ret) {
> +			kfree(spriv);
> +			return ret;
> +		}
> +	}
>  	return 0;
>  }
>  
> @@ -269,6 +469,8 @@ static void pl2303_release(struct usb_serial *serial)
>  {
>  	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
>  
> +	if (spriv->type->ngpio > 0)
> +		spriv->type->gpio_release(serial);

Call pl2303_gpio_release() and check ngpio there.

>  	kfree(spriv);
>  }

Thanks,
Johan
