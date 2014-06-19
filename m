Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbaFSIYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:24:03 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18932 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbaFSIX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:23:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jun 2014 01:14:34 -0700
From: Allen Yu <alleny@nvidia.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jun 2014 16:23:29 +0800
Subject: RE: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
Thread-Topic: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
Thread-Index: Ac+LTp+m+ZtF76U6T16Z2eYX4IKP1AAP8KUg
Message-ID: <9E7892CE01168A46922BCCE04DB02F9828F863E9@HKMAIL01.nvidia.com>
References: <Pine.LNX.4.44L0.1406181121220.1467-100000@iolanthe.rowland.org>
 <3528855.Z370J7O75B@vostro.rjw.lan>
In-Reply-To: <3528855.Z370J7O75B@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5J8O9jk024602

On Thursday, June 19, 2014, Rafael J. Wysocki wrote: 
> On Wednesday, June 18, 2014 11:30:51 AM Alan Stern wrote:
> > On Tue, 17 Jun 2014, Rafael J. Wysocki wrote:
> >
> > > On Tuesday, June 17, 2014 10:37:03 PM Rafael J. Wysocki wrote:
> > > > On Tuesday, June 17, 2014 10:26:14 PM Rafael J. Wysocki wrote:
> > > > > On Tuesday, June 17, 2014 10:11:32 AM Alan Stern wrote:
> > > > > > On Mon, 16 Jun 2014, Rafael J. Wysocki wrote:
> > > > > >
> > > > > > > > For reasons having nothing to do with Allen's suggested
> > > > > > > > change, I wonder if we shouldn't replace this line with
> something like:
> > > > > > > >
> > > > > > > > -	else if (dev->power.disable_depth == 1 && dev-
> >power.is_suspended
> > > > > > > > +	else if (dev->power.disable > 0 &&
> > > > > > > > +!dev->power.is_suspended
> > > > > > > > 	    && dev->power.runtime_status == RPM_ACTIVE)
> > > > > > > > 		retval = 1;
> > > > > > > >
> > > > > > > > It seems that I've been bitten by this several times in the past.
> > > > > > > > When a device is disabled for runtime PM, and more or less
> > > > > > > > permanently stuck in the RPM_ACTIVE state, calls to
> > > > > > > > pm_runtime_resume() or
> > > > > > > > pm_runtime_get_sync() shouldn't fail.
> > > > > > > >
> > > > > > > > For example, suppose some devices of a certain type
> > > > > > > > support runtime power management but others don't.  We
> > > > > > > > naturally want to call
> > > > > > > > pm_runtime_disable() for the ones that don't.  But we also
> > > > > > > > want the same driver to work for all the devices, which
> > > > > > > > means that
> > > > > > > > pm_runtime_get_sync() should return success -- otherwise
> > > > > > > > the driver will think that something has gone wrong.
> > > > > > > >
> > > > > > > > Rafael, what do you think?
> > > > > > >
> > > > > > > That condition is there specifically to take care of the
> > > > > > > system suspend code path.  It means that if runtime PM is
> > > > > > > disabled, but it only has been disabled by the system
> > > > > > > suspend code path, we should treat the device as "active" (ie.
> return 1).  That won't work after the proposed change.
> > > > > >
> > > > > > Ah, yes, quite true.  Okay, suppose we replace that line with just:
> > > > > >
> > > > > > +	else if (dev->power.disable > 0
> > > > > >
> > > > > > > I guess drivers that want to work with devices where runtime
> > > > > > > PM may be disabled can just check the return value of
> rpm_resume() for -EACCES?
> > > > > >
> > > > > > They could, but it's extra work and it's extremely easy to
> > > > > > forget about.  I'd prefer not to do things that way.
> > > > >
> > > > > In that case we need to audit all code that checks the return
> > > > > value of
> > > > > __pm_runtime_resume() to verify that it doesn't depend on the
> > > > > current behavior in any way.  It shouldn't, but still.
> > > > >
> > > > > Also we probably should drop the -EACCES return value from
> > > > > rpm_resume() in the same patch, because it specifically only
> > > > > covers the dev->power.disable > 0 case (which BTW is consistent
> > > > > with the suspend side of things, so I'm totally unsure about that being
> the right thing to do to be honest).
> >
> > It's still the correct action with runtime PM is disabled and the
> > device's runtime_status isn't RPM_ACTIVE.
> 
> Well, we used to have the notion that runtime_status is not meaningful for
> devices with dev->power.disable_depth greater than 0 (except for the
> special case in the suspend code path where we know why it is greater than
> 0).  I think it was useful. :-)

So what's the exact state of device if dev->power.is_suspended flag is set and runtime_status is RPM_ACTIVE? Is it a state like "suspended but still can be accessed"? 

I'm just afraid the existing code would cause a device hang if we allow it to be accessed even though it's suspended (at this point RPM_ACTIVE could be meaningless). I don't understand the original motivation of these code. If it's a valid case, most likely it should be handled in the specific device driver instead of the PM core.

> 
> > > > Perhaps it'd be better to rework __pm_runtime_resume() to convert
> > > > the -EACCES return value from rpm_resume() into 0 if RPM_GET_PUT is
> set?
> > >
> > > Or do something like this?
> > >
> > > ---
> > >  drivers/base/power/runtime.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > Index: linux-pm/drivers/base/power/runtime.c
> > >
> ==========================================================
> =========
> > > --- linux-pm.orig/drivers/base/power/runtime.c
> > > +++ linux-pm/drivers/base/power/runtime.c
> > > @@ -608,7 +608,8 @@ static int rpm_resume(struct device *dev
> > >   repeat:
> > >  	if (dev->power.runtime_error)
> > >  		retval = -EINVAL;
> > > -	else if (dev->power.disable_depth == 1 && dev-
> >power.is_suspended
> > > +	else if (((dev->power.disable_depth > 0 && (rpmflags &
> RPM_GET_PUT))
> > > +	    || (dev->power.disable_depth == 1 && dev-
> >power.is_suspended))
> > >  	    && dev->power.runtime_status == RPM_ACTIVE)
> > >  		retval = 1;
> > >  	else if (dev->power.disable_depth > 0)
> >
> > So pm_runtime_resume() and pm_request_resume() would still fail, but
> > pm_runtime_get() and pm_runtime_get_sync() would work?  I'm not sure
> > about the reason for this distinction.
> 
> The meaning of pm_runtime_get()/pm_runtime_get_sync() is "prevent the
> device from being suspended from now on and resume it if necessary" while
> "runtime PM disabled and runtime_status == RPM_ACTIVE" may be
> interpreted as "not necessary to resume", so it is reasonable to special case
> this particular situation for these particular routines IMHO.

As Rafael mentioned above that runtime_sataus is not meaningful if runtime PM is disabled, so shouldn't we avoid using the runtime_staus here and instead use dev->power.is_suspended only to decide the return value?

@@ -608,11 +608,13 @@ static int rpm_resume(struct device *dev, int rpmflags)
  repeat:
        if (dev->power.runtime_error)
                retval = -EINVAL;
-       else if (dev->power.disable_depth == 1 && dev->power.is_suspended
-           && dev->power.runtime_status == RPM_ACTIVE)
-               retval = 1;
-       else if (dev->power.disable_depth > 0)
-               retval = -EACCES;
+       else if (dev->power.disable_depth > 0) {
+               if (!dev->power.is_suspended)
+                       retval = 1;
+               else
+                       retval = -EACCES;
+       }
+
        if (retval)
                goto out;

However, this requires us to make sure device is in full functional state if it's not suspended before disabling runtime PM, just like the case runtime PM is not configured at all. And also requires device suspend routine to check dev->power.usage_count before suspending device.

Thanks,
Allen Yu
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
