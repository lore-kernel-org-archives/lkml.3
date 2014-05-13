Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbaEMQAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:00:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63918 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753377AbaEMQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:00:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
Date: Tue, 13 May 2014 18:16:53 +0200
Message-ID: <2673732.vGhgFDMBON@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405131139510.1098-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405131139510.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 13, 2014 11:46:55 AM Alan Stern wrote:
> On Tue, 13 May 2014, Rafael J. Wysocki wrote:
> 
> > > A wakeup request from the hardware could cause a runtime resume to 
> > > occur at this time.  The barrier wouldn't prevent that.
> > > 
> > > It's unlikely, I agree, but not impossible.
> > 
> > Yeah, I didn't think about that.
> 
> Come to think of it, if the hardware sends a wakeup request then it
> must have been enabled for remote wakeup.  And if the hardware settings
> are appropriate for system suspend then it must be enabled for system
> wakeup.  Consequently a wakeup from the hardware ought to abort the
> system suspend in any case.  So maybe we don't care about this 
> scenario.
> 
> On the other hand, there may be other mechanisms that could cause a 
> runtime resume at this inconvenient time.  A timer routine, for 
> instance.
> 
> > But that also can occur in __device_suspend(), after we've checked the flag
> > and decided not to invoke the ->suspend() callback, right?  So moving the
> > check in there doesn't help much I'd say.  It closes the race window, but
> > that's it.
> > 
> > That means that the whole approach based on ->prepare() is problematic
> > unless we somehow mix it with disabling runtime PM.
> 
> Maybe the call to __pm_runtime_disable() should be moved from
> __device_suspend_late() to __device_suspend(), after the callback has
> been invoked (or skipped, as the case may be).  Then after runtime PM
> has been disabled, you can check the device's status has changed and go
> back to invoke the callback if necessary.

We moved __pm_runtime_disable() to __device_suspend_late() to be able to
use pm_runtime_resume() in __device_suspend() (and we actually do that in
some places now).

But, in principle, we can do __pm_runtime_disable() temporarily in some place
between ->prepare() and ->suspend(), it doesn't matter if that's in
device_prepare() in __device_suspend() really.  Then, we can check the device's
runtime PM status (that'd need to be done carefully to take the disabling into
account) and
(1) if the device is runtime-suspended, set direct_complete for it without
    enabling runtime PM, or
(2) if the device is not runtime-suspended, clear direct_complete for it
    and re-enable runtime PM.
and in case of (1) we would re-enable runtime PM in device_complete().

That should work I suppose?

Of course, question is what ->prepare() is supposed to do then if it needs
to check the state of the device before deciding whether or not to return 1.
I guess it would need to disable runtime PM around that check too.

Rafael

