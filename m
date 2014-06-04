Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaFDVQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:16:19 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61155 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaFDVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:16:17 -0400
MIME-Version: 1.0
In-Reply-To: <1401551204-6399-1-git-send-email-janne.kanniainen@gmail.com>
References: <1401551204-6399-1-git-send-email-janne.kanniainen@gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 4 Jun 2014 14:15:56 -0700
Message-ID: <CAK5ve-LcWHOEF==FhLyDOKv1CFe0EcxjsTYRHSx6jM=k=MKLFA@mail.gmail.com>
Subject: Re: [PATCH] leds: USB: Add support for MSI GT683R led panels
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 8:46 AM, Janne Kanniainen
<janne.kanniainen@gmail.com> wrote:
> This driver adds support for USB controlled led panels that exist in MSI GT683R laptop.
>

Thanks for this patch, basically it looks good to me. Just some picky
improvement as bellow.

> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> ---
>  drivers/leds/Kconfig       |   6 ++
>  drivers/leds/Makefile      |   1 +
>  drivers/leds/leds-gt683r.c | 241 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 248 insertions(+)
>  create mode 100644 drivers/leds/leds-gt683r.c
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 6de9dfb..2cffa0c 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -487,6 +487,12 @@ config LEDS_BLINKM
>           This option enables support for the BlinkM RGB LED connected
>           through I2C. Say Y to enable support for the BlinkM LED.
>
> +config LEDS_GT683R
> +       tristate "LED support for the MSI GT683R"
> +       depends on LEDS_CLASS && USB
> +       help
> +         This option enables support for the MSI GT683R LEDS
> +
>  comment "LED Triggers"
>  source "drivers/leds/trigger/Kconfig"
>
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 3cd76db..af5fb4e 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -54,6 +54,7 @@ obj-$(CONFIG_LEDS_ASIC3)              += leds-asic3.o
>  obj-$(CONFIG_LEDS_MAX8997)             += leds-max8997.o
>  obj-$(CONFIG_LEDS_LM355x)              += leds-lm355x.o
>  obj-$(CONFIG_LEDS_BLINKM)              += leds-blinkm.o
> +obj-$(CONFIG_LEDS_GT683R)              += leds-gt683r.o
>
>  # LED SPI Drivers
>  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
> diff --git a/drivers/leds/leds-gt683r.c b/drivers/leds/leds-gt683r.c
> new file mode 100644
> index 0000000..d67709c
> --- /dev/null
> +++ b/drivers/leds/leds-gt683r.c
> @@ -0,0 +1,241 @@
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
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/usb.h>
> +#include <linux/slab.h>
> +#include <linux/leds.h>
> +

You'd better keep these header files in alphabetic order.

> +#define USB_DEVICE_ID_MSI_GT683R_LED_PANEL 0xff00
> +#define USB_VENDOR_ID_MSI 0x1770
> +
> +#define GT683R_LED_MSG_TYPE_CTRL 0
> +#define GT683R_LED_MSG_TYPE_INT 1
> +
> +#define GT683R_LED_FRONT 4
> +#define GT683R_LED_SIDE 2
> +#define GT683R_LED_BACK 1
> +#define GT683R_LED_NORMAL 5
> +#define GT683R_LED_BREATHING 3
> +#define GT683R_LED_AUDIO 2
> +#define GT683R_LED_OFF 0
> +
> +struct gt683r_led {
> +       struct usb_device *usb_dev;
> +
> +       struct usb_endpoint_descriptor *ctrl_out_ep;
> +       int ctrl_out_buffer_size;
> +       char *ctrl_out_buffer;
> +       struct usb_ctrlrequest *ctrl_out_request;
> +       struct urb *ctrl_out_urb;
> +
> +       struct led_classdev led_dev;
> +       struct mutex lock;
> +       struct work_struct work;
> +
> +       enum led_brightness brightness;
> +};
> +
> +static const struct usb_device_id gt683r_led_id[] = {
> +       { USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
> +       { }
> +};
> +
> +static char gt683r_led_select_leds[8] = {0x01, 0x02, 0x30, 0x00,
> +                                        0x00, 0x00, 0x00, 0x00};
> +static char gt683r_led_select_type[8] = {0x01, 0x02, 0x20, 0x00,
> +                                        0x01, 0x00, 0x00, 0x00};
> +
> +static void gt683r_brightness_set(struct led_classdev *led_cdev,
> +                                 enum led_brightness brightness)
> +{
> +       struct gt683r_led *led =
> +                       container_of(led_cdev, struct gt683r_led, led_dev);
> +
> +       led->brightness = brightness;
> +
> +       schedule_work(&led->work);
> +}
> +
> +static void gt683r_led_msg_snd_complete(struct urb *urb)
> +{
> +       usb_free_urb(urb);
> +}
> +
> +static int gt683r_led_snd_msg(struct gt683r_led *led, char *msg)
> +{
> +       int result;
> +
> +       if (strlen(msg) > led->ctrl_out_buffer_size) {
> +               dev_err(&led->usb_dev->dev, "Message to be send to device is too long\n");
> +               return -EMSGSIZE;
> +       }
> +
> +       led->ctrl_out_urb = usb_alloc_urb(0, GFP_KERNEL);
> +       strcpy(led->ctrl_out_buffer, msg);
> +       usb_fill_control_urb(led->ctrl_out_urb,
> +                            led->usb_dev,
> +                            usb_sndctrlpipe(led->usb_dev, led->ctrl_out_ep->bEndpointAddress),
> +                            (unsigned char *) led->ctrl_out_request,
> +                            led->ctrl_out_buffer,
> +                            led->ctrl_out_buffer_size,
> +                            gt683r_led_msg_snd_complete,
> +                            led);
> +
> +       result = usb_submit_urb(led->ctrl_out_urb, GFP_KERNEL);
> +
No need this empty line.

> +       if (result) {
> +               dev_err(&led->usb_dev->dev, "Failed to submit urb\n");
> +               return -ECOMM;
> +       }
> +
> +       return 0;
> +}
> +
> +static void gt683r_led_set(struct gt683r_led *led, char leds, char type)
> +{
> +       gt683r_led_select_leds[3] = leds;
> +       gt683r_led_select_type[3] = type;
> +       gt683r_led_snd_msg(led, gt683r_led_select_leds);
> +       gt683r_led_snd_msg(led, gt683r_led_select_type);
> +}
> +
> +static void gt683r_led_work(struct work_struct *work)
> +{
> +       struct gt683r_led *led =
> +                       container_of(work, struct gt683r_led, work);
> +
> +       mutex_lock(&led->lock);
> +
> +       if (led->brightness)
> +               gt683r_led_set(led, GT683R_LED_FRONT|GT683R_LED_SIDE|
> +                              GT683R_LED_BACK, GT683R_LED_NORMAL);

Please put space around "|"

> +       else
> +               gt683r_led_set(led, GT683R_LED_FRONT|GT683R_LED_SIDE|
> +                              GT683R_LED_BACK, GT683R_LED_OFF);
> +
> +       mutex_unlock(&led->lock);
> +}
> +
> +static struct led_classdev gt683r_led_dev = {
> +       .name = "gt683r-led",
> +       .brightness_set = gt683r_brightness_set,
> +       .max_brightness = 1,
> +       .flags = LED_CORE_SUSPENDRESUME,
> +};
> +
> +static int gt683r_led_probe(struct usb_interface *intf,
> +                           const struct usb_device_id *id)
> +{
> +       int ret = 0;
> +       struct usb_endpoint_descriptor *endpoint;
> +
> +       struct gt683r_led *led = kzalloc(sizeof(struct gt683r_led), GFP_KERNEL);
> +

I'd better to use devm_kzalloc() API here to make code simpler.


> +       if (!led) {
> +               ret = -ENOMEM;
> +               goto fail;
> +       }
> +
No need to check with devm_kzalloc() API


> +       led->usb_dev = interface_to_usbdev(intf);
> +       usb_set_intfdata(intf, led);
> +       endpoint = &led->usb_dev->ep0.desc;
> +
> +       if (!led->ctrl_out_ep &&
> +           usb_endpoint_xfer_control(endpoint) &&
> +           usb_endpoint_dir_out(endpoint)) {
> +               led->ctrl_out_ep = endpoint;
> +               led->ctrl_out_buffer_size = endpoint->wMaxPacketSize;
> +               led->ctrl_out_buffer = kmalloc(led->ctrl_out_buffer_size,
> +                                              GFP_KERNEL);
> +               if (!led->ctrl_out_buffer) {
> +                       ret = -ENOMEM;
> +                       goto fail;
> +               }
> +               led->ctrl_out_request = kmalloc(sizeof(struct usb_ctrlrequest),
> +                                                    GFP_KERNEL);
> +               if (!led->ctrl_out_request) {
> +                       ret = -ENOMEM;
> +                       goto fail;
> +               }
> +               led->ctrl_out_request->bRequestType = 0x22;
> +               led->ctrl_out_request->bRequest = 0x09;
> +               led->ctrl_out_request->wValue = cpu_to_le16(0x0301);
> +               led->ctrl_out_request->wIndex = cpu_to_le16(0x0000);
> +               led->ctrl_out_request->wLength = cpu_to_le16(0x0008);
> +       }
> +
> +       if (!led->ctrl_out_ep) {
> +               dev_err(&led->usb_dev->dev, "Could not find ctrl-out endpoint\n");
> +               ret = -EIO;
> +               goto fail;
> +       }
> +
> +       led->led_dev = gt683r_led_dev;
> +       ret = led_classdev_register(&led->usb_dev->dev, &led->led_dev);
> +       if (ret) {
> +               dev_err(&led->usb_dev->dev, "Could not register led_classdev\n");
> +               goto fail;
> +       }
> +
> +       mutex_init(&led->lock);
> +       INIT_WORK(&led->work, gt683r_led_work);
> +
> +       return 0;
> +fail:
> +       kfree(led->ctrl_out_buffer);
> +       led->ctrl_out_buffer = NULL;
> +
> +       kfree(led->ctrl_out_request);
> +       led->ctrl_out_request = NULL;
> +
> +       kfree(led);
> +       led = NULL;
> +
No need to check with devm_kzalloc() API

> +       return ret;
> +}
> +
> +static void gt683r_led_disconnect(struct usb_interface *intf)
> +{
> +       struct gt683r_led *led = usb_get_intfdata(intf);
> +
> +       led_classdev_unregister(&led->led_dev);
> +       msleep(500);
> +
> +       kfree(led->ctrl_out_buffer);
> +       led->ctrl_out_buffer = NULL;
> +
> +       kfree(led->ctrl_out_request);
> +       led->ctrl_out_request = NULL;
> +
> +       kfree(led);
> +       led = NULL;
No need to check with devm_kzalloc() API

> +}
> +
> +static struct usb_driver gt683r_led_driver = {
> +       .probe = gt683r_led_probe,
> +       .disconnect = gt683r_led_disconnect,
> +       .name = "GT683R Led Driver",
> +       .id_table = gt683r_led_id,
> +};
> +
> +module_usb_driver(gt683r_led_driver);
> +
> +MODULE_AUTHOR("Janne Kanniainen");
> +MODULE_DESCRIPTION("MSI GT683R led driver");
> +MODULE_LICENSE("GPL");
> --
> 1.9.2
>

-Bryan
