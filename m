Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaEIWs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 18:48:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42104 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaEIWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 18:48:25 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
References: <Pine.LNX.4.44L0.1405071126340.1325-100000@iolanthe.rowland.org>
	<2333255.ofrK1CRRL4@vostro.rjw.lan>
	<2703563.1xTcfTGG98@vostro.rjw.lan>
Date: Fri, 09 May 2014 15:48:21 -0700
In-Reply-To: <2703563.1xTcfTGG98@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Thu, 08 May 2014 01:29:47 +0200")
Message-ID: <7hmweqmuve.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@rjwysocki.net> writes:

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
> descendants can remain runtime suspended until the resume stage of system
> resume.
>
> To this end, introduce dev->power.leave_runtime_suspended.
> If a subsystem or driver sets this flag during the ->prepare() callback,
> and if the flag is set in all of the device's descendants, and if the
> device is still in runtime suspend at the beginning of the ->suspend()
> callback, that callback is allowed to return 0 without clearing
> power.leave_runtime_suspended and without changing the state of the
> device, unless the current state of the device is not appropriate for
> the upcoming system sleep state (for example, the device is supposed to
> wake up the system from that state and its current wakeup settings are
> not suitable for that).  Then, the PM core will not invoke the device's
> ->suspend_late(), ->suspend_irq(), ->resume_irq(), ->resume_early(), or
> ->resume() callbacks.  

Up to here, this sounds great.

> Instead, it will invoke ->runtime_resume() during the device resume
> stage of system resume.

But this part I'm not fully following...

> By leaving this flag set after ->suspend(), a driver or subsystem tells
> the PM core that the device is runtime suspended, it is in a suitable
> state for system suspend (for example, the wakeup setting does not
> need to be changed), and it does not need to return to full
> power until the resume stage.

But taking this "leave runtime suspended" idea the next logical step,
why would/should a device need to return to full power at the ->resume()
stage?  especially when it wasn't at full power when ->suspend()
happened?

IOW, why doesn't "leave runtime suspended" mean "leave runtime suspended
until runtime resumed on demand."

Forcing ->runtime_resume() during device resume means that in most
cases, a device will be forcibly runtime resumed, only to have nothing
to do but go idle and runtime suspend again, resulting in a(nother)
unnessary power-up, power-down cycle this patch is trying to avoid
during ->suspend().

Hmm, but wait a minute...

[...]

> @@ -735,6 +735,11 @@ static int device_resume(struct device *
>  	if (dev->power.syscore)
>  		goto Complete;
>  
> +	if (pm_leave_runtime_suspended(dev)) {
> +		pm_runtime_resume(dev);
> +		goto Complete;
> +	}

... maybe I'm forgetting how this works (since it's Friday and my brain
is already shutting down for the week) but after pm_runtime_resume() is
called, won't the device remain runtime active until
pm_runtime_suspend() is called, or until a
pm_runtime_get()/pm_runtime_put() cycle happens?

That means that on device resume, the device is forced into full power
state (even though it was runtime suspended when ->suspend() happened)
and will stay there until its used again.  

That seems like a rather unpleasant (and non-intuitive) side-effect of
"leave runtime suspended".

Kevin
