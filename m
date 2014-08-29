Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaH2M5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:57:33 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:56971 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbaH2M5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:57:31 -0400
From: Michal Sojka <sojka@merica.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: Re: [PATCH v4 3/3] usb: Add LED triggers for USB activity
In-Reply-To: <20140827210833.GB26372@kroah.com>
References: <20140827193028.GK6347@saruman.home> <1409173080-13921-1-git-send-email-sojka@merica.cz> <1409173080-13921-4-git-send-email-sojka@merica.cz> <20140827210833.GB26372@kroah.com>
User-Agent: Notmuch/0.18.1+70~ge8d943c (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 29 Aug 2014 14:57:23 +0200
Message-ID: <87k35rihcc.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27 2014, Greg Kroah-Hartman wrote:
> On Wed, Aug 27, 2014 at 10:58:00PM +0200, Michal Sojka wrote:
>> With this patch, USB activity can be signaled by blinking a LED. There
>> are two triggers, one for activity on USB host and one for USB gadget.
>> 
>> Both trigger should work with all host/device controllers. Tested only
>> with musb.
>> 
>> Signed-off-by: Michal Sojka <sojka@merica.cz>
>> ---
>>  drivers/usb/Kconfig               | 11 ++++++++
>>  drivers/usb/common/Makefile       |  1 +
>>  drivers/usb/common/led.c          | 56 +++++++++++++++++++++++++++++++++++++++
>>  drivers/usb/core/hcd.c            |  2 ++
>>  drivers/usb/gadget/udc/udc-core.c |  4 +++
>>  include/linux/usb.h               | 12 +++++++++
>>  6 files changed, 86 insertions(+)
>>  create mode 100644 drivers/usb/common/led.c
>> 
>> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
>> index e0cad441..fc90cda 100644
>> --- a/drivers/usb/Kconfig
>> +++ b/drivers/usb/Kconfig
>> @@ -147,4 +147,15 @@ source "drivers/usb/phy/Kconfig"
>>  
>>  source "drivers/usb/gadget/Kconfig"
>>  
>> +config USB_LED_TRIG
>> +	bool "USB LED Triggers"
>> +	depends on LEDS_CLASS && USB_COMMON
>> +	select LEDS_TRIGGERS
>
> I hate select lines, can't we just depend on LEDS_TRIGGERS as well as
> LEDS_CLASS?
>
>
>> +	help
>> +	  This option adds LED triggers for USB host and/or gadget activity.
>> +
>> +	  Say Y here if you are working on a system with led-class supported
>> +	  LEDs and you want to use them as activity indicators for USB host or
>> +	  gadget.
>> +
>>  endif # USB_SUPPORT
>> diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
>> index 052c120..ca2f8bd 100644
>> --- a/drivers/usb/common/Makefile
>> +++ b/drivers/usb/common/Makefile
>> @@ -4,5 +4,6 @@
>>  
>>  obj-$(CONFIG_USB_COMMON)	  += usb-common.o
>>  usb-common-y			  += common.o
>> +usb-common-$(CONFIG_USB_LED_TRIG) += led.o
>>  
>>  obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
>> diff --git a/drivers/usb/common/led.c b/drivers/usb/common/led.c
>> new file mode 100644
>> index 0000000..af3ce2c
>> --- /dev/null
>> +++ b/drivers/usb/common/led.c
>> @@ -0,0 +1,56 @@
>> +/*
>> + * LED Triggers for USB Activity
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
>> +#include <linux/usb.h>
>> +
>> +#define BLINK_DELAY 30
>> +
>> +static unsigned long usb_blink_delay = BLINK_DELAY;
>> +
>> +DEFINE_LED_TRIGGER(ledtrig_usb_gadget);
>> +DEFINE_LED_TRIGGER(ledtrig_usb_host);
>> +
>> +void usb_led_activity(enum usb_led_event ev)
>> +{
>> +	struct led_trigger *trig = NULL;
>> +
>> +	switch (ev) {
>> +	case USB_LED_EVENT_GADGET: trig = ledtrig_usb_gadget; break;
>> +	case USB_LED_EVENT_HOST:   trig = ledtrig_usb_host;    break;
>> +	}
>
> Very odd formatting, please use the correct one and don't try to put
> case expressions all on one line.
>
>> +	led_trigger_blink_oneshot(trig, &usb_blink_delay, &usb_blink_delay, 0);
>
> What happens if trig is NULL?

This will work correctly - I added a comment about it in v5.

>> +}
>> +EXPORT_SYMBOL(usb_led_activity);
>
> EXPORT_SYMBOL_GPL() please.
>
>> +static int __init ledtrig_usb_init(void)
>> +{
>> +#ifdef CONFIG_USB_GADGET
>> +	led_trigger_register_simple("usb-gadget", &ledtrig_usb_gadget);
>> +#endif
>> +#ifdef CONFIG_USB
>> +	led_trigger_register_simple("usb-host", &ledtrig_usb_host);
>> +#endif
>
> Why not just always register both?

I didn't want to offer users a trigger that doesn't do anything useful
on their system. Since you are the second person suggesting registering
both, I did just that in v5.

>> +	return 0;
>> +}
>> +
>> +static void __exit ledtrig_usb_exit(void)
>> +{
>> +	led_trigger_unregister_simple(ledtrig_usb_gadget);
>> +	led_trigger_unregister_simple(ledtrig_usb_host);
>
> So you can unregister things that you never registered with no issues?

Yes, but it doesn't matter anymore in v5.

>> +}
>> +
>> +module_init(ledtrig_usb_init);
>> +module_exit(ledtrig_usb_exit);
>> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
>> index 487abcf..409cb95 100644
>> --- a/drivers/usb/core/hcd.c
>> +++ b/drivers/usb/core/hcd.c
>> @@ -1664,6 +1664,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
>>  	usbmon_urb_complete(&hcd->self, urb, status);
>>  	usb_anchor_suspend_wakeups(anchor);
>>  	usb_unanchor_urb(urb);
>> +	if (likely(status == 0))
>> +		usb_led_activity(USB_LED_EVENT_HOST);
>
> That's a _really_ hot code path, how much is this going to cause in
> overhead?

I measured the overheads on ARM Cortex-A8 (TI AM335x) running on 600 MHz.

Duration of usb_led_activity():
- with no LED attached to the trigger:        2 ± 1 µs
- with one GPIO LED attached to the trigger:  2 ± 1 µs or 8 ± 2 µs (two peaks in histogram)

Duration of functions calling usb_led_activity()
(with my patches applied and no led attached to the trigger):
- __usb_hcd_giveback_urb():    10 - 25 µs
- usb_gadget_giveback_request(): 2 - 6 µs

With no LED attached, usb_led_activity() consists basically of
read_lock() and read_unlock().

I'll send v5 in a while.

Thanks,
-Michal
