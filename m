Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaFWR2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:28:24 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58194 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbaFWR2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:28:23 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 23 Jun 2014 19:27:45 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: johan@kernel.org, greg@kroah.com, jkosina@suse.cz, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v10] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140623172745.GB22424@localhost>
References: <20140623161723.GA20421@kroah.com>
 <1403543808-8228-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403543808-8228-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:16:48PM +0300, Janne Kanniainen wrote:
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
> Changes in v3:
> 	- implemented as HID device
> 	- some cleanups and bug fixes
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
> Changes in v10:
> 	- race condition fixed
> 	- using proper attribute group

You need to send a separate patch on top of v9, which Jiri has already
applied to his tree.

<snip>

> +static DEVICE_ATTR_RW(leds_mode);
> +
> +static struct attribute *gt683r_attributes[] = {
> +	&dev_attr_leds_mode.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group gt683r_attribute_group = {
> +	.attrs = gt683r_attributes
> +};
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
> +	mutex_init(&led->lock);
> +	INIT_WORK(&led->work, gt683r_led_work);
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
> +	ret = sysfs_create_group(&led->hdev->dev.kobj, &gt683r_attribute_group);
> +	if (ret) {
> +		hid_err(hdev, "failed to create sysfs attributes\n");
> +		goto fail;
> +	}

This does not solve the race Greg is referring to. There's some more
info here:

	http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/

but I'm not sure exactly how you'd apply that to an HID driver. Perhaps
you could use the struct device_driver in struct hid_driver (although it
is currently marked as "private").

Johan

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
> +	sysfs_remove_group(&led->hdev->dev.kobj, &gt683r_attribute_group);
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
