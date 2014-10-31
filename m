Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbaJaD5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:57:48 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:40681 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaJaD5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+RfmHbA8WAE+RLNTBKD3BC+TM3OzS1+psaO28pBCS1S9NxWmQ@mail.gmail.com>
References: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
	<20141007142554.GE24720@saruman>
	<CA+RfmHaNpQRpEJmZLUHrYPfizS0w+bbeG+SVsFXOA-5jbXS_Wg@mail.gmail.com>
	<20141010152044.GG31348@saruman>
	<CA+RfmHbA8WAE+RLNTBKD3BC+TM3OzS1+psaO28pBCS1S9NxWmQ@mail.gmail.com>
Date: Fri, 31 Oct 2014 09:27:43 +0530
Message-ID: <CA+RfmHZ5nJZ6bYDQ+bWQfPTBpiabRkEiXKzkfntXamtJj9kJuQ@mail.gmail.com>
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

HI Felipe,

On 27 October 2014 15:06, Kiran Raparthy <kiran.kumar@linaro.org> wrote:
> Hi Felipe,
>
> On 10 October 2014 20:50, Felipe Balbi <balbi@ti.com> wrote:
>> Hi,
>>
>> On Fri, Oct 10, 2014 at 11:37:31AM +0530, Kiran Raparthy wrote:
>>> Hi Felipe,
>>> Thank you very much for taking time in reviewing the patch.
>>> I will try to improve the patch as per your suggestions.
>>> however,i have few queries which i wanted to understand from you.
>>
>> sure thing.
>>
>>> On 7 October 2014 19:55, Felipe Balbi <balbi@ti.com> wrote:
>>> >> +static int otg_wakeupsource_init(void)
>>> >> +{
>>> >> +     int ret_usb2;
>>> >> +     int ret_usb3;
>>> >> +     char wsource_name_usb2[40];
>>> >> +     char wsource_name_usb3[40];
>>> >> +     static struct usb_phy *otgws_xceiv_usb2;
>>> >> +     static struct usb_phy *otgws_xceiv_usb3;
>>> >> +
>>> >> +     otgws_xceiv_usb2 = usb_get_phy(USB_PHY_TYPE_USB2);
>>> >> +     otgws_xceiv_usb3 = usb_get_phy(USB_PHY_TYPE_USB3);
>>> >> +
>>> >> +     if (IS_ERR(otgws_xceiv_usb2) && IS_ERR(otgws_xceiv_usb3)) {
>>> >> +             pr_err("%s: No OTG transceiver found\n", __func__);
>>> >> +             return PTR_ERR(otgws_xceiv_usb2);
>>> >> +     }
>>> >> +
>>> >> +     spin_lock_init(&otgws_xceiv_usb2->otgws_slock);
>>> >> +     spin_lock_init(&otgws_xceiv_usb3->otgws_slock);
>>> >> +
>>> >> +     snprintf(wsource_name_usb2, sizeof(wsource_name_usb2),
>>> >> "vbus-%s",
>>> >> +             dev_name(otgws_xceiv_usb2->dev));
>>> >> +     wakeup_source_init(&otgws_xceiv_usb2->wsource,
>>> >> wsource_name_usb2);
>>> >> +
>>> >> +     snprintf(wsource_name_usb3, sizeof(wsource_name_usb3),
>>> >> "vbus-%s",
>>> >> +             dev_name(otgws_xceiv_usb3->dev));
>>> >> +     wakeup_source_init(&otgws_xceiv_usb3->wsource,
>>> >> wsource_name_usb3);
>>> >> +
>>> >> +     otgws_xceiv_usb2->otgws_nb.notifier_call =
>>> >> otgws_otg_usb2_notifications;
>>> >> +     ret_usb2 = usb_register_notifier(otgws_xceiv_usb2,
>>> >> +                                     &otgws_xceiv_usb2->otgws_nb);
>>> >> +
>>> >> +     otgws_xceiv_usb3->otgws_nb.notifier_call =
>>> >> otgws_otg_usb3_notifications;
>>> >> +     ret_usb3 = usb_register_notifier(otgws_xceiv_usb3,
>>> >> +                                     &otgws_xceiv_usb3->otgws_nb);
>>> >> +
>>> >> +     if (ret_usb2 && ret_usb3) {
>>> >> +             pr_err("%s: usb_register_notifier on transceiver
>>> >> failed\n",
>>> >> +                      __func__);
>>> >> +             wakeup_source_trash(&otgws_xceiv_usb2->wsource);
>>> >> +             wakeup_source_trash(&otgws_xceiv_usb3->wsource);
>>> >> +             otgws_xceiv_usb2 = NULL;
>>> >> +             otgws_xceiv_usb3 = NULL;
>>> >> +             return ret_usb2 | ret_usb3;
>>> >> +     }
>>> >> +
>>> >> +     return 0;
>>> >> +}
>>> >> +
>>> >> +late_initcall(otg_wakeupsource_init);
>>> >
>>> > you guys are really not getting what I mean. I asked for this to be
>>> > built into the core itself. This means that you shouldn't need to use
>>> > notifications nor should you need to call usb_get_phy(). You're part of
>>> > the PHY framework.
>>> >
>>> > All this late_initcall() nonsense should go.
>>> >
>>> > This code won't even work if we have more than one phy of the same type
>>> > (AM437x SoC, for example, has up to 4 instances of dwc3, so that's 4
>>> > USB2 PHYs), because you can't grab the PHY you want.
>>>
>>> Apologies,I am new to usb sub system,so i missed this point before i
>>> posted my patch,Thanks for the information.
>>
>> np.
>>
>>> > What you need is to:
>>> >
>>> > 1) make PHY notifiers generic (move all of that phy-core.c)
>>> From the above points,you mentioned that "if we built it into core,we
>>> shouldn't need to use notifications"
>>> and your first point here says that make phy notifiers generic in
>>> phy-core.c
>>> can you help me understanding it better so that there wont be any
>>> understanding gap.
>>
>> yeah, notifiers should go but if you really must use them, then at least
>> make all of that generic ;-)
>>
>>> > 2) introduce usb_phy_set_event(phy, event) (which just sets the even to
>>> > a
>>> >         phy->event member for now)
>>> > 3) make all PHY drivers use usb_phy_set_event()
>>> > 4) add the following to usb_phy_set_event()
>>> >
>>> >         switch (event) {
>>> >         case USB_EVENT_ENUMERATED:
>>> >                 pm_stay_awake(&otgws_xceiv->wsource);
>>> >                 break;
>>> >
>>> >         case USB_EVENT_NONE:
>>> >         case USB_EVENT_VBUS:
>>> >         case USB_EVENT_ID:
>>> >         case USB_EVENT_CHARGER:
>>> >                 pm_wakeup_event(&otgws_xceiv->wsource,
>>> >                                 msecs_to_jiffies(TEMPORARY_HOLD_TIME));
>>> >                 break;
>>> >
>>> >         default:
>>> >                 break;
>>> >         }
>>> >
>>> Once the phy drivers receives per-PHY event notification(if we use
>>> notifier,else "for any event") we can call usb_phy_set_event from phy
>>> driver to hold the wakeup source.
>>> Please correct me if my understanding is incorrect.
>>
>> yeah. In fact, you can call usb_phy_set_event() directly from PHY's IRQ
>> handler.
>>
>>> I have gone through some phy drivers in drivers/phy,since the each
>>> driver implementation is different from others, i didn't get the best
>>> place in  PHY driver
>>> where we can trigger(use phy-core functionality) per-PHY notifier
>>> registration. any pointers here?
>>
>> registration ? probe(), they all have probe() functions. Now to figure
>> out where to call usb_phy_set_event(). That's something completely
>> different, and that's where the core of this change is :-)
>>
>> For PHYs which have IRQ lines, easy: just call usb_phy_set_event() from
>> IRQ handler. For those who don't, then it's a little more difficult and
>> will require your investigation.
>
just a gentle reminder, can you have a look at below points and share
your thoughts?

> I am following below approach,please suggest/correct me, if you feel
> something is wrong.
>
> 1. Adding usb_phy_set_event function in drivers/usb/phy/phy.c(you asked me
> to add this in phy-core.c but i felt phy.c is right place to add this
> function).
> 2. Also add usb_phy_wsource_init and usb_phy_wsource_trash in phy.c so that
> PHY drivers can use these interfaces to initialize and trash per-PHY
> wakeupsource.
> 3. call usb_phy_wsource_init from probe and usb_phy_wsource_trash from probe
> and xxx_remove functions respectively in PHY drivers.
> 4. call usb_phy_set_event from PHY drivers where complete USB enumeration(as
> peripheral) event is handled(not simply on VBUS detection).
> 5. As of now,i am not using any notification mechanism.
>
> Below are some issues for which i need your suggestions:
> 1. In previous patches(till V3), i have used "enabled" field which is a
> module param(/sys/module/otg_wakeupsource/parameters/enabled) to disallow
> "holding wakeupsource".
>
>     your comment for the above field was "This shouldn't be kernel
> parameter" and you asked me to drop it,Just wanted to understand whether you
> want me to drop it completely
>     or implement it per-PHY(if we need to implement it per-PHY,we may have
> to add module param entry in each PHY driver which leads to N number of
> sysfs entries).
>
>     If you still prefers to have this functionality, can we use single
> "enabled" field for all PHY's?(to avoid N number of sysfs entries,just
> wanted to check if this is okay?)
>     If you want me to remove this field completely,then i can make change
> accordingly to my patch.Please clarify.
>
> 2. I have gone through all the PHY drivers,but i could able to change only 6
> drivers to use wakeup source mechanism(call usb_phy_set_event after USB
> enumerated in peripheral
>     mode).Is it okay if i submit the patch modifying only 6 PHY drivers as
> initial patch?
>
>     I have classified as below based on my observations(please let me know
> if you have any suggestions).
>
>     I have modified below phy drivers to use wakeupsource mechanism:
>     drivers/phy/phy-omap-control.c
>     drivers/usb/phy/phy-ab8500-usb.c
>     phy-gpio-vbus-usb.c
>     drivers/usb/phy/phy-tahvo.c
>     drivers/usb/phy/phy-mv-usb.c
>     drivers/usb/phy/phy-gpio-vbus-usb.c
>
>     For below phy drivers,no PHY events(Enumeration in peripheral mode) are
> handled in driver
>     drivers/phy/phy-bcm-kona-usb2.c
>     drivers/phy/phy-exynos4210-usb2.c
>     drivers/phy/phy-exynos4x12-usb2.c
>     drivers/phy/phy-exynos5250-sata.c
>     drivers/phy/phy-exynos5-usbdrd.c
>     drivers/phy/phy-exynos-dp-video.c
>     drivers/phy/phy-exynos-mipi-video.c
>     drivers/phy/phy-mvebu-sata.c
>     drivers/phy/phy-samsung-usb2.c
>     drivers/phy/phy-sun4i-usb.c
>     drivers/phy/phy-ti-pipe3.c
>     drivers/phy/phy-xgene.c
>     drivers/phy/phy-omap-usb2.c
>     drivers/phy/phy-twl4030-usb.c
>     drivers/usb/phy/phy-am335x.c
>     drivers/usb/phy/phy-am335x-control.c
>     drivers/usb/phy/phy-generic.c
>     drivers/usb/phy/phy-isp1301.c
>     drivers/usb/phy/phy-rcar-gen2-usb.c
>     drivers/usb/phy/phy-rcar-usb.c
>     drivers/usb/phy/phy-samsung-usb2.c
>     drivers/usb/phy/phy-samsung-usb3.c
>     drivers/usb/phy/phy-samsung-usb.c
>     drivers/usb/phy/phy-tegra-usb.c
>     drivers/usb/phy/phy-ulpi-viewport.c
>     drivers/usb/phy/phy-keystone.c
>     drivers/usb/phy/phy-mxs-usb.c
>     drivers/usb/phy-omap-otg.c
>     drivers/usb/phy/phy-ulpi.c
>
>     For below PHY driver,disconnect event not handled,so we can't hold
> wakeupsource.
>     drivers/usb/phy/phy-fsl-usb.c
>
>     For below PHY driver,only VBUS events are handled(Enumeration event not
> handled).
>     drivers/usb/phy/phy-twl6030-usb.c
>
>     For below PHY drivers,i am not clear where to call usb_phy_set_event
>     drivers/usb/phy/phy-isp1301-omap.c
>     drivers/usb/phy/phy-msm-usb.c
>
>
Regards,
Kiran
> Regards,
> Kiran
>>
>> --
>> balbi
