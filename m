Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbaFQUTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:19:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52026 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932927AbaFQUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:19:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Tue, 17 Jun 2014 22:37:03 +0200
Message-ID: <1594380.FbALgJzamg@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2320679.BykjsXib1x@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1406171007000.1187-100000@iolanthe.rowland.org> <2320679.BykjsXib1x@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 17, 2014 10:26:14 PM Rafael J. Wysocki wrote:
> On Tuesday, June 17, 2014 10:11:32 AM Alan Stern wrote:
> > On Mon, 16 Jun 2014, Rafael J. Wysocki wrote:
> > 
> > > > For reasons having nothing to do with Allen's suggested change, I
> > > > wonder if we shouldn't replace this line with something like:
> > > > 
> > > > -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> > > > +	else if (dev->power.disable > 0 && !dev->power.is_suspended
> > > > 	    && dev->power.runtime_status == RPM_ACTIVE)
> > > > 		retval = 1;
> > > > 
> > > > It seems that I've been bitten by this several times in the past.  
> > > > When a device is disabled for runtime PM, and more or less permanently
> > > > stuck in the RPM_ACTIVE state, calls to pm_runtime_resume() or
> > > > pm_runtime_get_sync() shouldn't fail.
> > > > 
> > > > For example, suppose some devices of a certain type support runtime 
> > > > power management but others don't.  We naturally want to call 
> > > > pm_runtime_disable() for the ones that don't.  But we also want the 
> > > > same driver to work for all the devices, which means that 
> > > > pm_runtime_get_sync() should return success -- otherwise the driver 
> > > > will think that something has gone wrong.
> > > > 
> > > > Rafael, what do you think?
> > > 
> > > That condition is there specifically to take care of the system suspend
> > > code path.  It means that if runtime PM is disabled, but it only has been
> > > disabled by the system suspend code path, we should treat the device as
> > > "active" (ie. return 1).  That won't work after the proposed change.
> > 
> > Ah, yes, quite true.  Okay, suppose we replace that line with just:
> > 
> > +	else if (dev->power.disable > 0
> > 
> > > I guess drivers that want to work with devices where runtime PM may be
> > > disabled can just check the return value of rpm_resume() for -EACCES?
> > 
> > They could, but it's extra work and it's extremely easy to forget 
> > about.  I'd prefer not to do things that way.
> 
> In that case we need to audit all code that checks the return value of
> __pm_runtime_resume() to verify that it doesn't depend on the current
> behavior in any way.  It shouldn't, but still.
> 
> Also we probably should drop the -EACCES return value from rpm_resume() in the
> same patch, because it specifically only covers the dev->power.disable > 0 case
> (which BTW is consistent with the suspend side of things, so I'm totally unsure
> about that being the right thing to do to be honest).

Perhaps it'd be better to rework __pm_runtime_resume() to convert the -EACCES
return value from rpm_resume() into 0 if RPM_GET_PUT is set?

Rafael

