Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3DWMmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:42:12 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38206 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3DWMmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1304041022260.1324-100000@iolanthe.rowland.org>
References: <20130404092616.GD30991@arwen.pp.htv.fi>
	<Pine.LNX.4.44L0.1304041022260.1324-100000@iolanthe.rowland.org>
Date: Tue, 23 Apr 2013 18:12:06 +0530
Message-ID: <CAFp+6iHWMqNQjKV_EQH-Zm6qKbuFwvPJZeswzNFVSSdH-VDB3Q@mail.gmail.com>
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


On Thu, Apr 4, 2013 at 8:16 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

Apologies for delay in replying.

> On Thu, 4 Apr 2013, Felipe Balbi wrote:
>
>> > >> Some subsystems handle this issue by calling pm_runtime_get_sync()
>> > >> before probing a driver and pm_runtime_put_sync() after unbinding the
>> > >> driver.  If the driver is runtime-PM-enabled, it then does its own
>> > >> put_sync near the end of its probe routine and get_sync in its release
>> > >> routine.
>> > >
>> > > sounds a bit 'fishy' to me... So a separate entity would call
>> > > pm_runtime_get_sync(), even when we don't have registered dev_pm_ops,
>
> I don't know what you mean by "separate entity".  The PHY's subsystem
> would handle this.  After all, the subsystem has to handle registering
> the PHY in the first place.
>
> If the PHY doesn't have a dev_pm_ops, why are you talking about doing
> runtime PM on it?  That doesn't make any sense.
>
>> > > then drivers need to check if runtime_pm is enabled and call
>> > > pm_runtime_put*() conditionally before returning from probe(). One
>
> They don't have to check.  If CONFIG_PM_RUNTIME isn't set or the target
> is runtime-PM-disabled then pm_runtime_put* is essentially a no-op (in
> the disabled case it decrements the usage counter but doesn't do
> anything else).
>
> One possible complication I did not mention: The scheme described above
> assumes the device that uses the PHY will always be registered on the
> same type of bus.  If the device can be used on multiple bus types (and
> hence in multiple subsystems) then things aren't so simple, because
> some of the subsystems might support runtime PM and others might not.
> (You may very well run into this problem with USB controllers that are
> sometimes on a PCI bus and sometimes on a platform bus.)  In this case,
> the driver needs to adapt to the subsystem's capabilities.  Presumably
> the bus-glue part of the driver takes care of this.
>
>> > > remove, we might have another issue: device is already runtime_suspended
>> > > (due to e.g. autosuspend) when module is removed, a call to
>> > > pm_runtime_put_sync() will be unbalanced. No ?
>
> No.  I left out some of the details.  For one thing, the subsystem is
> careful to do a runtime resume before calling the driver's remove
> method.  (Also, if you look over my original description carefully,
> you'll see that there are no unbalanced calls -- even if the device is
> already runtime suspended when the driver is unbound.)
>
> For another, the subsystem needs to check before calling the driver's
> runtime-PM methods.  There are two brief windows during which the
> driver isn't in charge of the device even though dev->driver is set.
> Those windows occur in the subsystem's probe routine (before it calls
> the driver's probe method) and in the subsystem's remove routine
> (after it calls the driver's remove method).  At such times, the
> subsystem's runtime-PM handlers must be careful _not_ to call the
> driver's runtime-PM routines.
>
>> > May be i am misinterpreting !!
>> > If PHYs are runtime-PM enabled (PHY probe calls *runtime_enable*),
>> > then the consumers
>> > need to call pm_runtime_get_sync whever they want to access PHY.
>
> No, because in addition to being runtime-PM enabled, the PHY should
> automatically be runtime resumed when the consumer registers itself as
> a user of the PHY.  Therefore the consumer doesn't need to do anything
> at all -- which is good for consumers that aren't runtime-PM aware.
>
>> Alright, so here's my understanding:
>>
>> I suggested letting e.g. DWC3 enable the PHY's runtime_pm; Alan said
>> that it could be done before that so that DWC3 sees an enabled PHY
>> during probe.
>
> Basically right.  Help me to understand the overall situation a little
> better:
>
>         What code registers the PHY initially?
           PHY is added to global list by PHY drivers (like
phy-samsung-usb2.c/phy-omap-usb2.c)
           by usb_add_phy() API

>
>         What routine does the DWC3 driver call to register itself
>         as a consumer of the PHY?
           I think DWC3 doesn't registers itself as consumer of PHY,
rather it gets that PHY from
           the list using devm_usb_get_phy()/devm_usb_get_phy_by_phandle() API.
           DWC3 can now call PHY's initialization sequence using usb_phy_init().
           So, before DWC3 initializes the PHY, PHYs should be in active state.

>
>         Likewise, what routine does it call to unregister itself?
           Once DWC3's remove() is called PHYs are put.



-- 
Best Regards
Vivek
