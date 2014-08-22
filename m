Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaHVXy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:54:28 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:33123 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbaHVXyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:54:25 -0400
From: Michal Sojka <sojka@merica.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-leds@vger.kernel.org, michal.vokac@comap.cz,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] leds: usb: Add LED trigger for USB gadget activity
In-Reply-To: <20140822215924.GB19838@saruman.home>
References: <1408708399-20423-1-git-send-email-sojka@merica.cz> <20140822215924.GB19838@saruman.home>
User-Agent: Notmuch/0.18.1+70~ge8d943c (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 23 Aug 2014 01:54:12 +0200
Message-ID: <87ha149j2z.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, Aug 22 2014, Felipe Balbi wrote:
> Hi,
>
> On Fri, Aug 22, 2014 at 01:53:12PM +0200, Michal Sojka wrote:
>> With this patch, USB gadget activity can be signaled by blinking a LED.
>> 
>> Since there is no generic code where to put the trigger for all USB
>> controllers, each USB controller needs to call the trigger individually.
>> This patch adds the call only for the musb controller where I can test
>> it.
>> 
>> Signed-off-by: Michal Sojka <sojka@merica.cz>
>> ---
>>  drivers/leds/trigger/Kconfig             |  8 ++++++
>>  drivers/leds/trigger/Makefile            |  1 +
>>  drivers/leds/trigger/ledtrig-usbgadget.c | 45 ++++++++++++++++++++++++++++++++
>>  drivers/usb/musb/musb_gadget.c           |  6 +++--
>>  include/linux/leds.h                     |  6 +++++
>>  5 files changed, 64 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/leds/trigger/ledtrig-usbgadget.c
>> 
>> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
>> index 49794b4..9562963 100644
>> --- a/drivers/leds/trigger/Kconfig
>> +++ b/drivers/leds/trigger/Kconfig
>> @@ -41,6 +41,14 @@ config LEDS_TRIGGER_IDE_DISK
>>  	  This allows LEDs to be controlled by IDE disk activity.
>>  	  If unsure, say Y.
>>  
>> +config LEDS_TRIGGER_USBGADGET
>> +	bool "LED USB Gadget Trigger"
>> +	depends on (USB_MUSB_GADGET || USB_MUSB_DUAL_ROLE)
>> +	depends on LEDS_TRIGGERS
>> +	help
>> +	  This allows LEDs to be controlled by USB gadget activity.
>> +	  If unsure, say Y.
>> +
>>  config LEDS_TRIGGER_HEARTBEAT
>>  	tristate "LED Heartbeat Trigger"
>>  	depends on LEDS_TRIGGERS
>> diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
>> index 1abf48d..45917c0 100644
>> --- a/drivers/leds/trigger/Makefile
>> +++ b/drivers/leds/trigger/Makefile
>> @@ -8,3 +8,4 @@ obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
>>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
>>  obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
>>  obj-$(CONFIG_LEDS_TRIGGER_CAMERA)	+= ledtrig-camera.o
>> +obj-$(CONFIG_LEDS_TRIGGER_USBGADGET)	+= ledtrig-usbgadget.o
>> diff --git a/drivers/leds/trigger/ledtrig-usbgadget.c b/drivers/leds/trigger/ledtrig-usbgadget.c
>> new file mode 100644
>> index 0000000..1eb90da
>> --- /dev/null
>> +++ b/drivers/leds/trigger/ledtrig-usbgadget.c
>> @@ -0,0 +1,45 @@
>> +/*
>> + * LED Trigger for USB Gadget Activity
>> + *
>> + * Copyright 2014 Michal Sojka <sojka@merica.cz>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/leds.h>
>> +
>> +#define BLINK_DELAY 30
>> +
>> +DEFINE_LED_TRIGGER(ledtrig_usbgadget);
>> +static unsigned long usbgadget_blink_delay = BLINK_DELAY;
>> +
>> +void ledtrig_usbgadget_activity(void)
>> +{
>> +	led_trigger_blink_oneshot(ledtrig_usbgadget,
>> +				  &usbgadget_blink_delay, &usbgadget_blink_delay, 0);
>> +}
>> +EXPORT_SYMBOL(ledtrig_usbgadget_activity);
>> +
>> +static int __init ledtrig_usbgadget_init(void)
>> +{
>> +	led_trigger_register_simple("usb-gadget", &ledtrig_usbgadget);
>> +	return 0;
>> +}
>> +
>> +static void __exit ledtrig_usbgadget_exit(void)
>> +{
>> +	led_trigger_unregister_simple(ledtrig_usbgadget);
>> +}
>> +
>> +module_init(ledtrig_usbgadget_init);
>> +module_exit(ledtrig_usbgadget_exit);
>> +
>> +MODULE_AUTHOR("Michal Sojka <sojka@merica.cz>");
>> +MODULE_DESCRIPTION("LED Trigger for USB Gadget Activity");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
>> index d4aa779..98f8b24 100644
>> --- a/drivers/usb/musb/musb_gadget.c
>> +++ b/drivers/usb/musb/musb_gadget.c
>> @@ -42,6 +42,7 @@
>>  #include <linux/delay.h>
>>  #include <linux/dma-mapping.h>
>>  #include <linux/slab.h>
>> +#include <linux/leds.h>
>>  
>>  #include "musb_core.h"
>>  
>> @@ -167,11 +168,12 @@ __acquires(ep->musb->lock)
>>  	if (!dma_mapping_error(&musb->g.dev, request->dma))
>>  		unmap_dma_buffer(req, musb);
>>  
>> -	if (request->status == 0)
>> +	if (request->status == 0) {
>>  		dev_dbg(musb->controller, "%s done request %p,  %d/%d\n",
>>  				ep->end_point.name, request,
>>  				req->request.actual, req->request.length);
>> -	else
>> +		ledtrig_usbgadget_activity();
>
> looks like this should, somehow, be done at udc-core.c although you'd
> need some refactoring to make that happen. It shouldn't be too difficult
> to have a generic usb_gadget_giveback_request()

I'm sending a second version, where it is moved to udc directory. I'll
look at refactoring next week.

Thanks,
-Michal
