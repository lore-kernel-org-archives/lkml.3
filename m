Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3GYMrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:47:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39697 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab3GYMrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:47:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Aaron Lu <aaron.lu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        * =?ISO-8859-1?Q?SAM=CD?= * <miaousami@hotmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [Intel-gfx] Linux 3.11-rc2 [backlight] [ASUS N56VZ]
Date: Thu, 25 Jul 2013 14:57:52 +0200
Message-ID: <5730704.o2aLKRMvVz@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <877ggeyg1p.fsf@intel.com>
References: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl> <2024506.rXjN91yI0W@vostro.rjw.lan> <877ggeyg1p.fsf@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 03:34:10 PM Jani Nikula wrote:
> On Thu, 25 Jul 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > On Thursday, July 25, 2013 11:09:27 AM Jani Nikula wrote:
> >> On Thu, 25 Jul 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >> > Well, I wonder what about the appended (untested) patch?
> >> 
> >> Rafael, before going there, I've been trying to wrap my (poor, rusty
> >> after vacation) head around
> >> 
> >> commit 8c5bd7adb2ce47e6aa39d17b2375f69b0c0aa255
> >> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Date:   Thu Jul 18 02:08:06 2013 +0200
> >> 
> >>     ACPI / video / i915: No ACPI backlight if firmware expects Windows 8
> >> 
> >> and I can't see how it could work.
> >
> > Well, if it didn't work, people wouldn't see either improvement or breakage
> > from it, but they do see that, so it evidently works. :-)
> 
> I didn't claim it didn't work, just that *I* didn't see how it could. ;)
> 
> >> First, the ACPI_VIDEO_SKIP_BACKLIGHT flag seems to be checked before
> >> it's actually set anywhere.
> >
> > Are you sure about that?
> >
> > acpi_video_bus_add() is the .add() callback routine for acpi_video_bus which
> > in fact is an ACPI driver (the naming sucks, but I didn't invent it).  This
> > means that acpi_video_bus_add() can only be called *after* acpi_video_bus
> > has been registered with the ACPI subsystem (and the driver core).  That
> > is done by acpi_bus_register_driver() and, guess what?, this happens in
> > __acpi_video_register().  So clearly, acpi_video_bus_add() *cannot* run before
> > __acpi_video_register().
> 
> Right. I totally missed the call within the ternary operator. Thanks for
> the explanation, and apologies for the noise.
> 
> >> Second, with i915 that has opregion support, __acpi_video_register()
> >> should only ever get called once. Which means the acpi_walk_namespace()
> >> with video_unregister_backlight() should never get called in register.
> >> 
> >> Please enlighten me.
> >
> > Actually, that's correct, so we don't need the whole
> > video_unregister_backlight() thing, calling acpi_video_backlight_quirks() would
> > be sufficient.
> >
> > Ah, one more reason to do a full revert.  I'm thinking, though, that I'll leave
> > acpi_video_backlight_quirks() as is so that it can be used by
> > acpi_video_bus_(start)|(stop)_devices(), because that doesn't seem to cause
> > problems to happen.
> 
> I observe that for the regular non-quirk acpi_video_register() call,
> acpi_video_backlight_quirks() won't be called during register, but it
> will get called later. This might have subtle effects later on, don't
> you think?

Yes, it might, but after dropping ACPI_VIDEO_SKIP_BACKLIGHT it should be OK.

> As to the original problem, and your patch in this thread, what do you
> think about having another value in acpi_backlight kernel parameter for
> it? Having an i915 module parameter to tell acpi to use or not use
> quirks seems odd, since the i915 is not really taking over
> anything. It's just passing the info on to acpi.

I agree, I'm going to send a full revert in a while and we'll think what to
do about all that later.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
