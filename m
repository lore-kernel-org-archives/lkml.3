Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaBZWRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:17:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754022AbaBZWRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:17:04 -0500
Date: Wed, 26 Feb 2014 17:17:03 -0500 (EST)
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
In-Reply-To: <3594089.JH6xlacmJ3@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1402261708030.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014, Rafael J. Wysocki wrote:

> > > Still, I think that something like power.fast_suspend is needed to indicate
> > > that .suspend_late(), .suspend_noirq(), .resume_noirq() and .resume_early()
> > > should be skipped for it (in my opinion the core may very well skip them then)
> > > and so that .resume() knows how to handle the device.
> > 
> > I don't follow.  Why would you skip these routines without also
> > skipping .suspend and .resume?
> 
> Because .suspend will set the flag and then it would be reasonable to call .resume,
> for symmetry and to let it decide what to do (e.g. call pm_runtime_resume(dev) or
> do something else, depending on the subsystem).

In the original patch, ->prepare returned the flag.  When it was set,
you would skip ->suspend, ->suspend_late, and ->suspend_noirq (and the
corresponding resume callbacks).  Did you decide to change this?

> > However, the second may indeed be a problem.  I don't know how you
> > intend to handle it.  Apply the patch, like you did for ACPI and PCI
> > above, and then see what happens?
> 
> For starters, I'd just make the parent's ->resume call pm_runtime_resume(dev).
> That will make the parent be ready before the child's ->resume is called.
> And then it may be optimized further going forward, possibly by replacing
> the pm_runtime_resume() with pm_request_resume() for some devices and by
> leaving some devices in RPM_SUSPENDED.

Of course, this would not be possible with the original version of the 
patch, because it wouldn't invoke the parent's ->resume.

> > A simple solution is to use fast_suspend only for devices that have no
> > children.  But that would not be optimal.
> > 
> > Another possibility is always to call pm_runtime_resume(dev->parent)
> > before invoking dev's ->resume callback.  But that might not solve the
> > entire problem (it wouldn't help dev's ->resume_early callback, for
> > instance) and it also might be sub-optimal.
> 
> The child's ->resume_early may be a problem indeed (or its ->resume_noirq
> for that matter).

If the child knows about the problem beforehand, it can runtime-resume 
the parent during its ->suspend.

> Well, if power.fast_suspend set guarantees that ->suspend_late, ->suspend_noirq,
> ->resume_noirq, and ->resume_early will be skipped for a device, then we may
> restrict setting it for devices whose children have it set (or that have no
> children).  Initially, that will be equivalent to setting it for leaf devices
> only, but it might be extended over time in a natural way.

Initially, maybe.  But it's the wrong approach in general.  The right 
approach is to restrict setting fast_suspend for devices whose children 
don't mind their parent being suspended when their resume callbacks 
run -- not for devices whose children also have fast_suspend set.

That's the point I've been trying to express all along.

Alan Stern

