Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFMHyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:54:52 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:35749 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaFMHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:54:50 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 13 Jun 2014 09:54:11 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: jkosina@suse.cz, johan@kernel.org, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v5] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140613075411.GG10940@localhost>
References: <20140612090636.GK10256@localhost>
 <1402605252-9620-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402605252-9620-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:34:12PM +0300, Janne Kanniainen wrote:
> This driver adds support for USB controlled led panels that exists in
> MSI GT683R laptop
> 
> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> ---
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
> 
> Changes in v4:
> 	- more cleanups
> 	- support for selecting leds
> 	- suppport for selecting status
> 
> Changes in v5:
> 	- mode attribute documented under Documentation/ABI
> 	- made array for led_classdev
> 	- led devices uses now recommended naming scheme
> 
>  .../ABI/testing/sysfs-class-hid-driver-gt683r      |  10 +
>  drivers/hid/Kconfig                                |  11 +
>  drivers/hid/Makefile                               |   1 +
>  drivers/hid/hid-core.c                             |   1 +
>  drivers/hid/hid-gt683r.c                           | 294 +++++++++++++++++++++
>  drivers/hid/hid-ids.h                              |   2 +-
>  drivers/hid/usbhid/hid-quirks.c                    |   2 +-
>  7 files changed, 319 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
>  create mode 100644 drivers/hid/hid-gt683r.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> new file mode 100644
> index 0000000..c4d604e
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> @@ -0,0 +1,10 @@
> +What:		/sys/class/hidraw/<hidraw>/device/state

You should probably stick to "mode" (rather than "state") throughout (it
seems you just forgot to update a few uses).

> +Date:		Jun 2014
> +KernelVersion:	3.15

This should be 3.17.

> +Contact:	Janne Kanniainen <janne.kanniainen@gmail.com>
> +Description:
> +		Set the mode of LEDs
> +
> +		0 - normal
> +		1 - audio
> +		2 - breathing

Perhaps expand this with a short paragraph describing the different
modes.

> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 7af9d0b..d93e0ae 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -261,6 +261,17 @@ config HOLTEK_FF
>  	  Say Y here if you have a Holtek On Line Grip based game controller
>  	  and want to have force feedback support for it.
>  
> +config HID_GT683R
> +       tristate "MSI GT68xR LED support"
> +       depends on LEDS_CLASS && USB_HID
> +       ---help---
> +       Say Y here if you want to enable support for the MSI GT68xR LEDS
> +
> +       This driver support following states normal, breathing and audio.

You could also use "modes" and expand this with the same description.

> +       You can also select which leds you want to enable.
> +       Currently the following devices are know to be supported:
> +       - MSI GT683R
> +
>  config HID_HUION
>  	tristate "Huion tablets"
>  	depends on USB_HID
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index fc712dd..7129311 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -48,6 +48,7 @@ obj-$(CONFIG_HID_EMS_FF)	+= hid-emsff.o
>  obj-$(CONFIG_HID_ELECOM)	+= hid-elecom.o
>  obj-$(CONFIG_HID_ELO)		+= hid-elo.o
>  obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
> +obj-$(CONFIG_HID_GT683R)	+= hid-gt683r.o
>  obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
>  obj-$(CONFIG_HID_HOLTEK)	+= hid-holtek-kbd.o
>  obj-$(CONFIG_HID_HOLTEK)	+= hid-holtek-mouse.o
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
> index 0000000..6dffb76
> --- /dev/null
> +++ b/drivers/hid/hid-gt683r.c
> @@ -0,0 +1,294 @@
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
> +#include <linux/device.h>
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
> +
> +#define GT683R_BUFFER_SIZE			8
> +
> +/*
> + * GT683R_LED_OFF: all LEDs are off
> + * GT683R_LED_AUDIO: the status of LEDs depends
> + * on sound level
> + * GT683R_LED_BREATHING: LEDs brightness varies
> + * at human breathing rate
> + * GT683R_LED_NORMAL: LEDs are on
> + */
> +enum gt683r_led_mode {
> +	GT683R_LED_OFF = 0,
> +	GT683R_LED_AUDIO = 2,
> +	GT683R_LED_BREATHING = 3,
> +	GT683R_LED_NORMAL = 5
> +};
> +
> +enum gt683r_panels {
> +	back,
> +	side,
> +	front,
> +};

How about calling these GT683R_LED_BACK, etc, and simply do
BIT(GT683R_LED_BACK) in gt683r_led_setset_led below (and drop the
bitmask defines above).

You should also add a count enum/define rather than hard-code 3
throughout the driver, for example:

enum gt683r_panels {
	GT683R_LED_BACK = 0,
	GT683R_LED_SIDE = 1,
	GT683R_LED_FRONT = 2,
	GT683R_LED_COUNT
};

> +
> +const char *gt683r_panel_names[] = {
> +	"gt683r::back",
> +	"gt683r::side",
> +	"gt683r::front",
> +};

Your forgot to declare this static.

I don't think you should hard-code the device-part (i.e. "gt683r") but
rather derive it from the hid device (as in the driver I referred to as
an example). Just store the description here (e.g. "back"). More details
below.  

> +
> +struct gt683r_led {
> +	struct hid_device *hdev;
> +	struct led_classdev *led_devs[3];

You could keep these as embedded structs (an array of structs) rather
than do individual allocations in probe.

> +	struct mutex lock;
> +	struct work_struct work;
> +	enum led_brightness brightnesses[3];
> +	enum gt683r_led_mode mode;
> +};
> +
> +static const struct hid_device_id gt683r_led_id[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
> +	{ }
> +};
> +
> +static void gt683r_brightness_set(struct led_classdev *led_cdev,
> +				enum led_brightness brightness)
> +{
> +	int i;
> +	struct device *dev = led_cdev->dev->parent;
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +	for (i = 0; i < 3; i++) {
> +		if (led->led_devs[i] != led_cdev)
> +			continue;
> +
> +		led->brightnesses[i] = brightness;
> +		schedule_work(&led->work);
> +		break;

I'd move the assignment and work scheduling out of the loop (and add an
explicit check for LED-not-found, if at all needed).

> +	}
> +}
> +
> +static ssize_t gt683r_show_mode(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct hid_device *hdev =
> +		container_of(dev, struct hid_device, dev);
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +	if (led->mode == GT683R_LED_NORMAL)
> +		return scnprintf(buf, PAGE_SIZE, "0\n");
> +	else if (led->mode == GT683R_LED_AUDIO)
> +		return scnprintf(buf, PAGE_SIZE, "1\n");
> +	else
> +		return scnprintf(buf, PAGE_SIZE, "2\n");

How about mapping led->mode to sysfs mode in a temporary variable and
the just do one:

	return scnprintf(buf, PAGE_SIZE, "%u\n", sysfs_mode);

at the end?

> +
> +}
> +
> +static ssize_t gt683r_store_mode(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct hid_device *hdev =
> +		container_of(dev, struct hid_device, dev);
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +	mutex_lock(&led->lock);
> +
> +	if (!strncmp("0", buf, strlen("0"))) {
> +		led->mode = GT683R_LED_NORMAL;
> +	} else if (!strncmp("1", buf, strlen("1"))) {
> +		led->mode = GT683R_LED_AUDIO;
> +	} else if (!strncmp("2", buf, strlen("2"))) {
> +		led->mode = GT683R_LED_BREATHING;
> +	} else {
> +		count = -EINVAL;
> +		goto fail;
> +	}

Here you should use snprintf to parse buf as I already mentioned. With
the current implementation "22" would be accepted as a valid mode.

> +
> +	schedule_work(&led->work);
> +fail:
> +	mutex_unlock(&led->lock);

You should unlock before scheduling.

> +
> +	return count;
> +}
> +
> +static int gt683r_led_snd_msg(struct gt683r_led *led, u8 *msg)
> +{
> +	int ret;
> +
> +	ret = hid_hw_raw_request(led->hdev, msg[0], msg, GT683R_BUFFER_SIZE,
> +				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
> +	if (ret != GT683R_BUFFER_SIZE) {
> +		hid_err(led->hdev,
> +			"failed to send set report request: %i\n", ret);
> +		if (ret < 0)
> +			return ret;
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static void gt683r_led_set(struct gt683r_led *led, u8 leds, u8 mode)
> +{
> +	u8 *buffer;
> +
> +	buffer = kzalloc(GT683R_BUFFER_SIZE, GFP_KERNEL);
> +	if (!buffer)
> +		return;
> +
> +	buffer[0] = 0x01;
> +	buffer[1] = 0x02;
> +	buffer[2] = 0x30;
> +	buffer[3] = leds;
> +	if (gt683r_led_snd_msg(led, buffer))
> +		goto fail;
> +
> +	buffer[2] = 0x20;
> +	buffer[3] = mode;
> +	buffer[4] = 0x01;
> +	gt683r_led_snd_msg(led, buffer);

Ok, so you decided to continue setting mode on every LED brightness
update. That should be fine, but you never answered my question about
whether it is necessary?

> +
> +fail:
> +	kfree(buffer);
> +}
> +
> +static void gt683r_led_work(struct work_struct *work)
> +{
> +	struct gt683r_led *led =
> +			container_of(work, struct gt683r_led, work);
> +	u8 leds = 0;
> +
> +	mutex_lock(&led->lock);
> +
> +	if (led->brightnesses[back])
> +		leds |= GT683R_LED_BACK;
> +
> +	if (led->brightnesses[side])
> +		leds |= GT683R_LED_SIDE;
> +
> +	if (led->brightnesses[front])
> +		leds |= GT683R_LED_FRONT;
> +
> +	if (leds)
> +		gt683r_led_set(led, leds, led->mode);
> +	else
> +		gt683r_led_set(led, leds, GT683R_LED_OFF);
> +
> +	mutex_unlock(&led->lock);
> +}
> +
> +static DEVICE_ATTR(mode, 0644, gt683r_show_mode, gt683r_store_mode);

It is even recommended to use the new DEVICE_ATTR_RW macro here rather
(forgot about that).

> +
> +static int gt683r_led_probe(struct hid_device *hdev,
> +			const struct hid_device_id *id)
> +{
> +	int ret, i;
> +	struct gt683r_led *led;
> +
> +	led = devm_kzalloc(&hdev->dev, sizeof(struct gt683r_led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->mode = GT683R_LED_NORMAL;
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
> +	for (i = 0; i < 3; i++) {
> +		led->led_devs[i] = kzalloc(sizeof(struct led_classdev) +
> +					strlen(gt683r_panel_names[i]) + 1,

Why are you allocating space for the panel names here? Oh, now I see,
that's how it's done in the example I referred to. :)

Just embed the struct led_classdevs directly in struct gt683r_led, and
use devm_kzalloc(&hdev->dev, ...) to allocate the name buffers.

> +					GFP_KERNEL);
> +		if (!led->led_devs[i])
> +			goto fail2;
> +		led->led_devs[i]->name = gt683r_panel_names[i];

The other hid leds use dev_name(&hdev->dev) for the device name part of
the name. So determine the buffer length:

	strlen(dev_name(&hdev->dev)) + strlen(gt683r_panel_names[i]) + 3

and use snprintf with the following format "%s::%s".

> +		led->led_devs[i]->max_brightness = 1;
> +		led->led_devs[i]->brightness_set = gt683r_brightness_set;
> +		ret = led_classdev_register(&hdev->dev, led->led_devs[i]);
> +		if (ret) {
> +			hid_err(hdev, "could not register led device\n");
> +			goto fail2;
> +		}
> +	}
> +
> +	ret = device_create_file(&led->hdev->dev,
> +				&dev_attr_mode);
> +	if (ret) {
> +		hid_err(hdev, "could not make mode attribute file\n");
> +		goto fail2;
> +	}
> +
> +	mutex_init(&led->lock);
> +	INIT_WORK(&led->work, gt683r_led_work);
> +
> +	return 0;
> +
> +fail2:
> +	while (i-- > 0) {

Please use a for-loop instead (for readability).

> +		led_classdev_unregister(led->led_devs[i]);
> +		kfree(led->led_devs[i]);

This would currently leak memory if led_classdev_register fails, but
will work if you use devm_kzalloc as suggested above.

> +	}
> +	hid_hw_stop(hdev);
> +fail:
> +	return ret;
> +}
> +
> +static void gt683r_led_remove(struct hid_device *hdev)
> +{
> +	int i;
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +	for (i = 0; i < 3; i++) {
> +		led_classdev_unregister(led->led_devs[i]);
> +		kfree(led->led_devs[i]);
> +	}
> +	cancel_work_sync(&led->work);
> +	device_remove_file(&hdev->dev,
> +			&dev_attr_mode);
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
> index 34bb220..3692d37 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -641,7 +641,7 @@
>  #define USB_DEVICE_ID_GENIUS_KB29E	0x3004
>  
>  #define USB_VENDOR_ID_MSI		0x1770
> -#define USB_DEVICE_ID_MSI_GX680R_LED_PANEL	0xff00
> +#define USB_DEVICE_ID_MSI_GT683R_LED_PANEL 0xff00
>  
>  #define USB_VENDOR_ID_NATIONAL_SEMICONDUCTOR 0x0400
>  #define USB_DEVICE_ID_N_S_HARMONY	0xc359
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 8e4ddb3..c640e1d 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -73,7 +73,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
> -	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
> +	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },

You're almost done. One last update? :)

Thanks,
Johan
