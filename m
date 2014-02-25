Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBYRIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:08:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42702 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752877AbaBYRIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:08:16 -0500
Date: Tue, 25 Feb 2014 12:08:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of
 suspended devices
In-Reply-To: <10187724.x3fLnu1cYV@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1402251010190.1294-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, Rafael J. Wysocki wrote:

> > This discussion is getting a little messy.  Let's try to clarify it.
> > Here is the major point:
> > 
> > 	We would like to save time during system suspend/resume by
> 
> Actually, that's not only about saving time, but also about saving energy.

Sure.

> > 	skipping over devices that are already in runtime suspend,
> > 	whenever it is safe to do so.
> > 
> > Of course, the "it is safe to do so" part is what makes this difficult.  
> > It boils down to three characteristics for each device.
> > 
> >     (a) The device uses the same power state for runtime suspend and
> > 	system suspend.  Therefore, if the device is already in runtime
> > 	suspend and the wakeup settings are correct, there is no need
> > 	for the PM core to invoke the device's ->suspend callbacks.
> > 
> > This requires a few comments.  The matter of whether the same power
> > state is used for both types of suspend is generally known beforehand,
> > because it is decided by the subsystem or driver.  The matter of
> > whether the wakeup settings are correct often can't be known until the
> > system suspend starts, because userspace can select whether or not
> > wakeup should be enabled during a system sleep.
> > 
> > Also, if the PM core is going to skip the ->suspend callbacks then it 
> > is obliged to skip the ->resume callbacks as well (we mustn't call one 
> > without the other).  Therefore, in cases where (a) holds, the device 
> > will necessarily emerge from the system resume in a runtime-suspended 
> > state.
> 
> The "emerge from system resume" requires a bit of clarification in my
> opinion.  Do you refer to the status of the device when user space is
> thawed or earlier?  If earlier, then when exactly?

The status of the device when its ->resume callback returns.  Or in 
the context of your patch, when the ->resume callback is skipped.

> > This may or may not cause problems for the device's children; 
> > see below.
> > 
> >     (b) It's okay for the device's parent to be in runtime suspend
> > 	when the device's ->suspend callbacks are invoked.
> > 
> > I included this just to be thorough.  In fact, I expect (b) to be true 
> > for pretty much every device already.
> 
> I don't quite understand this.  What if the parent is a bridge and the
> child's ->suspend tries to access the child's registers?  That surely won't
> work if the parent is in a low-power state at that point.

It _does_ work on all current systems -- but only because the question 
never arises if the device's parent is never in runtime suspend when 
the device's ->suspend callbacks are invoked.

I admit, there most likely _are_ devices that would get into trouble if
the question ever did arise.

> > In the absence of any sort of special arrangement, if (b) wasn't true 
> > for some device then that device would already be experiencing problems 
> > going into system suspend.
> 
> Unless, of course, its parent is a PCI device, because in that case it will
> always be resumed by the PCI bus type.  And if the "always resumed" is going
> to be changed to "only resumed if the parent's configuration needs to change",
> there may be some regressions here and there.

Okay, so you want to take a problem involving PCI and some other
subsystems, and solve it by getting the PM core involved.  And you want
to mix it in with the idea of "fast suspend".  Is that really the best
approach?

Here's another approach.  Add an "okay for my parent to be
runtime-suspended when my ->suspend and ->resume callbacks are invoked"  
flag to dev->power.  Make pci_pm_prepare(dev) check this flag in every
child of dev; if there are any children where the flag isn't set then
call pm_runtime_resume(dev) (and print a message in the kernel log so 
that you know which driver needs to be fixed).

This is appropriate because it adjusts the PCI core in a way that can
safely avoid regressions, without getting the PM core involved in
matters that should remain strictly between the PCI subsystem and the
subsystems of children of PCI devices.

It also allows the "fast suspend" change to be cleanly separated out 
into a second patch.  In that patch, all you do is set 
dev->power.fast_suspend if ->prepare returns > 0, and then you skip 
->suspend and ->resume if fast_suspend is set and the device is
runtime-suspended.

> I agree with the idea, but I have a certain view on how to achieve it.
> Which is by allowing the "good" ones to mark themselves as "good", then
> go through the ones that aren't marked as "good" yet, fix them up and
> mark them as "good".  Finally, when everyone is marked "good", we can
> drop the marking.

How will you know when nothing remains unmarked?

> The reasoning was basically to set fast_suspend for a device if your condition
> (a) held *and* if fast_suspend was set for all of the device's children.  Then
> we would know that all those children would be RPM_SUSPENDED during system
> resume as well and the resume part might be "streamlined" as well.  There was
> nothing about (c) anywhere in that patchset. :-)

This seems like getting the answer to the wrong question.  You want to
know whether the children are okay with the parent being
runtime-suspended during the child's suspend and resume callbacks, but
instead you are asking if the children can remain runtime-suspended
through the entire system suspend.  Those are two different questions.

They seem related, because if the parent is in runtime suspend then the
child must also be in runtime suspend (disregarding the possibility of
ignore_children).  But this is a red herring.  It's entirely possible
for the child to be RPM_ACTIVE during one of these callback even if the
parent is RPM_SUSPENDED when the callback starts.  The child's driver
merely needs to call pm_runtime_resume(dev) at the beginning of the
callback.

If the child's driver does this, it would be perfectly okay for the
parent to use fast_suspend without the child using it too.  You could
skip calling the parent's suspend and resume callbacks, and the child
would work just fine.

> That would be a different optimization from the one I'm thinking about.
> 
> For now, I'm focusing on one problem, which is when resuming runtime-suspended
> devices during system suspend may be avoided and how to make that generally
> work for different parent-child arrangements.
> 
> The resume part changes in my patchset were consequences of that only.

See, I think that by considering this as a single problem, you aren't 
getting down to the fundamental issues.

Alan Stern

