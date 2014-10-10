Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaJJGHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 02:07:36 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:56420 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaJJGHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 02:07:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141007142554.GE24720@saruman>
References: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
	<20141007142554.GE24720@saruman>
Date: Fri, 10 Oct 2014 11:37:31 +0530
Message-ID: <CA+RfmHaNpQRpEJmZLUHrYPfizS0w+bbeG+SVsFXOA-5jbXS_Wg@mail.gmail.com>
Subject: Re: [RFC v4] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
Thank you very much for taking time in reviewing the patch.
I will try to improve the patch as per your suggestions.
however,i have few queries which i wanted to understand from you.

On 7 October 2014 19:55, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Oct 07, 2014 at 02:45:44PM +0530, Kiran Kumar Raparthy wrote:
>> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
>> new file mode 100644
>> index 0000000..00d3359
>> --- /dev/null
>> +++ b/drivers/usb/phy/otg-wakeupsource.c
>> @@ -0,0 +1,134 @@
>> +/*
>> + * otg-wakeupsource.c
>> + *
>> + * Copyright (C) 2011 Google, Inc.
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/device.h>
>> +#include <linux/module.h>
>> +#include <linux/notifier.h>
>> +#include <linux/pm_wakeup.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/usb/otg.h>
>> +
>> +static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned long event)
>> +{
>> +     unsigned long irqflags;
>> +
>> +     spin_lock_irqsave(&otgws_xceiv->otgws_slock, irqflags);
>> +
>> +     switch (event) {
>> +     case USB_EVENT_VBUS:
>
> Looks like VBUS should be temporary too.
>
>> +     case USB_EVENT_ENUMERATED:
>> +             __pm_stay_awake(&otgws_xceiv->wsource);
>> +             break;
>> +
>> +     case USB_EVENT_NONE:
>> +     case USB_EVENT_ID:
>> +     case USB_EVENT_CHARGER:
>> +             __pm_wakeup_event(&otgws_xceiv->wsource,
>> +                             msecs_to_jiffies(TEMPORARY_HOLD_TIME));
>> +             break;
>> +
>> +     default:
>> +             break;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&otgws_xceiv->otgws_slock, irqflags);
>> +}
>> +
>> +static int otgws_otg_usb2_notifications(struct notifier_block *nb,
>> +                             unsigned long event, void *unused)
>> +{
>> +     static struct usb_phy *otgws_xceiv;
>> +
>> +     otgws_xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
>> +
>> +     if (IS_ERR(otgws_xceiv)) {
>> +             pr_err("%s: No OTG transceiver found\n", __func__);
>> +             return PTR_ERR(otgws_xceiv);
>> +     }
>> +
>> +     otgws_handle_event(otgws_xceiv, event);
>> +
>> +     return NOTIFY_OK;
>> +}
>> +
>> +static int otgws_otg_usb3_notifications(struct notifier_block *nb,
>> +                             unsigned long event, void *unused)
>> +{
>> +     static struct usb_phy *otgws_xceiv;
>> +
>> +     otgws_xceiv = usb_get_phy(USB_PHY_TYPE_USB3);
>> +
>> +     if (IS_ERR(otgws_xceiv)) {
>> +             pr_err("%s: No OTG transceiver found\n", __func__);
>> +             return PTR_ERR(otgws_xceiv);
>> +     }
>> +
>> +     otgws_handle_event(otgws_xceiv, event);
>> +
>> +     return NOTIFY_OK;
>> +}
>> +
>> +static int otg_wakeupsource_init(void)
>> +{
>> +     int ret_usb2;
>> +     int ret_usb3;
>> +     char wsource_name_usb2[40];
>> +     char wsource_name_usb3[40];
>> +     static struct usb_phy *otgws_xceiv_usb2;
>> +     static struct usb_phy *otgws_xceiv_usb3;
>> +
>> +     otgws_xceiv_usb2 = usb_get_phy(USB_PHY_TYPE_USB2);
>> +     otgws_xceiv_usb3 = usb_get_phy(USB_PHY_TYPE_USB3);
>> +
>> +     if (IS_ERR(otgws_xceiv_usb2) && IS_ERR(otgws_xceiv_usb3)) {
>> +             pr_err("%s: No OTG transceiver found\n", __func__);
>> +             return PTR_ERR(otgws_xceiv_usb2);
>> +     }
>> +
>> +     spin_lock_init(&otgws_xceiv_usb2->otgws_slock);
>> +     spin_lock_init(&otgws_xceiv_usb3->otgws_slock);
>> +
>> +     snprintf(wsource_name_usb2, sizeof(wsource_name_usb2), "vbus-%s",
>> +             dev_name(otgws_xceiv_usb2->dev));
>> +     wakeup_source_init(&otgws_xceiv_usb2->wsource, wsource_name_usb2);
>> +
>> +     snprintf(wsource_name_usb3, sizeof(wsource_name_usb3), "vbus-%s",
>> +             dev_name(otgws_xceiv_usb3->dev));
>> +     wakeup_source_init(&otgws_xceiv_usb3->wsource, wsource_name_usb3);
>> +
>> +     otgws_xceiv_usb2->otgws_nb.notifier_call = otgws_otg_usb2_notifications;
>> +     ret_usb2 = usb_register_notifier(otgws_xceiv_usb2,
>> +                                     &otgws_xceiv_usb2->otgws_nb);
>> +
>> +     otgws_xceiv_usb3->otgws_nb.notifier_call = otgws_otg_usb3_notifications;
>> +     ret_usb3 = usb_register_notifier(otgws_xceiv_usb3,
>> +                                     &otgws_xceiv_usb3->otgws_nb);
>> +
>> +     if (ret_usb2 && ret_usb3) {
>> +             pr_err("%s: usb_register_notifier on transceiver failed\n",
>> +                      __func__);
>> +             wakeup_source_trash(&otgws_xceiv_usb2->wsource);
>> +             wakeup_source_trash(&otgws_xceiv_usb3->wsource);
>> +             otgws_xceiv_usb2 = NULL;
>> +             otgws_xceiv_usb3 = NULL;
>> +             return ret_usb2 | ret_usb3;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +late_initcall(otg_wakeupsource_init);
>
> you guys are really not getting what I mean. I asked for this to be
> built into the core itself. This means that you shouldn't need to use
> notifications nor should you need to call usb_get_phy(). You're part of
> the PHY framework.
>
> All this late_initcall() nonsense should go.
>
> This code won't even work if we have more than one phy of the same type
> (AM437x SoC, for example, has up to 4 instances of dwc3, so that's 4
> USB2 PHYs), because you can't grab the PHY you want.

Apologies,I am new to usb sub system,so i missed this point before i
posted my patch,Thanks for the information.
>
> What you need is to:
>
> 1) make PHY notifiers generic (move all of that phy-core.c)
>From the above points,you mentioned that "if we built it into core,we
shouldn't need to use notifications"
and your first point here says that make phy notifiers generic in phy-core.c
can you help me understanding it better so that there wont be any
understanding gap.

> 2) introduce usb_phy_set_event(phy, event) (which just sets the even to a
>         phy->event member for now)
> 3) make all PHY drivers use usb_phy_set_event()
> 4) add the following to usb_phy_set_event()
>
>         switch (event) {
>         case USB_EVENT_ENUMERATED:
>                 pm_stay_awake(&otgws_xceiv->wsource);
>                 break;
>
>         case USB_EVENT_NONE:
>         case USB_EVENT_VBUS:
>         case USB_EVENT_ID:
>         case USB_EVENT_CHARGER:
>                 pm_wakeup_event(&otgws_xceiv->wsource,
>                                 msecs_to_jiffies(TEMPORARY_HOLD_TIME));
>                 break;
>
>         default:
>                 break;
>         }
>
Once the phy drivers receives per-PHY event notification(if we use
notifier,else "for any event") we can call usb_phy_set_event from phy
driver to hold the wakeup source.
Please correct me if my understanding is incorrect.

I have gone through some phy drivers in drivers/phy,since the each
driver implementation is different from others, i didn't get the best
place in  PHY driver
where we can trigger(use phy-core functionality) per-PHY notifier
registration. any pointers here?
Regards,
Kiran

> note that I'm calling locked versions of those functions so you can drop
> the spinlock you added. But, dependending on when usb_phy_set_event() is
> called, you might want to switch back to unlocked versions. In any case,
> the new spinlock is unnecessary because you can either use
> dev->power.lock or you're calling usb_phy_set_event() from and IRQ
> handler.
>
>> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
>> index 353053a..dd64e2e 100644
>> --- a/include/linux/usb/phy.h
>> +++ b/include/linux/usb/phy.h
>> @@ -12,6 +12,8 @@
>>  #include <linux/notifier.h>
>>  #include <linux/usb.h>
>>
>> +#define TEMPORARY_HOLD_TIME    2000
>> +
>>  enum usb_phy_interface {
>>       USBPHY_INTERFACE_MODE_UNKNOWN,
>>       USBPHY_INTERFACE_MODE_UTMI,
>> @@ -88,6 +90,12 @@ struct usb_phy {
>>
>>       /* for notification of usb_phy_events */
>>       struct atomic_notifier_head     notifier;
>> +     struct notifier_block   otgws_nb;
>
> drop this notifier block.
>
>> +
>> +     /* wakeup source */
>> +     struct wakeup_source    wsource;
>
> this is the only thing you need.
>
>> +
>> +     spinlock_t              otgws_slock;
>
> drop this lock.
>
> --
> balbi
