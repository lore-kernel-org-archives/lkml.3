Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3IJFYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:24:00 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41062 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3IJFX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:23:57 -0400
Message-ID: <1378790631.2160.3.camel@ThinkPad-X230.localdomain>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date: Tue, 10 Sep 2013 09:23:51 +0400
In-Reply-To: <522D89EC.6050103@intel.com>
References: <522D88C3.7000808@intel.com> <522D89EC.6050103@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2013-09-09 at 16:42 +0800, Aaron Lu wrote:
> According to Matthew Garrett, "Windows 8 leaves backlight control up
> to individual graphics drivers rather than making ACPI calls itself.
> There's plenty of evidence to suggest that the Intel driver for
> Windows [8] doesn't use the ACPI interface, including the fact that
> it's broken on a bunch of machines when the OS claims to support
> Windows 8.  The simplest thing to do appears to be to disable the
> ACPI backlight interface on these systems".
> 
> There's a problem with that approach, however, because simply
> avoiding to register the ACPI backlight interface if the firmware
> calls _OSI for Windows 8 may not work in the following situations:
>  (1) The ACPI backlight interface actually works on the given system
>      and the i915 driver is not loaded (e.g. another graphics driver
>      is used).
>  (2) The ACPI backlight interface doesn't work on the given system,
>      but there is a vendor platform driver that will register its
>      own, equally broken, backlight interface if not prevented from
>      doing so by the ACPI subsystem.
> Therefore we need to allow the ACPI backlight interface to be
> registered until the i915 driver is loaded which then will unregister
> it if the firmware has called _OSI for Windows 8 (or will register
> the ACPI video driver without backlight support if not already
> present).
> 
> For this reason, introduce an alternative function for registering
> ACPI video, __acpi_video_register(bool), that if ture is passed,
> will check whether or not the ACPI video driver has already been
> registered and whether or not the backlight Windows 8 quirk has to
> be applied. If the quirk has to be applied, it will block the ACPI
> backlight support and either unregister the backlight interface if
> the ACPI video driver has already been registered, or register the
> ACPI video driver without the backlight interface otherwise.  Make
> the i915 driver use __acpi_video_register() instead of
> acpi_video_register() in i915_driver_load(), and the param passed
> there is controlled by the i915 module level parameter
> i915_take_over_backlight, which is set to false by default.
> 
> This change is evolved from earlier patches of Matthew Garrett,
> Chun-Yi Lee and Seth Forshee and is heavily based on two patches
> from Rafael:
> https://lkml.org/lkml/2013/7/17/720
> https://lkml.org/lkml/2013/7/24/806
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> ---
>  drivers/acpi/internal.h         |  2 ++
>  drivers/acpi/video.c            | 24 ++++++++++++++++--------
>  drivers/acpi/video_detect.c     | 15 ++++++++++++++-
>  drivers/gpu/drm/i915/i915_dma.c |  2 +-
>  drivers/gpu/drm/i915/i915_drv.c |  5 +++++
>  drivers/gpu/drm/i915/i915_drv.h |  1 +
>  include/acpi/video.h            |  9 +++++++--
>  include/linux/acpi.h            |  1 +
>  8 files changed, 47 insertions(+), 12 deletions(-)

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.11.0-3.fc20.x86_64

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.11.0-1.fc20.x86_64

