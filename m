Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaFKOG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:06:27 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46350 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbaFKOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:06:24 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 11 Jun 2014 16:05:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: jkosina@suse.cz, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v3] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140611140542.GG10256@localhost>
References: <CAEEjW06BnCiLyDDL82fjhFtwg5LyaGzKP+swzLFNKKwmZcvViQ@mail.gmail.com>
 <1402435299-16410-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402435299-16410-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:21:39AM +0300, Janne Kanniainen wrote:
> This driver adds support for USB controlled led panels that exists in MSI GT683R laptop

Can you break this line by 72 columns or so as well?

> Changes in v2:
> 	- sorted headers to alphabetic order
> 	- using devm_kzalloc
> 	- using BIT(n)
> 	- using usb_control_msg instead of usb_submit_urb
> 	- removing unneeded code
> 
> Changes in v3:
> 	- implemented as HID device
> 	- some cleanups and bug fixes

Thanks for the update, Janne. It looks really good now.

Please put the changelog entries after the cut-off line below as it's
not really needed in the git logs.

You should also always run your patches through scripts/checkpatch.pl
before submitting. It currently reports 8 warnings of which you should
fix all but possible the ones about device id entries exceeding 80 chars
(which is usually considered acceptable).

A few more comments follow below.

> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> ---
>  drivers/hid/Kconfig             |   6 ++
>  drivers/hid/Makefile            |   1 +
>  drivers/hid/hid-core.c          |   1 +
>  drivers/hid/hid-gt683r.c        | 186 ++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-ids.h           |   1 +
>  drivers/hid/usbhid/hid-quirks.c |   1 +
>  6 files changed, 196 insertions(+)
>  create mode 100644 drivers/hid/hid-gt683r.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 7af9d0b..6ecc527 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -210,6 +210,12 @@ config DRAGONRISE_FF
>  	Say Y here if you want to enable force feedback support for DragonRise Inc.
>  	game controllers.
>  
> +config HID_GT683R
> +       tristate "LED support for the MSI GT683R"

How about rephrasing this description as "MSI GT683R LED support" as this
should make entry easier to find in Kconfig.

As there appears to be more models that could use this driver (and uses
the same PID) perhaps you should use "MSI GT68xR" or similar depending
on what models there are. We now of at least GX680R (having the same
PID, at least).

There's no need to rename the driver and every function or variable
below though (i.e. a gt683r prefix is still perfectly fine).

> +       depends on LEDS_CLASS && USB_HID
> +       ---help---
> +       Say Y here if you want to enable support for the MSI GT683R LEDS
> +

checkpatch.pl suggests adding descriptive paragraph here.

>  config HID_EMS_FF
>  	tristate "EMS Production Inc. force feedback support"
>  	depends on HID
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index fc712dd..111304e 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -44,6 +44,7 @@ obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
>  obj-$(CONFIG_HID_CP2112)	+= hid-cp2112.o
>  obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
>  obj-$(CONFIG_HID_DRAGONRISE)	+= hid-dr.o
> +obj-$(CONFIG_HID_GT683R)	+= hid-gt683r.o

Keep the entries sorted?

>  obj-$(CONFIG_HID_EMS_FF)	+= hid-emsff.o
>  obj-$(CONFIG_HID_ELECOM)	+= hid-elecom.o
>  obj-$(CONFIG_HID_ELO)		+= hid-elo.o
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index da52279..ec88fdb 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1827,6 +1827,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_OFFICE_KB) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_2) },
> diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
> new file mode 100644
> index 0000000..4baaa36
> --- /dev/null
> +++ b/drivers/hid/hid-gt683r.c
> @@ -0,0 +1,186 @@
> +/*
> + * MSI GT683R led driver
> + *
> + * Copyright (c) 2014 Janne Kanniainen <janne.kanniainen@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/hid.h>
> +#include <linux/kernel.h>
> +#include <linux/leds.h>
> +#include <linux/module.h>
> +
> +#include "hid-ids.h"
> +
> +#define GT683R_LED_BACK				BIT(0)
> +#define GT683R_LED_SIDE				BIT(1)
> +#define GT683R_LED_FRONT			BIT(2)
> +#define GT683R_LED_ALL (GT683R_LED_BACK | GT683R_LED_SIDE | GT683R_LED_FRONT)

Since it seems you are able to control these three LEDs independently,
shouldn't you consider registering three LEDs?

> +
> +#define GT683R_LED_OFF				0
> +#define GT683R_LED_AUDIO			2
> +#define GT683R_LED_BREATHING			3
> +#define GT683R_LED_NORMAL			5

What are AUDIO and BREATHING for? Perhaps add a descriptive comment?

> +
> +#define GT683R_BUFFER_SIZE			8
> +
> +struct gt683r_led {
> +	struct hid_device *hdev;
> +	struct led_classdev led_dev;
> +	struct mutex lock;
> +	struct work_struct work;
> +	enum led_brightness brightness;
> +};
> +
> +static const struct hid_device_id gt683r_led_id[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
> +	{ }
> +};
> +
> +static const char gt683r_led_select_leds[GT683R_BUFFER_SIZE] = { 0x01, 0x02, 0x30, 0x00,
> +								 0x00, 0x00, 0x00, 0x00 };
> +static const char gt683r_led_select_type[GT683R_BUFFER_SIZE] = { 0x01, 0x02, 0x20, 0x00,
> +								 0x01, 0x00, 0x00, 0x00 };

80 char limit.

Perhaps move these to gt683r_led_set, which is the only place where they
are used?

> +
> +static void gt683r_brightness_set(struct led_classdev *led_cdev,
> +				  enum led_brightness brightness)
> +{
> +	struct gt683r_led *led =
> +			container_of(led_cdev, struct gt683r_led, led_dev);
> +
> +	led->brightness = brightness;
> +
> +	schedule_work(&led->work);
> +}
> +
> +static int gt683r_led_snd_msg(struct gt683r_led *led, char *msg)
> +{
> +	int ret;
> +
> +	ret = hid_hw_raw_request(led->hdev, 0x01, msg, GT683R_BUFFER_SIZE,
> +				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
> +	if (ret < 0) {
> +		hid_err(led->hdev,
> +			"failed to send set report request: %i\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void gt683r_led_set(struct gt683r_led *led, char type)
> +{
> +	char *buffer;
> +
> +	buffer = kmalloc(GT683R_BUFFER_SIZE, GFP_KERNEL);
> +	if (!buffer) {
> +		hid_err(led->hdev, "can\'t allocate buffer\n");

No need to log OOM messages as this would already have been taken care
of by the memory subsystem.

> +		return;
> +	}
> +
> +	memcpy(buffer, gt683r_led_select_leds, GT683R_BUFFER_SIZE);
> +	buffer[3] = GT683R_LED_ALL;
> +	gt683r_led_snd_msg(led, buffer);

Error handling? Perhaps there's no point in sending the "type" report
if select_leds failed?

> +
> +	memcpy(buffer, gt683r_led_select_type, GT683R_BUFFER_SIZE);
> +	buffer[3] = type;
> +	gt683r_led_snd_msg(led, buffer);

You don't have to change this if you don't want, but wouldn't
"set_state" be more descriptive than "select_type"?

> +
> +	kfree(buffer);
> +}
> +
> +static void gt683r_led_work(struct work_struct *work)
> +{
> +	struct gt683r_led *led =
> +			container_of(work, struct gt683r_led, work);
> +
> +	mutex_lock(&led->lock);
> +
> +	if (led->brightness)
> +		gt683r_led_set(led, GT683R_LED_NORMAL);
> +	else
> +		gt683r_led_set(led, GT683R_LED_OFF);
> +
> +	mutex_unlock(&led->lock);
> +}
> +
> +static struct led_classdev gt683r_led_dev = {
> +	.name = "gt683r-led",
> +	.brightness_set = gt683r_brightness_set,
> +	.max_brightness = 1,
> +	.flags = LED_CORE_SUSPENDRESUME,
> +};
> +
> +static int gt683r_led_probe(struct hid_device *hdev,
> +			const struct hid_device_id *id)
> +{
> +	int ret;
> +	struct gt683r_led *led;
> +
> +	led = devm_kzalloc(&hdev->dev, sizeof(struct gt683r_led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->hdev = hdev;
> +	hid_set_drvdata(hdev, led);
> +
> +	ret = hid_parse(hdev);
> +	if (ret) {
> +		hid_err(hdev, "hid parsing failed\n");
> +		goto fail;
> +	}
> +
> +	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
> +	if (ret) {
> +		hid_err(hdev, "hw start failed\n");
> +		goto fail;
> +	}
> +
> +	led->led_dev = gt683r_led_dev;
> +	ret = led_classdev_register(&hdev->dev, &led->led_dev);
> +	if (ret) {
> +		hid_err(hdev, "could not register led device\n");
> +		goto stop;
> +	}
> +
> +	mutex_init(&led->lock);
> +	INIT_WORK(&led->work, gt683r_led_work);
> +
> +	return 0;
> +stop:
> +	hid_hw_stop(hdev);
> +fail:
> +	return ret;
> +}
> +
> +static void gt683r_led_remove(struct hid_device *hdev)
> +{
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +	led_classdev_unregister(&led->led_dev);
> +	cancel_work_sync(&led->work);
> +	hid_hw_stop(hdev);
> +}
> +
> +static struct hid_driver gt683r_led_driver = {
> +	.probe = gt683r_led_probe,
> +	.remove = gt683r_led_remove,
> +	.name = "gt683r_led",
> +	.id_table = gt683r_led_id,
> +};
> +
> +module_hid_driver(gt683r_led_driver);
> +
> +MODULE_AUTHOR("Janne Kanniainen");
> +MODULE_DESCRIPTION("MSI GT683R led driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 34bb220..e2097f7 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -641,6 +641,7 @@
>  #define USB_DEVICE_ID_GENIUS_KB29E	0x3004
>  
>  #define USB_VENDOR_ID_MSI		0x1770
> +#define USB_DEVICE_ID_MSI_GT683R_LED_PANEL 0xff00
>  #define USB_DEVICE_ID_MSI_GX680R_LED_PANEL	0xff00

As these device have the same PID you shouldn't be adding a duplicate
entry to the blacklist_table below. Perhaps you can rename the original
one as GC68XR instead (or just remove the old one).

>  
>  #define USB_VENDOR_ID_NATIONAL_SEMICONDUCTOR 0x0400
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 8e4ddb3..927e7be 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -73,6 +73,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
> +	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },

Thanks,
Johan
