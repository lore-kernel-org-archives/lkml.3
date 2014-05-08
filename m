Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaEHL2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:28:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61353 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753106AbaEHL2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:28:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Thu, 08 May 2014 13:44:54 +0200
Message-ID: <2321901.5eTtTCbUUZ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFoPxXVYfK2ytGVJ8fYQDJXiSuaRX_6QtRYzffZVtKJfeA@mail.gmail.com>
References: <Pine.LNX.4.44L0.1405071126340.1325-100000@iolanthe.rowland.org> <1589827.thSfpq14Si@vostro.rjw.lan> <CAPDyKFoPxXVYfK2ytGVJ8fYQDJXiSuaRX_6QtRYzffZVtKJfeA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 12:59:20 PM Ulf Hansson wrote:
> On 8 May 2014 12:53, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, May 08, 2014 09:49:36 AM Ulf Hansson wrote:
> >> On 8 May 2014 01:29, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> >
> >> > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> >> > resume all runtime-suspended devices during system suspend, mostly
> >> > because those devices may need to be reprogrammed due to different
> >> > wakeup settings for system sleep and for runtime PM.
> >> >
> >> > For some devices, though, it's OK to remain in runtime suspend
> >> > throughout a complete system suspend/resume cycle (if the device was in
> >> > runtime suspend at the start of the cycle).  We would like to do this
> >> > whenever possible, to avoid the overhead of extra power-up and power-down
> >> > events.
> >> >
> >> > However, problems may arise because the device's descendants may require
> >> > it to be at full power at various points during the cycle.  Therefore the
> >> > most straightforward way to do this safely is if the device and all its
> >> > descendants can remain runtime suspended until the resume stage of system
> >> > resume.
> >> >
> >> > To this end, introduce dev->power.leave_runtime_suspended.
> >> > If a subsystem or driver sets this flag during the ->prepare() callback,
> >> > and if the flag is set in all of the device's descendants, and if the
> >> > device is still in runtime suspend at the beginning of the ->suspend()
> >> > callback, that callback is allowed to return 0 without clearing
> >> > power.leave_runtime_suspended and without changing the state of the
> >> > device, unless the current state of the device is not appropriate for
> >> > the upcoming system sleep state (for example, the device is supposed to
> >> > wake up the system from that state and its current wakeup settings are
> >> > not suitable for that).  Then, the PM core will not invoke the device's
> >> > ->suspend_late(), ->suspend_irq(), ->resume_irq(), ->resume_early(), or
> >> > ->resume() callbacks.  Instead, it will invoke ->runtime_resume() during
> >> > the device resume stage of system resume.
> >> >
> >> > By leaving this flag set after ->suspend(), a driver or subsystem tells
> >> > the PM core that the device is runtime suspended, it is in a suitable
> >> > state for system suspend (for example, the wakeup setting does not
> >> > need to be changed), and it does not need to return to full
> >> > power until the resume stage.
> >> >
> >> > Changelog based on an Alan Stern's description of the idea
> >> > (http://marc.info/?l=linux-pm&m=139940466625569&w=2).
> >> >
> >> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> > ---
> >> >  drivers/base/power/main.c    |   31 ++++++++++++++++++++++++-------
> >> >  drivers/base/power/runtime.c |   10 ++++++++++
> >> >  include/linux/pm.h           |    3 +++
> >> >  include/linux/pm_runtime.h   |   16 ++++++++++++++++
> >> >  kernel/power/Kconfig         |    4 ++++
> >> >  5 files changed, 57 insertions(+), 7 deletions(-)
> >> >
> >> > Index: linux-pm/kernel/power/Kconfig
> >> > ===================================================================
> >> > --- linux-pm.orig/kernel/power/Kconfig
> >> > +++ linux-pm/kernel/power/Kconfig
> >> > @@ -147,6 +147,10 @@ config PM
> >> >         def_bool y
> >> >         depends on PM_SLEEP || PM_RUNTIME
> >> >
> >> > +config PM_BOTH
> >> > +       def_bool y
> >> > +       depends on PM_SLEEP && PM_RUNTIME
> >> > +
> >>
> >> Should we not depend on PM_RUNTIME only? Thus we don't need the new
> >> Kconfig,
> >
> > Well, OK.  I guess we can tolerate one useless statement in rpm_resume()
> > in case CONFIG_PM_SLEEP is unset.
> >
> >> and then we could rename the new APIs to pm_runtime_* instead.
> >
> > That would just make the name longer - for what value?
> 
> Only "__set_leave_runtime_suspended" will be a bit longer.
> 
> The idea I had was to clearly indicate, these functions is a part of
> PM_RUNTIME API.
> 
> Compare what you have:
> __set_leave_runtime_suspended
> pm_set_leave_runtime_suspended
> pm_leave_runtime_suspended
> 
> To what I suggest:
> __pm_runtime_set_leave_suspended
> pm_runtime_set_leave_suspended
> pm_runtime_leave_suspended

And why exactly do you think these are any better?

The flag is not called leave_suspended surely?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
