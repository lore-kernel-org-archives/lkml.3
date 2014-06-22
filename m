Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaFVNDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 09:03:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54544 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750977AbaFVNDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 09:03:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Sun, 22 Jun 2014 15:21:23 +0200
Message-ID: <4507844.xYQKbujFj3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406201000470.1160-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406201000470.1160-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 20, 2014 10:43:11 AM Alan Stern wrote:
> On Fri, 20 Jun 2014, Rafael J. Wysocki wrote:
> 
> > On Thursday, June 19, 2014 10:34:01 AM Alan Stern wrote:
> > > On Thu, 19 Jun 2014, Rafael J. Wysocki wrote:
> > > 
> > > > Well, we used to have the notion that runtime_status is not meaningful for
> > > > devices with dev->power.disable_depth greater than 0 (except for the special
> > > > case in the suspend code path where we know why it is greater than 0).  I think
> > > > it was useful. :-)
> > > 
> > > Did we really have that notion?  My memory is a little cloudy, but I 
> > > thought we decided that runtime_status would not be meaningful when 
> > > dev->power.runtime_error was set -- not when dev->power.disable_depth 
> > > was greater than 0.  Am I mixed up?
> > 
> > Well, we clearly did, because we added things like
> > 
> > pm_runtime_set_active()
> > pm_runtime_set_suspended()
> > 
> > which allow the status to be changed without doing anything to the device
> > while power.disable_depth is greater than 0.
> 
> Yes.  I'm not sure that was thought out as carefully as it could have
> been.
> 
> Even with that restriction, it's not possible to guarantee that drivers
> won't make mistakes.  For example, suppose runtime_status is RPM_ACTIVE
> but the device really is powered down.  Before pm_runtime_disable() is
> called, pm_runtime_resume() will succeed.  The driver will think it can
> use the device, even though it can't.
> 
> This demonstrates that changing the runtime status can't be done
> properly unless the subsystem and driver take some of the
> responsibility.

That definitely is the case.

> Since that is true, perhaps we ought to allow drivers
> to call pm_runtime_set_active/suspended() whenever they want, and rely
> on them not to mess things up.

We can do that.  After all, having to disable runtime PM temporarily just
in order to change the status is not convenient after all.

IIRC the idea was to discourage drivers from setting the status in arbitrary
ways, but if that is too big of a problem ...

> As far as I know, there are only two major use cases for 
> _set_active/_set_suspended: when the device is being initialized during 
> probe, and during system resume.

I think you're right.

> During probe it's pretty safe to 
> assume there won't be any runtime PM calls, and much the same is true 
> during system resume (especially during the resume_irq and resume_early 
> phases).  Therefore relying on drivers shouldn't make their jobs any 
> harder.

I'm a little afraid of bugs resulting from being unsure how to use the API,
however.

> > > In any case, I think it is reasonable to regard runtime_status as 
> > > meaningful when disable_depth > 0.
> > 
> > So we need to remove the above helpers and modify all code using them.
> 
> We don't have to remove the helpers.  And practically none of the code 
> using them would need to be modified.  A certain amount of auditing 
> would be a good idea, though.

Auditing would help anyway, but I'm still not sure about the entire idea.

For example, what's the meaning of runtime_status for devices that haven't
been initialized yet?

> > > The PM core isn't allowed to invoke the runtime callbacks at such times,
> > > that's all.  This makes perfect sense for a device that doesn't support
> > > power management and hence must always be at full power.  Or when a driver
> > > knows that runtime_status is out of agreement with the device's actual
> > > power state and wants to update runtime_status directly.
> > 
> > That's what it is supposed to use the above helpers for, isn't it?
> > 
> > Devices that don't support power management, but that we want to use
> > drivers supporting power management with are clearly a special case, so
> 
> Are they?  I'm not so sure.  But never mind...
> 
> > perhaps we should treat them as such instead of trying to modity the core
> > to silently cover this case too automatically?
> 
> How would you treat them specially?  Add a "runtime_pm_not_supported" 
> flag?

I thought about a "runtime PM has been enabled at least once" flag rather
that would be set by pm_runtime_enable() every time it is called and never
cleared.  That would allow the core to distinguish between "runtime PM
disabled temporarily" and "runtime PM not used" which turn out to be
sufficiently different cases.

> > > > > So pm_runtime_resume() and pm_request_resume() would still fail, but 
> > > > > pm_runtime_get() and pm_runtime_get_sync() would work?  I'm not sure 
> > > > > about the reason for this distinction.
> > > > 
> > > > The meaning of pm_runtime_get()/pm_runtime_get_sync() is "prevent the
> > > > device from being suspended from now on and resume it if necessary" while
> > > > "runtime PM disabled and runtime_status == RPM_ACTIVE" may be interpreted
> > > > as "not necessary to resume", so it is reasonable to special case this
> > > > particular situation for these particular routines IMHO.
> > > 
> > > By the same reasoning, the meaning of pm_runtime_resume() is "resume 
> > > the device now if necsesary".  Since "runtime PM disabled and 
> > > runtime_status == RPM_ACTIVE" means "not necessary to resume", isn't it 
> > > logical for pm_runtime_resume() also to succeed under that condition?
> > 
> > My point really is that pm_runtime_get()/pm_runtime_get_sync() actually carry
> > out two operations, (1) incrementing the usage counter and (2) resuming the
> > device if need be.  It is not particularly clear if/when the result of (2)
> > should determine the return value of (1) and (2) together, so there is some
> > freedom in that area which we can use to cover special cases.  That's all.
> 
> Oh.  Well, currently those routines are documented as returning the 
> value from their internal pm_request_resume()/pm_runtime_resume() call.

Yes, they are, but that's because we made that particular choice at one point.
The freedom is there, though, and we can update the documentation too. :-)

> > I'm perfectly fine with leaving the code as is, though.  You wanted to change it. :-)
> 
> I'd be equally happy with a "runtime_pm_not_supported" flag, or 
> something equivalent.  Implementing it wouldn't be hard: Setting the 
> flag could call pm_runtime_forbid() and make the power/control sysfs 
> attribute return -EPERM for any attempted write.  Perhaps also make 
> power/runtime_status show "unsupported" rather than "on".
> 
> (Hmmm, now that I look at rtpm_status_show(), I see that it already 
> shows "unsupported" whenever disable_depth > 0.  Another indication of 
> how confused the situation is?)

Yes.  The core definitely needs to be able to distinguish between the
"runtime PM disabled temporarily" and "runtime PM not supported/not used"
situations.

Rafael

