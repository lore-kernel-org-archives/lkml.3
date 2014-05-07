Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbaEGPnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:43:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42581 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752076AbaEGPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:40 -0400
Date: Wed, 7 May 2014 11:43:39 -0400 (EDT)
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
In-Reply-To: <8506078.MQGrQB8sAy@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405071126340.1325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Rafael J. Wysocki wrote:

We seem to be in agreement that this is the way you want to go...

> > All right.  Then this seems to be what you want:
> > 
> > 	For some devices, it's okay to remain in runtime suspend 
> > 	throughout a complete system suspend/resume cycle (if the
> > 	device was in runtime suspend at the start of the cycle).
> > 	We would like to do this whenever possible, to avoid the
> > 	overhead of extra power-up and power-down events.
> 
> Yes.
> 
> > 	However, problems may arise because the device's descendants 
> > 	may require it to be at full power at various points during 
> > 	the cycle.  Therefore the only way to do this safely is if the 
> > 	device _and_ all its descendants can remain runtime suspended 
> > 	until the resume stage of system resume.
> 
> It may not be the only way, but it is *a* way to do this safely.
> 
> > 	To this end, introduce dev->power.leave_runtime_suspended.
> > 	If a subsystem or driver sets this flag during the ->prepare()
> > 	callback, and if the flag is set in all of the device's
> > 	descendants, and if the device is still in runtime suspend when
> > 	the ->suspend() callback would normally be invoked, then the PM
> > 	core will not invoke the device's ->suspend(), 
> > 	->suspend_late(), ->suspend_irq(), ->resume_irq(),
> > 	->resume_early(), or ->resume() callbacks.  Instead, it will 
> > 	invoke ->runtime_resume() during the resume stage of system
> > 	resume.
> 
> Yes.
> 
> > 	By setting this flag, a driver or subsystem tells the PM core
> > 	that the device is runtime suspended, it is in a suitable state
> > 	for system suspend (for example, the wakeup setting does not
> > 	need to be changed), and it does not need to return to full
> > 	power until the resume stage.
> 
> Yes.
> 
> > Does that correctly describe what you want to do, the potential
> > problems, and the proposed solution?
> 
> Almost.  Devices with power.ignore_children set are not covered by this.

I thought they were.  In what respect aren't they?  You mean because
they can be runtime suspended while their children remain active?

I don't think that matters here.  Suppose a parent device's
leave_runtime_suspended flag is set but one of its children isn't
runtime suspended.  Then that child's leave_runtime_suspended flag
won't be set, so the parent device won't meet the criterion for
skipping the normal PM callbacks.

Or do you mean that a child might expect the parent to be at full power
when the child is resumed (plus the fact that doing a runtime resume on
the child will not automatically resume the parent)?  That doesn't
matter either, because the PM core will do a runtime-resume of the
parent before the child's ->runtime_resume() is called.

> > If so, then it appears the parent_needed flag is unnecessary.
> 
> Well, I can agree with that.  It wasn't there in my first patchset and I added
> it kind of in the hope to be able to deal with the ignore_children devices
> with the help of it.

Yeah.  I contributed to that, by not understanding exactly what you 
were trying to accomplish.

> OK, I guess I need to prepare a new version without the parent_needed flag for
> further discussion. :-)

Consider using the description above (or some variant of it) for the
new Changelog.  IMNSHO it does a much better job of explaining the 
patch than your original version.  :-)

Alan Stern

