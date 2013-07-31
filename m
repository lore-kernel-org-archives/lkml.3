Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab3G3XvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:51:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48093 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab3G3Xu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:50:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <matthew.garrett@nebula.com>, daniel.vetter@ffwll.ch,
        Aaron Lu <aaron.lu@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>, "Lee, Chun-Yi" <jlee@suse.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [Update][PATCH 0/3] Fix backlight issues on some Windows 8 systems
Date: Wed, 31 Jul 2013 02:01:05 +0200
Message-ID: <3500424.KqMOhglylx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1448863.3slS729B6b@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1448863.3slS729B6b@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 18, 2013 02:16:09 AM Rafael J. Wysocki wrote:
> On Sunday, June 09, 2013 07:01:36 PM Matthew Garrett wrote:
> > Windows 8 introduced new policy for backlight control by pushing it out to
> > graphics drivers. This appears to have coincided with a range of vendors
> > adding Windows 8 checks to their backlight control code which trigger either
> > awkward behaviour (Lenovo) or complete brokenness (some Dells). The simplest
> > thing to do would be to just disable ACPI backlight control entirely if the
> > firmware indicates Windows 8 support, but it's entirely possible that
> > individual graphics drivers might still make use of the ACPI functionality in
> > preference to native control.
> > 
> > The first two patches in this series are picked from other patchesets aimed at
> > solving similar problems. The last simply unregisters ACPI backlight control
> > on Windows 8 systems when using an Intel GPU. Similar code could be added to
> > other drivers, but I'm reluctant to do so without further investigation as
> > to the behaviour of the vendor drivers under Windows.
> 
> Well, after some more time spent on that, we now have a series of 3 patches
> (different from the $subject one) that we think may be used to address this
> issue.  As far as I can say, it has been tested by multiple people whose
> systems have those problems and they generally saw improvement.
> 
> It is not my ideal approach, but it seems to be the least intrusive and/or
> with the least amount of possible side effects that we can do right now
> as a general measure (alternatively, we could create a possibly long
> blacklist table of affected systems with different workarounds for them,
> but let's just say that is not overwhelmingly attractive).
> 
> [1/3] Make ACPICA export things that we need for checking OSI(Win8).
> 
> [2/3] Make acpi_video_device_find_cap() call acpi_video_init_brightness() even
>       if it is not going to register the backlight interface (needed for
>       Thinkpads).
> 
> [3/3] Avoid using ACPI backlight if i915 is in use and the firmware believes
>       we are Windows 8.
> 
> Many thanks to everyone involved!

So this didn't work, as we had to revert [3/3], but I think we should try to
make some progress with this nevertheless.  A way forward I'm seeing now could
be to
(1) Split the ACPI video driver so that it is possible to register the
    backlight control separately from the event interface.
(2) Add a command line option to i915 to make it use the native backlight
    control (without registering the ACPI one) if set.  Make unset the
    default initially.
(3) Fix i915 backlight control issues for all systems known to have them
    (that may take a while) and flip the defailt for that option to set when we
    think we're ready.
(4) If there still are problem reports, flip the default back to unset and
    repeat (3).

If this converges, everyone will be using the native backlight control by
default and the original problem will go away automatically.

Thoughts?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
