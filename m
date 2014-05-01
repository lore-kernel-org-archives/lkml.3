Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaEAXUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:20:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57049 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752884AbaEAXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:20:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flags to speed up suspend-resume of runtime-suspended devices
Date: Fri, 02 May 2014 01:36:38 +0200
Message-ID: <1898485.lQeVbtvK4U@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2117270.jlg4ZsaoxL@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405011613200.881-100000@iolanthe.rowland.org> <2117270.jlg4ZsaoxL@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 01:15:14 AM Rafael J. Wysocki wrote:
> On Thursday, May 01, 2014 05:39:31 PM Alan Stern wrote:
> > On Fri, 25 Apr 2014, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> > > resume all runtime-suspended devices during system suspend, mostly
> > > because those devices may need to be reprogrammed due to different
> > > wakeup settings for system sleep and for runtime PM.  However, at
> > > least in some cases, that isn't really necessary, because the wakeup
> > > settings may not be really different.
> > > 
> > > The idea here is that subsystems should know whether or not it is
> > > necessary to reprogram a given device during system suspend and they
> > > should be able to tell the PM core about that.  For that reason, add
> > > two new device PM flags, power.resume_not_needed and
> > > power.use_runtime_resume, such that:
> > > 
> > >  (1) If power.resume_not_needed is set for the given device and for
> > >      all of its children and the device is runtime-suspended during
> > >      device_suspend(), the remaining device's system suspend/resume
> > >      callbacks need not be executed.
> > 
> > The patch doesn't do that last part.  That is, it still invokes the 
> > callbacks even when resume_not_needed is set.
> 
> Yes, it does and the above paragraph doesn't say that it won't.  It only
> says that the flag indicates no need to do that.
> 
> > I'm not sure that you should skip the resume callbacks.
> 
> The reason why is that if the device were suspended using ->runtime_suspend(),
> its driver (or bus type) may be confused if ->runtime_resume() is not used
> to resume it.
> 
> > We expect devices to be resumed during system resume even if they were in
> > runtime suspend beforehand.  Yes, this means calling resume_noirq without
> > calling suspend_noirq (ditto for the other callbacks).  Think of it as
> > a form of optimization -- we could have called suspend_noirq, but we
> > know that the subsystem would have seen that the device was already in
> > runtime suspend and then returned immediately.  By not calling
> > suspend_noirq, we spare the subsystem from testing the runtime status.
> 
> The driver/subsystem has the right to expect that ->resume_noirq() will
> always be called after ->suspend_noirq() (if both are implemented).  Thus
> calling the former without the latter may be a bug (for the particular
> driver).  Since we've always had symmetry there, the risk of breaking stuff
> if we change that is relatively high.
> 
> On the other hand, ->runtime_resume() should not make any assumptions
> about the hardware state when it is called anyway, so it should handle
> the device during system resume properly, given that the last PM callback
> executed for it was ->runtime_suspend(), regardless of what the firmware
> did to it in the meantime.
> 
> > (And I also think "resume_not_needed" is too general.  It should be 
> > something more like "runtime_resume_not_needed_during_system_suspend", 
> > only not quite so long.)
> 
> Well, I can agree with that, but I couldn't invent a better name. In particular,
> one that wouldn't be too long. :-)
> 
> > >  (2) If power.use_runtime_resume is set for the given device and the
> > >      device is runtime-suspended in device_suspend_late(), its late/early
> > >      and noirq system suspend/resume callbacks should be skipped and
> > >      it should be resumed through pm_runtime_resume() in device_resume().
> > 
> > IMO this should be a separate patch.  It has no direct connection with 
> > the main goal of providing subsystems with a mechanism to avoid waking 
> > up devices for reprogramming during system suspend.
> 
> I'm not sure what you mean, honestly.  The main goal here is to allow
> devices that were runtime suspended to stay that way throughout system
> suspend and resume up until device_resume() is called for them.
> 
> > The main goal of this other patch will be to allow devices which were
> > in runtime suspend throughout the system suspend phases to remain in
> > runtime suspend throughout the system resume.  When they do finally get
> > resumed, it will be by a ->runtime_resume() callback, not ->resume().
> 
> Yes, and that's what *this* patch does, isn't it?
> 
> I have no idea how to split it so that both parts still make sense.

OK, I guess you mean that the first flag (resume_not_needed) should be introduced
by one patch and the second one by another, but I'm not sure if that would really
make any difference.  Both of them are needed anyway and resume_not_needed without
the other flag wouldn't have any effect.

Well, perhaps I should make __device_suspend() check that use_runtime_resume is
only set when resume_not_needed is set too and return an error if that's not
the case.

Rafael

