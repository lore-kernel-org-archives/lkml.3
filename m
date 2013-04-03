Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab3DCOKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:10:49 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:39054 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3DCOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:10:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130403135659.GH14680@arwen.pp.htv.fi>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
	<1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
	<515BB951.40702@ti.com>
	<CAFp+6iG8WdWHXVCANx77OiTXLeZ-4qE4jySWqPLhfR1KOEP4fw@mail.gmail.com>
	<20130403081532.GE25837@arwen.pp.htv.fi>
	<CAFp+6iHXW8z2sc44c1hq2au_UnUyVZEr9D0t5BM4mfqcQKZgbA@mail.gmail.com>
	<20130403135414.GG14680@arwen.pp.htv.fi>
	<20130403135659.GH14680@arwen.pp.htv.fi>
Date: Wed, 3 Apr 2013 19:40:44 +0530
Message-ID: <CAFp+6iEmJtS2vxz8YHXP+FbNsxK2bR94rDrrSiKbGRRuUhBA5g@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, dianders@chromium.org,
        t.figa@samsung.com, p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Apr 3, 2013 at 7:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Apr 03, 2013 at 04:54:14PM +0300, Felipe Balbi wrote:
>> > >> >> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
>> > >> >> +{
>> > >> >> +       if (!x || !x->dev) {
>> > >> >> +               dev_err(x->dev, "no PHY or attached device available\n");
>> > >> >> +               return;
>> > >> >> +               }
>> > >> >> +
>> > >> >> +       pm_runtime_enable(x->dev);
>> > >> >> +}
>> > >> >
>> > >> >
>> > >> > IMO we need not have wrapper APIs for runtime_enable and runtime_disable
>> > >> > here. Generally runtime_enable and runtime_disable is done in probe and
>> > >> > remove of a driver respectively. So it's better to leave the
>> > >> > runtime_enable/runtime_disable to be done in *phy provider* driver than
>> > >> > having an API for it to be done by *phy user* driver. Felipe, what do you
>> > >> > think?
>> > >>
>> > >> Thanks!!
>> > >> That's very true, runtime_enable() and runtime_disable() calls are made by
>> > >> *phy_provider* only. But a querry here.
>> > >> Wouldn't in any case a PHY consumer might want to disable runtime_pm on PHY ?
>> > >> Say, when consumer failed to suspend the PHY properly
>> > >> (*put_sync(phy->dev)* fails), how much sure is the consumer about the
>> > >> state of PHY ?
>> > >
>> > > no no, wait a minute. We might not want to enable runtime pm for the PHY
>> > > until the UDC says it can handle runtime pm, no ? I guess this makes a
>> > > bit of sense (at least in my head :-p).
>> > >
>> > > Imagine if PHY is runtime suspended but e.g. DWC3 isn't runtime pm
>> > > enabled... Does it make sense to leave that control to the USB
>> > > controller drivers ?
>> > >
>> > > I'm open for suggestions
>> >
>> > Of course unless the PHY consumer can handle runtime PM for PHY,
>> > PHY should not ideally be going into runtime_suspend.
>> >
>> > Actually trying out few things, here are my observations
>> >
>> > Enabling runtime_pm on PHY pushes PHY to go into runtime_suspend state.
>> > But a device detection wakes up DWC3 controller, and if i don't wake
>> > up PHY (using get_sync(phy->dev)) here
>> > in runtime_resume() callback of DWC3, i don't get PHY back in active state.
>> > So it becomes the duty of DWC3 controller to handle PHY's sleep and wake-up.
>> > Thereby it becomes logical that DWC3 controller has the right to
>> > enable runtime_pm
>> > of PHY.
>> >
>> > But there's a catch here. if there are multiple consumers of PHY (like
>> > USB2 type PHY can
>> > have DWC3 controller as well as EHCI/OHCI or even HSGadget) then in that case,
>> > only one of the consumer can enable runtime_pm on PHY. So who decides this.
>> >
>> > Aargh!! lot of confusion here :-(
>>
>>
>> hmmm, maybe add a flag to struct usb_phy and check it on
>> usb_phy_autopm_enable() ??
>>
>> How does usbcore handle it ? They request class drivers to pass
>> supports_autosuspend, but while we should have a similar flag, that's
>> not enough. We also need a flag to tell us when pm_runtime has already
>> been enabled.

True

>>
>> So how about:
>>
>> usb_phy_autopm_enable()
>> {
>>       if (!phy->suports_autosuspend)
>>               return -ENOSYS;
>>
>>       if (phy->autosuspend_enabled)
>>               return 0;
>>
>>       phy->autosuspend_enabled = true;
>>       return pm_runtime_enable(phy->dev);
>> }
>>
>> ???

Great

>
> and of course I missed the fact that pm_runtime_enable returns nothing
> :-) But you got my point.

Yea, this is a way around this. :-)

Just one more query :-)

Lets suppose DWC3 enables runtime_pm on USB 2 type phy,
it will try to go into suspend state and thereby call runtime_suspend(), if any.
And PHY will come to active state only when its consumer wakes it up,
and this consumer is operational
only when its related PHY is in fully functional state.
So do we have a situation in which this PHY goes into low power state
in its runtime_suspend(),
resulting in non-detection of devices on further attach (since PHY is
in low power state) ?

Will the controller (like EHCI/OHCI) be functional now ?



-- 
Thanks & Regards
Vivek
