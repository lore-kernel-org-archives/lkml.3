Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaJMDqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 23:46:08 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:34075 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaJMDqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 23:46:04 -0400
MIME-Version: 1.0
In-Reply-To: <20141010152044.GG31348@saruman>
References: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
	<20141007142554.GE24720@saruman>
	<CA+RfmHaNpQRpEJmZLUHrYPfizS0w+bbeG+SVsFXOA-5jbXS_Wg@mail.gmail.com>
	<20141010152044.GG31348@saruman>
Date: Mon, 13 Oct 2014 09:16:02 +0530
Message-ID: <CA+RfmHboDB4UwezfEP8X_7OfF2QfhfSKLmipXLRanpZY5YWSXw@mail.gmail.com>
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

On 10 October 2014 20:50, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Oct 10, 2014 at 11:37:31AM +0530, Kiran Raparthy wrote:
>> Hi Felipe,
>> Thank you very much for taking time in reviewing the patch.
>> I will try to improve the patch as per your suggestions.
>> however,i have few queries which i wanted to understand from you.
>
> sure thing.
>
>> On 7 October 2014 19:55, Felipe Balbi <balbi@ti.com> wrote:
>> >> +static int otg_wakeupsource_init(void)
>> >> +{
>> >> +     int ret_usb2;
>> >> +     int ret_usb3;
>> >> +     char wsource_name_usb2[40];
>> >> +     char wsource_name_usb3[40];
>> >> +     static struct usb_phy *otgws_xceiv_usb2;
>> >> +     static struct usb_phy *otgws_xceiv_usb3;
>> >> +
>> >> +     otgws_xceiv_usb2 = usb_get_phy(USB_PHY_TYPE_USB2);
>> >> +     otgws_xceiv_usb3 = usb_get_phy(USB_PHY_TYPE_USB3);
>> >> +
>> >> +     if (IS_ERR(otgws_xceiv_usb2) && IS_ERR(otgws_xceiv_usb3)) {
>> >> +             pr_err("%s: No OTG transceiver found\n", __func__);
>> >> +             return PTR_ERR(otgws_xceiv_usb2);
>> >> +     }
>> >> +
>> >> +     spin_lock_init(&otgws_xceiv_usb2->otgws_slock);
>> >> +     spin_lock_init(&otgws_xceiv_usb3->otgws_slock);
>> >> +
>> >> +     snprintf(wsource_name_usb2, sizeof(wsource_name_usb2), "vbus-%s",
>> >> +             dev_name(otgws_xceiv_usb2->dev));
>> >> +     wakeup_source_init(&otgws_xceiv_usb2->wsource, wsource_name_usb2);
>> >> +
>> >> +     snprintf(wsource_name_usb3, sizeof(wsource_name_usb3), "vbus-%s",
>> >> +             dev_name(otgws_xceiv_usb3->dev));
>> >> +     wakeup_source_init(&otgws_xceiv_usb3->wsource, wsource_name_usb3);
>> >> +
>> >> +     otgws_xceiv_usb2->otgws_nb.notifier_call = otgws_otg_usb2_notifications;
>> >> +     ret_usb2 = usb_register_notifier(otgws_xceiv_usb2,
>> >> +                                     &otgws_xceiv_usb2->otgws_nb);
>> >> +
>> >> +     otgws_xceiv_usb3->otgws_nb.notifier_call = otgws_otg_usb3_notifications;
>> >> +     ret_usb3 = usb_register_notifier(otgws_xceiv_usb3,
>> >> +                                     &otgws_xceiv_usb3->otgws_nb);
>> >> +
>> >> +     if (ret_usb2 && ret_usb3) {
>> >> +             pr_err("%s: usb_register_notifier on transceiver failed\n",
>> >> +                      __func__);
>> >> +             wakeup_source_trash(&otgws_xceiv_usb2->wsource);
>> >> +             wakeup_source_trash(&otgws_xceiv_usb3->wsource);
>> >> +             otgws_xceiv_usb2 = NULL;
>> >> +             otgws_xceiv_usb3 = NULL;
>> >> +             return ret_usb2 | ret_usb3;
>> >> +     }
>> >> +
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +late_initcall(otg_wakeupsource_init);
>> >
>> > you guys are really not getting what I mean. I asked for this to be
>> > built into the core itself. This means that you shouldn't need to use
>> > notifications nor should you need to call usb_get_phy(). You're part of
>> > the PHY framework.
>> >
>> > All this late_initcall() nonsense should go.
>> >
>> > This code won't even work if we have more than one phy of the same type
>> > (AM437x SoC, for example, has up to 4 instances of dwc3, so that's 4
>> > USB2 PHYs), because you can't grab the PHY you want.
>>
>> Apologies,I am new to usb sub system,so i missed this point before i
>> posted my patch,Thanks for the information.
>
> np.
>
>> > What you need is to:
>> >
>> > 1) make PHY notifiers generic (move all of that phy-core.c)
>> From the above points,you mentioned that "if we built it into core,we
>> shouldn't need to use notifications"
>> and your first point here says that make phy notifiers generic in phy-core.c
>> can you help me understanding it better so that there wont be any
>> understanding gap.
>
> yeah, notifiers should go but if you really must use them, then at least
> make all of that generic ;-)
>
>> > 2) introduce usb_phy_set_event(phy, event) (which just sets the even to a
>> >         phy->event member for now)
>> > 3) make all PHY drivers use usb_phy_set_event()
>> > 4) add the following to usb_phy_set_event()
>> >
>> >         switch (event) {
>> >         case USB_EVENT_ENUMERATED:
>> >                 pm_stay_awake(&otgws_xceiv->wsource);
>> >                 break;
>> >
>> >         case USB_EVENT_NONE:
>> >         case USB_EVENT_VBUS:
>> >         case USB_EVENT_ID:
>> >         case USB_EVENT_CHARGER:
>> >                 pm_wakeup_event(&otgws_xceiv->wsource,
>> >                                 msecs_to_jiffies(TEMPORARY_HOLD_TIME));
>> >                 break;
>> >
>> >         default:
>> >                 break;
>> >         }
>> >
>> Once the phy drivers receives per-PHY event notification(if we use
>> notifier,else "for any event") we can call usb_phy_set_event from phy
>> driver to hold the wakeup source.
>> Please correct me if my understanding is incorrect.
>
> yeah. In fact, you can call usb_phy_set_event() directly from PHY's IRQ
> handler.
>
>> I have gone through some phy drivers in drivers/phy,since the each
>> driver implementation is different from others, i didn't get the best
>> place in  PHY driver
>> where we can trigger(use phy-core functionality) per-PHY notifier
>> registration. any pointers here?
>
> registration ? probe(), they all have probe() functions. Now to figure
> out where to call usb_phy_set_event(). That's something completely
> different, and that's where the core of this change is :-)
>
> For PHYs which have IRQ lines, easy: just call usb_phy_set_event() from
> IRQ handler. For those who don't, then it's a little more difficult and
> will require your investigation.
Thanks for your inputs.
Regards,
Kiran
>
> --
> balbi
