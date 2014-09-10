Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaIJICB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:02:01 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:61434 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaIJIB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:01:58 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 10 Sep 2014 09:59:58 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140910075958.GD2974@localhost>
References: <20140831152456.GA25207@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831152456.GA25207@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 11:24:56PM +0800, Wang YanQing wrote:
> PL2303 USB Serial devices may has GPIOs, this patch add
> basic PL2303 gpio support.
> 
> Known issue:
> If gpios are in use(export to userspace through sysfs interface, etc),
> then call pl2303_release(unplug usb-serial convertor, modprobe -r, etc),
> will cause trouble, so we need to make sure there is no gpio user before
> call pl2303_release.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  Note: I sniffed office HXD gpio test program to get 
>        gpios control protocol with PL2303 RA, so I only
>        test it with PL2303 RA and HXA, I don't have HXD,
>        but because it is *office* HXD gpio test program,
>        so if it doesn't work with HXD, I will feel surprise.

Nice.

That should be ok as long as you can test it with RA and the official
driver treats them the same (and perhaps someone else could do the HXD
testing?).

> 
>  Changes
>  v7-v8:
>  1: add support for four dedicated gpios on HXD and RA
>  2: fix problem reported by Johan Hovold in v7
>  3: fix checkpatch.pl's warning
> 
>  v6-v7:
>  1: add generic gpio support interfaces for pl2303 USB Serial devices
>     in pl2303_type_data and pl2303_serial_private suggested by Andreas Mohr.
>  2: drop different label names for different pl2303 instance suggested by Johan Hovold.
>  3: fix missing lock corrected by Johan Hovold.
>  4: use prefix pl2303hx_gpio instead pl2303_gpio, pl2303_gpio is over generic for current code,
>     and now we move gpio_startup|gpio_release into type-specified data structure, so pl2303hx_gpio
>     is a better prefix.
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
>  drivers/usb/serial/Kconfig  |  11 ++
>  drivers/usb/serial/pl2303.c | 250 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 261 insertions(+)
> 
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> index 3ce5c74..b4e0cf9 100644
> --- a/drivers/usb/serial/Kconfig
> +++ b/drivers/usb/serial/Kconfig
> @@ -516,6 +516,17 @@ config USB_SERIAL_PL2303
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
> +	  It supports 2 dedicated GPIOs on PL2303HXA, 4 dedicated GPIOs on
> +	  PL2303HXD and PL2303RA currently.
> +	  If unsure, say N.
> +
>  config USB_SERIAL_OTI6858
>  	tristate "USB Ours Technology Inc. OTi-6858 USB To RS232 Bridge Controller"
>  	help
> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> index e9bad92..a3f8411 100644
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
> @@ -132,6 +134,22 @@ MODULE_DEVICE_TABLE(usb, id_table);
>  #define UART_OVERRUN_ERROR		0x40
>  #define UART_CTS			0x80
>  
> +#define HXD_GPIO_01_CTRL		0x0001
> +#define HXD_GPIO_01_VALUE		0x0081
> +#define HXD_GPIO_23_DIR_CTRL		0x0c0c
> +#define HXD_GPIO_23_VALUE_CTRL		0x0d0d
> +#define HXD_GPIO_23_VALUE		0x8d8d

These three new wValues look odd. Perhaps the most-significant byte is
ignored? Doesn't matter. :)

I would also suggest naming these registers differently, for example:

	PL2303_GPIO_01_CTRL
	PL2303_GPIO_01_STATUS
	PL2303_GPIO_23_OUTPUT_ENABLE
	PL2303_GPIO_23_OUTPUT
	PL2303_GPIO_23_STATUS

in order to reflect the different semantics for the two sets of
registers (and to use more standardised names).

> +
> +#define HXD_GPIO0_DIR_MASK		0x10
> +#define HXD_GPIO1_DIR_MASK		0x20
> +#define HXD_GPIO2_DIR_MASK		0x03
> +#define HXD_GPIO3_DIR_MASK		0x0c

Do you really need two-bit wide masks?

> +
> +#define HXD_GPIO0_VALUE_MASK		0x40
> +#define HXD_GPIO1_VALUE_MASK		0x80
> +#define HXD_GPIO2_VALUE_MASK		0x01
> +#define HXD_GPIO3_VALUE_MASK		0x02
> +
>  
>  enum pl2303_type {
>  	TYPE_01,	/* Type 0 and 1 (difference unknown) */
> @@ -144,9 +162,12 @@ struct pl2303_type_data {
>  	unsigned long quirks;
>  };
>  
> +struct pl2303_gpio;
>  struct pl2303_serial_private {
>  	const struct pl2303_type_data *type;
>  	unsigned long quirks;
> +	u8 ngpio;

Keep this in the type data as in the last version (more below).

> +	struct pl2303_gpio *gpio;
>  };
>  
>  struct pl2303_private {
> @@ -157,6 +178,14 @@ struct pl2303_private {
>  	u8 line_settings[7];
>  };
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +static int pl2303_gpio_startup(struct usb_serial *serial);
> +static void pl2303_gpio_release(struct usb_serial *serial);
> +#else
> +static inline int pl2303_gpio_startup(struct usb_serial *serial) { return 0; }
> +static inline void pl2303_gpio_release(struct usb_serial *serial) {}
> +#endif
> +
>  static const struct pl2303_type_data pl2303_type_data[TYPE_COUNT] = {
>  	[TYPE_01] = {
>  		.max_baud_rate =	1228800,
> @@ -214,11 +243,213 @@ static int pl2303_probe(struct usb_serial *serial,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +struct pl2303_gpio_desc {
> +	u8 dir_offset;
> +	u8 dir_mask;
> +	u16 dir_ctrl;
> +	u8 value_offset;
> +	u8 value_mask;
> +	u16 value_ctrl;
> +	u16 read_ctrl;
> +};
> +
> +struct pl2303_gpio {
> +	struct pl2303_gpio_desc *descs;
> +	u8 data[3];

I see what you're trying to achieve, but I think this abstraction is
much to opaque. Especially with this data[3].

Keep the three shadow registers ctrl_01, oe_23 and output_23 in the gpio
struct explicitly instead and skip the pl2303_gpio_descs.

All devices we currently know of use the same two sets of registers,
but some only have the first (singleton) set (i.e. HX with two gpios).
Handle this in the gpio callbacks instead for now (e.g. re-introduce the
mask helper functions, but implement them using bit shifts as already
suggested).

> +	struct mutex lock;
> +	struct usb_serial *serial;
> +	struct gpio_chip gpio_chip;
> +};
> +
> +static inline struct pl2303_gpio *to_pl2303_gpio(struct gpio_chip *chip)
> +{
> +	return container_of(chip, struct pl2303_gpio, gpio_chip);
> +}
> +
> +static void pl2303_gpio_add(struct usb_serial *serial, u8 num, u16 read_ctrl,
> +			u8 dir_offset, u8 dir_mask, u16 dir_ctrl,
> +			u8 value_offset, u8 value_mask, u16 value_ctrl)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +	struct pl2303_gpio *gpio = spriv->gpio;
> +
> +	BUG_ON(num >= spriv->ngpio);

Never use BUG_ON in driver code. Handle the error, or make sure it does
not happen.

> +	gpio->descs[num].dir_offset = dir_offset;
> +	gpio->descs[num].dir_mask = dir_mask;
> +	gpio->descs[num].dir_ctrl = dir_ctrl;
> +
> +	gpio->descs[num].value_offset = value_offset;
> +	gpio->descs[num].value_mask = value_mask;
> +	gpio->descs[num].value_ctrl = value_ctrl;
> +
> +	gpio->descs[num].read_ctrl = read_ctrl;
> +}
> +
> +static int pl2303_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +	struct pl2303_gpio_desc *desc;
> +	int ret;
> +
> +	mutex_lock(&gpio->lock);
> +	desc = gpio->descs+offset;
> +	gpio->data[desc->dir_offset] &= ~desc->dir_mask;
> +	ret = pl2303_vendor_write(gpio->serial, desc->dir_ctrl,
> +				gpio->data[desc->dir_offset]);
> +	mutex_unlock(&gpio->lock);
> +
> +	return ret;
> +}
> +
> +static int pl2303_gpio_direction_out(struct gpio_chip *chip,
> +				unsigned offset, int value)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +	struct pl2303_gpio_desc *desc;
> +	int ret;
> +
> +	mutex_lock(&gpio->lock);
> +	desc = gpio->descs+offset;
> +	gpio->data[desc->dir_offset] |= desc->dir_mask;
> +	ret = pl2303_vendor_write(gpio->serial, desc->dir_ctrl,
> +				gpio->data[desc->dir_offset]);
> +	if (ret)
> +		goto error;
> +
> +	if (value)
> +		gpio->data[desc->value_offset] |= desc->value_mask;
> +	else
> +		gpio->data[desc->value_offset] &= ~desc->value_mask;
> +
> +	ret = pl2303_vendor_write(gpio->serial, desc->value_ctrl,
> +				gpio->data[desc->value_offset]);
> +error:
> +	mutex_unlock(&gpio->lock);
> +
> +	return ret;
> +}
> +
> +static void pl2303_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +	struct pl2303_gpio_desc *desc;
> +
> +	mutex_lock(&gpio->lock);
> +	desc = gpio->descs+offset;
> +	if (value)
> +		gpio->data[desc->value_offset] |= desc->value_mask;
> +	else
> +		gpio->data[desc->value_offset] &= ~desc->value_mask;
> +
> +	pl2303_vendor_write(gpio->serial, desc->value_ctrl,
> +			gpio->data[desc->value_offset]);
> +	mutex_unlock(&gpio->lock);
> +}
> +
> +static int pl2303_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +	struct pl2303_gpio_desc *desc;
> +	unsigned char *buf;
> +	int value;
> +
> +	buf = kzalloc(1, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	mutex_lock(&gpio->lock);
> +	desc = gpio->descs+offset;
> +
> +	if (pl2303_vendor_read(gpio->serial, desc->read_ctrl, buf)) {
> +		mutex_unlock(&gpio->lock);
> +		return -EIO;
> +	}
> +
> +	value = buf[0] & desc->value_mask;
> +	mutex_unlock(&gpio->lock);
> +	kfree(buf);
> +
> +	return value;
> +}
> +
> +static int pl2303_gpio_startup(struct usb_serial *serial)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +	struct pl2303_gpio *gpio;
> +	int ret;
> +
> +	gpio = kzalloc(sizeof(struct pl2303_gpio), GFP_KERNEL);
> +	if (!gpio)
> +		return -ENOMEM;
> +
> +	gpio->descs = kcalloc(spriv->ngpio, sizeof(struct pl2303_gpio_desc),
> +			GFP_KERNEL);
> +	if (!gpio->descs) {
> +		kfree(gpio);
> +		return -ENOMEM;
> +	}
> +	spriv->gpio = gpio;
> +
> +	pl2303_gpio_add(serial, 0, HXD_GPIO_01_VALUE,
> +			0, HXD_GPIO0_DIR_MASK, HXD_GPIO_01_CTRL,
> +			0, HXD_GPIO0_VALUE_MASK, HXD_GPIO_01_CTRL);
> +	pl2303_gpio_add(serial, 1, HXD_GPIO_01_VALUE,
> +			0, HXD_GPIO1_DIR_MASK, HXD_GPIO_01_CTRL,
> +			0, HXD_GPIO1_VALUE_MASK, HXD_GPIO_01_CTRL);
> +
> +	if (spriv->ngpio == 4) {
> +		pl2303_gpio_add(serial, 2, HXD_GPIO_23_VALUE,
> +				1, HXD_GPIO2_DIR_MASK, HXD_GPIO_23_DIR_CTRL,
> +				2, HXD_GPIO2_VALUE_MASK,
> +				HXD_GPIO_23_VALUE_CTRL);
> +		pl2303_gpio_add(serial, 3, HXD_GPIO_23_VALUE,
> +				1, HXD_GPIO3_DIR_MASK, HXD_GPIO_23_DIR_CTRL,
> +				2, HXD_GPIO3_VALUE_MASK,
> +				HXD_GPIO_23_VALUE_CTRL);
> +	}
> +
> +	gpio->serial = serial;
> +	mutex_init(&gpio->lock);
> +
> +	gpio->gpio_chip.label = "pl2303";
> +	gpio->gpio_chip.owner = THIS_MODULE;
> +	gpio->gpio_chip.direction_input = pl2303_gpio_direction_in;
> +	gpio->gpio_chip.get = pl2303_gpio_get;
> +	gpio->gpio_chip.direction_output = pl2303_gpio_direction_out;

Why not keep direction_{in,out} together?

> +	gpio->gpio_chip.set = pl2303_gpio_set;
> +	gpio->gpio_chip.can_sleep  = true;

I already mentioned the stray     ^ whitespace here I believe.

> +	gpio->gpio_chip.ngpio = spriv->ngpio;
> +	gpio->gpio_chip.base = -1;
> +	gpio->gpio_chip.dev = &serial->interface->dev;
> +
> +	ret = gpiochip_add(&gpio->gpio_chip);
> +	if (ret < 0) {
> +		kfree(gpio);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static void pl2303_gpio_release(struct usb_serial *serial)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +	struct pl2303_gpio *gpio = (struct pl2303_gpio *)spriv->gpio;

No need to cast.

> +
> +	gpiochip_remove(&gpio->gpio_chip);
> +	kfree(gpio->descs);
> +	kfree(gpio);
> +}
> +#endif
> +
>  static int pl2303_startup(struct usb_serial *serial)
>  {
>  	struct pl2303_serial_private *spriv;
>  	enum pl2303_type type = TYPE_01;
>  	unsigned char *buf;
> +	u16 bcdDevice;
> +	u8 major_revision;
> +	int ret;
>  
>  	spriv = kzalloc(sizeof(*spriv), GFP_KERNEL);
>  	if (!spriv)
> @@ -244,6 +475,16 @@ static int pl2303_startup(struct usb_serial *serial)
>  	spriv->quirks = (unsigned long)usb_get_serial_data(serial);
>  	spriv->quirks |= spriv->type->quirks;
>  
> +	spriv->ngpio = 0;
> +	if (type == TYPE_HX) {
> +		bcdDevice = le16_to_cpu(serial->dev->descriptor.bcdDevice);
> +		major_revision = bcdDevice = bcdDevice >> 8;
> +		if (major_revision == 3)
> +			spriv->ngpio = 2;
> +		else if (major_revision == 4)
> +			spriv->ngpio = 4;
> +	}

This should be implemented as a new device type. Split the current
TYPE_HX into TYPE_HX and TYPE_HXD and store the number of gpios along
with the type data as in previous versions of the patch.

And please do this on top of the usb-next branch of my tree

	git://git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial.git

as there have been some updates related to the TYPE_HX.

> +
>  	usb_set_serial_data(serial, spriv);
>  
>  	pl2303_vendor_read(serial, 0x8484, buf);
> @@ -263,6 +504,13 @@ static int pl2303_startup(struct usb_serial *serial)
>  
>  	kfree(buf);
>  
> +	if (spriv->ngpio > 0) {

Move the ngpio check to pl2303_gpio_startup as most devices will have
gpios (or it's compiled out).

> +		ret = pl2303_gpio_startup(serial);
> +		if (ret) {
> +			kfree(spriv);
> +			return ret;
> +		}
> +	}
>  	return 0;
>  }
>  
> @@ -270,6 +518,8 @@ static void pl2303_release(struct usb_serial *serial)
>  {
>  	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
>  
> +	if (spriv->ngpio > 0)

Same here.

> +		pl2303_gpio_release(serial);
>  	kfree(spriv);
>  }

Thanks,
Johan
