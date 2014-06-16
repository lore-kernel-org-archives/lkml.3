Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaFPVLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:11:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52910 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752582AbaFPVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:11:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Mon, 16 Jun 2014 23:29:17 +0200
Message-ID: <1901328.MvkshKEuEq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406161329350.1292-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406161329350.1292-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 16, 2014 01:40:05 PM Alan Stern wrote:
> On Sat, 14 Jun 2014, Allen Yu wrote:
> 
> > --- a/drivers/base/power/runtime.c
> > +++ b/drivers/base/power/runtime.c
> > @@ -608,7 +608,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
> >   repeat:
> >  	if (dev->power.runtime_error)
> >  		retval = -EINVAL;
> > -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> > +	else if (dev->power.disable_depth == 1 && !dev->power.is_suspended
> >  	    && dev->power.runtime_status == RPM_ACTIVE)
> >  		retval = 1;
> 
> For reasons having nothing to do with Allen's suggested change, I
> wonder if we shouldn't replace this line with something like:
> 
> -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> +	else if (dev->power.disable > 0 && !dev->power.is_suspended
> 	    && dev->power.runtime_status == RPM_ACTIVE)
> 		retval = 1;
> 
> It seems that I've been bitten by this several times in the past.  
> When a device is disabled for runtime PM, and more or less permanently
> stuck in the RPM_ACTIVE state, calls to pm_runtime_resume() or
> pm_runtime_get_sync() shouldn't fail.
> 
> For example, suppose some devices of a certain type support runtime 
> power management but others don't.  We naturally want to call 
> pm_runtime_disable() for the ones that don't.  But we also want the 
> same driver to work for all the devices, which means that 
> pm_runtime_get_sync() should return success -- otherwise the driver 
> will think that something has gone wrong.
> 
> Rafael, what do you think?

That condition is there specifically to take care of the system suspend
code path.  It means that if runtime PM is disabled, but it only has been
disabled by the system suspend code path, we should treat the device as
"active" (ie. return 1).  That won't work after the proposed change.

I guess drivers that want to work with devices where runtime PM may be
disabled can just check the return value of rpm_resume() for -EACCES?

Rafael

