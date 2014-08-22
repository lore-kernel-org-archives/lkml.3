Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaHVRj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:39:28 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:58530 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaHVRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:39:26 -0400
MIME-Version: 1.0
In-Reply-To: <1408708399-20423-1-git-send-email-sojka@merica.cz>
References: <1408708399-20423-1-git-send-email-sojka@merica.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 22 Aug 2014 10:39:03 -0700
Message-ID: <CAK5ve-LaGPgsAVMMMw3=EWpjom5NF29btu0Yxjg=6iwPpioQFg@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: usb: Add LED trigger for USB gadget activity
To: Michal Sojka <sojka@merica.cz>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>, michal.vokac@comap.cz,
        Richard Purdie <rpurdie@rpsys.net>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 4:53 AM, Michal Sojka <sojka@merica.cz> wrote:
> With this patch, USB gadget activity can be signaled by blinking a LED.
>
> Since there is no generic code where to put the trigger for all USB
> controllers, each USB controller needs to call the trigger individually.
> This patch adds the call only for the musb controller where I can test
> it.
>

Generally I think one led trigger for both USB host and USB gadget
activity is good enough. We don't need 2 same led trigger here.

And probably you can just put this code in drivers/usb subsystem,
since this driver is quite simple to add to USB subsystem.

Thanks,
-Bryan

> Signed-off-by: Michal Sojka <sojka@merica.cz>
> ---
>  drivers/leds/trigger/Kconfig             |  8 ++++++
>  drivers/leds/trigger/Makefile            |  1 +
>  drivers/leds/trigger/ledtrig-usbgadget.c | 45 ++++++++++++++++++++++++++++++++
>  drivers/usb/musb/musb_gadget.c           |  6 +++--
>  include/linux/leds.h                     |  6 +++++
>  5 files changed, 64 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/leds/trigger/ledtrig-usbgadget.c
>
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index 49794b4..9562963 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -41,6 +41,14 @@ config LEDS_TRIGGER_IDE_DISK
>           This allows LEDs to be controlled by IDE disk activity.
>           If unsure, say Y.
>
> +config LEDS_TRIGGER_USBGADGET
> +       bool "LED USB Gadget Trigger"
> +       depends on (USB_MUSB_GADGET || USB_MUSB_DUAL_ROLE)
> +       depends on LEDS_TRIGGERS
> +       help
> +         This allows LEDs to be controlled by USB gadget activity.
> +         If unsure, say Y.
> +
>  config LEDS_TRIGGER_HEARTBEAT
>         tristate "LED Heartbeat Trigger"
>         depends on LEDS_TRIGGERS
> diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
> index 1abf48d..45917c0 100644
> --- a/drivers/leds/trigger/Makefile
> +++ b/drivers/leds/trigger/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_LEDS_TRIGGER_CPU)          += ledtrig-cpu.o
>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)  += ledtrig-default-on.o
>  obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)   += ledtrig-transient.o
>  obj-$(CONFIG_LEDS_TRIGGER_CAMERA)      += ledtrig-camera.o
> +obj-$(CONFIG_LEDS_TRIGGER_USBGADGET)   += ledtrig-usbgadget.o
> diff --git a/drivers/leds/trigger/ledtrig-usbgadget.c b/drivers/leds/trigger/ledtrig-usbgadget.c
> new file mode 100644
> index 0000000..1eb90da
> --- /dev/null
> +++ b/drivers/leds/trigger/ledtrig-usbgadget.c
> @@ -0,0 +1,45 @@
> +/*
> + * LED Trigger for USB Gadget Activity
> + *
> + * Copyright 2014 Michal Sojka <sojka@merica.cz>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/leds.h>
> +
> +#define BLINK_DELAY 30
> +
> +DEFINE_LED_TRIGGER(ledtrig_usbgadget);
> +static unsigned long usbgadget_blink_delay = BLINK_DELAY;
> +
> +void ledtrig_usbgadget_activity(void)
> +{
> +       led_trigger_blink_oneshot(ledtrig_usbgadget,
> +                                 &usbgadget_blink_delay, &usbgadget_blink_delay, 0);
> +}
> +EXPORT_SYMBOL(ledtrig_usbgadget_activity);
> +
> +static int __init ledtrig_usbgadget_init(void)
> +{
> +       led_trigger_register_simple("usb-gadget", &ledtrig_usbgadget);
> +       return 0;
> +}
> +
> +static void __exit ledtrig_usbgadget_exit(void)
> +{
> +       led_trigger_unregister_simple(ledtrig_usbgadget);
> +}
> +
> +module_init(ledtrig_usbgadget_init);
> +module_exit(ledtrig_usbgadget_exit);
> +
> +MODULE_AUTHOR("Michal Sojka <sojka@merica.cz>");
> +MODULE_DESCRIPTION("LED Trigger for USB Gadget Activity");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index d4aa779..98f8b24 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -42,6 +42,7 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
> +#include <linux/leds.h>
>
>  #include "musb_core.h"
>
> @@ -167,11 +168,12 @@ __acquires(ep->musb->lock)
>         if (!dma_mapping_error(&musb->g.dev, request->dma))
>                 unmap_dma_buffer(req, musb);
>
> -       if (request->status == 0)
> +       if (request->status == 0) {
>                 dev_dbg(musb->controller, "%s done request %p,  %d/%d\n",
>                                 ep->end_point.name, request,
>                                 req->request.actual, req->request.length);
> -       else
> +               ledtrig_usbgadget_activity();
> +       } else
>                 dev_dbg(musb->controller, "%s request %p, %d/%d fault %d\n",
>                                 ep->end_point.name, request,
>                                 req->request.actual, req->request.length,
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 0287ab2..5d9668e 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -218,6 +218,12 @@ extern void ledtrig_ide_activity(void);
>  static inline void ledtrig_ide_activity(void) {}
>  #endif
>
> +#ifdef CONFIG_LEDS_TRIGGER_USBGADGET
> +extern void ledtrig_usbgadget_activity(void);
> +#else
> +static inline void ledtrig_usbgadget_activity(void) {}
> +#endif
> +
>  #if defined(CONFIG_LEDS_TRIGGER_CAMERA) || defined(CONFIG_LEDS_TRIGGER_CAMERA_MODULE)
>  extern void ledtrig_flash_ctrl(bool on);
>  extern void ledtrig_torch_ctrl(bool on);
> --
> 2.1.0
>
