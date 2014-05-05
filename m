Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaEEPqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:46:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42602 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754311AbaEEPqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:46:48 -0400
Date: Mon, 5 May 2014 11:46:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flags to speed up suspend-resume
 of runtime-suspended devices
In-Reply-To: <7301393.PpWC4ERV6A@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405051018160.1443-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll trim a lot of material and respond to the points that are 
important comments or criticisms.

On Mon, 5 May 2014, Rafael J. Wysocki wrote:

> > The description below is much better than the earlier one, but I still feel
> > this deserves to be split in two: one patch for each new flag.
> 
> Well, I guess I can introduce power.leave_runtime_suspended for leaf devices
> first, but that would be somewhat artificial, because in that case some code
> added by the first patch would be removed by the second one. :-)

The "leaf devices" thing is a key point; see below.

> There is a theoretical case where the child is runtime-suspended, but
> not actually zero-power, and it doesn't have leave_runtime_suspended set,
> but its driver doesn't implement ->suspend() at all and instead it waits
> until ->suspend_late() or even ->suspend_noirq() and then attempts to do
> something extra to the device.  Then, if the parent is a bridge and is
> required to be functional for accessing the child, we can't leave it
> runtime-suspended too.
> 
> I'm not sure how realistic that is, to be honest, but it does look like
> a valid thing to do to my eyes, so in my opinion we may need to get the
> child driver's permission to leave the parent in runtime suspend for
> that reason too.

The only time this would be a problem is if the driver changes the
device's settings from the runtime-suspend values to the system-suspend
values, without doing a runtime resume first.  For example, the driver
might disable wakeup while the device remains at low power.

I'm not sure how realistic this is, either -- although it's not hard to 
imagine a PCI driver doing this sort of thing.  Still, if you think we 
should worry about it then I agree, the parent_needed flag ought to be 
present from the start.

> I guess it is fair to simply say that "we need to get the child driver's
> permission to leave the parent in runtime suspend".

Okay.  But does it follow that we need permission from the child's
descendants as well?  I don't see any reason why.  After all, if a
grandchild needs the child to be at full power, then the parent will
automatically end up at full power too.  Which means neither
leave_runtime_suspended nor parent_needed has to be propagated up the
tree.

Hmmm, I just thought of something else.  What about non-parent-child 
relationships?  Device B might depend on device A, even though A isn't 
an ancestor of B.  I guess in this case, A's leave_runtime_suspended 
flag should not be set.

> > As a corollary, if we don't have the child's permission to leave the
> > parent suspended during system resume then we have to invoke all of the
> > parent's resume callbacks, which means we also have to invoke all the
> > suspend callbacks.  However, we still might be able to leave the parent
> > in runtime suspend during the suspend stages.  The decision whether or
> > not to do so should be up to the subsystem or driver, not the PM core; 
> > the subsystem's callback routines can check the device's runtime status 
> > and then do what they want.
> 
> Yes, but they can do that anyway, can't they? :-)

Yes, they can.  The point of this part of the patch is adding the
leave_runtime_suspended flag (1) makes the subsystem's decision a
little easier and (2) informs the subsystem when it can safely avoid
perfoming a runtime resume in its ->suspend() callback.

> > You are using leave_runtime_suspended to mean two different things:  
> > remain runtime-suspended during the system suspend stages (i.e., no
> > reprogramming is needed so don't go to full power), and remain
> > runtime-suspended during both the system suspend and system resume
> > stages.  Only the first meaning matters if all you want to accomplish
> > is to avoid unnecessary runtime resumes during system suspend.
> 
> Well, this is not the case, becase you can't call ->resume_noirq() *after*
> ->runtime_suspend() for a number of drivers, as they simply may not expect
> that to happen (that covers all of the PCI drivers and the ACPI PM domain at
> least).

For some non-PCI, non-ACPI PM domain drivers, it _is_ okay to call
->resume_noirq() after ->runtime_suspend().

But forget about that; let's concentrate on PCI.  When a PCI driver
sets leave_runtime_suspended, it is telling the PCI core that it
doesn't mind having its ->resume_noirq() callback invoked after
->runtime_suspend().  If a PCI driver doesn't set
leave_runtime_suspended, the PCI core will continue to handle it
exactly the same as now: do a runtime resume before invoking the
driver's ->suspend() callback.

> So you can't say "well, I'll skip your ->suspend_late and ->suspend_noirq,
> but then I'll resume you traditionally" for those drivers, but this isn't
> about remaining runtime-suspended during system resume too, but about
> preserving the expected ordering of callbacks for them.

For drivers that don't set leave_runtime_suspended, the ordering of 
callbacks will be unchanged.  That's why you introduced this flag 
originally, right?  So that the subsystem would know which drivers 
don't mind doing things differently.

> So yes, the goal is to "remain runtime-suspended during the system suspend stages",
> but that *leads* *to* "do not execute system resume callbacks up to and including
> ->resume()" either at least for an important subset of drivers.

I disagree, for the reasons given above.

Now, this raises a second issue: How should we handle devices that can
remain runtime-suspended through both the system suspend and system
resume stages?  Maybe we better discuss that in a separate email
thread.

> > > Note: Drivers (or bus types etc.) can reasonably expect that the
> > > next PM callback executed after ->runtime_suspend() will be
> > > ->runtime_resume() rather than ->resume_noirq() or ->resume_early().
> > > This change is designed with that expectation in mind.
> > 
> > Except, of course, that in the current kernel this isn't true.
> 
> Well, what about PCI devices?  Their drivers surely can have such an expectation,
> because all of the PCI devices *are* resumed today in either pci_pm_prepare() or
> pci_pm_suspend(), before executing the driver's ->suspend() callback.

Yes, of course.  But the USB subsystem, for example, doesn't expect it.

> > And there probably are a few cases where it can't ever be true.
> 
> It is easy to say things like that without giving any examples.

Sorry, what I meant was that _if_ a device is going to remain in 
runtime suspend throughout the system suspend and system resume stages, 
then there probably are cases where the device will have to come back 
to full power during resume_early -- which means ->runtime_resume() 
can't be used, because runtime PM is disabled during resume_early.  
Isn't this true of PCI bridges?

Alan Stern

