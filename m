Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3LBPVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:21:15 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:33743 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3LBPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:21:10 -0500
MIME-Version: 1.0
In-Reply-To: <3006899.CPLMC2kU1a@vostro.rjw.lan>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
	<81539588.EsdqydM2iX@vostro.rjw.lan>
	<CAPDyKFrRjB7gPpQ4c1U5e-BTHEt6k=kDqo7q1Grc04v-SDrsDw@mail.gmail.com>
	<3006899.CPLMC2kU1a@vostro.rjw.lan>
Date: Mon, 2 Dec 2013 16:21:09 +0100
Message-ID: <CAPDyKFopLAj=2mUMf5WC8_U=h9s06EU-2Ani4h1XaUG8vDR80w@mail.gmail.com>
Subject: Re: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at
 system suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Well, to be honest, I'd never put a call to pm_runtime_get_sync() into
> a driver's system suspend callback.

Nevertheless, the PM core allows it to happen and there are not only
subsystem-level code but also drivers that use it, for whatever
reasons.

>
> Subsystem callbacks are a different matter (see below).
>
>> Now, obviously I don't think we shall change the behaviour of PM core,
>> that would just not be convenient for subsystems and drivers, right?
>>
>> So, the PM core allows layering violations for the .runtime_resume
>> callbacks to be invoked during system suspend. It can do so, because
>> it trust drivers/subsystems to act responsibly and to what suites them
>> best.
>
> Actually, there's different reason for that.  Some subsystems (not necessarily
> drivers) resume devices during the prepare phase of system suspend in case
> those devices need to be reprogrammed before entering system sleep (for
> example, to change their wakeup settings).  That's done by the PCI bus type
> and ACPI PM domain.
>
> If that wasn't necessary, then yes, I would just disable the runtime PM
> framework for all devices during the entire system suspend/resume.
>
>> For the same reasons, I believe we should trust drivers/subsystems, to
>> understand when it makes sense for them to re-use all of the runtime
>> PM callbacks during system suspend and not just the .runtime_suspend
>> callback.
>>
>> That is in principle what I and Alan, who came up with this idea, are
>> suggesting.
>
> The problem with it is, as I said, the subsystem-level code you're calling
> back through pm_generic_suspend_late_runtime() (and the other resume function)
> has to be implemented in a specific way for things to work.  So it goes like
> this: "OK, now I'm not runtime-suspended, so I need to do something about that.
> Why don't I call back to the layer above me that has just called me (and that
> surely won't do anything after I return, right?), so that it does the right
> thing (which it surely will do, of course?) and calls my runtime PM callback
> as expected".

Let me try elaborate some more on the scenario I am trying to improve
for, in hope to make it more clear.

These are some typical runtime PM resources a driver may control:

- When clocks can be gated/ungated.
- When pins can be put in sleep/default state.
- When to drop/fetch a reference to a power domain regulator.
- When register context need to be saved/restored.

It still does not make sense for the driver itself to handle each
resource. For example, the PM domain code needs to control the actual
PM domain regulator. At subsystem-level, a bus could for example
control a bus clock, as in the AMBA case (drivers/amba/bus.c).

Before we continue the discussion about where, how and if the new
pm_generic functions should be implemented, I want to highlight the
following important facts while we consider the options.

1.
The order of handling the runtime PM resources are important,
including during the system suspend sequence. In these scenarios, the
driver has by default the knowledge of how to put it's device into low
power state and then obviously also how to restore it to full power.

Since historically, drivers could not re-use the runtime PM callbacks
to handle system suspend; in the OMAP2 case, this knowledge were
transferred to the PM domain. Quickly you then realize the PM domain
will become complex, due to the fact that it needs to know details
about every device. In principle parts of the drivers were moved to
the PM domain.

2.
Drivers (especially Cross SoC drivers) shall be able to put it's
device into low power state during system suspend, both with and
without a PM domain. Obviously because the existence of the PM domain
is SoC specific.

To make it more clear, drivers must not rely on that the PM domain
re-uses and invokes the runtime PM callbacks during system suspend to
put it's device into low power state. This can only be initiated by
the driver.

>
> And now suppose that your subsystem-level callbacks look like this (pseudo code):
>
> a_suspend_late(dev)
> {
>         if (successful(pm_generic_suspend_late(dev)))
>                 do_X(dev);
> }
>
> a_runtime_suspend(dev)
> {
>         if (successful(pm_generic_runtime_suspend(dev)))
>                 do_Y(dev);
> }
>
> Then, if the driver uses your pm_generic_suspend_late_runtime(), the actually
> executed code will be (assuming dev is not runtime-suspended):
>
>         a_suspend_late(dev)
>                 driver->suspend_late(dev)
>                         a_runtime_suspend(dev)
>                                 driver->runtime_suspend(dev)
>                                 do_Y(dev)
>         do_X(dev)
>
> So what if do_X(dev) after do_Y(dev) doesn't actually work?
>
> And what you actually want is
>
>         driver->runtime_suspend(dev)
>         do_Y(dev)
>
>> >> And, as you stated previously during these discussions, we have the
>> >> opportunity to update the documentation around this topic, I will
>> >> happily do it, if needed.
>> >
>> > That's always welcome. :-)
>> >
>> >> >
>> >> > Let's talk about specific examples, though.
>> >> >
>> >> > Why exactly do you need what patch [5/5] does in the exynos_drm_fimc driver?
>> >>
>> >> This was a simple example, I wanted to visualize how the new building
>> >> blocks were going to be used. Anyway, this we achieve with the patch:
>> >>
>> >> 1.
>> >> The PM part in the driver becomes simplified, we don't need the
>> >> wrapper functions for the runtime PM callbacks any more.
>> >
>> > No, it is not simplified.  It becomes *far* more complicated conceptually
>> > instead, although that is hidden by moving the complexity into the functions
>> > added by patch [1/5].  So whoever doesn't look into those functions will
>> > not actually realize how complicated the code really is.
>> >
>> >> 2.
>> >> Previously the driver did not make sure runtime PM was disabled,
>> >> before it put the device into low power state at .suspend. From a
>> >> runtime PM point of view, this is not a "nice" behaviour and opens up
>> >> for confusions, even if it likely would work in most cases.
>> >
>> > So the proper fix, in my opinion, would be to point .suspend_late and
>> > .resume_early in that driver to fimc_suspend() and fimc_resume(),
>> > respectively, and leave the .suspend and .resume pointers unpopulated.
>> >
>> > Wouldn't that actually work?
>>
>> If we decide to ignore the power domain issue below, yes.
>>
>> >
>> >> 3.
>> >> The power domain runtime PM callbacks were by-passed during system
>> >> suspend, my patch fixes this.
>> >
>> > I don't exactly understand this.  Why would they be bypassed?
>> >
>> >> Why do I want this? Because the power
>> >> domain can have runtime PM resources it need to handle at this phase.
>> >> Potentially, it could handle that from it's .suspend_late callback
>> >> instead, but then it gets unnecessary complicated, which is what
>> >> clearly happened to the power domain for OMAP2, for example.
>> >
>> > I'd like to understand this.  What exactly do you mean by "unnecessary
>> > complicated"?
>>
>> Please, have a deeper look into the OMAP power domain implementation.
>
> What files exactly do I need to look at?

Start with this:

arch/arm/mach-omap2/omap_device.c

>
>> If each SoC (for those that have power domain regulators) needs their
>> own version of such a power domain, then I certainly think it is more
>> complicated that in needs to be.
>
> They surely can share implementations.
>
>> >
>> >>
>> >> If you want additional proof of concepts, we can have a look at more
>> >> complex example.
>> >>
>> >> Typically I am thinking of cases were a cross SoC driver is attached
>> >> to a bus and for some SoCs a power domain as well. Then, the bus, the
>> >> power domain and the driver - all have runtime PM resources to handle.
>> >
>> > Sure.
>>
>> OK, I consider resending the patch set, including some additional
>> proof of concept patches.
>>
>> >
>> >> In these cases using the new building blocks will not only
>> >> significantly simplify code, but also fix immediate bugs. One example
>> >> are drivers attached to the AMBA bus, at drivers/amba/bus.c.
>> >
>> > Again, what drivers and what's the bug you're talking about?
>>
>> I will use some of these as examples, it will be more visible to you then.
>
> Well, I think I know what you're trying to do.  The problem is that in my
> opinion the way you're trying to achieve that is not the right one.

I am not so sure I have managed to describe the scenarios in detail
which I am trying to solve. Hopefully the information in this reply
adds some more insight though.

It sounds like you think the direction of where my solution is heading
is totally wrong. I would certainly appreciate some advise from you at
this point, because I am kind of out ideas at the moment.

Kind regards
Ulf Hansson

>
> Thanks!
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
