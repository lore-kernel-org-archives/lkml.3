Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966819AbaFTNqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:46:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59656 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965260AbaFTNqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:46:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Allen Yu <alleny@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Fri, 20 Jun 2014 16:04:29 +0200
Message-ID: <3309176.n81vTPHlTR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9E7892CE01168A46922BCCE04DB02F9828F86494@HKMAIL01.nvidia.com>
References: <Pine.LNX.4.44L0.1406181121220.1467-100000@iolanthe.rowland.org> <4216316.IaLNu46z52@vostro.rjw.lan> <9E7892CE01168A46922BCCE04DB02F9828F86494@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 19, 2014 10:34:51 PM Allen Yu wrote:
> On Thursday, June 19, 2014, Rafael J. Wysocki wrote:
> > On Thursday, June 19, 2014 04:23:29 PM Allen Yu wrote:
> > > On Thursday, June 19, 2014, Rafael J. Wysocki wrote:

[cut]

> > > > Well, we used to have the notion that runtime_status is not
> > > > meaningful for devices with dev->power.disable_depth greater than 0
> > > > (except for the special case in the suspend code path where we know
> > > > why it is greater than 0).  I think it was useful. :-)
> > >
> > So what's the exact state of device if dev->power.is_suspended flag is set
> > and runtime_status is RPM_ACTIVE? Is it a state like "suspended but still can
> > be accessed"?

The real state of the device should be known to its driver at this point
anyway.  From the runtime PM perspectiver it is "active", because runtime PM
doesn't track system suspend operations.  From the system suspend sequence
standpoint it is "suspended", but that only means that its system resume
callbacks should be run for it before completing the sequence.

The PM core doesn't have a common device status notion valid for both runtime
PM and the system suspend/resume frameworks at the same time.  Perhaps it would
be useful to add something like that to the PM core, but it hasn't been clearly
demonstrated so far.

> > >
> > I'm just afraid the existing code would cause a device hang if we allow it to
> > be accessed even though it's suspended (at this point RPM_ACTIVE could be

That depends on what "we" means here.  The driver/bus type are responsible for
maintaining the correct state of the device.

> > meaningless). I don't understand the original motivation of these code. If it's
> > a valid case, most likely it should be handled in the specific device driver
> > instead of the PM core.

You may be right here (please follow the Alan's discussion with Kevin).

[cut]

> > >
> > > As Rafael mentioned above that runtime_sataus is not meaningful if
> > > runtime PM is disabled, so shouldn't we avoid using the runtime_staus
> > > here and instead use
> > > dev->power.is_suspended only to decide the return value?
> > 
> > No, we shouldn't.
> > 
> > This is a special case. If dev->power.disable_depth == 1 and dev-
> > >power.is_suspended is set at the same time, we know for a fact that
> > runtime PM was only disabled by the system suspend code path and it was
> > enabled otherwise, so dev->power.runtime_status equal to RPM_ACTIVE is
> > actually meaningful in that particular case.
> 
> I'm still confused about the state of device if dev->power.is_suspended flag is set
> and runtime_status is RPM_ACTIVE. Is it a state like "suspended but still can
> be accessed"?

Please see above.

That basically is for drivers that want to run pm_runtime_get_sync() from their
late suspend or early resume system suspend callbacks and don't want to worry
about the return value of that.  It may be argued that this is a hack, but
then it is a somewhat useful one. :-)

> > 
> > > @@ -608,11 +608,13 @@ static int rpm_resume(struct device *dev, int
> > rpmflags)
> > >   repeat:
> > >         if (dev->power.runtime_error)
> > >                 retval = -EINVAL;
> > > -       else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> > > -           && dev->power.runtime_status == RPM_ACTIVE)
> > > -               retval = 1;
> > > -       else if (dev->power.disable_depth > 0)
> > > -               retval = -EACCES;
> > > +       else if (dev->power.disable_depth > 0) {
> > > +               if (!dev->power.is_suspended)
> > > +                       retval = 1;
> > > +               else
> > > +                       retval = -EACCES;
> > > +       }
> > > +
> > >         if (retval)
> > >                 goto out;
> > >
> > > However, this requires us to make sure device is in full functional
> > > state if it's not suspended before disabling runtime PM, just like the
> > > case runtime PM is not configured at all.
> > 
> > If runtime PM is not configured at all, the device has to be in full functional
> > state (from the PM perspective) outside of the system suspend-resume
> > sequence.
> 
> So before disabling runtime PM of a device, caller need to make it full
> functional as long as  it's outside of system suspend-resume sequence (or
> to be more specific, is_suspended flag is not set)?

No, it doesn't need to do that.  Runtime PM disabled means "don't execute
runtime PM callbacks for this device".  It has nothing to do with the
device's state.  However, *before* enabling runtime PM for the device
again the caller must ensure that runtime_status is appropriate.

And the runtime PM status only means which runtime PM callback has been
executed for the device most recently, which information is only useful to
the PM core if it is *allowed* to execute runtime PM callbacks for that
device.

> - This is in fact what my comment above meant.
> If this is true,

It isn't.

> can't we just return 1 in
> case dev->power.disable_depth > 0 && dev->power.is_suspended == false?

Why do we need to check dev->power.is_suspended here at all, then?

> - This is in fact what the code above meant to do.
> This should work for both pm_runtime_resume() and pm_runtime_get() then.

What's the use case?  I don't see it, honestly.

That seems to be another instance of "I don't need to track the state of
the device in the driver, because the PM core does that for me" thinking,
which isn't correct, because the PM core doesn't do that.

Can you please accept the fact that runtime PM and system suspend/resume
are different frameworks and drivers need to do some work to coordinate
between them?  And they should not use the PM core's internal data structures
for that, because those data structures are not suitable for this purpose
in many cases?

Yes, we need to integrate runtime PM with system suspend/resume more tightly,
but not by making ad hoc changes to the PM core. 

Rafael

