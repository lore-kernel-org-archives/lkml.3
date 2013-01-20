Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab3ATPcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:32:19 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64940 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3ATPcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:32:17 -0500
Date: Sun, 20 Jan 2013 16:32:09 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] kms locking rework
Message-ID: <20130120153209.GA2881@biers.ffwll.ch>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux biers 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I've figured a pull request is easier ;-)

Changes since the patchbomb on dri-devel:
- Added a patch to adjust the new omapdrm code in 3.8-rc4, reviewed by Rob
  Clark on irc (hence also why the baseline of this pull is 3.8-rc4).
- Slightly fixed/clarified some commit messages and fixed one spelling
  fail in a comment.
- Sprinkled Rob's r-b tags over the patches (for drm core changes +
  omapdrm).

Imo the individual patches contain really detailed commit messages, so for
the merge commit just a quick overview:

The aim of this locking rework is that ioctls which a compositor should be
might call for every frame (set_cursor, page_flip, addfb, rmfb and
getfb/create_handle) should not be able to block on kms background
activities like output detection. And since each EDID read takes about
25ms (in the best case), that always means we'll drop at least one frame.

The solution is to add per-crtc locking for these ioctls, and restrict
background activities to only use the global lock. Change-the-world type
of events (modeset, dpms, ...) need to grab all locks.

Two tricky parts arose in the conversion:
- A lot of current code assumes that a kms fb object can't disappear while
  holding the global lock, since the current code serializes fb
  destruction with it. Hence proper lifetime management using the already
  created refcounting for fbs need to be instantiated for all ioctls and
  interfaces/users.

- The rmfb ioctl removes the to-be-deleted fb from all active users. But
  unconditionally taking the global kms lock to do so introduces an
  unacceptable potential stall point. And obviously changing the userspace
  abi isn't on the table, either. Hence this conversion opportunistically
  checks whether the rmfb ioctl holds the very last reference, which
  guarantees that the fb isn't in active use on any crtc or plane (thanks
  to the conversion to the new lifetime rules using proper refcounting).
  Only if this is not the case will the code go through the slowpath and
  grab all modeset locks. Sane compositors will never hit this path and so
  avoid the stall, but userspace relying on these semantics will also not
  break.

All these cases are exercised by the newly added subtests for the i-g-t
kms_flip, tested on a machine where a full detect cycle takes around 100
ms.  It works, and no frames are dropped any more with these patches
applied.  kms_flip also contains a special case to exercise the
above-describe rmfb slowpath.

Yours, Daniel

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-kms-locking

for you to fetch changes up to 57c45428f2b005e95bbc6706cd61574183ed8522:

  drm/fb_helper: check whether fbcon is bound (2013-01-20 15:59:55 +0100)

----------------------------------------------------------------
Daniel Vetter (36):
      drm: review locking rules in drm_crtc.c
      drm/doc: integrate drm_crtc.c kerneldoc
      drm/<drivers>: reorder framebuffer init sequence
      drm/vmwgfx: reorder framebuffer init sequence
      drm/gma500: move fbcon restore to lastclose
      drm/nouveau: protect evo_wait/evo_kick sections with a channel mutex
      drm/nouveau: try to protect nbo->pin_refcount
      drm/<drivers>: Unified handling of unimplemented fb->create_handle
      drm: encapsulate crtc->set_config calls
      drm: add drm_modeset_lock|unlock_all
      drm/i915: use drm_modeset_lock_all
      drm/gma500: use drm_modeset_lock_all
      drm/ast: use drm_modeset_lock_all
      drm/shmobile: use drm_modeset_lock_all
      drm/vmwgfx: use drm_modeset_lock_all
      omapdrm: use modeset_lock_all
      drm: add per-crtc locks
      drm: only take the crtc lock for ->cursor_set
      drm: only take the crtc lock for ->cursor_move
      drm: revamp locking around fb creation/destruction
      drm: create drm_framebuffer_lookup
      drm: revamp framebuffer cleanup interfaces
      drm: reference framebuffers which are on the idr
      drm: nest modeset locks within fpriv->fbs_lock
      drm: push modeset_lock_all into ->fb_create driver callbacks
      drm: don't take modeset locks in getfb ioctl
      drm: fb refcounting for dirtyfb_ioctl
      drm: refcounting for sprite framebuffers
      drm: refcounting for crtc framebuffers
      drm/i915: dump refcount into framebuffer debugfs file
      drm/vmwgfx: add proper framebuffer refcounting
      drm: optimize drm_framebuffer_remove
      drm: only grab the crtc lock for pageflips
      drm: don't hold crtc mutexes for connector ->detect callbacks
      drm/doc: updates for new framebuffer lifetime rules
      drm/fb_helper: check whether fbcon is bound

 Documentation/DocBook/drm.tmpl            |   63 ++-
 drivers/gpu/drm/ast/ast_drv.c             |    4 +-
 drivers/gpu/drm/ast/ast_drv.h             |    2 +
 drivers/gpu/drm/ast/ast_fb.c              |    1 +
 drivers/gpu/drm/ast/ast_main.c            |   12 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c     |    1 +
 drivers/gpu/drm/cirrus/cirrus_main.c      |   12 +-
 drivers/gpu/drm/drm_crtc.c                |  792 +++++++++++++++++------------
 drivers/gpu/drm/drm_fb_cma_helper.c       |   15 +-
 drivers/gpu/drm/drm_fb_helper.c           |   65 ++-
 drivers/gpu/drm/drm_fops.c                |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c |    4 +-
 drivers/gpu/drm/gma500/framebuffer.c      |   29 +-
 drivers/gpu/drm/gma500/psb_device.c       |    8 +-
 drivers/gpu/drm/gma500/psb_drv.c          |   14 +-
 drivers/gpu/drm/i2c/ch7006_drv.c          |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c       |   15 +-
 drivers/gpu/drm/i915/intel_display.c      |   21 +-
 drivers/gpu/drm/i915/intel_dp.c           |    2 +
 drivers/gpu/drm/i915/intel_fb.c           |    5 +-
 drivers/gpu/drm/i915/intel_lvds.c         |    4 +-
 drivers/gpu/drm/i915/intel_overlay.c      |   14 +-
 drivers/gpu/drm/i915/intel_sprite.c       |    8 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c      |    1 +
 drivers/gpu/drm/mgag200/mgag200_main.c    |   16 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c      |   22 +-
 drivers/gpu/drm/nouveau/nouveau_bo.h      |    2 +
 drivers/gpu/drm/nouveau/nouveau_display.c |   10 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c   |    1 +
 drivers/gpu/drm/nouveau/nv04_display.c    |    2 +-
 drivers/gpu/drm/nouveau/nv17_tv.c         |    2 +-
 drivers/gpu/drm/nouveau/nv50_display.c    |   10 +
 drivers/gpu/drm/radeon/radeon_cursor.c    |    8 +-
 drivers/gpu/drm/radeon/radeon_display.c   |    2 +-
 drivers/gpu/drm/radeon/radeon_fb.c        |    2 +
 drivers/gpu/drm/shmobile/shmob_drm_drv.c  |    4 +-
 drivers/gpu/drm/udl/udl_fb.c              |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c       |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c     |   38 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c       |   87 ++--
 drivers/staging/omapdrm/omap_crtc.c       |    8 +-
 drivers/staging/omapdrm/omap_debugfs.c    |    2 +
 drivers/staging/omapdrm/omap_drv.c        |    4 +-
 drivers/staging/omapdrm/omap_fb.c         |   16 +-
 drivers/staging/omapdrm/omap_fbdev.c      |    8 +-
 include/drm/drmP.h                        |   13 +
 include/drm/drm_crtc.h                    |   30 ++
 47 files changed, 836 insertions(+), 552 deletions(-)

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
