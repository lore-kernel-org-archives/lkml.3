Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaEAVje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:39:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42734 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752147AbaEAVjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:39:32 -0400
Date: Thu, 1 May 2014 17:39:31 -0400 (EDT)
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
In-Reply-To: <2381177.mrXhZ4Wotn@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405011613200.881-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> resume all runtime-suspended devices during system suspend, mostly
> because those devices may need to be reprogrammed due to different
> wakeup settings for system sleep and for runtime PM.  However, at
> least in some cases, that isn't really necessary, because the wakeup
> settings may not be really different.
> 
> The idea here is that subsystems should know whether or not it is
> necessary to reprogram a given device during system suspend and they
> should be able to tell the PM core about that.  For that reason, add
> two new device PM flags, power.resume_not_needed and
> power.use_runtime_resume, such that:
> 
>  (1) If power.resume_not_needed is set for the given device and for
>      all of its children and the device is runtime-suspended during
>      device_suspend(), the remaining device's system suspend/resume
>      callbacks need not be executed.

The patch doesn't do that last part.  That is, it still invokes the 
callbacks even when resume_not_needed is set.

I'm not sure that you should skip the resume callbacks.  We expect
devices to be resumed during system resume even if they were in runtime
suspend beforehand.  Yes, this means calling resume_noirq without
calling suspend_noirq (ditto for the other callbacks).  Think of it as
a form of optimization -- we could have called suspend_noirq, but we
know that the subsystem would have seen that the device was already in
runtime suspend and then returned immediately.  By not calling
suspend_noirq, we spare the subsystem from testing the runtime status.

(And I also think "resume_not_needed" is too general.  It should be 
something more like "runtime_resume_not_needed_during_system_suspend", 
only not quite so long.)

>  (2) If power.use_runtime_resume is set for the given device and the
>      device is runtime-suspended in device_suspend_late(), its late/early
>      and noirq system suspend/resume callbacks should be skipped and
>      it should be resumed through pm_runtime_resume() in device_resume().

IMO this should be a separate patch.  It has no direct connection with 
the main goal of providing subsystems with a mechanism to avoid waking 
up devices for reprogramming during system suspend.

The main goal of this other patch will be to allow devices which were
in runtime suspend throughout the system suspend phases to remain in
runtime suspend throughout the system resume.  When they do finally get
resumed, it will be by a ->runtime_resume() callback, not ->resume().

This will require coordination with the child devices.  If the 
child expects the parent always to be resumed during the resume_early 
phase, we mustn't skip the resume_early callback.  I'm not sure if the 
coordination provided by the resume_not_needed flag is sufficient.

("use_runtime_resume" is also too general.  
"remain_in_runtime_suspend_during_system_resume"?)

Alan Stern

