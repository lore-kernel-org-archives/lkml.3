Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3DWSF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:05:29 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:34350 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3DWSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:05:27 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1304231243040.1679-100000@iolanthe.rowland.org>
References: <CAFp+6iHWMqNQjKV_EQH-Zm6qKbuFwvPJZeswzNFVSSdH-VDB3Q@mail.gmail.com>
	<Pine.LNX.4.44L0.1304231243040.1679-100000@iolanthe.rowland.org>
Date: Tue, 23 Apr 2013 23:35:25 +0530
Message-ID: <CAFp+6iECumogLo9Tf+4pMqRhtkGHf1CqA52YjL1tACTRyGO7jw@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, dianders@chromium.org, t.figa@samsung.com,
        p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Apr 23, 2013 at 10:23 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 23 Apr 2013, Vivek Gautam wrote:
>
>> >> Alright, so here's my understanding:
>> >>
>> >> I suggested letting e.g. DWC3 enable the PHY's runtime_pm; Alan said
>> >> that it could be done before that so that DWC3 sees an enabled PHY
>> >> during probe.
>> >
>> > Basically right.  Help me to understand the overall situation a little
>> > better:
>> >
>> >         What code registers the PHY initially?
>>            PHY is added to global list by PHY drivers (like
>> phy-samsung-usb2.c/phy-omap-usb2.c)
>>            by usb_add_phy() API
>
> Then this routine should initialize the PHY.  The initialized state
> could be either active or suspended, your choice.  Suspended would be
> best, in case the PHY never gets used.

Fair enough.

>
>> >         What routine does the DWC3 driver call to register itself
>> >         as a consumer of the PHY?
>>            I think DWC3 doesn't registers itself as consumer of PHY,
>> rather it gets that PHY from
>>            the list using devm_usb_get_phy()/devm_usb_get_phy_by_phandle() API.
>>            DWC3 can now call PHY's initialization sequence using usb_phy_init().
>>            So, before DWC3 initializes the PHY, PHYs should be in active state.
>
> Then usb_phy_init should make sure the PHY is in the active state.  If
> usb_add_phy() left the PHY suspended, then this routine should call
> pm_runtime_get_sync().

Right

>
> After DWC3 (or any other driver) has acquired the PHY, it can call
> pm_runtime_put/get() however it likes, so long as the calls balance
> properly.  If the driver isn't runtime-PM aware then it won't use any
> of these calls, and the PHY will remain active the entire time.

Alright, so DWC3 (or any other consumer of PHY) should do minimal to
handle runtime state of PHYs; get() when accessing PHY and put() when it's done
with it.

>
>> >         Likewise, what routine does it call to unregister itself?
>>            Once DWC3's remove() is called PHYs are put.
>
> Is there a routine analogous to usb_phy_init() that gets called when
> PHY is released?  That routine would do the opposite of usb_phy_init(),
> putting the PHY back into its initialized state.

Yes, ofcourse there's a routine usb_phy_shutdown(). So this will be
calling put_sync()
to put PHYs back to its initialized state. Right ?



-- 
Best Regards
Vivek
