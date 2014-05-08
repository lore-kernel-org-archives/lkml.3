Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaEHUBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:01:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62425 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755023AbaEHUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:01:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Thu, 08 May 2014 22:17:50 +0200
Message-ID: <3058268.hrHgpxktTP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405081040330.1087-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405081040330.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 10:57:36 AM Alan Stern wrote:
> On Thu, 8 May 2014, Rafael J. Wysocki wrote:
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
> > ->resume() callbacks.  Instead, it will invoke ->runtime_resume() during
> > the device resume stage of system resume.
> 
> Wait a minute.  Following ->runtime_suspend(), you are going to call 
> ->suspend() and then ->runtime_resume()?  That doesn't seem like what 
> you really want; a ->suspend() call should always have a matching 
> ->resume().

Yes, it should, but I didn't see any other way to do that.

> I guess you did it this way to allow for runtime-resumes and -suspends 
> between ->prepare() and ->suspend(), but it still seems wrong.

No.  I did that to allow ->suspend() to check whether or not the device is
in the right state.  ->prepare() could do that, arguably, but then there's
the case when ->runtime_suspend() may still be running in parallel with it.
And the device may be runtime-suspended immediately before its ->suspend()
in theory if its children do pm_runtime_put_sync(parent).

Also, this is a bus type ->suspend(), so the *driver* ->suspend()
won't be called at this point in the ACPI PM domain case for example.

> How about asking drivers to set leave_runtime_suspended in their
> ->runtime_suspend() callbacks, as well as during ->prepare()?  Then
> intervening runtime resume/suspend cycles wouldn't matter and you
> wouldn't need to call ->suspend(); you could skip it along with the
> other PM callbacks.

That wouldn't work, because they cannot know the target sleep state of the
system in advance.  This only is known during the given suspend sequence.

> > By leaving this flag set after ->suspend(), a driver or subsystem tells
> > the PM core that the device is runtime suspended, it is in a suitable
> > state for system suspend (for example, the wakeup setting does not
> > need to be changed), and it does not need to return to full
> > power until the resume stage.
> 
> So: By setting this flag during ->runtime_suspend() and ->prepare(), a
> driver or subsystem tells the PM core that the device is in a suitable
> state for system suspend (for example, the wakeup setting would not
> need to be changed), if one should occur before the next runtime
> resume, and the device would not need to return to full power until the
> resume stage.
>
> > --- linux-pm.orig/include/linux/pm_runtime.h
> > +++ linux-pm/include/linux/pm_runtime.h
> > @@ -264,4 +264,20 @@ static inline void pm_runtime_dont_use_a
> >  	__pm_runtime_use_autosuspend(dev, false);
> >  }
> >  
> > +#ifdef CONFIG_PM_BOTH
> > +static inline void __set_leave_runtime_suspended(struct device *dev, bool val)
> > +{
> > +	dev->power.leave_runtime_suspended = val;
> > +}
> > +extern void pm_set_leave_runtime_suspended(struct device *dev, bool val);
> > +static inline bool pm_leave_runtime_suspended(struct device *dev)
> > +{
> > +	return dev->power.leave_runtime_suspended;
> > +}
> 
> Is it generally your custom to use "set_" and "" rather than "set_" and 
> "get_"?

But (dev->power.syscore || pm_get_leave_runtime_suspended(dev)) looks awkward. :-)
 
> >   End:
> >  	if (!error) {
> > +		struct device *parent = dev->parent;
> > +
> >  		dev->power.is_suspended = true;
> > -		if (dev->power.wakeup_path
> > -		    && dev->parent && !dev->parent->power.ignore_children)
> > -			dev->parent->power.wakeup_path = true;
> > +		if (parent) {
> > +			spin_lock_irq(&parent->power.lock);
> > +
> > +			if (dev->power.wakeup_path
> > +			    && !parent->power.ignore_children)
> > +				parent->power.wakeup_path = true;
> > +
> > +			if (!pm_leave_runtime_suspended(dev))
> > +				__set_leave_runtime_suspended(parent, false);
> > +
> > +			spin_unlock_irq(&parent->power.lock);
> > +		}
> 
> Then of course, this code would move up, before the callback, and the 
> callback would be skipped if leave_runtime_suspended was set.

Well, not really. :-)

Rafael

