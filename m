Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaFRQMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:12:30 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33306 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFRQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:12:27 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 18 Jun 2014 18:11:50 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: jkosina@suse.cz, johan@kernel.org, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v9] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140618161150.GH31163@localhost>
References: <20140618073950.GC31163@localhost>
 <1403107502-14106-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403107502-14106-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 07:05:02PM +0300, Janne Kanniainen wrote:
> This driver adds support for USB controlled led panels that exists in
> MSI GT683R laptop
> 
> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>

Reviewed-by: Johan Hovold <johan@kernel.org>

Thanks, Janne!

Johan

> ---
> Changes in v2:
> 	- sorted headers to alphabetic order
> 	- using devm_kzalloc
> 	- using BIT(n)
> 	- using usb_control_msg instead of usb_submit_urb
> 	- removing unneeded code
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
> Changes in v6:
> 	- flush_work added
> 	- using hid device name instead of hard coded gt683r
> 	- allocating name buffers with devm_kzalloc
> 
> Changes in v7:
> 	- buf with for fixed
> 
> Changes in v8:
> 	- some cleanups and bugs fixed
> 
> Changes in v9:
> 	- few style issues fixed
> 
>  .../ABI/testing/sysfs-class-hid-driver-gt683r      |  14 +
>  drivers/hid/Kconfig                                |  14 +
>  drivers/hid/Makefile                               |   1 +
>  drivers/hid/hid-core.c                             |   1 +
>  drivers/hid/hid-gt683r.c                           | 309 +++++++++++++++++++++
>  drivers/hid/hid-ids.h                              |   2 +-
>  drivers/hid/usbhid/hid-quirks.c                    |   2 +-
>  7 files changed, 341 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
>  create mode 100644 drivers/hid/hid-gt683r.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> new file mode 100644
> index 0000000..317e9d5
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> @@ -0,0 +1,14 @@
> +What:		/sys/class/hidraw/<hidraw>/device/leds_mode
> +Date:		Jun 2014
> +KernelVersion:	3.17
> +Contact:	Janne Kanniainen <janne.kanniainen@gmail.com>
> +Description:
> +		Set the mode of LEDs
> +
> +		0 - normal
> +		1 - audio
> +		2 - breathing
> +
> +		Normal: LEDs are fully on when enabled
> +		Audio:  LEDs brightness depends on sound level
> +		Breathing: LEDs brightness varies at human breathing rate
> \ No newline at end of file
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 7af9d0b..e2f4590 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -261,6 +261,20 @@ config HOLTEK_FF
>  	  Say Y here if you have a Holtek On Line Grip based game controller
>  	  and want to have force feedback support for it.
>  
> +config HID_GT683R
> +	tristate "MSI GT68xR LED support"
> +	depends on LEDS_CLASS && USB_HID
> +	---help---
> +	Say Y here if you want to enable support for the three MSI GT68xR LEDs
> +
> +	This driver support following modes:
> +	  - Normal: LEDs are fully on when enabled
> +	  - Audio:  LEDs brightness depends on sound level
> +	  - Breathing: LEDs brightness varies at human breathing rate
> +
> +	Currently the following devices are know to be supported:
> +	  - MSI GT683R
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
> index 0000000..077f7a1
> --- /dev/null
> +++ b/drivers/hid/hid-gt683r.c
> @@ -0,0 +1,309 @@
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
> +#define GT683R_BUFFER_SIZE			8
> +
> +/*
> + * GT683R_LED_OFF: all LEDs are off
> + * GT683R_LED_AUDIO: LEDs brightness depends on sound level
> + * GT683R_LED_BREATHING: LEDs brightness varies at human breathing rate
> + * GT683R_LED_NORMAL: LEDs are fully on when enabled
> + */
> +enum gt683r_led_mode {
> +	GT683R_LED_OFF = 0,
> +	GT683R_LED_AUDIO = 2,
> +	GT683R_LED_BREATHING = 3,
> +	GT683R_LED_NORMAL = 5
> +};
> +
> +enum gt683r_panels {
> +	GT683R_LED_BACK = 0,
> +	GT683R_LED_SIDE = 1,
> +	GT683R_LED_FRONT = 2,
> +	GT683R_LED_COUNT,
> +};
> +
> +static const char * const gt683r_panel_names[] = {
> +	"back",
> +	"side",
> +	"front",
> +};
> +
> +struct gt683r_led {
> +	struct hid_device *hdev;
> +	struct led_classdev led_devs[GT683R_LED_COUNT];
> +	struct mutex lock;
> +	struct work_struct work;
> +	enum led_brightness brightnesses[GT683R_LED_COUNT];
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
> +	for (i = 0; i < GT683R_LED_COUNT; i++) {
> +		if (led_cdev == &led->led_devs[i])
> +			break;
> +	}
> +
> +	if (i < GT683R_LED_COUNT) {
> +		led->brightnesses[i] = brightness;
> +		schedule_work(&led->work);
> +	}
> +}
> +
> +static ssize_t leds_mode_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	u8 sysfs_mode;
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +	if (led->mode == GT683R_LED_NORMAL)
> +		sysfs_mode = 0;
> +	else if (led->mode == GT683R_LED_AUDIO)
> +		sysfs_mode = 1;
> +	else
> +		sysfs_mode = 2;
> +
> +	return scnprintf(buf, PAGE_SIZE, "%u\n", sysfs_mode);
> +}
> +
> +static ssize_t leds_mode_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	u8 sysfs_mode;
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +
> +	if (kstrtou8(buf, 10, &sysfs_mode) || sysfs_mode > 2)
> +		return -EINVAL;
> +
> +	mutex_lock(&led->lock);
> +
> +	if (sysfs_mode == 0)
> +		led->mode = GT683R_LED_NORMAL;
> +	else if (sysfs_mode == 1)
> +		led->mode = GT683R_LED_AUDIO;
> +	else
> +		led->mode = GT683R_LED_BREATHING;
> +
> +	mutex_unlock(&led->lock);
> +	schedule_work(&led->work);
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
> +static int gt683r_leds_set(struct gt683r_led *led, u8 leds)
> +{
> +	int ret;
> +	u8 *buffer;
> +
> +	buffer = kzalloc(GT683R_BUFFER_SIZE, GFP_KERNEL);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	buffer[0] = 0x01;
> +	buffer[1] = 0x02;
> +	buffer[2] = 0x30;
> +	buffer[3] = leds;
> +	ret = gt683r_led_snd_msg(led, buffer);
> +
> +	kfree(buffer);
> +	return ret;
> +}
> +
> +static int gt683r_mode_set(struct gt683r_led *led, u8 mode)
> +{
> +	int ret;
> +	u8 *buffer;
> +
> +	buffer = kzalloc(GT683R_BUFFER_SIZE, GFP_KERNEL);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	buffer[0] = 0x01;
> +	buffer[1] = 0x02;
> +	buffer[2] = 0x20;
> +	buffer[3] = mode;
> +	buffer[4] = 0x01;
> +	ret = gt683r_led_snd_msg(led, buffer);
> +
> +	kfree(buffer);
> +	return ret;
> +}
> +
> +static void gt683r_led_work(struct work_struct *work)
> +{
> +	int i;
> +	u8 leds = 0;
> +	u8 mode;
> +	struct gt683r_led *led = container_of(work, struct gt683r_led, work);
> +
> +	mutex_lock(&led->lock);
> +
> +	for (i = 0; i < GT683R_LED_COUNT; i++) {
> +		if (led->brightnesses[i])
> +			leds |= BIT(i);
> +	}
> +
> +	if (gt683r_leds_set(led, leds))
> +		goto fail;
> +
> +	if (leds)
> +		mode = led->mode;
> +	else
> +		mode = GT683R_LED_OFF;
> +
> +	gt683r_mode_set(led, mode);
> +fail:
> +	mutex_unlock(&led->lock);
> +}
> +
> +static DEVICE_ATTR_RW(leds_mode);
> +
> +static int gt683r_led_probe(struct hid_device *hdev,
> +			const struct hid_device_id *id)
> +{
> +	int i;
> +	int ret;
> +	int name_sz;
> +	char *name;
> +	struct gt683r_led *led;
> +
> +	led = devm_kzalloc(&hdev->dev, sizeof(*led), GFP_KERNEL);
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
> +		return ret;
> +	}
> +
> +	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
> +	if (ret) {
> +		hid_err(hdev, "hw start failed\n");
> +		return ret;
> +	}
> +
> +	for (i = 0; i < GT683R_LED_COUNT; i++) {
> +		name_sz = strlen(dev_name(&hdev->dev)) +
> +				strlen(gt683r_panel_names[i]) + 3;
> +
> +		name = devm_kzalloc(&hdev->dev, name_sz, GFP_KERNEL);
> +		if (!name) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		snprintf(name, name_sz, "%s::%s",
> +				dev_name(&hdev->dev), gt683r_panel_names[i]);
> +		led->led_devs[i].name = name;
> +		led->led_devs[i].max_brightness = 1;
> +		led->led_devs[i].brightness_set = gt683r_brightness_set;
> +		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
> +		if (ret) {
> +			hid_err(hdev, "could not register led device\n");
> +			goto fail;
> +		}
> +	}
> +
> +	ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
> +	if (ret) {
> +		hid_err(hdev, "could not make mode attribute file\n");
> +		goto fail;
> +	}
> +
> +	mutex_init(&led->lock);
> +	INIT_WORK(&led->work, gt683r_led_work);
> +
> +	return 0;
> +
> +fail:
> +	for (i = i - 1; i >= 0; i--)
> +		led_classdev_unregister(&led->led_devs[i]);
> +	hid_hw_stop(hdev);
> +	return ret;
> +}
> +
> +static void gt683r_led_remove(struct hid_device *hdev)
> +{
> +	int i;
> +	struct gt683r_led *led = hid_get_drvdata(hdev);
> +
> +	device_remove_file(&hdev->dev, &dev_attr_leds_mode);
> +	for (i = 0; i < GT683R_LED_COUNT; i++)
> +		led_classdev_unregister(&led->led_devs[i]);
> +	flush_work(&led->work);
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
