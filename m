Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaIJPyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:54:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57410 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaIJPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:54:51 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 0/4] Linking DRM Connectors to Backlight Devices
Date: Wed, 10 Sep 2014 17:54:19 +0200
Message-Id: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This series introduces a link between DRM connectors and backlight-class
devices. It tries to solve some long standing issues:

 * User-space currently has a hard-time figuring out which backlight device to
   use, and which backlight device belongs to which display. So far, most
   systems only provide backlight-devices for internal displays, so figuring out
   the connection is easy, but that might change with more capable external
   connectors.
   If multiple backlights are available, the easiest solution is to simply write
   to all of them and hope at least one of them works. This obviously fails if
   the devices interact badly, so it's not really a solution.

 * User-space needs root privileges to write to sysfs. There are no char-devs
   that can be used to control access-management to the backlight API, so /sys
   is the only interface available. So far, udev policy has been "/sys is
   read-only for non-root" and it's not going to change. char-devs are *THE*
   standard way to provide non-root user-space APIs, so use them!

Several solutions have been discussed so far, but we never agreed on one. I'm
aware of at least the following solutions:

 * Provide char-devs for backlight devices and a sysfs link from connectors to
   backlight devices. This way, user-space can managed access to char-devs *and*
   get proper topology information.
   However, this might be an n:m relationship (n:1 for displays exposed as
   multiple connectors, 1:m for boards with multiple backlights? whatever..) and
   it sounds like a waste of resources to add char-devs just to write brightness
   values.

 * Do everything in privileged user-space. One daemon that provides an
   unprivileged-API and forwards writes to /sys. It reads topology information
   from udev hwdb.
   This circumvents the ugly sysfs API and not really solves the problem. It
   should work, though ugly.

 * Add a DRM connector property that takes brightness values.
   This is the nicest solution for user-space, but introduces a whole lot of
   issues on the kernel side. There already is a backlight-class and we had a
   hard-time trying to move it into DRM drivers, so no-one ever did the work.

This series tries to solve this problem with a much simpler approach:
Instead of moving backlights into DRM, we simply link DRM properties to a
backlight device. That is, the kernel manages a link between a connector and a
backlight device (or n backlight devices) which can be modified by udev in case
the kernel got it wrong (we don't want huge board-fixup-tables in the kernel).
User-space can now use the simpl DRM API to manage backlights, and the kernel
does not need any special driver code to make it work.

Patch #1 and #2 are cleanups and can be applied right away. #3 adds in-kernel
backlight APIs and #4 implements the connector-backlight link.

Comments welcome!
David

David Herrmann (4):
  backlight: use static initializers
  backlight: use spin-lock to protect device list
  backlight: add kernel-internal backlight API
  drm: link connectors to backlight devices

 drivers/gpu/drm/Kconfig             |   1 +
 drivers/gpu/drm/Makefile            |   2 +-
 drivers/gpu/drm/drm_backlight.c     | 387 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_crtc.c          |  45 +++--
 drivers/gpu/drm/drm_drv.c           |  11 +
 drivers/gpu/drm/drm_sysfs.c         |  53 +++++
 drivers/video/backlight/backlight.c |  91 +++++++--
 include/drm/drm_backlight.h         |  44 ++++
 include/drm/drm_crtc.h              |   3 +
 include/linux/backlight.h           |  17 ++
 10 files changed, 622 insertions(+), 32 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_backlight.c
 create mode 100644 include/drm/drm_backlight.h

-- 
2.1.0

