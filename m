Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132Ab3DCNMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:12:53 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:45186 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3DCNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:12:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130403081532.GE25837@arwen.pp.htv.fi>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
	<1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
	<515BB951.40702@ti.com>
	<CAFp+6iG8WdWHXVCANx77OiTXLeZ-4qE4jySWqPLhfR1KOEP4fw@mail.gmail.com>
	<20130403081532.GE25837@arwen.pp.htv.fi>
Date: Wed, 3 Apr 2013 18:42:48 +0530
Message-ID: <CAFp+6iHXW8z2sc44c1hq2au_UnUyVZEr9D0t5BM4mfqcQKZgbA@mail.gmail.com>
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

Hi Felipe,


On Wed, Apr 3, 2013 at 1:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Apr 03, 2013 at 11:48:39AM +0530, Vivek Gautam wrote:
>> >> Adding  APIs to handle runtime power management on PHY
>> >> devices. PHY consumers may need to wake-up/suspend PHYs
>> >> when they work across autosuspend.
>> >>
>> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> >> ---
>> >>   include/linux/usb/phy.h |  141
>> >> +++++++++++++++++++++++++++++++++++++++++++++++
>> >>   1 files changed, 141 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
>> >> index 6b5978f..01bf9c1 100644
>> >> --- a/include/linux/usb/phy.h
>> >> +++ b/include/linux/usb/phy.h
>> >> @@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(enum
>> >> usb_phy_type type)
>> >>                 return "UNKNOWN PHY TYPE";
>> >>         }
>> >>   }
>> >> +
>> >> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
>> >> +{
>> >> +       if (!x || !x->dev) {
>> >> +               dev_err(x->dev, "no PHY or attached device available\n");
>> >> +               return;
>> >> +               }
>> >> +
>> >> +       pm_runtime_enable(x->dev);
>> >> +}
>> >
>> >
>> > IMO we need not have wrapper APIs for runtime_enable and runtime_disable
>> > here. Generally runtime_enable and runtime_disable is done in probe and
>> > remove of a driver respectively. So it's better to leave the
>> > runtime_enable/runtime_disable to be done in *phy provider* driver than
>> > having an API for it to be done by *phy user* driver. Felipe, what do you
>> > think?
>>
>> Thanks!!
>> That's very true, runtime_enable() and runtime_disable() calls are made by
>> *phy_provider* only. But a querry here.
>> Wouldn't in any case a PHY consumer might want to disable runtime_pm on PHY ?
>> Say, when consumer failed to suspend the PHY properly
>> (*put_sync(phy->dev)* fails), how much sure is the consumer about the
>> state of PHY ?
>
> no no, wait a minute. We might not want to enable runtime pm for the PHY
> until the UDC says it can handle runtime pm, no ? I guess this makes a
> bit of sense (at least in my head :-p).
>
> Imagine if PHY is runtime suspended but e.g. DWC3 isn't runtime pm
> enabled... Does it make sense to leave that control to the USB
> controller drivers ?
>
> I'm open for suggestions

Of course unless the PHY consumer can handle runtime PM for PHY,
PHY should not ideally be going into runtime_suspend.

Actually trying out few things, here are my observations

Enabling runtime_pm on PHY pushes PHY to go into runtime_suspend state.
But a device detection wakes up DWC3 controller, and if i don't wake
up PHY (using get_sync(phy->dev)) here
in runtime_resume() callback of DWC3, i don't get PHY back in active state.
So it becomes the duty of DWC3 controller to handle PHY's sleep and wake-up.
Thereby it becomes logical that DWC3 controller has the right to
enable runtime_pm
of PHY.

But there's a catch here. if there are multiple consumers of PHY (like
USB2 type PHY can
have DWC3 controller as well as EHCI/OHCI or even HSGadget) then in that case,
only one of the consumer can enable runtime_pm on PHY. So who decides this.

Aargh!! lot of confusion here :-(


>
> --
> balbi



-- 
Thanks & Regards
Vivek
