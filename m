Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaFRPax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:30:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46579 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752169AbaFRPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:30:52 -0400
Date: Wed, 18 Jun 2014 11:30:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <2420304.GaXVpqVQD5@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1406181121220.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Rafael J. Wysocki wrote:

> On Tuesday, June 17, 2014 10:37:03 PM Rafael J. Wysocki wrote:
> > On Tuesday, June 17, 2014 10:26:14 PM Rafael J. Wysocki wrote:
> > > On Tuesday, June 17, 2014 10:11:32 AM Alan Stern wrote:
> > > > On Mon, 16 Jun 2014, Rafael J. Wysocki wrote:
> > > > 
> > > > > > For reasons having nothing to do with Allen's suggested change, I
> > > > > > wonder if we shouldn't replace this line with something like:
> > > > > > 
> > > > > > -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> > > > > > +	else if (dev->power.disable > 0 && !dev->power.is_suspended
> > > > > > 	    && dev->power.runtime_status == RPM_ACTIVE)
> > > > > > 		retval = 1;
> > > > > > 
> > > > > > It seems that I've been bitten by this several times in the past.  
> > > > > > When a device is disabled for runtime PM, and more or less permanently
> > > > > > stuck in the RPM_ACTIVE state, calls to pm_runtime_resume() or
> > > > > > pm_runtime_get_sync() shouldn't fail.
> > > > > > 
> > > > > > For example, suppose some devices of a certain type support runtime 
> > > > > > power management but others don't.  We naturally want to call 
> > > > > > pm_runtime_disable() for the ones that don't.  But we also want the 
> > > > > > same driver to work for all the devices, which means that 
> > > > > > pm_runtime_get_sync() should return success -- otherwise the driver 
> > > > > > will think that something has gone wrong.
> > > > > > 
> > > > > > Rafael, what do you think?
> > > > > 
> > > > > That condition is there specifically to take care of the system suspend
> > > > > code path.  It means that if runtime PM is disabled, but it only has been
> > > > > disabled by the system suspend code path, we should treat the device as
> > > > > "active" (ie. return 1).  That won't work after the proposed change.
> > > > 
> > > > Ah, yes, quite true.  Okay, suppose we replace that line with just:
> > > > 
> > > > +	else if (dev->power.disable > 0
> > > > 
> > > > > I guess drivers that want to work with devices where runtime PM may be
> > > > > disabled can just check the return value of rpm_resume() for -EACCES?
> > > > 
> > > > They could, but it's extra work and it's extremely easy to forget 
> > > > about.  I'd prefer not to do things that way.
> > > 
> > > In that case we need to audit all code that checks the return value of
> > > __pm_runtime_resume() to verify that it doesn't depend on the current
> > > behavior in any way.  It shouldn't, but still.
> > > 
> > > Also we probably should drop the -EACCES return value from rpm_resume() in the
> > > same patch, because it specifically only covers the dev->power.disable > 0 case
> > > (which BTW is consistent with the suspend side of things, so I'm totally unsure
> > > about that being the right thing to do to be honest).

It's still the correct action with runtime PM is disabled and the 
device's runtime_status isn't RPM_ACTIVE.

> > Perhaps it'd be better to rework __pm_runtime_resume() to convert the -EACCES
> > return value from rpm_resume() into 0 if RPM_GET_PUT is set?
> 
> Or do something like this?
> 
> ---
>  drivers/base/power/runtime.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/base/power/runtime.c
> ===================================================================
> --- linux-pm.orig/drivers/base/power/runtime.c
> +++ linux-pm/drivers/base/power/runtime.c
> @@ -608,7 +608,8 @@ static int rpm_resume(struct device *dev
>   repeat:
>  	if (dev->power.runtime_error)
>  		retval = -EINVAL;
> -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> +	else if (((dev->power.disable_depth > 0 && (rpmflags & RPM_GET_PUT))
> +	    || (dev->power.disable_depth == 1 && dev->power.is_suspended))
>  	    && dev->power.runtime_status == RPM_ACTIVE)
>  		retval = 1;
>  	else if (dev->power.disable_depth > 0)

So pm_runtime_resume() and pm_request_resume() would still fail, but 
pm_runtime_get() and pm_runtime_get_sync() would work?  I'm not sure 
about the reason for this distinction.

Allen, what do you think?

Alan Stern

