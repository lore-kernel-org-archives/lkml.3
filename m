Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaBSRBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:01:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33143 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754569AbaBSRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:01:21 -0500
Date: Wed, 19 Feb 2014 12:01:20 -0500 (EST)
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
In-Reply-To: <21442757.ztmIxNHa8O@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1402191137350.1133-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Rafael J. Wysocki wrote:

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
> should be able to tell the PM core about that.  For this reason,
> modify the PM core so that if the .prepare() callback returns a
> positive value for certain device, the core will set a new
> power.fast_suspend flag for it.  Then, if that flag is set, the core
> will skip all of the subsequent suspend callbacks for that device.
> It also will skip all of the system resume callbacks for the device
> during the subsequent system resume and pm_request_resume() will be
> executed to trigger a runtime PM resume of the device after the
> system device resume sequence has been finished.

Does the PM core really need to get involved in this?  Can't the 
subsystem do the right thing on its own?

In the USB subsystem, the .suspend routine checks the required wakeup
settings.  If they are different for runtime suspend and system
suspend, and if the device is runtime suspended, then we call
pm_runtime_resume.  After that, if the device is still in runtime
suspend then we return immediately.

Of course, this addresses only the suspend side of the issue.  Skipping 
the resume callbacks is a separate matter, and the USB subsystem 
doesn't try to do it.  Still, I don't see any reason why we couldn't 
take care of that as well.

> However, since parents may need to be resumed so that their children
> can be reprogrammed, make the PM core clear power.fast_suspend for
> devices whose children don't have power.fast_suspend set (the
> power.ignore_children flag doesn't matter here, because a parent
> whose children are normally ignored for runtime PM may still need to
> be accessible for their children to be prepare for system suspend
> properly).

I have run across a similar issue.  It's a general problem that a
device may try to remain in runtime suspend during a system resume, but
a descendant of the device may need to perform I/O as part of its own
resume routine.  A natural solution would be to use the regular runtime
PM facilities to wake up the device.  But since the PM work queue is
frozen, we can't rely on pm_runtime_get or the equivalent.  I'm not
sure what the best solution will be.


After a quick look, I noticed a couple of questionable things in this
patch.  This is after reading just the second half...

> @@ -1296,8 +1301,10 @@ static int __device_suspend(struct devic
>  	 * for it, this is equivalent to the device signaling wakeup, so the
>  	 * system suspend operation should be aborted.
>  	 */
> -	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
> +	if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
>  		pm_wakeup_event(dev, 0);
> +		dev->power.fast_suspend = false;
> +	}

Is this change needed?  We're aborting the sleep transition anyway, 
right?

> @@ -1310,6 +1317,9 @@ static int __device_suspend(struct devic
>  	dpm_watchdog_set(&wd, dev);
>  	device_lock(dev);
>  
> +	if (dev->power.fast_suspend)
> +		goto End;
> +

What happens if dev->power.fast_suspend gets set following the .prepare
callback, but then before __device_suspend runs, the device gets
runtime resumed?

It looks like rpm_resume needs to clear the new flag.

> @@ -1358,9 +1368,14 @@ static int __device_suspend(struct devic
>   End:
>  	if (!error) {
>  		dev->power.is_suspended = true;
> -		if (dev->power.wakeup_path
> -		    && dev->parent && !dev->parent->power.ignore_children)
> -			dev->parent->power.wakeup_path = true;
> +		if (dev->parent) {
> +			if (!dev->parent->power.ignore_children
> +			    && dev->power.wakeup_path)
> +				dev->parent->power.wakeup_path = true;
> +
> +			if (!dev->power.fast_suspend)
> +				dev->parent->power.fast_suspend = false;
> +		}

On SMP systems with async suspend, this isn't safe.  Two threads should 
not be allowed to write to bitfields in the same structure at the same 
time.

Alan Stern

