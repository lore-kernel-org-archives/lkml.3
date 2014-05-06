Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaEFTbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:31:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43115 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754194AbaEFTbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:31:03 -0400
Date: Tue, 6 May 2014 15:31:02 -0400 (EDT)
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
In-Reply-To: <4434633.DA7GzqtpnF@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405061035491.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Rafael J. Wysocki wrote:

> > > > You are using leave_runtime_suspended to mean two different things:  
> > > > remain runtime-suspended during the system suspend stages (i.e., no
> > > > reprogramming is needed so don't go to full power), and remain
> > > > runtime-suspended during both the system suspend and system resume
> > > > stages.  Only the first meaning matters if all you want to accomplish
> > > > is to avoid unnecessary runtime resumes during system suspend.
> > > 
> > > Well, this is not the case, becase you can't call ->resume_noirq() *after*
> > > ->runtime_suspend() for a number of drivers, as they simply may not expect
> > > that to happen (that covers all of the PCI drivers and the ACPI PM domain at
> > > least).

If you can't call ->resume_noirq() after ->runtime_suspend(), is it
okay to call ->suspend() after ->runtime_suspend()?

If it is okay, then there's no problem.  The subsystem invokes all of 
the driver's callbacks, even if leave_runtime_suspended is set.  The 
only difference is that the subsystem doesn't do a runtime-resume 
before invoking the ->suspend() callback.

It it's not okay...  Well, then the only option (aside from the runtime
resume we currently do) is to leave the device in runtime suspend all
the way up to the resume stage of system resume, and then do a
runtime-resume instead of calling ->resume().

> > For some non-PCI, non-ACPI PM domain drivers, it _is_ okay to call
> > ->resume_noirq() after ->runtime_suspend().
> 
> Yes, it may be OK to do that for some drivers, but not for all of them and
> that's the point.
> 
> > But forget about that; let's concentrate on PCI.  When a PCI driver
> > sets leave_runtime_suspended, it is telling the PCI core that it
> > doesn't mind having its ->resume_noirq() callback invoked after
> > ->runtime_suspend().
> 
> No, it doesn't.
> 
> First of all, you're assumig that drivers will set that flag, but PCI
> drivers have no idea about the wakeup settings which are taken care of by
> the PCI bus type.  This means that the bus type will also set
> leave_runtime_suspended.

How can the subsystem know whether the device is in a suitable state 
for system suspend?  Only the driver knows -- assuming there is a 
driver.  Agreed, if there is no driver then the subsystem might set
leave_runtime_suspended, but in that case it wouldn't cause any 
problem.

> Second, even if a driver sets leave_runtime_suspended for a device, this
> doesn't have to mean that its ->resume_noirq() may be called directly
> after its ->runtime_suspend().  What it means is that (a) the state of
> the device is appropriate for system suspend and (b) there are no reasons
> known to it why the device should be resumed during system suspend.

It's not too late to change the meaning.  :-)

> And yes, the subsystem can very well do it all by itself, but then the
> same approach will probably be duplicated in multiple subsystems and
> they won't be able to cross the bus type boundary, for example.

True.

> In fact, my original idea was to do that thing in the subsystems without
> involving the PM core, but then I would only be able to cover leaf devices.
> So I decided to do something more general, but the flag is exactly for what
> it does in the pach - to tell the PM core to skip a number of callbacks for
> a device, all of the high-level considerations notwithstanding.
> 
> So you may not like the idea that skipping suspend callbacks implies skipping
> the corresponding resume callbacks, but that's the simplest way to do it and
> quite frankly I don't see why this is a problem.

All right.  Then this seems to be what you want:

	For some devices, it's okay to remain in runtime suspend 
	throughout a complete system suspend/resume cycle (if the
	device was in runtime suspend at the start of the cycle).
	We would like to do this whenever possible, to avoid the
	overhead of extra power-up and power-down events.

	However, problems may arise because the device's descendants 
	may require it to be at full power at various points during 
	the cycle.  Therefore the only way to do this safely is if the 
	device _and_ all its descendants can remain runtime suspended 
	until the resume stage of system resume.

	To this end, introduce dev->power.leave_runtime_suspended.
	If a subsystem or driver sets this flag during the ->prepare()
	callback, and if the flag is set in all of the device's
	descendants, and if the device is still in runtime suspend when
	the ->suspend() callback would normally be invoked, then the PM
	core will not invoke the device's ->suspend(), 
	->suspend_late(), ->suspend_irq(), ->resume_irq(),
	->resume_early(), or ->resume() callbacks.  Instead, it will 
	invoke ->runtime_resume() during the resume stage of system
	resume.

	By setting this flag, a driver or subsystem tells the PM core
	that the device is runtime suspended, it is in a suitable state
	for system suspend (for example, the wakeup setting does not
	need to be changed), and it does not need to return to full
	power until the resume stage.

Does that correctly describe what you want to do, the potential
problems, and the proposed solution?

If so, then it appears the parent_needed flag is unnecessary.

Alan Stern

