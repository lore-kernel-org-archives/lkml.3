Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaEONJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:09:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:62779 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaEONJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="512150353"
Date: Thu, 15 May 2014 06:09:24 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming
 runtime-suspended devices unnecessarily
Message-ID: <20140515060924.69ae7486@ultegra>
In-Reply-To: <2114493.MQBIxPPRgp@vostro.rjw.lan>
References: <4649019.is79p6EySp@vostro.rjw.lan>
	<1752814.FckPkBGaUc@vostro.rjw.lan>
	<20140514152421.6d21b025@ultegra>
	<2114493.MQBIxPPRgp@vostro.rjw.lan>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 13:11:15 +0200
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Wednesday, May 14, 2014 03:24:21 PM Jacob Pan wrote:
> > On Tue, 13 May 2014 03:10:19 +0200
> > "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> > 
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have
> > > to resume all runtime-suspended devices during system suspend,
> > > mostly because those devices may need to be reprogrammed due to
> > > different wakeup settings for system sleep and for runtime PM.
> > > 
> > > For some devices, though, it's OK to remain in runtime suspend 
> > > throughout a complete system suspend/resume cycle (if the device
> > > was in runtime suspend at the start of the cycle).  We would like
> > > to do this whenever possible, to avoid the overhead of extra
> > > power-up and power-down events.
> > > 
> > > However, problems may arise because the device's descendants may
> > > require it to be at full power at various points during the cycle.
> > > Therefore the most straightforward way to do this safely is if the
> > > device and all its descendants can remain runtime suspended until
> > > the complete stage of system resume.
> > > 
> > > To this end, introduce a new device PM flag, power.direct_complete
> > > and modify the PM core to use that flag as follows.
> > > 
> > > If the ->prepare() callback of a device returns a positive number,
> > > the PM core will regard that as an indication that it may leave
> > > the device runtime-suspended.  It will then check if the system
> > > power transition in progress is a suspend (and not hibernation in
> > > particular) and if the device is, indeed, runtime-suspended.  In
> > > that case, the PM core will set the device's
> > > power.direct_complete flag. Otherwise it will clear
> > > power.direct_complete for the device and it also will later clear
> > > it for the device's parent (if there's one).
> > > 
> > > Next, the PM core will not invoke the ->suspend()
> > > ->suspend_late(), ->suspend_irq(), ->resume_irq(),
> > > ->resume_early(), or ->resume() callbacks for all devices having
> > > power.direct_complete set.  It will invoke their ->complete()
> > > callbacks, however, and those callbacks are then responsible for
> > > resuming the devices as appropriate, if necessary.
> > > 
> > > Changelog partly based on an Alan Stern's description of the idea
> > > (http://marc.info/?l=linux-pm&m=139940466625569&w=2).
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/base/power/main.c |   45
> > > ++++++++++++++++++++++++++++-----------------
> > > include/linux/pm.h        |    1 + 2 files changed, 29
> > > insertions(+), 17 deletions(-)
> > > 
> > > Index: linux-pm/include/linux/pm.h
> > > ===================================================================
> > > --- linux-pm.orig/include/linux/pm.h
> > > +++ linux-pm/include/linux/pm.h
> > > @@ -546,6 +546,7 @@ struct dev_pm_info {
> > >  	bool			is_late_suspended:1;
> > >  	bool			ignore_children:1;
> > >  	bool			early_init:1;	/*
> > > Owned by the PM core */
> > > +	bool			direct_complete:1;	/*
> > > Owned by the PM core */ spinlock_t		lock;
> > >  #ifdef CONFIG_PM_SLEEP
> > >  	struct list_head	entry;
> > > Index: linux-pm/drivers/base/power/main.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/base/power/main.c
> > > +++ linux-pm/drivers/base/power/main.c
> > > @@ -479,7 +479,7 @@ static int device_resume_noirq(struct de
> > >  	TRACE_DEVICE(dev);
> > >  	TRACE_RESUME(0);
> > >  
> > > -	if (dev->power.syscore)
> > > +	if (dev->power.syscore || dev->power.direct_complete)
> > >  		goto Out;
> > >  
> > >  	if (!dev->power.is_noirq_suspended)
> > > @@ -605,7 +605,7 @@ static int device_resume_early(struct de
> > >  	TRACE_DEVICE(dev);
> > >  	TRACE_RESUME(0);
> > >  
> > > -	if (dev->power.syscore)
> > > +	if (dev->power.syscore || dev->power.direct_complete)
> > >  		goto Out;
> > >  
> > >  	if (!dev->power.is_late_suspended)
> > > @@ -732,7 +732,7 @@ static int device_resume(struct device *
> > >  	TRACE_DEVICE(dev);
> > >  	TRACE_RESUME(0);
> > >  
> > > -	if (dev->power.syscore)
> > > +	if (dev->power.syscore || dev->power.direct_complete)
> > >  		goto Complete;
> > >  
> > >  	dpm_wait(dev->parent, async);
> > > @@ -1007,7 +1007,7 @@ static int __device_suspend_noirq(struct
> > >  		goto Complete;
> > >  	}
> > >  
> > > -	if (dev->power.syscore)
> > > +	if (dev->power.syscore || dev->power.direct_complete)
> > >  		goto Complete;
> > >  
> > >  	dpm_wait_for_children(dev, async);
> > > @@ -1146,7 +1146,7 @@ static int __device_suspend_late(struct
> > >  		goto Complete;
> > >  	}
> > >  
> > > -	if (dev->power.syscore)
> > > +	if (dev->power.syscore || dev->power.direct_complete)
> > >  		goto Complete;
> > >  
> > >  	dpm_wait_for_children(dev, async);
> > > @@ -1312,7 +1312,7 @@ static int __device_suspend(struct devic
> > >  
> > >  	dpm_wait_for_children(dev, async);
> > >  
> > > -	if (async_error || dev->power.syscore)
> > > +	if (async_error || dev->power.syscore ||
> > > dev->power.direct_complete) goto Complete;
> > >  
> > >  	dpm_watchdog_set(&wd, dev);
> > > @@ -1365,10 +1365,19 @@ static int __device_suspend(struct devic
> > >  
> > >   End:
> > >  	if (!error) {
> > > +		struct device *parent = dev->parent;
> > > +
> > >  		dev->power.is_suspended = true;
> > > -		if (dev->power.wakeup_path
> > > -		    && dev->parent
> > > && !dev->parent->power.ignore_children)
> > > -			dev->parent->power.wakeup_path = true;
> > > +		if (parent) {
> > > +			spin_lock_irq(&parent->power.lock);
> > > +
> > > +			dev->parent->power.direct_complete =
> > > false;
> > should we respect ignore_children flag here? not all parent devices
> > create children with proper .prepare() function. this allows parents
> > override children.
> > I am looking at USB, a USB device could have logical children such
> > as ep_xx, they don't go through the same subsystem .prepare().
> 
> Well, I'm not sure about that.  Let me consider that for a while.
OK. let me be more clear about the situation i see in USB. Correct me
if I am wrong, a USB device will always has at least one endpoint/ep_00
as a kid for control pipe, it is a logical device. So when
device_prepare() is called, its call back is NULL which
makes .direct_complete = 0. Since children device suspend is called
before parents, the parents .direct_complete flag will always get
cleared.

What i am trying to achieve here is to see if we avoid resuming
built-in (hardwired connect_type) non-hub USB devices based on this new
patchset. E.g. we don't want to resume/suspend USB camera every time in
system suspend/resume cycle if they are already rpm suspended. We can
save ~100ms resume time for the devices we have tested.

> 
> Alan, what do you think?
> 
> > 
> > > +			if (dev->power.wakeup_path
> > > +
> > > && !dev->parent->power.ignore_children)
> > > +				dev->parent->power.wakeup_path =
> > > true; +
> > > +			spin_unlock_irq(&parent->power.lock);
> > > +		}
> > >  	}
> > >  
> > >  	device_unlock(dev);
> > > @@ -1470,7 +1479,7 @@ static int device_prepare(struct device
> > >  {
> > >  	int (*callback)(struct device *) = NULL;
> > >  	char *info = NULL;
> > > -	int error = 0;
> > > +	int ret = 0;
> > >  
> > >  	if (dev->power.syscore)
> > >  		return 0;
> > > @@ -1518,17 +1527,19 @@ static int device_prepare(struct device
> > >  		callback = dev->driver->pm->prepare;
> > >  	}
> > >  
> > > -	if (callback) {
> > > -		error = callback(dev);
> > > -		suspend_report_result(callback, error);
> > > -	}
> > > +	if (callback)
> > > +		ret = callback(dev);
> > >  
> > >  	device_unlock(dev);
> > >  
> > > -	if (error)
> > > +	if (ret < 0) {
> > > +		suspend_report_result(callback, ret);
> > >  		pm_runtime_put(dev);
> > > -
> > > -	return error;
> > > +		return ret;
> > > +	}
> > > +	dev->power.direct_complete = ret > 0 && state.event ==
> > > PM_EVENT_SUSPEND
> > > +					&&
> > > pm_runtime_suspended(dev);
> > > +	return 0;
> > >  }
> > >  
> > >  /**
> > > 
> > > --
> 
> Rafael
> 

[Jacob Pan]
