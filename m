Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaFPOn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:43:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54144 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890AbaFPOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:43:27 -0400
Date: Mon, 16 Jun 2014 10:43:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Allen Yu <alleny@nvidia.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <9E7892CE01168A46922BCCE04DB02F9828E62353@HKMAIL01.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1406161019160.1292-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Allen Yu wrote:

> On Sat, 14 Jun 2014, Alan Stern wrote:
> 
> > > dev->power.is_suspended is set after core suspends device during system
> > suspend.
> > > This flag mostly means device is not operational (all I/O been
> > > quiesced, no more data read or write acceptible, etc.), hence it's
> > > dangerous to access hardware if device is suspended even though runtime
> > PM status is RPM_ACTIVE.
> > >
> > > In turn, we should allow device to be accessed in case device is *not*
> > > suspended and runtime PM status is RPM_ACTIVE, even if runtime PM
> > > disabled. This corner case can happen to a device in a generic PM
> > > domain if the domain is not powered off while preparing for a system-wide
> > power transition.
> > 
> > I don't understand.  Even if the PM domain isn't powered off, the device's
> > is_suspended flag will still be set by __device_suspend().
> 
> Yes, is_suspended flag will be set by __device_suspend(). But runtime PM can be disabled in pm_genpd_prepare():
> 
> 914 static int pm_genpd_prepare(struct device *dev){
> ...
> 956         /*
> 957          * The PM domain must be in the GPD_STATE_ACTIVE state at this point,
> 958          * so pm_genpd_poweron() will return immediately, but if the device
> 959          * is suspended (e.g. it's been stopped by genpd_stop_dev()), we need
> 960          * to make it operational.
> 961          */
> 962         pm_runtime_resume(dev);
> 963         __pm_runtime_disable(dev, false);
> ...
> 978 }
> 
> And there is a gap between pm_genpd_prepare() and __device_suspend(), during which is_suspended flag is *not* yet set but runtime PM is disabled and device status is RPM_ACTIVE. 

It sounds like the real problem lies in pm_genpd_prepare().  It 
disables the device too early.

> > >  In this case, runtime PM status will
> > > be set to RPM_ACTIVE and then runtime PM is disabled. After that,
> > > device driver may call pm_runtime_get_sync() and rpm_resume() should
> > > return 1, because the device is still active as long as not been suspended.
> > 
> > Isn't that what the existing code does already?  Your patch seems to change
> > it so that it _doesn't_ behave the way you want.
> > 
> 
> The existing code return 1 for case is_suspended flag is set.  That means __device_suspend() has been called and device is not in operational state. Whereas the case I mentioned above is before device is suspended.
> It's dangerous to access device if it's in suspended state, so I propose only allowing access to a device if it's not suspended (i.e. value of "is_suspneded" flag is false).

Okay, now I understand what you want to do.  I couldn't figure it out
just from the patch description.

A better solution might be to remove the __pm_runtime_disable() call 
from pm_genpd_prepare().  There's no obvious reason for it to be there, 
especially since the PM core does a disable in __device_suspend_late().

Alan Stern

