Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbaHYS7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:59:39 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52697 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaHYS7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:59:37 -0400
MIME-Version: 1.0
In-Reply-To: <87egw7a5yd.fsf@steelpick.2x.cz>
References: <87ha149j2z.fsf@steelpick.2x.cz> <1408752502-4162-1-git-send-email-sojka@merica.cz>
 <1408752502-4162-3-git-send-email-sojka@merica.cz> <CAK5ve-LgeZcR+NHZoLo=rVKCk8TfRjRy-u7KwKRYs1weW==Nqw@mail.gmail.com>
 <87egw7a5yd.fsf@steelpick.2x.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 25 Aug 2014 11:59:14 -0700
Message-ID: <CAK5ve-Jz7=7uZ3_Qg2bAH9BiGRZ36k-Oj9TNZ-_nAvaq6LGbjA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] usb: Add LED trigger for USB host activity
To: Michal Sojka <sojka@merica.cz>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, michal.vokac@comap.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 2:52 AM, Michal Sojka <sojka@merica.cz> wrote:
> Hi Bryan,
>
> thanks for the review. See some comments below.
>
> On Sat, Aug 23 2014, Bryan Wu wrote:
>> On Fri, Aug 22, 2014 at 5:08 PM, Michal Sojka <sojka@merica.cz> wrote:
>>> With this patch, USB host activity can be signaled by blinking a LED.
>>>
>>> This should work with all host controllers. Tested only with musb.
>>>
>>> Signed-off-by: Michal Sojka <sojka@merica.cz>
>>> ---
>>>  drivers/usb/core/Kconfig  |  9 +++++++++
>>>  drivers/usb/core/Makefile |  1 +
>>>  drivers/usb/core/hcd.c    |  2 ++
>>>  drivers/usb/core/led.c    | 38 ++++++++++++++++++++++++++++++++++++++
>>>  include/linux/usb/hcd.h   |  6 ++++++
>>>  5 files changed, 56 insertions(+)
>>>  create mode 100644 drivers/usb/core/led.c
>>>
>>> diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
>>> index 1060657..8295f65 100644
>>> --- a/drivers/usb/core/Kconfig
>>> +++ b/drivers/usb/core/Kconfig
>>> @@ -90,3 +90,12 @@ config USB_OTG_FSM
>>>           Implements OTG Finite State Machine as specified in On-The-Go
>>>           and Embedded Host Supplement to the USB Revision 2.0 Specification.
>>>
>>> +config USB_HOST_LED
>>> +       bool "USB Host LED Trigger"
>>> +       depends on LEDS_CLASS
>>> +       select LEDS_TRIGGERS
>>> +       help
>>> +         This option adds a LED trigger for USB host controllers.
>>> +
>>> +         Say Y here if you are working on a system with led-class supported
>>> +         LEDs and you want to use them as USB host activity indicators.
>>> diff --git a/drivers/usb/core/Makefile b/drivers/usb/core/Makefile
>>> index 2f6f932..324c8c9 100644
>>> --- a/drivers/usb/core/Makefile
>>> +++ b/drivers/usb/core/Makefile
>>> @@ -9,5 +9,6 @@ usbcore-y += port.o
>>>
>>>  usbcore-$(CONFIG_PCI)          += hcd-pci.o
>>>  usbcore-$(CONFIG_ACPI)         += usb-acpi.o
>>> +usbcore-$(CONFIG_USB_HOST_LED) += led.o
>>>
>>>  obj-$(CONFIG_USB)              += usbcore.o
>>> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
>>> index 487abcf..46d9f3a 100644
>>> --- a/drivers/usb/core/hcd.c
>>> +++ b/drivers/usb/core/hcd.c
>>> @@ -1664,6 +1664,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
>>>         usbmon_urb_complete(&hcd->self, urb, status);
>>>         usb_anchor_suspend_wakeups(anchor);
>>>         usb_unanchor_urb(urb);
>>> +       if (status == 0)
>>> +               usb_hcd_led_activity();
>>>
>>>         /* pass ownership to the completion handler */
>>>         urb->status = status;
>>> diff --git a/drivers/usb/core/led.c b/drivers/usb/core/led.c
>>> new file mode 100644
>>> index 0000000..49ff76c
>>> --- /dev/null
>>> +++ b/drivers/usb/core/led.c
>>> @@ -0,0 +1,38 @@
>>> +/*
>>> + * LED Trigger for USB Host Activity
>>> + *
>>> + * Copyright 2014 Michal Sojka <sojka@merica.cz>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + */
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/init.h>
>>> +#include <linux/leds.h>
>>> +#include <linux/usb/hcd.h>
>>> +
>>> +#define BLINK_DELAY 30
>>> +
>>> +DEFINE_LED_TRIGGER(ledtrig_usb_hcd);
>>
>> Add one more trigger named ledtrig_usb_gadget
>>
>>> +static unsigned long usb_hcd_blink_delay = BLINK_DELAY;
>>> +
>>> +void usb_hcd_led_activity(void)
>>
>> Give an input parameter like emum usb_led_event.
>> USB_LED_EVENT_HOST = 0
>> USB_LED_EVENT_GADGET = 1
>>
>>
>>> +{
>>
>> Add case for USB_LED_EVENT_HOST:
>>> +       led_trigger_blink_oneshot(ledtrig_usb_hcd,
>>> +                                 &usb_hcd_blink_delay, &usb_hcd_blink_delay, 0);
>>
>> Add case for USB_LED_EVENT_GADGET:
>>  led_trigger_blink_oneshot(ledtrig_usb_gadget,
>>                              &usb_gadget_blink_delay,
>> &usb_gadget_blink_delay, 0);
>>
>>> +}
>>> +
>>> +int __init ledtrig_usb_hcd_init(void)
>>> +{
>>> +       led_trigger_register_simple("usb-host", &ledtrig_usb_hcd);
>> register one more trigger for gadget.
>
> This way, the code will be full of #ifdefs. Is the following really what
> you want? If you want to have it without #ifdefs, then I don't think it
> is a good idea to offer users the usb-gadget trigger on systems without
> usb gadget support.
>

Why do we need #ifdef here?
We can always define the 2 triggers for both USB host and gadget and
provide API like usb_led_activity().

If USB gadget stack is disabled in kernel, there is no users of this
usb_led_activity(, USB_LED_EVENT_GADGET). We don't need to change
anything in our driver but just waste one trigger instance.

Thanks,
-Bryan

> #define BLINK_DELAY 30
>
> static unsigned long usb_blink_delay = BLINK_DELAY;
>
> enum usb_led_event {
>         USB_LED_EVENT_HOST = 0,
>         USB_LED_EVENT_GADGET = 1,
> };
>
> #ifdef CONFIG_USB_GADGET_LED
> DEFINE_LED_TRIGGER(ledtrig_usbgadget);
> #endif
> #ifdef CONFIG_USB_HOST_LED
> DEFINE_LED_TRIGGER(ledtrig_usb_hcd);
> #endif
>
> void usb_led_activity(enum usb_led_event ev)
> {
>         struct led_trigger *trig;
>
>         switch (ev) {
> #ifdef CONFIG_USB_GADGET_LED
>         case USB_LED_EVENT_GADGET: trig = ledtrig_usb_gadget; break;
> #endif
> #ifdef CONFIG_USB_HOST_LED
>         case USB_LED_EVENT_HOST:   trig = ledtrig_usb_hcd; break;
> #endif
>         default:;
>         }
>         led_trigger_blink_oneshot(trig, &usb_blink_delay, &usb_blink_delay, 0);
> }
> EXPORT_SYMBOL(usb_led_activity);
>
>
> int __init ledtrig_usb_init(void)
> {
> #ifdef CONFIG_USB_GADGET_LED
>         led_trigger_register_simple("usb-gadget", &ledtrig_usbgadget);
> #endif
> #ifdef CONFIG_USB_HOST_LED
>         led_trigger_register_simple("usb-host", &ledtrig_usb_hcd);
> #endif
>         return 0;
> }
>
> void __exit ledtrig_usb_exit(void)
> {
> #ifdef CONFIG_USB_GADGET_LED
>         led_trigger_unregister_simple(ledtrig_usbgadget);
> #endif
> #ifdef CONFIG_USB_HOST_LED
>         led_trigger_unregister_simple(ledtrig_usb_hcd);
> #endif
> }
>
>
> -Michal
