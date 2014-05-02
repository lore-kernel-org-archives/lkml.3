Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaEBSor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:44:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42666 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752146AbaEBSoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:44:44 -0400
Date: Fri, 2 May 2014 14:44:43 -0400 (EDT)
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
In-Reply-To: <6199158.2qqefUVTXs@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405021340180.1225-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Rafael J. Wysocki wrote:

> Well, I have a second update.
> 
> It has different flag names and changelog (that should explain things better
> hopefully) and the purpose of both flags should be more clear now (patch [3/3]
> would need to be reworked on top of this, but for now let's just discuss the
> core changes).

We've got patch descriptions passing in the night!  :-)

This doesn't contain any changes to the patch itself, apart from the 
flag names, right?  The description below is much better than the 
earlier one, but I still feel this deserves to be split in two: one 
patch for each new flag.

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PM / sleep: Flags to speed up suspend-resume of runtime-suspended devices
> 
> Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> resume all runtime-suspended devices during system suspend, mostly
> because those devices may need to be reprogrammed due to different
> wakeup settings for system sleep and for runtime PM.  However, at
> least in some cases, that isn't really necessary, because the wakeup
> settings may not be really different.
> 
> The idea here is that subsystems should know whether or not it is
> necessary to resume a given device during system suspend as long as
> they know that the device's children will not need it to be functional
> during the late/early and noirq phases of their suspend and resume.

Perhaps the matter of the children's requirements should be discussed 
more fully.  I skimmed over it in my suggested description too.

Under what conditions will a child need the parent device to be 
functional?  Let's start by assuming the parent's ignore_children 
bit isn't set.

By this assumption, if the child was at full power during the suspend
stages then the parent would have to be at full power too.  So let's
assume that the child is in runtime suspend when its ->suspend()
routine runs.  I can't think of any scenario where the child's driver
would require the parent to be at full power without also needing the
child to be at full power.  If the child really does need to be at full
power then the driver will have to do a runtime resume, which would
also bring the parent to full power.  Either way, we don't have to do
anything special -- during the suspend stages, if the child needs the 
parent to be at full power then it will be.

(As a variant of this case, maybe the child belongs to one of the
subsystems like PCI, and its driver expects the subsystem to
runtime-resume the child before invoking its ->suspend() callback.  
When the subsystem does this, the parent will automatically be resumed
as well.  Again there are no special requirements; the point is moot
because the parent will never be runtime-suspended when its ->suspend()
routine is ready to run.)

During the resume stages, if the child is going to be restored to full
power then certainly the parent has to be at full power first.  
Drivers expect this, so if we're going to leave the parent in runtime
suspend during system resume, we have to get the child driver's
permission first.  _That's_ what the parent_needed flag should mean.

What about the case where ignore_children _is_ set?  Then the child's 
driver might indeed need the parent to be at full power during system 
suspend, since we could start off with the parent suspended and the 
child active.

Putting these arguments together, the result is that during system
suspend we don't care about the children's needs unless the parent's
ignore_children bit is set.  But during system resume, we must resume
the parent unless the child's driver says we don't have to.

As a corollary, if we don't have the child's permission to leave the
parent suspended during system resume then we have to invoke all of the
parent's resume callbacks, which means we also have to invoke all the
suspend callbacks.  However, we still might be able to leave the parent
in runtime suspend during the suspend stages.  The decision whether or
not to do so should be up to the subsystem or driver, not the PM core; 
the subsystem's callback routines can check the device's runtime status 
and then do what they want.

> To help them with that, introduce two new device PM flags:
> power.parent_needed and power.leave_runtime_suspended supposed to work
> as follows.
> 
> The PM core will clear power.leave_runtime_suspended and will set
> power.parent_needed for all devices in dpm_prepare().  Next, the
> subsystem (or driver) of a device that in principle may not need
> to be resumed during system suspend, if runtume-suspended already,
> will set power.leave_runtime_suspended in its ->prepare() callback.
> Also the subsystems (or drivers) of devices whose parents need not
> be resumed during system suspend, if runtime-suspended already,
> are supposed to clear power.parent_needed for them.  The PM core
> will then clear power.leave_runtime_suspended for the parents of
> all devices having power.parent_needed set in __device_suspend().

You are using leave_runtime_suspended to mean two different things:  
remain runtime-suspended during the system suspend stages (i.e., no
reprogramming is needed so don't go to full power), and remain
runtime-suspended during both the system suspend and system resume
stages.  Only the first meaning matters if all you want to accomplish
is to avoid unnecessary runtime resumes during system suspend.

For the first meaning -- and I claim that this is the appropriate
meaning for this patch -- the leave_runtime_suspend flag doesn't depend
on the children's needs, except in the case where the parent's
ignore_children bit is set.  In that case, we could simply force the
parent's leave_runtime_suspended flag to be always off.  Or we could 
leave it set if it is set in all of the parent's children.

The parent_needed flag is the one that really has to propagate up the
device tree.  If this flag is set in a child then the PM core has to
invoke all the suspend and resume callbacks, not just in the child's
parent but in all its ancestors.  (Perhaps you could stop if you reach
an ancestor with ignore_children set, but it's safer not to.)

> Now, if the ->suspend() callback is executed for a device whose
> power.leave_runtime_suspended is set, it can simply return 0 after
> checking the device's state if that state is appropriate for
> system suspend.  The PM core will then skip the late/early and
> noirq system suspend/resume callbacks for that device and will
> use pm_runtime_resume() to resume it in device_resume().

By the discussion above, the PM core shouldn't skip anything
unless the parent_needed flag is clear.

> If the state of a device with power.leave_runtime_suspended is not
> appropriate for system suspend, the ->suspend() callback should
> resume it using pm_runtime_resume() and clear
> power.leave_runtime_suspended for it.

Oh yes, I forgot to discuss this earlier.  We have two choices for 
handling this:

	As you wrote above, require drivers not to set 
	leave_runtime_suspended if the device isn't in an appropriate
	state, and propagate the flag up the device tree.  (But as
	I mentioned, in most cases the flag shouldn't need to be
	propagated.)

	Make the PM core automatically clear leave_runtime_suspended
	whenever the device is (or becomes) runtime-active.  Then 
	callbacks don't have to check whether the device actually is in
	runtime suspend; they just have to check the flag.

I prefer the second choice, because it is easier for drivers.

> Note: Drivers (or bus types etc.) can reasonably expect that the
> next PM callback executed after ->runtime_suspend() will be
> ->runtime_resume() rather than ->resume_noirq() or ->resume_early().
> This change is designed with that expectation in mind.

Except, of course, that in the current kernel this isn't true.  And 
there probably are a few cases where it can't ever be true.

Alan Stern

