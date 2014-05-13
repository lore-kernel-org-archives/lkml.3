Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaEMPrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:47:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42681 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754895AbaEMPq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:46:57 -0400
Date: Tue, 13 May 2014 11:46:55 -0400 (EDT)
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
In-Reply-To: <1652919.R3bbdKUH5p@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405131139510.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Rafael J. Wysocki wrote:

> > A wakeup request from the hardware could cause a runtime resume to 
> > occur at this time.  The barrier wouldn't prevent that.
> > 
> > It's unlikely, I agree, but not impossible.
> 
> Yeah, I didn't think about that.

Come to think of it, if the hardware sends a wakeup request then it
must have been enabled for remote wakeup.  And if the hardware settings
are appropriate for system suspend then it must be enabled for system
wakeup.  Consequently a wakeup from the hardware ought to abort the
system suspend in any case.  So maybe we don't care about this 
scenario.

On the other hand, there may be other mechanisms that could cause a 
runtime resume at this inconvenient time.  A timer routine, for 
instance.

> But that also can occur in __device_suspend(), after we've checked the flag
> and decided not to invoke the ->suspend() callback, right?  So moving the
> check in there doesn't help much I'd say.  It closes the race window, but
> that's it.
> 
> That means that the whole approach based on ->prepare() is problematic
> unless we somehow mix it with disabling runtime PM.

Maybe the call to __pm_runtime_disable() should be moved from
__device_suspend_late() to __device_suspend(), after the callback has
been invoked (or skipped, as the case may be).  Then after runtime PM
has been disabled, you can check the device's status has changed and go
back to invoke the callback if necessary.

Alan Stern

