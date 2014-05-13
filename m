Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbaEMQT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:19:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42719 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760076AbaEMQTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:19:15 -0400
Date: Tue, 13 May 2014 12:19:14 -0400 (EDT)
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
In-Reply-To: <2673732.vGhgFDMBON@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405131211080.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Rafael J. Wysocki wrote:

> > Maybe the call to __pm_runtime_disable() should be moved from
> > __device_suspend_late() to __device_suspend(), after the callback has
> > been invoked (or skipped, as the case may be).  Then after runtime PM
> > has been disabled, you can check the device's status has changed and go
> > back to invoke the callback if necessary.
> 
> We moved __pm_runtime_disable() to __device_suspend_late() to be able to
> use pm_runtime_resume() in __device_suspend() (and we actually do that in
> some places now).
> 
> But, in principle, we can do __pm_runtime_disable() temporarily in some place
> between ->prepare() and ->suspend(), it doesn't matter if that's in
> device_prepare() in __device_suspend() really.

It should be as late as possible, to allow for detecting wakeup 
requests.

>  Then, we can check the device's
> runtime PM status (that'd need to be done carefully to take the disabling into
> account) and
> (1) if the device is runtime-suspended, set direct_complete for it without
>     enabling runtime PM, or
> (2) if the device is not runtime-suspended, clear direct_complete for it
>     and re-enable runtime PM.
> and in case of (1) we would re-enable runtime PM in device_complete().
> 
> That should work I suppose?

Yes; it's similar to what I proposed.  Note that this can be skipped if 
direct_complete is already clear.

> Of course, question is what ->prepare() is supposed to do then if it needs
> to check the state of the device before deciding whether or not to return 1.
> I guess it would need to disable runtime PM around that check too.

It would be surprising if ->prepare() needed to make any difficult
checks.  This would imply that the device could have multiple
runtime-suspend states, some of which are appropriate for system
suspend while others aren't.  Not impossible, but I wouldn't expect it
to come up often.

Besides, as I mentioned before, we never have to worry about status 
changes.  If one occurs while ->prepare() is running or afterward, it 
means the device is runtime-resumed and therefore the setting of 
direct_complete doesn't matter.

Alan Stern

