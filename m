Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3K2Njd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:39:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65421 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752543Ab3K2Nj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:39:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at system suspend
Date: Fri, 29 Nov 2013 14:52:20 +0100
Message-ID: <3006899.CPLMC2kU1a@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAPDyKFrRjB7gPpQ4c1U5e-BTHEt6k=kDqo7q1Grc04v-SDrsDw@mail.gmail.com>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org> <81539588.EsdqydM2iX@vostro.rjw.lan> <CAPDyKFrRjB7gPpQ4c1U5e-BTHEt6k=kDqo7q1Grc04v-SDrsDw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 10:32:06 AM Ulf Hansson wrote:
> >
> > The lack of specificity here doesn't make the discussion any easier.
> >
> > It usually is better to talk about specific problems to address than
> > using general terms which may mean slightly different things for different
> > people.
> 
> During these discussions, I have tried to point at existing code for
> drivers and existing code for power domains. Those which at the moment
> either have got things wrong or are unnecessary complicated, in
> regards to their PM implementation.
> 
> I suppose I could provide some more patches for proof of concept, will
> that be a way forward?

I'd like to understand the problems you're trying to address first, to
be honest.

> >> >> Additionally, some drivers seems to have messed up things when combining
> >> >> runtime PM with system PM. While we enable the option of re-using the runtime
> >> >> PM callbacks during system PM, we also intend to clarify the way forward for
> >> >> how these scenarios could be resolved.
> >> >>
> >> >> Some new helper macros for defining PM callbacks and two new pm_generic*
> >> >> functions has been implemented in this patch set. These are provided to make it
> >> >> easier for those who wants to enable the option of re-using the runtime PM
> >> >> callbacks during system suspend.
> >> >
> >> > I'm generally opposed to re-using callbacks like this, because it adds confusion
> >> > to the picture.  It may seem to be clever, but in fact it leads to bad design
> >> > choices in the drivers in my opinion.
> >>
> >> In my world of the kernel, it will clearly resolve confusions and
> >> simplify a significant amount of code in power domains, buses and
> >> drivers. So I guess it depends on from what point you look at this.
> >
> > This is so vague that I don't even know how to respond. :-)
> >
> > So let me say instead that what you did in patch [5/5] is a layering violation
> > which always is a bug, even if it doesn't break things outright.
> >
> > After that patch the driver would call into a layer that is supposed to call
> > into it under normal conditions.  Moreover, it would expect that layer to
> > call back into it again in a specific way, which may or may not happen depending
> > on how exactly that layer is implemented.  So even if it works today, it will
> > add constraints on how that other layer may be implmented which *is* confusing
> > and wrong in my not so humble opinion.
> >
> > I'll never apply any patches that lead to situations like that, don't even
> > bother to send them to me.  Pretty please.
> >
> 
> After all these good discussions which clearly pointed the solution
> into this direction, you decide to bring up this argument now? It
> makes me wonder.
> 
> Indirectly what you are saying is that, the PM core should at
> device_prepare, do pm_runtime_disable() instead of
> pm_runtime_get_noresume(), to prevent drivers/subsystems from
> triggering "layering violations" by invoking pm_runtime_get_sync().
> 
> Because, this is exactly the same kind of layering violation you refer
> to while neglecting my approach, which at the moment
> drivers/subsystems not only are allowed to, but also encouraged to do
> during system suspend.

Well, to be honest, I'd never put a call to pm_runtime_get_sync() into
a driver's system suspend callback.

Subsystem callbacks are a different matter (see below).

> Now, obviously I don't think we shall change the behaviour of PM core,
> that would just not be convenient for subsystems and drivers, right?
> 
> So, the PM core allows layering violations for the .runtime_resume
> callbacks to be invoked during system suspend. It can do so, because
> it trust drivers/subsystems to act responsibly and to what suites them
> best.

Actually, there's different reason for that.  Some subsystems (not necessarily
drivers) resume devices during the prepare phase of system suspend in case
those devices need to be reprogrammed before entering system sleep (for
example, to change their wakeup settings).  That's done by the PCI bus type
and ACPI PM domain.

If that wasn't necessary, then yes, I would just disable the runtime PM
framework for all devices during the entire system suspend/resume.

> For the same reasons, I believe we should trust drivers/subsystems, to
> understand when it makes sense for them to re-use all of the runtime
> PM callbacks during system suspend and not just the .runtime_suspend
> callback.
> 
> That is in principle what I and Alan, who came up with this idea, are
> suggesting.

The problem with it is, as I said, the subsystem-level code you're calling
back through pm_generic_suspend_late_runtime() (and the other resume function)
has to be implemented in a specific way for things to work.  So it goes like
this: "OK, now I'm not runtime-suspended, so I need to do something about that.
Why don't I call back to the layer above me that has just called me (and that
surely won't do anything after I return, right?), so that it does the right
thing (which it surely will do, of course?) and calls my runtime PM callback
as expected".

And now suppose that your subsystem-level callbacks look like this (pseudo code):

a_suspend_late(dev)
{
	if (successful(pm_generic_suspend_late(dev)))
		do_X(dev);
}

a_runtime_suspend(dev)
{
	if (successful(pm_generic_runtime_suspend(dev)))
		do_Y(dev);
}

Then, if the driver uses your pm_generic_suspend_late_runtime(), the actually
executed code will be (assuming dev is not runtime-suspended):

	a_suspend_late(dev)
		driver->suspend_late(dev)
			a_runtime_suspend(dev)
				driver->runtime_suspend(dev)
				do_Y(dev)
	do_X(dev)

So what if do_X(dev) after do_Y(dev) doesn't actually work?

And what you actually want is

	driver->runtime_suspend(dev)
	do_Y(dev)

> >> And, as you stated previously during these discussions, we have the
> >> opportunity to update the documentation around this topic, I will
> >> happily do it, if needed.
> >
> > That's always welcome. :-)
> >
> >> >
> >> > Let's talk about specific examples, though.
> >> >
> >> > Why exactly do you need what patch [5/5] does in the exynos_drm_fimc driver?
> >>
> >> This was a simple example, I wanted to visualize how the new building
> >> blocks were going to be used. Anyway, this we achieve with the patch:
> >>
> >> 1.
> >> The PM part in the driver becomes simplified, we don't need the
> >> wrapper functions for the runtime PM callbacks any more.
> >
> > No, it is not simplified.  It becomes *far* more complicated conceptually
> > instead, although that is hidden by moving the complexity into the functions
> > added by patch [1/5].  So whoever doesn't look into those functions will
> > not actually realize how complicated the code really is.
> >
> >> 2.
> >> Previously the driver did not make sure runtime PM was disabled,
> >> before it put the device into low power state at .suspend. From a
> >> runtime PM point of view, this is not a "nice" behaviour and opens up
> >> for confusions, even if it likely would work in most cases.
> >
> > So the proper fix, in my opinion, would be to point .suspend_late and
> > .resume_early in that driver to fimc_suspend() and fimc_resume(),
> > respectively, and leave the .suspend and .resume pointers unpopulated.
> >
> > Wouldn't that actually work?
> 
> If we decide to ignore the power domain issue below, yes.
> 
> >
> >> 3.
> >> The power domain runtime PM callbacks were by-passed during system
> >> suspend, my patch fixes this.
> >
> > I don't exactly understand this.  Why would they be bypassed?
> >
> >> Why do I want this? Because the power
> >> domain can have runtime PM resources it need to handle at this phase.
> >> Potentially, it could handle that from it's .suspend_late callback
> >> instead, but then it gets unnecessary complicated, which is what
> >> clearly happened to the power domain for OMAP2, for example.
> >
> > I'd like to understand this.  What exactly do you mean by "unnecessary
> > complicated"?
> 
> Please, have a deeper look into the OMAP power domain implementation.

What files exactly do I need to look at?

> If each SoC (for those that have power domain regulators) needs their
> own version of such a power domain, then I certainly think it is more
> complicated that in needs to be.

They surely can share implementations.

> >
> >>
> >> If you want additional proof of concepts, we can have a look at more
> >> complex example.
> >>
> >> Typically I am thinking of cases were a cross SoC driver is attached
> >> to a bus and for some SoCs a power domain as well. Then, the bus, the
> >> power domain and the driver - all have runtime PM resources to handle.
> >
> > Sure.
> 
> OK, I consider resending the patch set, including some additional
> proof of concept patches.
> 
> >
> >> In these cases using the new building blocks will not only
> >> significantly simplify code, but also fix immediate bugs. One example
> >> are drivers attached to the AMBA bus, at drivers/amba/bus.c.
> >
> > Again, what drivers and what's the bug you're talking about?
> 
> I will use some of these as examples, it will be more visible to you then.

Well, I think I know what you're trying to do.  The problem is that in my
opinion the way you're trying to achieve that is not the right one.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
