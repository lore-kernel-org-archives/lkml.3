Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3GUAMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 20:12:12 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57218 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab3GUAML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 20:12:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org
Subject: [GIT PULL] ACPI video support fixes for v3.11
Date: Sun, 21 Jul 2013 02:22:09 +0200
Message-ID: <32735792.sAmhGYT8HA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-video-3.11

to receive fixes for some problems related to ACPI backlight support and
Windows 8 compatibility with top-most commit
efaa14c7e981bdf8d3c8d39d3ed12bdc60faabb8

  ACPI / video: no automatic brightness changes by win8-compatible firmware

on top of commit ad81f0545ef01ea651886dddac4bef6cec930092

  Linux 3.11-rc1

I'm sending a separate pull request for this as it may be somewhat
controversial.  The breakage addressed here is not really new and the fixes may
not satisfy all users of the affected systems, but we've had so much back and
forth dance in this area over the last several weeks that I think it's time
to actually make some progress.

The source of the problem is that about a year ago we started to tell
BIOSes that we're compatible with Windows 8, which we really need to do,
because some systems shipping with Windows 8 are tested with it and
nothing else, so if we tell their BIOSes that we aren't compatible with
Windows 8, we expose our users to untested BIOS/AML code paths.

However, as it turns out, some Windows 8-specific AML code paths are not
tested either, because Windows 8 actually doesn't use the ACPI methods
containing them, so if we declare Windows 8 compatibility and attempt to
use those ACPI methods, things break.  That occurs mostly in the
backlight support area where in particular the _BCM and _BQC methods are
plain unusable on some systems if the OS declares Windows 8 compatibility.
[The additional twist is that they actually become usable if the OS says
 it is not compatible with Windows 8, but that may cause problems to
 show up elsewhere.]

Investigation carried out by Matthew Garrett indicates that what Windows 8
does about backlight is to leave backlight control up to individual
graphics drivers.  At least there's evidence that it does that if the
Intel graphics driver is used, so we've decided to follow Windows 8 in
that respect and allow i915 to control backlight (Daniel likes that part).

The first commit from Aaron Lu makes ACPICA export the variable from
which we can infer whether or not the BIOS believes that we are compatible
with Windows 8.

The second commit from Matthew Garrett prepares the ACPI video driver
by making it initialize the ACPI backlight even if it is not going to be
used afterward (that is needed for backlight control to work on Thinkpads).

The third commit implements the actual workaround making i915 take over
bakclight control if the firmware thinks it's dealing with Windows 8
and is based on the work of multiple developers, including Matthew Garrett,
Chun-Yi Lee, Seth Forshee, and Aaron Lu.

The final commit from Aaron Lu makes us follow Windows 8 by informing
the firmware through the _DOS method that it should not carry out
automatic brightness changes, so that brightness can be controlled by
GUI.

Hopefully, this approach will allow us to avoid using blacklists
of systems that should not declare Windows 8 compatibility just to
avoid backlight control problems in the future.

Thanks!


---------------

Aaron Lu (2):
      ACPICA: expose OSI version
      ACPI / video: no automatic brightness changes by win8-compatible firmware

Matthew Garrett (1):
      ACPI / video: Always call acpi_video_init_brightness() on init

Rafael J. Wysocki (1):
      ACPI / video / i915: No ACPI backlight if firmware expects Windows 8

---------------

 drivers/acpi/acpica/aclocal.h   |   13 -------
 drivers/acpi/internal.h         |   11 ++++++
 drivers/acpi/video.c            |   90 ++++++++++++++++++++++++++++++++++++++++-------
 drivers/acpi/video_detect.c     |   21 +++++++++++
 drivers/gpu/drm/i915/i915_dma.c |    2 +-
 include/acpi/acpixf.h           |    1 +
 include/acpi/actypes.h          |   15 ++++++++
 include/acpi/video.h            |   11 +++++-
 include/linux/acpi.h            |    1 +
 9 files changed, 137 insertions(+), 28 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
