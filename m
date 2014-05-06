Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbaEFBOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:14:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57660 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933458AbaEFBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:14:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flags to speed up suspend-resume of runtime-suspended devices
Date: Tue, 06 May 2014 03:31:21 +0200
Message-ID: <4434633.DA7GzqtpnF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405051018160.1443-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405051018160.1443-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2014 11:46:47 AM Alan Stern wrote:
> I'll trim a lot of material and respond to the points that are 
> important comments or criticisms.
> 
> On Mon, 5 May 2014, Rafael J. Wysocki wrote:
> 
> > > The description below is much better than the earlier one, but I still feel
> > > this deserves to be split in two: one patch for each new flag.
> > 
> > Well, I guess I can introduce power.leave_runtime_suspended for leaf devices
> > first, but that would be somewhat artificial, because in that case some code
> > added by the first patch would be removed by the second one. :-)
> 
> The "leaf devices" thing is a key point; see below.
> 
> > There is a theoretical case where the child is runtime-suspended, but
> > not actually zero-power, and it doesn't have leave_runtime_suspended set,
> > but its driver doesn't implement ->suspend() at all and instead it waits
> > until ->suspend_late() or even ->suspend_noirq() and then attempts to do
> > something extra to the device.  Then, if the parent is a bridge and is
> > required to be functional for accessing the child, we can't leave it
> > runtime-suspended too.
> > 
> > I'm not sure how realistic that is, to be honest, but it does look like
> > a valid thing to do to my eyes, so in my opinion we may need to get the
> > child driver's permission to leave the parent in runtime suspend for
> > that reason too.
> 
> The only time this would be a problem is if the driver changes the
> device's settings from the runtime-suspend values to the system-suspend
> values, without doing a runtime resume first.  For example, the driver
> might disable wakeup while the device remains at low power.
> 
> I'm not sure how realistic this is, either -- although it's not hard to 
> imagine a PCI driver doing this sort of thing.  Still, if you think we 
> should worry about it then I agree, the parent_needed flag ought to be 
> present from the start.
> 
> > I guess it is fair to simply say that "we need to get the child driver's
> > permission to leave the parent in runtime suspend".
> 
> Okay.  But does it follow that we need permission from the child's
> descendants as well?  I don't see any reason why.  After all, if a
> grandchild needs the child to be at full power, then the parent will
> automatically end up at full power too.  Which means neither
> leave_runtime_suspended nor parent_needed has to be propagated up the
> tree.
> 
> Hmmm, I just thought of something else.  What about non-parent-child 
> relationships?  Device B might depend on device A, even though A isn't 
> an ancestor of B.  I guess in this case, A's leave_runtime_suspended 
> flag should not be set.

That's true in general, but then I wouldn't expect A to be runtime-suspended
any more after B's ->suspend() has run which needs to happen before the A's
->suspend() runs and that's where the flag is checked.

[This assumes that rpm_resume() will clear leave_runtime_suspended automatically
and I'll make this assumption going forward.]

> > > As a corollary, if we don't have the child's permission to leave the
> > > parent suspended during system resume then we have to invoke all of the
> > > parent's resume callbacks, which means we also have to invoke all the
> > > suspend callbacks.  However, we still might be able to leave the parent
> > > in runtime suspend during the suspend stages.  The decision whether or
> > > not to do so should be up to the subsystem or driver, not the PM core; 
> > > the subsystem's callback routines can check the device's runtime status 
> > > and then do what they want.
> > 
> > Yes, but they can do that anyway, can't they? :-)
> 
> Yes, they can.  The point of this part of the patch is adding the
> leave_runtime_suspended flag (1) makes the subsystem's decision a
> little easier and (2) informs the subsystem when it can safely avoid
> perfoming a runtime resume in its ->suspend() callback.

Yes, it is.

> > > You are using leave_runtime_suspended to mean two different things:  
> > > remain runtime-suspended during the system suspend stages (i.e., no
> > > reprogramming is needed so don't go to full power), and remain
> > > runtime-suspended during both the system suspend and system resume
> > > stages.  Only the first meaning matters if all you want to accomplish
> > > is to avoid unnecessary runtime resumes during system suspend.
> > 
> > Well, this is not the case, becase you can't call ->resume_noirq() *after*
> > ->runtime_suspend() for a number of drivers, as they simply may not expect
> > that to happen (that covers all of the PCI drivers and the ACPI PM domain at
> > least).
> 
> For some non-PCI, non-ACPI PM domain drivers, it _is_ okay to call
> ->resume_noirq() after ->runtime_suspend().

Yes, it may be OK to do that for some drivers, but not for all of them and
that's the point.

> But forget about that; let's concentrate on PCI.  When a PCI driver
> sets leave_runtime_suspended, it is telling the PCI core that it
> doesn't mind having its ->resume_noirq() callback invoked after
> ->runtime_suspend().

No, it doesn't.

First of all, you're assumig that drivers will set that flag, but PCI
drivers have no idea about the wakeup settings which are taken care of by
the PCI bus type.  This means that the bus type will also set
leave_runtime_suspended.

Second, even if a driver sets leave_runtime_suspended for a device, this
doesn't have to mean that its ->resume_noirq() may be called directly
after its ->runtime_suspend().  What it means is that (a) the state of
the device is appropriate for system suspend and (b) there are no reasons
known to it why the device should be resumed during system suspend.

And yes, the subsystem can very well do it all by itself, but then the
same approach will probably be duplicated in multiple subsystems and
they won't be able to cross the bus type boundary, for example.

> If a PCI driver doesn't set
> leave_runtime_suspended, the PCI core will continue to handle it
> exactly the same as now: do a runtime resume before invoking the
> driver's ->suspend() callback.
> 
> > So you can't say "well, I'll skip your ->suspend_late and ->suspend_noirq,
> > but then I'll resume you traditionally" for those drivers, but this isn't
> > about remaining runtime-suspended during system resume too, but about
> > preserving the expected ordering of callbacks for them.
> 
> For drivers that don't set leave_runtime_suspended, the ordering of 
> callbacks will be unchanged.  That's why you introduced this flag 
> originally, right?

No.

> So that the subsystem would know which drivers don't mind doing things differently.

Again, no.

In fact, my original idea was to do that thing in the subsystems without
involving the PM core, but then I would only be able to cover leaf devices.
So I decided to do something more general, but the flag is exactly for what
it does in the pach - to tell the PM core to skip a number of callbacks for
a device, all of the high-level considerations notwithstanding.

So you may not like the idea that skipping suspend callbacks implies skipping
the corresponding resume callbacks, but that's the simplest way to do it and
quite frankly I don't see why this is a problem.

So if that is a problem, for example, for USB, please tell me why it is a
problem.  I mean, practically.

> > So yes, the goal is to "remain runtime-suspended during the system suspend stages",
> > but that *leads* *to* "do not execute system resume callbacks up to and including
> > ->resume()" either at least for an important subset of drivers.
> 
> I disagree, for the reasons given above.

Well, that means we don't agree here. :-)

> Now, this raises a second issue: How should we handle devices that can
> remain runtime-suspended through both the system suspend and system
> resume stages?  Maybe we better discuss that in a separate email
> thread.

I'm not sure what you mean?  Devices that can stay suspended throughout the
entire system suspend and resume?

> > > > Note: Drivers (or bus types etc.) can reasonably expect that the
> > > > next PM callback executed after ->runtime_suspend() will be
> > > > ->runtime_resume() rather than ->resume_noirq() or ->resume_early().
> > > > This change is designed with that expectation in mind.
> > > 
> > > Except, of course, that in the current kernel this isn't true.
> > 
> > Well, what about PCI devices?  Their drivers surely can have such an expectation,
> > because all of the PCI devices *are* resumed today in either pci_pm_prepare() or
> > pci_pm_suspend(), before executing the driver's ->suspend() callback.
> 
> Yes, of course.  But the USB subsystem, for example, doesn't expect it.

Well, it may not expect it and that's fine.  Still, as long as there are any
drivers that can expect it, the PM core has to take that into account.

> > > And there probably are a few cases where it can't ever be true.
> > 
> > It is easy to say things like that without giving any examples.
> 
> Sorry, what I meant was that _if_ a device is going to remain in 
> runtime suspend throughout the system suspend and system resume stages, 
> then there probably are cases where the device will have to come back 
> to full power during resume_early -- which means ->runtime_resume() 
> can't be used, because runtime PM is disabled during resume_early.  
> Isn't this true of PCI bridges?

Yes, we want PCI bridges to go to full power early and they are kind of special
in a few ways, so I don't think we'll set leave_runtime_suspended for them any
time soon (and it wouldn't make sense anyway, because they don't go to low
power during runtime suspend).

That said in principle if everything below a bridge is suspended it may
stay suspended too, as long as there's no need to access any devices below it.

This actually seems to be a key observation not only for bridges. :-)

Rafael

