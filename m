Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3G2WBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:01:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46550 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab3G2WBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:01:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: * =?ISO-8859-1?Q?SAM=CD?= * <miaousami@hotmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aaron Lu <aaron.lu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [Intel-gfx] Linux 3.11-rc2 [backlight] [ASUS N56VZ]
Date: Tue, 30 Jul 2013 00:11:44 +0200
Message-ID: <2885333.INd1NEtEGR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <BLU0-SMTP140D7F45ED3DD21F0C0ECE3A6550@phx.gbl>
References: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl> <1472278.oeeviaMfXH@vostro.rjw.lan> <BLU0-SMTP140D7F45ED3DD21F0C0ECE3A6550@phx.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 11:53:59 PM * SAMÍ * wrote:
> When I make acpi_video_backlight_quirks() return false:
> - the Fn+x keys are not working anymore (remember that they didn't work 
> in 3.10 nor 3.9)
> - At least the backlight remains on at boot.
> - Gnome brightness settings do not work anymore. Neither do xbacklight.
> - Writing to /sys/class/backlight/intel_backlight/brightness works

Well, you're better off with acpi_video_backlight_quirks() as is, then. :-)

I'm afraid we can't help you by revering anything more at this point.

Please file a bug in the kernel BZ to further track the issues you're
seeing.

Thanks,
Rafael


> On 07/29/2013 10:03 PM, Rafael J. Wysocki wrote:
> > On Monday, July 29, 2013 09:36:31 PM * SAMÍ * wrote:
> >> Hi Rafael,
> >>
> >>
> >> did you commit a full revert?
> > Yes, but I left acpi_video_backlight_quirks() (in drivers/acpi/video_detect.c)
> > that is used to decide what to do with _DOS.
> >
> > Can you please check if making that function always return 'false' makes any
> > difference?
> >
> > Rafael
> >
> >
> >> Because I am experiencing quite weird things in rc3.
> >> Do we have a bug opened to discuss about it?
> >>
> >> Here is what I can observe:
> >> 1) During boot, probably when loading the driver, backlight gets off (or
> >> to a level low enough to make me feel it is off)
> >> 2) When I am playing with my Fn+x keys, I am getting a completely full /
> >> completely low brightness with no intermediate steps
> >> 3) When I am playing with my Fn+x keys while gnome brightness settings
> >> panel is open, I am recovering intermediate steps but the Fn+x keys
> >> behavior is inverted (the key supposed to lower the brightness make it
> >> increase and vice-versa. Note that the gnome brightness indicator also
> >> gets inverted).
> >> 4) Playing with the mouse on gnome brightness settings is working,
> >> except that on the minimum level, backlight gets off
> >> 5) Writing to /sys/class/backlight/intel_backlight/brightness works
> >>
> >>
> >> Regards
> >>
> >> On 07/25/2013 02:57 PM, Rafael J. Wysocki wrote:
> >>> On Thursday, July 25, 2013 03:34:10 PM Jani Nikula wrote:
> >>>> On Thu, 25 Jul 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >>>>> On Thursday, July 25, 2013 11:09:27 AM Jani Nikula wrote:
> >>>>>> On Thu, 25 Jul 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >>>>>>> Well, I wonder what about the appended (untested) patch?
> >>>>>> Rafael, before going there, I've been trying to wrap my (poor, rusty
> >>>>>> after vacation) head around
> >>>>>>
> >>>>>> commit 8c5bd7adb2ce47e6aa39d17b2375f69b0c0aa255
> >>>>>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>>>> Date:   Thu Jul 18 02:08:06 2013 +0200
> >>>>>>
> >>>>>>       ACPI / video / i915: No ACPI backlight if firmware expects Windows 8
> >>>>>>
> >>>>>> and I can't see how it could work.
> >>>>> Well, if it didn't work, people wouldn't see either improvement or breakage
> >>>>> from it, but they do see that, so it evidently works. :-)
> >>>> I didn't claim it didn't work, just that *I* didn't see how it could. ;)
> >>>>
> >>>>>> First, the ACPI_VIDEO_SKIP_BACKLIGHT flag seems to be checked before
> >>>>>> it's actually set anywhere.
> >>>>> Are you sure about that?
> >>>>>
> >>>>> acpi_video_bus_add() is the .add() callback routine for acpi_video_bus which
> >>>>> in fact is an ACPI driver (the naming sucks, but I didn't invent it).  This
> >>>>> means that acpi_video_bus_add() can only be called *after* acpi_video_bus
> >>>>> has been registered with the ACPI subsystem (and the driver core).  That
> >>>>> is done by acpi_bus_register_driver() and, guess what?, this happens in
> >>>>> __acpi_video_register().  So clearly, acpi_video_bus_add() *cannot* run before
> >>>>> __acpi_video_register().
> >>>> Right. I totally missed the call within the ternary operator. Thanks for
> >>>> the explanation, and apologies for the noise.
> >>>>
> >>>>>> Second, with i915 that has opregion support, __acpi_video_register()
> >>>>>> should only ever get called once. Which means the acpi_walk_namespace()
> >>>>>> with video_unregister_backlight() should never get called in register.
> >>>>>>
> >>>>>> Please enlighten me.
> >>>>> Actually, that's correct, so we don't need the whole
> >>>>> video_unregister_backlight() thing, calling acpi_video_backlight_quirks() would
> >>>>> be sufficient.
> >>>>>
> >>>>> Ah, one more reason to do a full revert.  I'm thinking, though, that I'll leave
> >>>>> acpi_video_backlight_quirks() as is so that it can be used by
> >>>>> acpi_video_bus_(start)|(stop)_devices(), because that doesn't seem to cause
> >>>>> problems to happen.
> >>>> I observe that for the regular non-quirk acpi_video_register() call,
> >>>> acpi_video_backlight_quirks() won't be called during register, but it
> >>>> will get called later. This might have subtle effects later on, don't
> >>>> you think?
> >>> Yes, it might, but after dropping ACPI_VIDEO_SKIP_BACKLIGHT it should be OK.
> >>>
> >>>> As to the original problem, and your patch in this thread, what do you
> >>>> think about having another value in acpi_backlight kernel parameter for
> >>>> it? Having an i915 module parameter to tell acpi to use or not use
> >>>> quirks seems odd, since the i915 is not really taking over
> >>>> anything. It's just passing the info on to acpi.
> >>> I agree, I'm going to send a full revert in a while and we'll think what to
> >>> do about all that later.
> >>>
> >>> Thanks,
> >>> Rafael
> >>>
> >>>
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
