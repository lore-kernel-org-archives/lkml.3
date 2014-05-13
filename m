Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbaEMOtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:49:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42597 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760198AbaEMOtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:49:33 -0400
Date: Tue, 13 May 2014 10:49:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming
 runtime-suspended devices unnecessarily
In-Reply-To: <1752814.FckPkBGaUc@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405131046250.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> resume all runtime-suspended devices during system suspend, mostly
> because those devices may need to be reprogrammed due to different
> wakeup settings for system sleep and for runtime PM.
> 
> For some devices, though, it's OK to remain in runtime suspend 
> throughout a complete system suspend/resume cycle (if the device was in
> runtime suspend at the start of the cycle).  We would like to do this
> whenever possible, to avoid the overhead of extra power-up and power-down
> events.
> 
> However, problems may arise because the device's descendants may require
> it to be at full power at various points during the cycle.  Therefore the
> most straightforward way to do this safely is if the device and all its
> descendants can remain runtime suspended until the complete stage of
> system resume.
> 
> To this end, introduce a new device PM flag, power.direct_complete
> and modify the PM core to use that flag as follows.
> 
> If the ->prepare() callback of a device returns a positive number,
> the PM core will regard that as an indication that it may leave the
> device runtime-suspended.  It will then check if the system power
> transition in progress is a suspend (and not hibernation in particular)
> and if the device is, indeed, runtime-suspended.  In that case, the PM
> core will set the device's power.direct_complete flag.  Otherwise it
> will clear power.direct_complete for the device and it also will later
> clear it for the device's parent (if there's one).
> 
> Next, the PM core will not invoke the ->suspend() ->suspend_late(),
> ->suspend_irq(), ->resume_irq(), ->resume_early(), or ->resume()
> callbacks for all devices having power.direct_complete set.  It
> will invoke their ->complete() callbacks, however, and those
> callbacks are then responsible for resuming the devices as
> appropriate, if necessary.

Perhaps you should mention here (and maybe even as a comment in the 
code) that ->complete() callbacks may want to call pm_request_resume() 
if dev->power.direct_resume is set, but they shouldn't call 
pm_runtime_resume().

> Changelog partly based on an Alan Stern's description of the idea
> (http://marc.info/?l=linux-pm&m=139940466625569&w=2).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

...

> @@ -1518,17 +1527,19 @@ static int device_prepare(struct device
>  		callback = dev->driver->pm->prepare;
>  	}
>  
> -	if (callback) {
> -		error = callback(dev);
> -		suspend_report_result(callback, error);
> -	}
> +	if (callback)
> +		ret = callback(dev);
>  
>  	device_unlock(dev);
>  
> -	if (error)
> +	if (ret < 0) {
> +		suspend_report_result(callback, ret);
>  		pm_runtime_put(dev);
> -
> -	return error;
> +		return ret;
> +	}
> +	dev->power.direct_complete = ret > 0 && state.event == PM_EVENT_SUSPEND
> +					&& pm_runtime_suspended(dev);

Shouldn't the flag be set under the spinlock?

Alan Stern

