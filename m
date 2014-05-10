Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbaEJBVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 21:21:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62898 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754499AbaEJBVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 21:21:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Sat, 10 May 2014 03:38:27 +0200
Message-ID: <2529433.Aygp7Yxy87@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7hmweqmuve.fsf@paris.lan>
References: <Pine.LNX.4.44L0.1405071126340.1325-100000@iolanthe.rowland.org> <2703563.1xTcfTGG98@vostro.rjw.lan> <7hmweqmuve.fsf@paris.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 03:48:21 PM Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@rjwysocki.net> writes:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> > resume all runtime-suspended devices during system suspend, mostly
> > because those devices may need to be reprogrammed due to different
> > wakeup settings for system sleep and for runtime PM.
> >
> > For some devices, though, it's OK to remain in runtime suspend 
> > throughout a complete system suspend/resume cycle (if the device was in
> > runtime suspend at the start of the cycle).  We would like to do this
> > whenever possible, to avoid the overhead of extra power-up and power-down
> > events.
> >
> > However, problems may arise because the device's descendants may require
> > it to be at full power at various points during the cycle.  Therefore the
> > most straightforward way to do this safely is if the device and all its
> > descendants can remain runtime suspended until the resume stage of system
> > resume.
> >
> > To this end, introduce dev->power.leave_runtime_suspended.
> > If a subsystem or driver sets this flag during the ->prepare() callback,
> > and if the flag is set in all of the device's descendants, and if the
> > device is still in runtime suspend at the beginning of the ->suspend()
> > callback, that callback is allowed to return 0 without clearing
> > power.leave_runtime_suspended and without changing the state of the
> > device, unless the current state of the device is not appropriate for
> > the upcoming system sleep state (for example, the device is supposed to
> > wake up the system from that state and its current wakeup settings are
> > not suitable for that).  Then, the PM core will not invoke the device's
> > ->suspend_late(), ->suspend_irq(), ->resume_irq(), ->resume_early(), or
> > ->resume() callbacks.  
> 
> Up to here, this sounds great.
> 
> > Instead, it will invoke ->runtime_resume() during the device resume
> > stage of system resume.
> 
> But this part I'm not fully following...

You're not looking at the most recent one. :-)

Please look here: https://patchwork.kernel.org/patch/4139181/

> > By leaving this flag set after ->suspend(), a driver or subsystem tells
> > the PM core that the device is runtime suspended, it is in a suitable
> > state for system suspend (for example, the wakeup setting does not
> > need to be changed), and it does not need to return to full
> > power until the resume stage.
> 
> But taking this "leave runtime suspended" idea the next logical step,
> why would/should a device need to return to full power at the ->resume()
> stage?  especially when it wasn't at full power when ->suspend()
> happened?

Good question and I've been thinking about that for a while.

Generally, the main reason for resuming is that on some platforms devices are
automatically powered up by firmware and in those cases it's better to
resume them (to make the runtime PM status reflect the physical state) and
suspend again later.

Generally speaking, subsystems that need to do that know what they are and
that's what I was talking about in the most recent reply to Alan:

http://marc.info/?l=linux-pm&m=139967477806094&w=4

Currently, I think, there are two options on the table really.

 1. Do more or less what https://patchwork.kernel.org/patch/4139181/ does
    with a modification to check that ->suspend() doesn't "cheat" (by setting
    the flag that had been unset before it was called).  The subsystem's
    ->resume() would then decide what to do with the device (resume it or
    leave it suspended).

 2. Do what Alan was suggesting, that is set the flag in ->prepare() and
    make the PM core skip *all* of the system suspend/resume callbacks
    for devices with that flag set and let the ->complete() callback
    decide what to do with the device.

I'm leaning a bit towards 2, but still considering 1 too.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
