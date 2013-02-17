Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab3BQR7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 12:59:52 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:55877 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3BQR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:59:50 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 0/9] System Framebuffer Bus (sysfb)
Date: Sun, 17 Feb 2013 18:59:02 +0100
Message-Id: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This series tries to fix the mess with global system framebuffer access in
device drivers. Currently, architecture initialization sets the "screen_info"
object according to the system framebuffer that was detected during boot. The
device driver that can map VMEM first gets access to it. There is no way to give
a specific driver access to the device and no _proper_ way to revoke access
again. In fact, some drivers don't even check whether they mapped the VMEM
successfully, letting multiple drivers to access the system framebuffer at the
same time.

This series introduces a new bus in patch #1. Global system framebuffers are
added as devices to this bus and drivers can register as bus drivers. Via sysfs
we can now bind/unbind the drivers. This guarantees that only one driver has
access to a single system-framebuffer at a time. But we can also easily control
which driver gets loaded (and extend this logic at a central place if we want).

If a real hardware drivers gets loaded via another bus that actually provides
the system-framebuffer (like pci-bus), these drivers can use a special BUS
function to claim the system framebuffer and unload all other drivers from this
device. This can be used by _real_ DRM drivers that want to kill all other
generic framebuffer drivers.

This series adds a SYSFB_VBE (VESA/VBE) framebuffer type as example, but the bus
can be used with any other system-framebuffer type. Any other architecture can
add their own type like SYSFB_VBE. Patch #3 is currently a HACK to provide the
VBE framebuffer on all architectures. However, the platform-device for
system-framebuffers should instead be provided by architecture code.


Why a new BUS type?
We need a way to allow transition from a generic driver to a real hardware
driver (like most DRM drivers or special fbdev drivers). We could implement this
logic separately, but the BUS driver-core code is available, anyway. So lets use
it and save a lot of .text space.
Additionally, we get some extra features like driver binding/unbinding via sysfs
for free (which is really handy for debugging).
The new bus is actually implemented in <200 lines of code. I don't think we can
get a smaller implementation when not using the bus-core code.


Patch #4 fixes vesafb.c to be hotplug-capable. It doesn't depend on this new bus
so it would be nice if it could get applied right away. It allows vesafb to be
compiled as a module.

Patch #5 makes vesafb.c register as new bus driver on the system-framebuffer
bus.

Patch #6-#9 introduce DVBE. It's a DRM driver based on VBE/VESA. It also uses
the new system-framebuffer bus and provides merely the same functionality as
vesafb.c but with a sane user-space API and without any fbdev dependency.


What needs to be done?
All drivers that use screen_info currently don't _have_ to be converted to the
new bus as the request_memory() calls protect the drivers from interfering. So
this new bus works even if no other driver gets converted. However, we really
_should_ convert the drivers. I will do that if a maintainer agrees to take the
bus code through their tree. But I hope to avoid converting all drivers if no
maintainer thinks this bus is a good idea.
The DVBE and vesafb drivers show how it is done.

I also like to see the system-framebuffer platform-devices being registered
during architecture initialization. I haven't worked much there so any comments
are welcome. Otherwise, I will keep the HACK to add the devices during sysfb
module-init.


Regards
David

David Herrmann (9):
  video: introduce system framebuffer bus
  video: sysfb: new vbefb device type
  video: sysfb: always provide vbefb device
  video: vesafb: allow building as module
  video: vesafb: use sysfb bus
  drm: new sysfb DRM bus module
  drm: new VESA BIOS Extension DRM driver stub
  drm: dvbe: implement VBE/VESA blitting backend
  drm: dvbe: add optional fbdev frontend

 drivers/gpu/drm/Kconfig           |   7 +
 drivers/gpu/drm/Makefile          |   2 +
 drivers/gpu/drm/drm_sysfb.c       | 145 +++++++++++++
 drivers/gpu/drm/dvbe/Kconfig      |  47 +++++
 drivers/gpu/drm/dvbe/Makefile     |   5 +
 drivers/gpu/drm/dvbe/dvbe.h       | 121 +++++++++++
 drivers/gpu/drm/dvbe/dvbe_drv.c   | 104 +++++++++
 drivers/gpu/drm/dvbe/dvbe_fbdev.c | 235 +++++++++++++++++++++
 drivers/gpu/drm/dvbe/dvbe_main.c  | 432 ++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/dvbe/dvbe_mem.c   | 269 ++++++++++++++++++++++++
 drivers/gpu/drm/dvbe/dvbe_vesa.c  | 263 +++++++++++++++++++++++
 drivers/video/Kconfig             |  20 +-
 drivers/video/Makefile            |   1 +
 drivers/video/sysfb.c             | 315 +++++++++++++++++++++++++++
 drivers/video/vesafb.c            | 105 ++++-----
 include/drm/drmP.h                |   4 +
 include/drm/drm_sysfb.h           |  35 +++
 include/linux/sysfb.h             | 137 ++++++++++++
 18 files changed, 2197 insertions(+), 50 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_sysfb.c
 create mode 100644 drivers/gpu/drm/dvbe/Kconfig
 create mode 100644 drivers/gpu/drm/dvbe/Makefile
 create mode 100644 drivers/gpu/drm/dvbe/dvbe.h
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_drv.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_fbdev.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_main.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_mem.c
 create mode 100644 drivers/gpu/drm/dvbe/dvbe_vesa.c
 create mode 100644 drivers/video/sysfb.c
 create mode 100644 include/drm/drm_sysfb.h
 create mode 100644 include/linux/sysfb.h

-- 
1.8.1.3

