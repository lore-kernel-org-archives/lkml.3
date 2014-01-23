Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaAWOPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:15:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52068 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaAWOPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:15:47 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 00/11] SimpleDRM & Sysfb
Date: Thu, 23 Jan 2014 15:14:52 +0100
Message-Id: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Another round of SimpleDRM patches. I somehow lost track of the last ones and as
this is a major rewrite, I'll just start at v1 again.

Some comments up-front:

 - @Ingo: Patch #1 and #2 are unchanged from the previous ML discussions. I
   included them in this series as the other patches depend on them. Could you
   pick them up for the x86 tree? The other 9 patches won't make it in 3.14 so
   no reason to put them through the DRM tree.
   All mentioned issues should be addressed. If there's still sth missing,
   please let me know.

 - The DRM patches depend on my "DRM Anonymous Inode" patches. But it should be
   trivial to apply them on drm-next (I think only one line needs to be changed:
   i_mapping => dev_mapping).

 - I tested the SimpleDRM fbdev fallback with linux-console+Xorg and it works
   fine. The DRM backend is only tested with some DRM tests I have locally. I
   have no idea how to make Xorg pick up a specific /dev/dri/card0 card. It
   always tells me "no screens found" (as the underlying device is not marked as
   boot_vga..). If someone knows how to tell Xorg to use card0, I'd gladly test
   this. But I'm no longer used to writing xorg.confs..


This series introduces two new concepts: sysfb and SimpleDRM
Sysfb is just a generalization of the x86-sysfb concept. It allows to register
firmware-framebuffers with the system as platform-devices. This way, drivers can
properly bind to these devices and we prevent multiple drivers from accessing
the same firmware-framebuffer.
Sysfb also provides hooks to get a safe handover to real hw-drivers (like i915).
Please see the "video: sysfb: add generic firmware-fb interface" patch for a
thorough description of the API. This patch also adds a rather verbose
documentation of all known firmware-fb facilities.

As second part, this series introduces SimpleDRM. It's a very basic DRM driver
that can replace efifb, vesafb, simplefb and friends. It's 100% compatible to
the "udl" DRM driver, so user-space like xf86-video-modesetting can pick them up
just fine. User-space that cannot deal with drmModeDirtyFB() (like weston and
friends) currently cannot use SimpleDRM. However, that's also true for all other
DRM drivers which provide shadow framebuffers. We could provide something like
FB-DEFIO, but that's just useless overhead to paper of lazy user-space.

I have tested this with all hardware that I have at home, with a lot hand-over
combinations (with/without SYSFB, with efifb/vesafb/simplefb, with SimpleDRM,
...) and all worked great so far.

Comments welcome!
David

David Herrmann (11):
  x86: sysfb: fool-proof CONFIG_X86_SYSFB
  x86: sysfb: remove sysfb when probing real hw
  fbdev: efifb: add dev->remove() callback
  fbdev: vesafb: add dev->remove() callback
  x86: sysfb: store apertures in simplefb platform-data
  video: sysfb: add generic firmware-fb interface
  drm: mgag200: remove redundant fbdev removal
  drm/i915: remove sysfbs early
  drm: add SimpleDRM driver
  drm: simpledrm: add fbdev fallback support
  x86/sysfb: allow sysfb+simpledrm combination

 Documentation/firmware-fbs.txt               | 236 +++++++++++++++++
 MAINTAINERS                                  |   8 +
 arch/x86/Kconfig                             |   2 +
 arch/x86/include/asm/sysfb.h                 |   6 +-
 arch/x86/kernel/sysfb.c                      |   3 +-
 arch/x86/kernel/sysfb_simplefb.c             |  97 ++++---
 drivers/gpu/drm/Kconfig                      |   2 +
 drivers/gpu/drm/Makefile                     |   1 +
 drivers/gpu/drm/i915/i915_drv.c              |   6 +
 drivers/gpu/drm/mgag200/mgag200_main.c       |   9 -
 drivers/gpu/drm/simpledrm/Kconfig            |  29 +++
 drivers/gpu/drm/simpledrm/Makefile           |   4 +
 drivers/gpu/drm/simpledrm/simpledrm.c        | 263 +++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm.h        | 122 +++++++++
 drivers/gpu/drm/simpledrm/simpledrm_damage.c | 306 ++++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c  | 148 +++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_gem.c    | 282 +++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_kms.c    | 365 +++++++++++++++++++++++++++
 drivers/video/Kconfig                        |   3 +
 drivers/video/Makefile                       |   1 +
 drivers/video/efifb.c                        |  13 +-
 drivers/video/fbmem.c                        |  17 +-
 drivers/video/simplefb.c                     |   8 -
 drivers/video/sysfb.c                        | 348 +++++++++++++++++++++++++
 drivers/video/vesafb.c                       |  13 +-
 include/linux/fb.h                           |   9 +-
 include/linux/platform_data/simplefb.h       |   2 +
 include/linux/sysfb.h                        |  62 +++++
 28 files changed, 2299 insertions(+), 66 deletions(-)
 create mode 100644 Documentation/firmware-fbs.txt
 create mode 100644 drivers/gpu/drm/simpledrm/Kconfig
 create mode 100644 drivers/gpu/drm/simpledrm/Makefile
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm.h
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_damage.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_gem.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_kms.c
 create mode 100644 drivers/video/sysfb.c
 create mode 100644 include/linux/sysfb.h

-- 
1.8.5.3

