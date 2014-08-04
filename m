Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaHDOBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:01:54 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:42370 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaHDOBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:01:52 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 4 Aug 2014 16:00:32 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140804140032.GA25529@localhost>
References: <20140729165709.GA3380@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729165709.GA3380@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 12:57:09AM +0800, Wang YanQing wrote:
> PL2303HX has two GPIOs, this patch add interface for it.

In fact, PL2303HX (rev D) has four dedicated GPIOs (and an additional
four multiplexed ones).

Even if we do not know how to use the other two at this time, we should
not be hard coding that limitation in the driver as is done below.

> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  Changes v5-v6:
>  1: fix typo error in Kconfig reported by Andreas Mohr
>  2: add const qulification to gpio_dir_mask and gpio_value_mask
>  suggested by Andreas Mohr

Please include the full changelog for all revisions when you resubmit.

>  Hi, Linus Walleij, I see you give your review-by to v4, but v4
>  has a obvious bug (template_chip overwrite label's value), so
>  could you review this version? Thanks!
> 
>  Greg KH, although I really hope this is the last version, 
>  but what is your suggestion?
>  
>  Thanks again for all guys' review and correction.

Also, in some previous versions you mentioned "known issues" related to
disconnect. Why did you drop that comment? Things still blow up if I
export a gpio and then disconnect and reconnect the device.

I think this is a limitation (bug?) in gpiolib, but still:

[  318.317352] Unable to handle kernel NULL pointer dereference at virtual address 00000030
[  318.317413] pgd = c0004000
[  318.317443] [00000030] *pgd=00000000
[  318.317504] Internal error: Oops: 17 [#1] PREEMPT ARM
[  318.317565] Modules linked in: pl2303 usbserial netconsole
[  318.317687] CPU: 0 PID: 16 Comm: khubd Tainted: G        W     3.16.0-rc5 #1
[  318.317718] task: df2b7480 ti: df2b8000 task.ti: df2b8000
[  318.317779] PC is at gpiochip_add+0x1c0/0x36c
[  318.317810] LR is at _raw_spin_lock_irqsave+0x60/0x6c
[  318.317840] pc : [<c0236a70>]    lr : [<c042b444>]    psr: 000f0093
[  318.317840] sp : df2b99f8  ip : df2b99c8  fp : df2b9a24
[  318.317901] r10: df4ca000  r9 : 00000001  r8 : fffffffd
[  318.317932] r7 : c06aec30  r6 : a00f0013  r5 : c06aec98  r4 : df3c028c
[  318.317962] r3 : fffffff4  r2 : 00000000  r1 : ffffffff  r0 : 00000002
[  318.317993] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  318.318023] Control: 10c5387d  Table: 9f4f4019  DAC: 00000015
[  318.318054] Process khubd (pid: 16, stack limit = 0xdf2b8240)
[  318.318084] Stack: (0xdf2b99f8 to 0xdf2ba000)
[  318.318206] 99e0:                                                       00000000 00000000
[  318.318237] 9a00: 00000064 df3c0580 df4127c0 00000000 df3c0280 df412800 df2b9a54 df2b9a28
[  318.318298] 9a20: bf016764 c02368bc 000000d0 df3c0400 df410068 bf017608 df410068 0000000a
[  318.318328] 9a40: df3c0580 df3c0584 df2b9b54 df2b9a58 bf006328 bf01649c df2b78c8 00000000
[  318.318359] 9a60: c06a8900 df2b78c8 00000001 bf017608 00000001 bf009d98 00000000 df410068
[  318.318420] 9a80: 00000001 00000001 bf017608 df419c00 df2b9b08 df419c20 df410000 df4ca28c
[  318.318450] 9aa0: bf017608 df2b9aa8 df3c0400 df2b9ab8 00000001 df2b8018 c0429dc4 df2b7480
[  318.318511] 9ac0: 00000001 c0429e6c df2b9af4 df2b9ad8 c0076e6c c0076cd8 df3a9cc0 df3a9ce4
[  318.318542] 9ae0: 600f0013 df2b8008 df3c0460 df2b9af8 c0076f58 c0076d6c df2b9b2c df2b9b08
[  318.318572] 9b00: c0429dc4 c0076f50 df3c0430 df346000 00000000 df3c0810 df419c20 bf016be4
[  318.318634] 9b20: df2b9b3c df2b9b30 c0429e6c df410068 df410000 df3c0810 df419c20 bf016be4
[  318.318664] 9b40: 00000000 00000000 df2b9b8c df2b9b58 c03054f4 bf005704 c016b40c df419c00
[  318.318725] 9b60: df2b9b8c c0ea6ef0 df419c20 c06d26c0 00000000 df3c0810 c06baf80 00000007
[  318.318756] 9b80: df2b9bc4 df2b9b90 c028225c c0305344 00000000 df3c0810 df419c00 df3c0810
[  318.318817] 9ba0: df419c20 c02824bc df410068 00000000 c06baf80 00000001 df2b9bdc df2b9bc8
[  318.318847] 9bc0: c028250c c028211c 00000000 df419c20 df2b9c04 df2b9be0 c0280330 c02824c8
[  318.318878] 9be0: df2958d8 df4cfe94 df410068 df419c20 df419c54 c06baf98 df2b9c24 df2b9c08
[  318.318939] 9c00: c028209c c02802d4 df295800 df419c28 df419c20 c06baf98 df2b9c44 df2b9c28
[  318.318969] 9c20: c0281508 c0282020 df2b7480 df419c28 df419c20 00000000 df2b9c7c df2b9c48
[  318.319030] 9c40: c027f444 c028147c df2b9c64 df2b9c58 c0429e6c c03032c0 00000000 c06d5168
[  318.319061] 9c60: df410068 df419c00 df410000 df40aa50 df2b9d04 df2b9c80 c0303330 c027efec
[  318.319091] 9c80: 00000001 00000000 00000000 00000000 00001388 df418c30 df2b9cbc c016b380
[  318.319152] 9ca0: c06cc133 df346000 00000001 df4e2b80 df410004 00000001 df40aa00 c06bb134
[  318.319183] 9cc0: c06baf98 c03020b4 00000001 df4e2b80 df410068 df40aa50 c016b380 df410000
[  318.319244] 9ce0: 00000001 c06d26c0 00000000 c06bb9e4 c06bac8c 00000007 df2b9d1c df2b9d08
[  318.319274] 9d00: c030d644 c0302d80 c06bb9e4 df410000 df2b9d34 df2b9d20 c0305304 c030d614
[  318.319335] 9d20: c0ea6ef0 df410068 df2b9d6c df2b9d38 c028225c c03052c4 df2b9d5c df2b9d48
[  318.319366] 9d40: c042b558 c06bb9e4 df410068 c02824bc df3ca068 00000000 c06bac8c 00000000
[  318.319396] 9d60: df2b9d84 df2b9d70 c028250c c028211c 00000000 df410068 df2b9dac df2b9d88
[  318.319458] 9d80: c0280330 c02824c8 df2958d8 df297e14 df3ca068 df410068 df41009c c06baf98
[  318.319488] 9da0: df2b9dcc df2b9db0 c028209c c02802d4 df295800 df410070 df410068 c06baf98
[  318.319580] 9dc0: df2b9dec df2b9dd0 c0281508 c0282020 df2b7480 df410070 df410068 00000000
[  318.319641] 9de0: df2b9e24 df2b9df0 c027f444 c028147c 39383120 c000343a df40ac68 0000475b
[  318.319671] 9e00: df410000 df410068 df4e2dc0 df410000 df3ca000 df40ac68 df2b9e64 df2b9e28
[  318.319732] 9e20: c02f8c90 c027efec 00000000 c0076f50 00000007 00000000 00000001 00000000
[  318.319763] 9e40: 00000001 df40da44 df410000 df3ca000 df40ac68 00000000 df2b9f24 df2b9e68
[  318.319793] 9e60: c02fa558 c02f89f4 0000000a c0426b5c df2b9f14 df2b9e80 c0426b5c 00000005
[  318.319854] 9e80: 00000000 c0e9d7d0 c0ea81f4 df346000 00000001 df40da44 df40ac08 c06bacb4
[  318.319885] 9ea0: df40ac7c 00000064 df40ac74 df40ac70 df40ac00 df40dc20 df40da44 df40d808
[  318.319946] 9ec0: c06d47a8 df40dc00 df3ca09c df40ac00 df40d800 df3ca000 df085dfc 01010113
[  318.319976] 9ee0: df2b0001 00000000 df2b7480 c0072ac8 df2b9ef0 df2b9ef0 c02f9c38 df294400
[  318.320037] 9f00: 00000000 00000000 c02f9c38 00000000 00000000 00000000 df2b9fac df2b9f28
[  318.320068] 9f20: c00610b4 c02f9c44 df2b9f44 00000000 c0076f58 00000000 00000000 00000001
[  318.320098] 9f40: dead4ead ffffffff ffffffff c06db8d0 00000000 00000000 c0534520 df2b9f5c
[  318.320159] 9f60: df2b9f5c 00000000 00000001 dead4ead ffffffff ffffffff c06db8d0 00000000
[  318.320190] 9f80: 00000000 c0534520 df2b9f88 df2b9f88 df294400 c0060fcc 00000000 00000000
[  318.320251] 9fa0: 00000000 df2b9fb0 c000f988 c0060fd8 00000000 00000000 00000000 00000000
[  318.320281] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  318.320312] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00410400 80200300
[  318.320404] [<c0236a70>] (gpiochip_add) from [<bf016764>] (pl2303_startup+0x2d4/0x3a0 [pl2303])
[  318.320495] [<bf016764>] (pl2303_startup [pl2303]) from [<bf006328>] (usb_serial_probe+0xc30/0xfe8 [usbserial])
[  318.320587] [<bf006328>] (usb_serial_probe [usbserial]) from [<c03054f4>] (usb_probe_interface+0x1bc/0x2a8)
[  318.320648] [<c03054f4>] (usb_probe_interface) from [<c028225c>] (driver_probe_device+0x14c/0x3ac)
[  318.320709] [<c028225c>] (driver_probe_device) from [<c028250c>] (__device_attach+0x50/0x54)
[  318.320739] [<c028250c>] (__device_attach) from [<c0280330>] (bus_for_each_drv+0x68/0x9c)
[  318.320800] [<c0280330>] (bus_for_each_drv) from [<c028209c>] (device_attach+0x88/0x9c)
[  318.320831] [<c028209c>] (device_attach) from [<c0281508>] (bus_probe_device+0x98/0xbc)
[  318.320892] [<c0281508>] (bus_probe_device) from [<c027f444>] (device_add+0x464/0x584)
[  318.320953] [<c027f444>] (device_add) from [<c0303330>] (usb_set_configuration+0x5bc/0x7f8)
[  318.320983] [<c0303330>] (usb_set_configuration) from [<c030d644>] (generic_probe+0x3c/0x88)
[  318.321044] [<c030d644>] (generic_probe) from [<c0305304>] (usb_probe_device+0x4c/0x80)
[  318.321075] [<c0305304>] (usb_probe_device) from [<c028225c>] (driver_probe_device+0x14c/0x3ac)
[  318.321197] [<c028225c>] (driver_probe_device) from [<c028250c>] (__device_attach+0x50/0x54)
[  318.321228] [<c028250c>] (__device_attach) from [<c0280330>] (bus_for_each_drv+0x68/0x9c)
[  318.321289] [<c0280330>] (bus_for_each_drv) from [<c028209c>] (device_attach+0x88/0x9c)
[  318.321319] [<c028209c>] (device_attach) from [<c0281508>] (bus_probe_device+0x98/0xbc)
[  318.321380] [<c0281508>] (bus_probe_device) from [<c027f444>] (device_add+0x464/0x584)
[  318.321441] [<c027f444>] (device_add) from [<c02f8c90>] (usb_new_device+0x2a8/0x474)
[  318.321472] [<c02f8c90>] (usb_new_device) from [<c02fa558>] (hub_thread+0x920/0x1618)
[  318.321533] [<c02fa558>] (hub_thread) from [<c00610b4>] (kthread+0xe8/0xfc)
[  318.321594] [<c00610b4>] (kthread) from [<c000f988>] (ret_from_fork+0x14/0x20)
[  318.321655] Code: e0608001 e1520005 e242300c 0a000004 (e5921030) 
[  318.321685] ---[ end trace 2c11038b73dcaf4b ]---

>  drivers/usb/serial/Kconfig  |  10 +++
>  drivers/usb/serial/pl2303.c | 189 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 199 insertions(+)
> 
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> index 3ce5c74..f7619f9 100644
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
> +	  Say Y here if you want to use the GPIOs on PL2303 USB Serial single port
> +	  adapter from Prolific.
> +
> +	  It supports 2 GPIOs on PL2303HX currently,
> +	  if unsure, say N.

You can drop the "unsure" bit (or at least split it into two sentences).

> +
>  config USB_SERIAL_OTI6858
>  	tristate "USB Ours Technology Inc. OTi-6858 USB To RS232 Bridge Controller"
>  	help
> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> index b3d5a35..5b78574 100644
> --- a/drivers/usb/serial/pl2303.c
> +++ b/drivers/usb/serial/pl2303.c
> @@ -28,6 +28,8 @@
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
>  #include <asm/unaligned.h>
> +#include <linux/gpio.h>
> +#include <linux/idr.h>
>  #include "pl2303.h"
>  
>  
> @@ -143,9 +145,26 @@ struct pl2303_type_data {
>  	unsigned long quirks;
>  };
>  
> +struct pl2303_gpio {
> +	/*
> +	 * 0..3: unknown (zero)
> +	 * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
> +	 * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
> +	 * 6: gp0 pin value
> +	 * 7: gp1 pin value
> +	 */
> +	u8 index;
> +	u32 minor;
> +	struct usb_serial *serial;
> +	struct gpio_chip gpio_chip;

Will this even compile without GPIOLIB? Just add a forward declaration
of struct pl2303_gpio and move the definition under the ifdef below?

> +};
> +
>  struct pl2303_serial_private {
>  	const struct pl2303_type_data *type;
>  	unsigned long quirks;
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +	struct pl2303_gpio *gpio;
> +#endif
>  };
>  
>  struct pl2303_private {
> @@ -213,6 +232,170 @@ static int pl2303_probe(struct usb_serial *serial,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +#define GPIO_NUM (2)

As mentioned above, do not hard code the number of gpios. There are at
least four gpios on HX (rev D) (and there are other prolific devices out
there with more gpios that we may one day support).

Instead add an ngpio field to the type data (set to 2 for now for
TYPE_HX).

> +static const u8 gpio_dir_mask[GPIO_NUM] = {0x10, 0x20};
> +static const u8 gpio_value_mask[GPIO_NUM] = {0x40, 0x80};

And calculate these masks (perhaps in a helper function) when you need
them instead.

> +static DEFINE_IDR(gpiochip_minor);
> +static DEFINE_MUTEX(gpiochip_lock);

Please add a pl2303_ prefix for these. Nevermind -- these are not needed
(see below).

> +
> +static inline struct pl2303_gpio *to_pl2303_gpio(struct gpio_chip *chip)
> +{
> +	return container_of(chip, struct pl2303_gpio, gpio_chip);
> +}
> +
> +static int pl2303_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +
> +	if (offset >= chip->ngpio)
> +		return -EINVAL;

Is this really needed? I would expect gpiolib to handle that.

> +
> +	gpio->index &= ~gpio_dir_mask[offset];

Locking for index?

> +	pl2303_vendor_write(gpio->serial, 1, gpio->index);

Try to avoid adding further magic constants and use a proper define for
wValue 1 instead (e.g. PL2303_REG_GPIO_CONF).

> +	return 0;
> +}
> +
> +static int pl2303_gpio_direction_out(struct gpio_chip *chip,
> +				unsigned offset, int value)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +
> +	if (offset >= chip->ngpio)
> +		return -EINVAL;
> +
> +	gpio->index |= gpio_dir_mask[offset];
> +	if (value)
> +		gpio->index |= gpio_value_mask[offset];
> +	else
> +		gpio->index &= ~gpio_value_mask[offset];
> +
> +	pl2303_vendor_write(gpio->serial, 1, gpio->index);
> +	return 0;
> +}
> +
> +static void pl2303_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +
> +	if (offset >= chip->ngpio) > +		return;
> +
> +	if (value)
> +		gpio->index |= gpio_value_mask[offset];
> +	else
> +		gpio->index &= ~gpio_value_mask[offset];
> +
> +	pl2303_vendor_write(gpio->serial, 1, gpio->index);
> +}
> +
> +static int pl2303_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct pl2303_gpio *gpio = to_pl2303_gpio(chip);
> +	unsigned char buf[1];

You must allocate the buffer dynamically as some platforms cannot do DMA
to the stack.

> +	int value = 0;
> +
> +	if (offset >= chip->ngpio)
> +		return -EINVAL;
> +
> +	if (pl2303_vendor_read(gpio->serial, 0x0081, buf))
> +		return -EIO;

Another wValue constant that want a define (e.g. PL2303_REG_GPIO_STATE).

> +
> +	value = buf[0] & gpio_value_mask[offset];

I noticed that setting direction to output and setting the gpio high has
no effect on the read-back value (i.e. I still read back 0) for my
pl2303hx (note that my device has no easily accessible gpios so I
haven't verified the actual state of the output pin).

What happens on your system? Is the read-back value still 0, even when
the GPIO output is actually high? Should we return the cached value in
this case?

> +	return value;
> +}
> +
> +static const struct gpio_chip template_chip = {
> +	.owner                  = THIS_MODULE,
> +	.direction_input        = pl2303_gpio_direction_in,
> +	.get                    = pl2303_gpio_get,
> +	.direction_output       = pl2303_gpio_direction_out,
> +	.set                    = pl2303_gpio_set,
> +	.can_sleep              = true,
> +};

Skip this and just set these fields along with the rest in
pl2303_gpio_startup below? (Otherwise, include the constants base and
label above).

> +
> +static int pl2303_gpio_startup(struct usb_serial *serial)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +	char *label;
> +	int ret;
> +	int minor;
> +
> +	if (spriv->type != &pl2303_type_data[TYPE_HX])
> +		return 0;

Please test for number-of-gpios rather than type here (by adding a
ngpio-field to the type data as mentioned above).

> +
> +	spriv->gpio = kzalloc(sizeof(struct pl2303_gpio), GFP_KERNEL);
> +	if (spriv->gpio == NULL) {

Please use ! here and elsewhere for NULL tests.

> +		dev_err(&serial->interface->dev,
> +			"Failed to allocate pl2303_gpio\n");
> +		ret = -ENOMEM;
> +		goto ERROR0;

Just return -ENOMEM directly.

> +	}
> +
> +	spriv->gpio->index = 0x00;
> +	spriv->gpio->serial = serial;
> +
> +	mutex_lock(&gpiochip_lock);
> +	minor = idr_alloc(&gpiochip_minor, serial, 0, 0, GFP_KERNEL);
> +	if (minor < 0) {
> +		mutex_unlock(&gpiochip_lock);
> +		ret = minor;
> +		goto ERROR1;
> +	}
> +	spriv->gpio->minor = minor;
> +	mutex_unlock(&gpiochip_lock);
> +
> +	label = kasprintf(GFP_KERNEL, "pl2303-gpio%d",
> +			  spriv->gpio->minor);
> +	if (label == NULL) {
> +		ret = -ENOMEM;
> +		goto ERROR2;
> +	}

The id allocation and label generation is just overkill (if anything,
you'd want the generated name to include the interface name rather
than some new random number).

But as we can always find the parent device via sysfs, simply set the
label to "pl2303".

> +	spriv->gpio->gpio_chip = template_chip;
> +	spriv->gpio->gpio_chip.label = label;
> +	spriv->gpio->gpio_chip.ngpio = GPIO_NUM;
> +	spriv->gpio->gpio_chip.base = -1;
> +	spriv->gpio->gpio_chip.dev = &serial->interface->dev;
> +	/* initialize GPIOs, input mode as default */
> +	pl2303_vendor_write(spriv->gpio->serial, 1, spriv->gpio->index);
> +
> +	ret = gpiochip_add(&spriv->gpio->gpio_chip);
> +	if (ret < 0) {
> +		dev_err(&serial->interface->dev,
> +			"Could not register gpiochip, %d\n", ret);
> +		goto ERROR3;
> +	}
> +	return 0;
> +ERROR3:

Use lowercase for labels.

> +	kfree(spriv->gpio->gpio_chip.label);
> +ERROR2:
> +	mutex_lock(&gpiochip_lock);
> +	idr_remove(&gpiochip_minor, spriv->gpio->minor);
> +	mutex_unlock(&gpiochip_lock);
> +ERROR1:
> +	kfree(spriv->gpio);
> +	spriv->gpio = NULL;
> +ERROR0:
> +	return ret;
> +}
> +
> +static void pl2303_gpio_release(struct usb_serial *serial)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +
> +	if (spriv->gpio) {
> +		mutex_lock(&gpiochip_lock);
> +		idr_remove(&gpiochip_minor, spriv->gpio->minor);
> +		mutex_unlock(&gpiochip_lock);

Remove the gpio chip before releasing minor (but you should drop this
completely, as mentioned above).

> +
> +		gpiochip_remove(&spriv->gpio->gpio_chip);

So this triggers a compiler warning, but that's expected and will go
away soon I understand from the thread:

/home/johan/work/omicron/src/linux/drivers/usb/serial/pl2303.c:391:18: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]

> +		kfree(spriv->gpio->gpio_chip.label);
> +		kfree(spriv->gpio);
> +		spriv->gpio = NULL;

No need to set to NULL.

> +	}
> +}
> +#endif
> +
>  static int pl2303_startup(struct usb_serial *serial)
>  {
>  	struct pl2303_serial_private *spriv;
> @@ -262,6 +445,9 @@ static int pl2303_startup(struct usb_serial *serial)
>  
>  	kfree(buf);
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO

Please add empty inline functions for pl2303_gpio_startup and
pl2303_gpio_release when !defined(CONFIG_USB_SERIAL_PL2303_GPIO) above
so you can get rid of these ifdefs.

> +	pl2303_gpio_startup(serial);

I also think we should bail out on errors (after freeing the private
data) here (and test for ngpio >0 rather than spriv->gpio != NULL in
release).

> +#endif
>  	return 0;
>  }
>  
> @@ -269,6 +455,9 @@ static void pl2303_release(struct usb_serial *serial)
>  {
>  	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +	pl2303_gpio_release(serial);
> +#endif
>  	kfree(spriv);
>  }

Thanks,
Johan
