Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaGHWL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:11:27 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43080 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGHWLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:11:24 -0400
Date: Tue, 8 Jul 2014 15:11:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] GPIO button wth wakeup attribute is supposed to wake the
 system up
Message-ID: <20140708221114.GA29203@core.coreip.homeip.net>
References: <53A2340D.9030503@linux.intel.com>
 <2962778.H1VBlZAtS4@vostro.rjw.lan>
 <20140708211259.GA26792@core.coreip.homeip.net>
 <1489151.dWxTTZlWzH@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489151.dWxTTZlWzH@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 11:47:01PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, July 08, 2014 02:12:59 PM Dmitry Torokhov wrote:
> > On Tue, Jul 08, 2014 at 11:06:17PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, July 08, 2014 01:45:30 PM Dmitry Torokhov wrote:
> > > > On Tue, Jul 08, 2014 at 10:52:52PM +0200, Rafael J. Wysocki wrote:
> > > > > On Thursday, June 19, 2014 08:51:25 AM Li, Aubrey wrote:
> > > > > > When the wakeup attribute is set, the GPIO button is capable of
> > > > > > waking up the system from sleep states, including the "freeze"
> > > > > > sleep state.  For that to work, its driver needs to pass the
> > > > > > IRQF_NO_SUSPEND flag to devm_request_any_context_irq(), or the
> > > > > > interrupt will be disabled by suspend_device_irqs() and the
> > > > > > system won't be woken up by it from the "freeze" sleep state.
> > > > > > 
> > > > > > The suspend_device_irqs() routine is a workaround for drivers
> > > > > > that mishandle interrupts triggered when the devices handled
> > > > > > by them are suspended, so it is safe to use IRQF_NO_SUSPEND in
> > > > > > all drivers that don't have that problem.
> > > > > > 
> > > > > > The affected/tested machines include Dell Venue 11 Pro and Asus T100TA.
> > > > > > 
> > > > > > Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
> > > > > > Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > 
> > > > > OK
> > > > > 
> > > > > Due to the lack of response (ie. no objections) and because the issue
> > > > > addressed by this patch is real, I'm queuing it up as a PM-related fix
> > > > > for 3.17.
> > > > 
> > > > Please do not. The response is till the same: board code should make sure
> > > > that enable_irq_wake() does the right thing and keeps interrupts enabled.
> > > 
> > > Which board code?  That's nothing like that for the platforms in question.
> > 
> > Then it needs to be written.
> 
> Well, excuse me, but I don't get it.  Why would I need to write any board code
> for an ACPI-based system?

Why would not you? What is the difference between ACPI systems and all
other systems? If ACPI-based systems need certain behavior they need to
implement it, the same as DT-based systems or custom boards.

> 
> > > > It is wrong to patch drivers for this.
> > > 
> > > Why is it?  Only drivers know if they can handle incoming interrupts after
> > > having suspended their devices.
> > 
> > The driver correctly used enable_irq_wake() to indicate that interrupt should
> > be a wakeup source, the now the core/board needs to make sure the interrupt
> > gets delivered to the driver properly. We should not be patching every driver
> > that uses enable_irq_wake() with IRQF_NO_SUSPEND.
> 
> Interrupts that can wake up from the "freeze" sleep state need not be set up
> with enable_irq_wake() and the flag doesn't say "this is a wakeup interrupt".
> It says "do not suspend this interrupt, I can handle it after the device has
> been suspended" (as I said).

And the driver does not really care about this and whether the sleep
state is suspend or freeze or something else, it is your platform that
cares and has certain limitations that require interrupts to be not
suspended in certain cases.

>From the driver POV it says that the device can be a waekup source
(again it does not care about details as to which sleep state we woudl
be waking from) and it expects the PM core to handle the things
properly. If certain sleep state requires interrupts to be kept on then
PM core should make them as such, not driver.

> 
> And if it is OK for a driver to set IRQF_SHARED, it is equally OK for it to
> set IRQF_NO_SUSPEND, because, in fact, those two flags are related.

Are you proposing for IRQ core to automatically set IRQF_NO_SUSPEND for
IRQF_SHARED interrupts? That wold be fine with me.

> 
> > If you look at the earlier patch discussion Tegra folks managed to implement
> > this behavior just fine.
> 
> I'm not sure whose idea it was that IRQF_NO_SUSPEND was not to be set by drivers,
> but it is not a correct one.  I know why suspend_device_irqs() was introduced
> and I'm telling you this has nothing to do with setting up the IRQ chip to do
> system wakeup.

I do not believe I asked why suspend_device_irqs() was introduced.

> 
> And please grep for IRQF_NO_SUSPEND to see how drivers generally use it.

I see that just handful of them use IRQF_NO_SUSPEND (not sure how many
are actully required), I see that a lot more drivers use
enable_irq_wake() and do not bother setting IRQF_NO_SUSPEND.

Thanks.

-- 
Dmitry
