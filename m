Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaEHUrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:47:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57603 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752840AbaEHUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:47:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Thu, 08 May 2014 23:03:58 +0200
Message-ID: <1528372.jfySyitOy3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3058268.hrHgpxktTP@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405081040330.1087-100000@iolanthe.rowland.org> <3058268.hrHgpxktTP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 10:17:50 PM Rafael J. Wysocki wrote:
> On Thursday, May 08, 2014 10:57:36 AM Alan Stern wrote:
> > On Thu, 8 May 2014, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> > > resume all runtime-suspended devices during system suspend, mostly
> > > because those devices may need to be reprogrammed due to different
> > > wakeup settings for system sleep and for runtime PM.
> > > 
> > > For some devices, though, it's OK to remain in runtime suspend 
> > > throughout a complete system suspend/resume cycle (if the device was in
> > > runtime suspend at the start of the cycle).  We would like to do this
> > > whenever possible, to avoid the overhead of extra power-up and power-down
> > > events.
> > > 
> > > However, problems may arise because the device's descendants may require
> > > it to be at full power at various points during the cycle.  Therefore the
> > > most straightforward way to do this safely is if the device and all its
> > > descendants can remain runtime suspended until the resume stage of system
> > > resume.
> > > 
> > > To this end, introduce dev->power.leave_runtime_suspended.
> > > If a subsystem or driver sets this flag during the ->prepare() callback,
> > > and if the flag is set in all of the device's descendants, and if the
> > > device is still in runtime suspend at the beginning of the ->suspend()
> > > callback, that callback is allowed to return 0 without clearing
> > > power.leave_runtime_suspended and without changing the state of the
> > > device, unless the current state of the device is not appropriate for
> > > the upcoming system sleep state (for example, the device is supposed to
> > > wake up the system from that state and its current wakeup settings are
> > > not suitable for that).  Then, the PM core will not invoke the device's
> > > ->suspend_late(), ->suspend_irq(), ->resume_irq(), ->resume_early(), or
> > > ->resume() callbacks.  Instead, it will invoke ->runtime_resume() during
> > > the device resume stage of system resume.
> > 
> > Wait a minute.  Following ->runtime_suspend(), you are going to call 
> > ->suspend() and then ->runtime_resume()?  That doesn't seem like what 
> > you really want; a ->suspend() call should always have a matching 
> > ->resume().
> 
> Yes, it should, but I didn't see any other way to do that.

Actually, that's kind of easy to resolve. :-)

When ->suspend() leaves power.leave_runtime_suspended set, the PM core can
simply skip the early/late and noirq callbacks and then call ->resume()
that will be responsible for using whatever is necessary to resume the
device.

And perhaps the flag should be called something different then, like
direct_resume (meaning go directly for ->resume() without executing
the intermediate callbacks)?

Rafael

