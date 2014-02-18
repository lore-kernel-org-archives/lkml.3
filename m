Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaBRNKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:10:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53631 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755484AbaBRNKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:10:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of suspended devices
Date: Tue, 18 Feb 2014 14:25:42 +0100
Message-ID: <1916955.HdCFyzXUXW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFps5hr0L9OzK-Lgfm4EWUdkaK_PLf8JWu15x-MQy3s2cQ@mail.gmail.com>
References: <5420830.W4laSGaAU9@vostro.rjw.lan> <21442757.ztmIxNHa8O@vostro.rjw.lan> <CAPDyKFps5hr0L9OzK-Lgfm4EWUdkaK_PLf8JWu15x-MQy3s2cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 01:59:36 PM Ulf Hansson wrote:
> On 17 February 2014 00:50, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> > resume all runtime-suspended devices during system suspend, mostly
> > because those devices may need to be reprogrammed due to different
> > wakeup settings for system sleep and for runtime PM.  However, at
> > least in some cases, that isn't really necessary, because the wakeup
> > settings may not be really different.
> >
> > The idea here is that subsystems should know whether or not it is
> > necessary to reprogram a given device during system suspend and they
> > should be able to tell the PM core about that.  For this reason,
> > modify the PM core so that if the .prepare() callback returns a
> > positive value for certain device, the core will set a new
> > power.fast_suspend flag for it.  Then, if that flag is set, the core
> > will skip all of the subsequent suspend callbacks for that device.
> > It also will skip all of the system resume callbacks for the device
> > during the subsequent system resume and pm_request_resume() will be
> > executed to trigger a runtime PM resume of the device after the
> > system device resume sequence has been finished.
> >
> > However, since parents may need to be resumed so that their children
> > can be reprogrammed, make the PM core clear power.fast_suspend for
> > devices whose children don't have power.fast_suspend set (the
> > power.ignore_children flag doesn't matter here, because a parent
> > whose children are normally ignored for runtime PM may still need to
> > be accessible for their children to be prepare for system suspend
> > properly).
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/base/power/main.c |   49 +++++++++++++++++++++++++++++++---------------
> >  include/linux/pm.h        |    1
> >  2 files changed, 35 insertions(+), 15 deletions(-)
> >
> > Index: linux-pm/drivers/base/power/main.c
> > ===================================================================
> > --- linux-pm.orig/drivers/base/power/main.c
> > +++ linux-pm/drivers/base/power/main.c
> > @@ -478,7 +478,7 @@ static int device_resume_noirq(struct de
> >         TRACE_DEVICE(dev);
> >         TRACE_RESUME(0);
> >
> > -       if (dev->power.syscore)
> > +       if (dev->power.syscore || dev->power.fast_suspend)
> >                 goto Out;
> >
> >         if (!dev->power.is_noirq_suspended)
> > @@ -599,7 +599,7 @@ static int device_resume_early(struct de
> >         TRACE_DEVICE(dev);
> >         TRACE_RESUME(0);
> >
> > -       if (dev->power.syscore)
> > +       if (dev->power.syscore || dev->power.fast_suspend)
> >                 goto Out;
> >
> >         if (!dev->power.is_late_suspended)
> > @@ -724,6 +724,11 @@ static int device_resume(struct device *
> >         if (dev->power.syscore)
> >                 goto Complete;
> >
> > +       if (dev->power.fast_suspend) {
> > +               pm_request_resume(dev);
> > +               goto Complete;
> 
> So, this will trigger an async request to runtime resume the device.
> 
> At device_complete(), we do pm_runtime_put() to return the reference
> we fetched at device_prepare(), thus likely causing the device to be
> runtime suspended again. Is that the expected sequence you need? Could
> you elaborate why?

That pm_runtime_put() will not cause the device to be re-suspended,
because it will be executed before the resume scheduled by the
pm_request_resume() above.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
