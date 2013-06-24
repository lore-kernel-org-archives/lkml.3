Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab3FXW2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:28:12 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48810 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3FXW2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:28:10 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        linux-fbdev@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC 0/6] SimpleDRM Driver (was: dvbe driver)
Date: Tue, 25 Jun 2013 00:27:23 +0200
Message-Id: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is my second revision of the dvbe driver. I renamed it to SimpleDRM to
show the resemblence with the recently introduced simplefb.c fbdev driver. The
driver is supposed to be the most basic DRM driver similar to efifb.c, vesafb.c,
offb.c, simplefb.c, ...
It provides a single virtual CRTC+encoder+connector and allows user-space to
create one dumb-buffer at a time and attach it.

The setup changed slightly. It no longer uses shadow buffers but instead maps
the framebuffer directly into userspace. Furthermore, a new infrastructure is
used to unload firmware drivers during real hardware drivers probe cycles. Only
nouveau was changed to use it, yet.

I still have an odd problem when unloading DRM drivers (not just SimpleDRM) with
an fbdev fallback. If I call printk() directly after unregister_framebufer(), I
get a NULL-deref somewhere in the VT layer (most times hide_cursor()). I haven't
figured out exactly where that happens, but I am also very reluctant to spend
more time debugging the VT layer.

Anyhow, comments welcome. If someone wants to test it, you probably need to add
a line to ./include/linux/platform_data/simplefb.h and add the modeline of your
VESA/EFI framebuffer.

Cheers
David

David Herrmann (6):
  fbdev: simplefb: add init through platform_data
  x86: provide platform-devices for boot-framebuffers
  drm: add SimpleDRM driver
  drm: simpledrm: add fbdev fallback support
  drm: add helpers to kick out firmware drivers
  drm: nouveau: kick out firmware drivers during probe

 MAINTAINERS                                 |   8 +
 arch/x86/Kconfig                            |  18 ++
 arch/x86/kernel/Makefile                    |   1 +
 arch/x86/kernel/sysfb.c                     | 157 ++++++++++++
 drivers/gpu/drm/Kconfig                     |   2 +
 drivers/gpu/drm/Makefile                    |   1 +
 drivers/gpu/drm/drm_pci.c                   |   1 +
 drivers/gpu/drm/drm_platform.c              |   1 +
 drivers/gpu/drm/drm_stub.c                  | 107 ++++++++
 drivers/gpu/drm/drm_usb.c                   |   1 +
 drivers/gpu/drm/nouveau/nouveau_drm.c       |  29 ++-
 drivers/gpu/drm/simpledrm/Kconfig           |  29 +++
 drivers/gpu/drm/simpledrm/Makefile          |   9 +
 drivers/gpu/drm/simpledrm/simpledrm.h       | 114 +++++++++
 drivers/gpu/drm/simpledrm/simpledrm_drv.c   | 231 ++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c | 180 ++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_main.c  | 366 ++++++++++++++++++++++++++++
 drivers/gpu/drm/simpledrm/simpledrm_mem.c   | 254 +++++++++++++++++++
 drivers/video/Kconfig                       |   5 +-
 drivers/video/simplefb.c                    |  45 +++-
 include/drm/drmP.h                          |  26 ++
 include/linux/platform_data/simplefb.h      |  40 +++
 22 files changed, 1604 insertions(+), 21 deletions(-)
 create mode 100644 arch/x86/kernel/sysfb.c
 create mode 100644 drivers/gpu/drm/simpledrm/Kconfig
 create mode 100644 drivers/gpu/drm/simpledrm/Makefile
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm.h
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_drv.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_main.c
 create mode 100644 drivers/gpu/drm/simpledrm/simpledrm_mem.c
 create mode 100644 include/linux/platform_data/simplefb.h

-- 
1.8.3.1

