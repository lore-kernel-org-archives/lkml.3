Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaEBQMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:12:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753230AbaEBQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:12:33 -0400
Date: Fri, 2 May 2014 12:12:32 -0400 (EDT)
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
In-Reply-To: <1898485.lQeVbtvK4U@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405021104120.1225-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Rafael J. Wysocki wrote:

> On Friday, May 02, 2014 01:15:14 AM Rafael J. Wysocki wrote:
> > On Thursday, May 01, 2014 05:39:31 PM Alan Stern wrote:
> > > On Fri, 25 Apr 2014, Rafael J. Wysocki wrote:
> > > 
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> > > > resume all runtime-suspended devices during system suspend, mostly
> > > > because those devices may need to be reprogrammed due to different
> > > > wakeup settings for system sleep and for runtime PM.  However, at
> > > > least in some cases, that isn't really necessary, because the wakeup
> > > > settings may not be really different.
> > > > 
> > > > The idea here is that subsystems should know whether or not it is
> > > > necessary to reprogram a given device during system suspend and they
> > > > should be able to tell the PM core about that.  For that reason, add
> > > > two new device PM flags, power.resume_not_needed and
> > > > power.use_runtime_resume, such that:
> > > > 
> > > >  (1) If power.resume_not_needed is set for the given device and for
> > > >      all of its children and the device is runtime-suspended during
> > > >      device_suspend(), the remaining device's system suspend/resume
> > > >      callbacks need not be executed.
> > > 
> > > The patch doesn't do that last part.  That is, it still invokes the 
> > > callbacks even when resume_not_needed is set.
> > 
> > Yes, it does and the above paragraph doesn't say that it won't.  It only
> > says that the flag indicates no need to do that.

But then the reader is left wondering: What is the reason for having
the flag, if it doesn't cause the PM core to do anything different?
This is partly a weakness of the patch description.  Here's a 
suggestion for an improved description:

--------------------------------------------------------------------

Many devices have different wakeup settings for runtime suspend and
system suspend.  If such a device is already runtime-suspended when a
system suspend starts, it will be necessary to perform a runtime resume
in order to reprogram the device's wakeup settings.  Thus, the device
will always enter system suspend in a runtime-active state.

Other devices may need to be runtime-active when a system suspend
starts for other reasons.  Still, there are quite a few devices which
have no such requirements.  If they are already in runtime suspend,
there's no reason why they shouldn't remain that way during the system
suspend.  And avoiding an extra runtime-resume/device-suspend pair
could help speed up the procedure.

Some subsystems, such as PCI and the ACPI PM domain, automatically 
resume all runtime-suspended devices when a system suspend starts, on 
the theory that the device may require reprogramming.  As described 
above, we would like to avoid doing this in cases where it isn't 
needed.

This patch introduces a standardized way for drivers to tell their
subsystems that no reprogramming is needed and a device may remain in
runtime suspend during a system suspend.  A new flag,
dev->power.resume_not_needed, is added.  Drivers set this flag during
their ->prepare() callbacks to tell the subsystems that no runtime
resume is necessary.  If the flag is set and the device is
runtime-suspended, the subsystem can return immediately from its
->suspend(), ->suspend_late(), and ->suspend_noirq() callbacks.  
(However, the various resume callbacks should continue to function as 
before, because we want the device to end up at full power when the 
system resume is over.)

Note: If dev->power.ignore_children is set then
dev->power.resume_not_needed probably should not be set.  This is
because the driver for the child device may expect dev always to be at
full power when the child's suspend routines run.

--------------------------------------------------------------------

This description doesn't say anything about the PM core skipping the 
various suspend callbacks.  That's because the patch doesn't actually 
skip them.

It also doesn't say anything about requiring resume_not_needed to be 
set in all the descendant devices.  That's because this isn't 
necessary, if all you want to accomplish is to avoid the unnecessary 
runtime resumes.

> > > >  (2) If power.use_runtime_resume is set for the given device and the
> > > >      device is runtime-suspended in device_suspend_late(), its late/early
> > > >      and noirq system suspend/resume callbacks should be skipped and
> > > >      it should be resumed through pm_runtime_resume() in device_resume().
> > > 
> > > IMO this should be a separate patch.  It has no direct connection with 
> > > the main goal of providing subsystems with a mechanism to avoid waking 
> > > up devices for reprogramming during system suspend.
> > 
> > I'm not sure what you mean, honestly.  The main goal here is to allow
> > devices that were runtime suspended to stay that way throughout system
> > suspend and resume up until device_resume() is called for them.

No, not exactly.  The main goal is to allow devices that were runtime
suspended to stay that way throughout system suspend _only_.  We expect
system resume to function as it has in the past.  Changing the
expectations for system resume should be the subject of a second patch.

> > I have no idea how to split it so that both parts still make sense.
> 
> OK, I guess you mean that the first flag (resume_not_needed) should be introduced
> by one patch and the second one by another, but I'm not sure if that would really
> make any difference.  Both of them are needed anyway and resume_not_needed without
> the other flag wouldn't have any effect.
> 
> Well, perhaps I should make __device_suspend() check that use_runtime_resume is
> only set when resume_not_needed is set too and return an error if that's not
> the case.

Here's my suggestion for the second patch's description.  It describes 
what I have in mind:

--------------------------------------------------------------------

Now that we have a mechanism for allowing devices to remain in a
runtime-suspended state during system suspend, it makes sense to add a
mechanism allowing them to remain in runtime suspend during system
resume as well -- in other words, throughout an entire system suspend
cycle.  In theory, all the PM core has to do is avoid invoking the
suspend and resume callbacks for devices that are runtime suspended.

However, some drivers may not be prepared to handle this new behavior.
They may assume that their various resume callbacks always get called,
regardless of the device's runtime status, because that's how it works
now.  Or they may assume that the device's parent is always at full
power when the device's resume callbacks run, which wouldn't have to
hold if the parent's power.ignore_children flag was set.

Therefore this patch adds a new flag: dev->power.use_runtime_resume.  
Drivers can set this flag in their ->prepare() routines.  When
__device_suspend() runs, if the device and all its descendants are
runtime suspended, and if power.use_runtime_resume is set in the device
and all its descendants, then the PM core will skip the ->suspend(),
->suspend_late(), ->suspend_noirq(), ->resume_noirq(),
->resume_early(), and ->resume() callbacks.  The device will not return 
to full power until a runtime resume occurs.

--------------------------------------------------------------------

This isn't exactly the same as what you implemented, but I think the 
description explains the situation well enough that the reasons for the 
differences are clear.

Alan Stern

