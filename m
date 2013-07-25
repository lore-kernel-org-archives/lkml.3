Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3GYMcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:32:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:48732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab3GYMcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:32:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,743,1367996400"; 
   d="scan'208";a="351413142"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Aaron Lu <aaron.lu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        * =?utf-8?Q?SAM=C3=8D?= * <miaousami@hotmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [Intel-gfx] Linux 3.11-rc2 [backlight] [ASUS N56VZ]
In-Reply-To: <2024506.rXjN91yI0W@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl> <6051153.b6TE1dlrel@vostro.rjw.lan> <87hafjxdqg.fsf@intel.com> <2024506.rXjN91yI0W@vostro.rjw.lan>
User-Agent: Notmuch/0.15.2+227~g0ff681e (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 25 Jul 2013 15:34:10 +0300
Message-ID: <877ggeyg1p.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Thursday, July 25, 2013 11:09:27 AM Jani Nikula wrote:
>> On Thu, 25 Jul 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> > Well, I wonder what about the appended (untested) patch?
>> 
>> Rafael, before going there, I've been trying to wrap my (poor, rusty
>> after vacation) head around
>> 
>> commit 8c5bd7adb2ce47e6aa39d17b2375f69b0c0aa255
>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Date:   Thu Jul 18 02:08:06 2013 +0200
>> 
>>     ACPI / video / i915: No ACPI backlight if firmware expects Windows 8
>> 
>> and I can't see how it could work.
>
> Well, if it didn't work, people wouldn't see either improvement or breakage
> from it, but they do see that, so it evidently works. :-)

I didn't claim it didn't work, just that *I* didn't see how it could. ;)

>> First, the ACPI_VIDEO_SKIP_BACKLIGHT flag seems to be checked before
>> it's actually set anywhere.
>
> Are you sure about that?
>
> acpi_video_bus_add() is the .add() callback routine for acpi_video_bus which
> in fact is an ACPI driver (the naming sucks, but I didn't invent it).  This
> means that acpi_video_bus_add() can only be called *after* acpi_video_bus
> has been registered with the ACPI subsystem (and the driver core).  That
> is done by acpi_bus_register_driver() and, guess what?, this happens in
> __acpi_video_register().  So clearly, acpi_video_bus_add() *cannot* run before
> __acpi_video_register().

Right. I totally missed the call within the ternary operator. Thanks for
the explanation, and apologies for the noise.

>> Second, with i915 that has opregion support, __acpi_video_register()
>> should only ever get called once. Which means the acpi_walk_namespace()
>> with video_unregister_backlight() should never get called in register.
>> 
>> Please enlighten me.
>
> Actually, that's correct, so we don't need the whole
> video_unregister_backlight() thing, calling acpi_video_backlight_quirks() would
> be sufficient.
>
> Ah, one more reason to do a full revert.  I'm thinking, though, that I'll leave
> acpi_video_backlight_quirks() as is so that it can be used by
> acpi_video_bus_(start)|(stop)_devices(), because that doesn't seem to cause
> problems to happen.

I observe that for the regular non-quirk acpi_video_register() call,
acpi_video_backlight_quirks() won't be called during register, but it
will get called later. This might have subtle effects later on, don't
you think?

As to the original problem, and your patch in this thread, what do you
think about having another value in acpi_backlight kernel parameter for
it? Having an i915 module parameter to tell acpi to use or not use
quirks seems odd, since the i915 is not really taking over
anything. It's just passing the info on to acpi.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
