Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967527AbaFTNC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:02:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56761 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967467AbaFTNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:02:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kevin Hilman <khilman@linaro.org>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Fri, 20 Jun 2014 15:20:31 +0200
Message-ID: <17793417.Syoi52bq6K@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406191552330.1247-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406191552330.1247-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 19, 2014 04:13:07 PM Alan Stern wrote:
> On Thu, 19 Jun 2014, Kevin Hilman wrote:
> 
> > Alan Stern <stern@rowland.harvard.edu> writes:
> > 
> > > On Thu, 19 Jun 2014, Allen Yu wrote:
> > >
> > >> So what's the exact state of device if dev->power.is_suspended flag
> > >> is set and runtime_status is RPM_ACTIVE? Is it a state like
> > >> "suspended but still can be accessed"?
> > >> 
> > >> I'm just afraid the existing code would cause a device hang if we
> > >> allow it to be accessed even though it's suspended (at this point
> > >> RPM_ACTIVE could be meaningless). I don't understand the original
> > >> motivation of these code. If it's a valid case, most likely it should
> > >> be handled in the specific device driver instead of the PM core.
> > >
> > > You should read the Changelog for commit 6f3c77b040f (PM / Runtime:  
> > > let rpm_resume() succeed if RPM_ACTIVE, even when disabled, v2).  It
> > > explains why the code looks the way it does.
> > >
> > > However, I'm starting to think the reasoning in that commit may not be
> > > valid.  While perhaps it is okay for some I2C devices (mentioned in the
> > > commit log), it probably isn't okay in general.
> > 
> > Why not?
> 
> See below.
> 
> > > Kevin, do have any comments on this matter?  What do you think about 
> > > making the following change to rpm_resume():
> > >
> > >  repeat:
> > > 	if (dev->power.runtime_error)
> > > 		retval = -EINVAL;
> > > -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> > > +	else if (dev->power.disable_depth > 0
> > > 	    && dev->power.runtime_status == RPM_ACTIVE)
> > > 		retval = 1;
> > > 	else if (dev->power.disable_depth > 0)
> > >
> > > Or even:
> > >
> > > +	else if (dev->power.disable_depth > 0 && !dev->power.is_suspended
> > >
> > > although this would require the I2C driver you mentioned in your commit 
> > > to change.
> > 
> > My change was introduced to catch a very specific case.  Namely, when we
> > know that the core has successfully asked the device to do a system suspend
> > (dev->power.is_suspended == true) *and* we know that runtime PM was
> > disabled *only* by the PM core (disable_depth == 0) while the device was
> > still active (runtime_status == RPM_ACTIVE.)
> 
> For a general device, the fact that dev->power.is_suspended is set
> means the device _has_ been powered down.  Even though the
> runtime_status may not have changed, the PM core has to assume the
> device is not available for use.

This seems to go a bit too far.  What power.is_suspended actually means is
that __device_suspend() has run for the device successfully.  What the
implications of that are depends on the bus type (or subsystem in general)
and device driver.

> While your I2C devices may be useable even after the ->suspend callback
> returns, for most devices this isn't true.  So we shouldn't allow
> rpm_resume() to return imediately when is_suspended is set.

I can agree with that.

> > In your first idea above, it would allow a _get() to succeed even if
> > someone other than the core (including the driver itself) had called
> > pm_runtime_disable().  I don't think we want that.
> 
> Why not?  The fact that the device is disabled for runtime PM means
> that the PM core mustn't try to change its power state.  But if the
> runtime status is RPM_ACTIVE then the device should already be powered
> up, so there's no harm in letting runtime_resume() succeed.
> 
> To put it another way, disabled_depth > 0 means that the PM core isn't
> allowed to invoke any of the runtime PM callbacks.  But when
> runtime_status == RPM_ACTIVE, runtime_resume() can run successfully
> without invoking any callbacks.

Theoretically.  That is, unless someone changes the status from RPM_SUSPENDED
to RPM_ACTIVE while runtime PM is disabled for the device, which is documented
as a *valid* thing to do.

So really, perhaps we should go back to thinking that runtime_status is
meaningless while runtime PM is disabled, which really is the case?

Rafael

