Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaGIAPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:15:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46312 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaGIAPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:15:14 -0400
Date: Tue, 8 Jul 2014 17:15:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] GPIO button wth wakeup attribute is supposed to wake the
 system up
Message-ID: <20140709001506.GA14935@core.coreip.homeip.net>
References: <53A2340D.9030503@linux.intel.com>
 <1489151.dWxTTZlWzH@vostro.rjw.lan>
 <20140708221114.GA29203@core.coreip.homeip.net>
 <2213522.hTnsy9lMxO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2213522.hTnsy9lMxO@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:06:07AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, July 08, 2014 03:11:14 PM Dmitry Torokhov wrote:
> > On Tue, Jul 08, 2014 at 11:47:01PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, July 08, 2014 02:12:59 PM Dmitry Torokhov wrote:
> > > > On Tue, Jul 08, 2014 at 11:06:17PM +0200, Rafael J. Wysocki wrote:
> > > > > On Tuesday, July 08, 2014 01:45:30 PM Dmitry Torokhov wrote:
> > > > > > On Tue, Jul 08, 2014 at 10:52:52PM +0200, Rafael J. Wysocki wrote:
> > > > > > > On Thursday, June 19, 2014 08:51:25 AM Li, Aubrey wrote:
> > > > > > > > When the wakeup attribute is set, the GPIO button is capable of
> > > > > > > > waking up the system from sleep states, including the "freeze"
> > > > > > > > sleep state.  For that to work, its driver needs to pass the
> > > > > > > > IRQF_NO_SUSPEND flag to devm_request_any_context_irq(), or the
> > > > > > > > interrupt will be disabled by suspend_device_irqs() and the
> > > > > > > > system won't be woken up by it from the "freeze" sleep state.
> > > > > > > > 
> > > > > > > > The suspend_device_irqs() routine is a workaround for drivers
> > > > > > > > that mishandle interrupts triggered when the devices handled
> > > > > > > > by them are suspended, so it is safe to use IRQF_NO_SUSPEND in
> > > > > > > > all drivers that don't have that problem.
> > > > > > > > 
> > > > > > > > The affected/tested machines include Dell Venue 11 Pro and Asus T100TA.
> > > > > > > > 
> > > > > > > > Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
> > > > > > > > Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > 
> > > > > > > OK
> > > > > > > 
> > > > > > > Due to the lack of response (ie. no objections) and because the issue
> > > > > > > addressed by this patch is real, I'm queuing it up as a PM-related fix
> > > > > > > for 3.17.
> > > > > > 
> > > > > > Please do not. The response is till the same: board code should make sure
> > > > > > that enable_irq_wake() does the right thing and keeps interrupts enabled.
> > > > > 
> > > > > Which board code?  That's nothing like that for the platforms in question.
> > > > 
> > > > Then it needs to be written.
> > > 
> > > Well, excuse me, but I don't get it.  Why would I need to write any board code
> > > for an ACPI-based system?
> > 
> > Why would not you? What is the difference between ACPI systems and all
> > other systems? If ACPI-based systems need certain behavior they need to
> > implement it, the same as DT-based systems or custom boards.
> 
> I'm not sure what you're talking about.
> 
> This isn't an ACPI-based system that needs certain behavior.  That's certain
> behavior we want from GPIO buttons that can wake up *in* *general*.
> 
> Regardless of the platform, we want interrupts from those buttons to happen
> after calling suspend_device_irqs().  Why?  Because we want them to be able
> to happen while freeze_enter() is being executed and *that* is platform
> independent.

Tell me this: do we always call suspend_device_irqs()?

> 
> > > > > > It is wrong to patch drivers for this.
> > > > > 
> > > > > Why is it?  Only drivers know if they can handle incoming interrupts after
> > > > > having suspended their devices.
> > > > 
> > > > The driver correctly used enable_irq_wake() to indicate that interrupt should
> > > > be a wakeup source, the now the core/board needs to make sure the interrupt
> > > > gets delivered to the driver properly. We should not be patching every driver
> > > > that uses enable_irq_wake() with IRQF_NO_SUSPEND.
> > > 
> > > Interrupts that can wake up from the "freeze" sleep state need not be set up
> > > with enable_irq_wake() and the flag doesn't say "this is a wakeup interrupt".
> > > It says "do not suspend this interrupt, I can handle it after the device has
> > > been suspended" (as I said).
> > 
> > And the driver does not really care about this and whether the sleep
> > state is suspend or freeze or something else, it is your platform that
> > cares and has certain limitations that require interrupts to be not
> > suspended in certain cases.
> 
> Not in "certain cases", but actually never and it is not about any platform
> limitations.  I'm not sure what other words I need to use to make it more
> clear.
> 
> > From the driver POV it says that the device can be a waekup source
> > (again it does not care about details as to which sleep state we woudl
> > be waking from) and it expects the PM core to handle the things
> > properly. If certain sleep state requires interrupts to be kept on then
> > PM core should make them as such, not driver.
> 
> That would be the case in an ideal world, but the real one is not ideal,
> unfortunately.  The problem is that the PM core actually cannot decide
> which interrupts to keep on, because it doesn't know which drivers can
> cope with interrupts that happen after their devices have been suspended.
> Using IRQF_NO_SUSPEND is the way to experess that by a driver.

When device driver marks IRQ as a wakeup source I believe it is prepared
to handle it (or it would shut it off explicitly).

> 
> And again, that has nothing to do with platform limitations or requirements.
> All this is about is whether or not to allow interrupts to be *handled* by
> drivers after certain point in the suspend sequence, which is
> suspend_device_irqs().  By using IRQF_NO_SUSPEND drivers say, basically "it is
> OK to leave this IRQ as is, I promise to take care of it going forward" and
> that covers *all* suspend/hibernate transitions.
> 
> The reason why the "freeze" sleep state is somewhat special is that it doesn't
> do any platform-specific magic and needs *normal* device interrupts to work
> after suspend_device_irqs().  And I would *love* *to* drop suspend_device_irqs()
> at this point, but I can't, because there still are drivers that would have
> broken had I done that.
> 
> And I'm saying "somewhat" above, because that behavior is actually needed to
> prevent wakeup events occuring *during* suspend transitions from being lost
> for all kinds of those transitions (if someone actually cares).
> 
> > > 
> > > And if it is OK for a driver to set IRQF_SHARED, it is equally OK for it to
> > > set IRQF_NO_SUSPEND, because, in fact, those two flags are related.
> > 
> > Are you proposing for IRQ core to automatically set IRQF_NO_SUSPEND for
> > IRQF_SHARED interrupts? That wold be fine with me.
> 
> No, I'm not.

Then they are not really related that closely, are they?

> 
> The first choice basically is to go through all drivers that don't use IRQF_NO_SUSPEND
> and which have _noirq suspend callbacks (that covers all PCI drivers and some
> non-PCI ones too IIRC) and audit their interrupt handlers to check whether or not
> they can cope with interrupts coming after their devices have been suspended.  Fix
> the ones that can't and we can drop suspend_device_irqs().
> 
> But I guess I may be forgiven for regarding that as rather unattractive.  And we
> actually could have done that to start with, guess why we didn't?
> 
> The second choice is to use IRQF_NO_SUSPEND in the drivers that are OK.  That
> isn't too attractive either but has been practice for quite a while.
> 
> > > > If you look at the earlier patch discussion Tegra folks managed to implement
> > > > this behavior just fine.
> > > 
> > > I'm not sure whose idea it was that IRQF_NO_SUSPEND was not to be set by drivers,
> > > but it is not a correct one.  I know why suspend_device_irqs() was introduced
> > > and I'm telling you this has nothing to do with setting up the IRQ chip to do
> > > system wakeup.
> > 
> > I do not believe I asked why suspend_device_irqs() was introduced.
> 
> But you should, because suspend_device_irqs() is the very reason why
> IRQF_NO_SUSPEND exists. :-)

Then you should have shared this knowledge instead of asserting that you
possess it.

> 
> > > 
> > > And please grep for IRQF_NO_SUSPEND to see how drivers generally use it.
> > 
> > I see that just handful of them use IRQF_NO_SUSPEND (not sure how many
> > are actully required), I see that a lot more drivers use
> > enable_irq_wake() and do not bother setting IRQF_NO_SUSPEND.
> 
> And they will have problems with the "freeze" sleep state.
> 
> enable_irq_wake() is *not* a replacement for IRQF_NO_SUSPEND, nor the other
> way around.  They are different things.

However what I hear is that one has to use one when using another, and
form this fact comes my request: when entering freeze sleep state
interrupts that are marked as wakeup sources should be automatically
excluded form the list of IRQs that need to be suspended.

Thanks.

-- 
Dmitry
