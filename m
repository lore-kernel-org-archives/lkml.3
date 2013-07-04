Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3GDM01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:26:27 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49066 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3GDM0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:25 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 00/14] Platform Framebuffers and SimpleDRM
Date: Thu,  4 Jul 2013 14:25:00 +0200
Message-Id: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This series changes the way we handle firmware framebuffers on x86 systems. On
other architectures the recently introduced "simple-framebuffer"
platform-devices provide a sane and proper way to handle firmware framebuffers.
So why not use it on x86, too?

This series adds x86 setup code to create proper platform-devices for firmware
framebuffers. For backwards compatibility, efi-fb, vesa-fb and platform-fb
devices are created and vesafb.c, efifb.c bind to the right device. We no
longer have vesafb and efifb load unconditionally on "screen_info".
If a fw-FB is compatible to "simple-framebuffer" devices, we create these
instead. We can then use the generic arch-independent simplefb.c on x86 without
any vesafb/efifb conflicts.

Last but not least, the series introduces SimpleDRM, which is basically simplefb
but as DRM driver with all the usual benefits. SimpleDRM is also the motivation
behind this series, but probably only of interest for the dri-devel
mailing-list.

* Patches 1 & 2 modify simplefb.c to accept framebuffer information via plain
  old platform_data and allow real hw drivers to remove simplefb on conflicts.

* Patches 3 & 4 add x86 setup code to create the right platform-device for any
  found firmware framebuffer.

* Patches 5 - 7 modify simplefb.c, vesafb.c, efifb.c to use these new devices
  and support common x86 formats.

* Patch 8 fixes fbcon to require console binding to avoid crashes during
  framebuffer hotplugging

* Patches 9-14: Introduce SimpleDRM

Changes in v2:
 - We now provide efi-framebuffer, vesa-framebuffer or platform-framebuffer
   legacy devices instead of just platform-framebuffer devs. This allows to
   load vesafb, efifb, .. simultaneously instead of only one driver.
 - vesafb and efifb now use the new platform devices
 - simplefb can now be unloaded via remove_conflicting_framebuffers()
 - efifb EFI quirks now moved to x86 setup
 - refactored x86 setup code to avoid #ifdefs
 - Many small fixes (thanks to Stephen and Andy)
 - Adjusted i915 and radeon to use new drm_kick_out_firmware()
 - fbcon now works with SimpleDRM (fixed the palette handling and def-flags)
 - fbdev unloading fixed (Patch #8)

Open issues:
 - How does static platform-device creation conflict with OF support on x86?
   If we want to support "simple-framebuffer" devices via OF, we currently
   require screen_info...isVGA to be 0 so sysfb.c does nothing. Is that
   guaranteed?
 - Should we try to move the offb.c DT parser to sysfb.c, too, so we can
   convert these devices to simple-framebuffers?
 - How can we integrate vga16fb.c into this? Bind to "platform-framebuffer"?
 - Is there any other generic driver that we might want to check? I haven't
   found more (except uvesafb, which always was separate, anyway).
 - What FB formats are common on x86 that we should add to SIMPLEFB_FORMATS?
   (other than ARGB/XRGB32)
 - Should we move default_vga detection from efifb.c to sysfb_efi.c, too? We
   could make the DMI table __init then.

I tested this (including DRM handover) with vesafb, efifb and simpledrm. It all
worked well without problems. More testing is highly welcome! Also feel free
to pickup individual fixes which don't directly depend on the series (eg. #1,
 #2, #7, #8).

Comments welcome!
Cheers
David

David Herrmann (14):
  fbdev: simplefb: add init through platform_data
  fbdev: simplefb: mark as fw and allocate apertures
  x86: provide platform-devices for boot-framebuffers
  x86: sysfb: move EFI quirks from efifb to sysfb
  fbdev: simplefb: add 32bit RGB formats
  fbdev: vesafb: bind to platform-framebuffer device
  fbdev: efifb: bind to efi-framebuffer
  fbdev: fbcon: select VT_HW_CONSOLE_BINDING
  drm: add SimpleDRM driver
  drm: simpledrm: add fbdev fallback support
  drm: add helpers to kick out firmware drivers
  drm: nouveau: kick out firmware drivers during probe
  drm/i915: use new drm_kick_out_firmware()
  drm/radeon: use new drm_kick_out_firmware()

 MAINTAINERS                                 |   8 +
 arch/x86/Kconfig                            |  26 ++
 arch/x86/include/asm/sysfb.h                |  98 ++++++++
 arch/x86/kernel/Makefile                    |   3 +
 arch/x86/kernel/sysfb.c                     |  74 ++++++
 arch/x86/kernel/sysfb_efi.c                 | 214 ++++++++++++++++
 arch/x86/kernel/sysfb_simplefb.c            |  95 ++++++++
 drivers/gpu/drm/Kconfig                     |   2 +
 drivers/gpu/drm/Makefile                    |   1 +
 drivers/gpu/drm/drm_pci.c                   |   1 +
 drivers/gpu/drm/drm_platform.c              |   1 +
 drivers/gpu/drm/drm_stub.c                  | 118 +++++++++
 drivers/gpu/drm/drm_usb.c                   |   1 +
 drivers/gpu/drm/i915/i915_dma.c             |   6 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c       |  29 ++-
 drivers/gpu/drm/radeon/radeon_drv.c         |  28 ---
 drivers/gpu/drm/radeon/radeon_kms.c         |  30 +++
 drivers/gpu/drm/simpledrm/Kconfig           |  29 +++
 drivers/gpu/drm/simpledrm/Makefile          |   6 +
 drivers/gpu/drm/simpledrm/simpledrm.h       | 112 +++++++++
 drivers/gpu/drm/simpledrm/simpledrm_drv.c   | 227 +++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c | 153 ++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_main.c  | 363 ++++++++++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_mem.c   | 252 +++++++++++++++++++
 drivers/video/Kconfig                       |   5 +-
 drivers/video/console/Kconfig               |   3 +-
 drivers/video/efifb.c                       | 302 +++--------------------
 drivers/video/simplefb.c                    |  58 +++--
 drivers/video/vesafb.c                      |  55 ++---
 include/drm/drmP.h                          |  26 ++
 include/linux/platform_data/simplefb.h      |  58 +++++
 31 files changed, 2016 insertions(+), 368 deletions(-)
 create mode 100644 arch/x86/include/asm/sysfb.h
 create mode 100644 arch/x86/kernel/sysfb.c
 create mode 100644 arch/x86/kernel/sysfb_efi.c
 create mode 100644 arch/x86/kernel/sysfb_simplefb.c
 create mode 100644 drivers/gpu/drm/simpledrm/Kconfig
 create mode 100644 drivers/gpu/drm/simpledrm/Makefile
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm.h
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_drv.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_main.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_mem.c
 create mode 100644 include/linux/platform_data/simplefb.h

-- 
1.8.3.2

