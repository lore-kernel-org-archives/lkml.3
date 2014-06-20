Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967629AbaFTNPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:15:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63623 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966834AbaFTNPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:15:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Fri, 20 Jun 2014 15:33:25 +0200
Message-ID: <2531875.1yYGe4dtjp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406191020140.1247-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406191020140.1247-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 19, 2014 10:34:01 AM Alan Stern wrote:
> On Thu, 19 Jun 2014, Rafael J. Wysocki wrote:
> 
> > Well, we used to have the notion that runtime_status is not meaningful for
> > devices with dev->power.disable_depth greater than 0 (except for the special
> > case in the suspend code path where we know why it is greater than 0).  I think
> > it was useful. :-)
> 
> Did we really have that notion?  My memory is a little cloudy, but I 
> thought we decided that runtime_status would not be meaningful when 
> dev->power.runtime_error was set -- not when dev->power.disable_depth 
> was greater than 0.  Am I mixed up?

Well, we clearly did, because we added things like

pm_runtime_set_active()
pm_runtime_set_suspended()

which allow the status to be changed without doing anything to the device
while power.disable_depth is greater than 0.

> In any case, I think it is reasonable to regard runtime_status as 
> meaningful when disable_depth > 0.

So we need to remove the above helpers and modify all code using them.

> The PM core isn't allowed to invoke the runtime callbacks at such times,
> that's all.  This makes perfect sense for a device that doesn't support
> power management and hence must always be at full power.  Or when a driver
> knows that runtime_status is out of agreement with the device's actual
> power state and wants to update runtime_status directly.

That's what it is supposed to use the above helpers for, isn't it?

Devices that don't support power management, but that we want to use
drivers supporting power management with are clearly a special case, so
perhaps we should treat them as such instead of trying to modity the core
to silently cover this case too automatically?

> > > So pm_runtime_resume() and pm_request_resume() would still fail, but 
> > > pm_runtime_get() and pm_runtime_get_sync() would work?  I'm not sure 
> > > about the reason for this distinction.
> > 
> > The meaning of pm_runtime_get()/pm_runtime_get_sync() is "prevent the
> > device from being suspended from now on and resume it if necessary" while
> > "runtime PM disabled and runtime_status == RPM_ACTIVE" may be interpreted
> > as "not necessary to resume", so it is reasonable to special case this
> > particular situation for these particular routines IMHO.
> 
> By the same reasoning, the meaning of pm_runtime_resume() is "resume 
> the device now if necsesary".  Since "runtime PM disabled and 
> runtime_status == RPM_ACTIVE" means "not necessary to resume", isn't it 
> logical for pm_runtime_resume() also to succeed under that condition?

My point really is that pm_runtime_get()/pm_runtime_get_sync() actually carry
out two operations, (1) incrementing the usage counter and (2) resuming the
device if need be.  It is not particularly clear if/when the result of (2)
should determine the return value of (1) and (2) together, so there is some
freedom in that area which we can use to cover special cases.  That's all.

I'm perfectly fine with leaving the code as is, though.  You wanted to change it. :-)

Rafael

