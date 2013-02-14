Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3BNIeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:34:00 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64481 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3BNId7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:33:59 -0500
Date: Thu, 14 Feb 2013 09:36:13 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: [pull] fb helper cleanups
Message-ID: <20130214083613.GT5813@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

[Andrew: Pull contains the patch "drm/fb-helper: don't sleep for screen
unblank when an oopps is in progress" which is also in your tree, hence
the cc.]

I've figured a pull request is easier to handle ;-)

This is the drm fb helper cleanup, mostly motivated by strange things I've
seen in my locking rework and the i915 modeset revamp. Compared to the
original submission I've reinstated the setup flexibility you'd like to
retain, kerneldoc has been reviewed by Laurent Pinchart and Rob Clark
reviewed the code changes.

Quick overview of the changes:
- Cleaned-up library interface for drivers using the fb helper, also
  simplified the fb allocation callback since no driver supported
  reallocating the fb on-the-fly. And the fbdev/fbcon code keeps pointers
  to the old mapping around anyway, so reallocating backing storage will
  be much more work.
- No longer call the crtc helper "disable everything" function at init
  time, but allow drivers to do so. Motivated by i915's fastboot effort
  and allows us to drop a bunch of noop dummy functions just to avoid
  calling NULL function pointers from i915.ko.
- Properly clear old state when doing modeset calls, the fb helper left
  some old modes in there and unconditionally set an fb (even when
  disabling a crtc). The crtc helpers didn't care, but i915 modeset code
  can now drop a few special cases.
- Full kerneldoc for the fb helper. Yay!
- My version of the "don't sleep in panic ->unblank calls". The patch is
  already in -mm, I guess Andrew can drop it as soon as this pull lands in
  drm-next.

Imo the fb helper looks now rather nice, and there's only a few pieces
left to fix up further:
- Removing the duplicated gamma handling.
- Reviewing the locking in the panic/sysrq/kgdb handlers some more.
- Maybe move some function pointers only used by the fb helper from the
  crtc helper structs to the fb helper structs. Currently those vtable
  misplacements are the last thing tying fb/crtc helpers together.
- Locking around init/teardown still looks a bit fishy. But that ties into
  the console_lock madness, so I'm not volunteering ;-)

Cheers, Daniel

The following changes since commit b9e5071386007729110e86fd2c55c687085624e3:

  Merge branch 'for-airlied' of git://people.freedesktop.org/~mlankhorst/linux into drm-next (2013-02-08 14:02:32 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm drm-fb-helper

for you to fetch changes up to a065b46a01b25d7d364e01e75f7ec2bd9ed5d9cb:

  drm/fb-helper: remove unused members of struct drm_fb_helper (2013-02-14 00:08:41 +0100)

----------------------------------------------------------------
Daniel Vetter (14):
      drm: review locking for drm_fb_helper_restore_fbdev_mode
      drm/fb-helper: kill drm_fb_helper_restore
      drm/fb-helper: unexport drm_fb_helper_panic
      drm/fb-helper: unexport drm_fb_helper_single_fb_probe
      drm/tegra: don't set up initial fbcon config twice
      drm/fb-helper: don't disable everything in initial_config
      drm/i915: rip out helper->disable noop functions
      drm/fb-helper: fixup set_config semantics
      drm/fb-helper: directly call set_par from the hotplug handler
      drm/fb-helper: streamline drm_fb_helper_single_fb_probe
      drm/<drivers>: simplify ->fb_probe callback
      drm/fb-helper: improve kerneldoc
      drm/fb-helper: don't sleep for screen unblank when an oopps is in progress
      drm/fb-helper: remove unused members of struct drm_fb_helper

 Documentation/DocBook/drm.tmpl            |    1 +
 drivers/gpu/drm/ast/ast_fb.c              |   26 +--
 drivers/gpu/drm/cirrus/cirrus_fbdev.c     |   26 +--
 drivers/gpu/drm/drm_crtc.c                |   16 +-
 drivers/gpu/drm/drm_fb_cma_helper.c       |   22 +--
 drivers/gpu/drm/drm_fb_helper.c           |  251 +++++++++++++++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c |   35 +---
 drivers/gpu/drm/gma500/framebuffer.c      |   14 +-
 drivers/gpu/drm/i915/intel_crt.c          |    1 -
 drivers/gpu/drm/i915/intel_ddi.c          |    1 -
 drivers/gpu/drm/i915/intel_display.c      |   20 +--
 drivers/gpu/drm/i915/intel_dp.c           |    1 -
 drivers/gpu/drm/i915/intel_drv.h          |    1 -
 drivers/gpu/drm/i915/intel_dvo.c          |    1 -
 drivers/gpu/drm/i915/intel_fb.c           |   21 +--
 drivers/gpu/drm/i915/intel_hdmi.c         |    1 -
 drivers/gpu/drm/i915/intel_lvds.c         |    1 -
 drivers/gpu/drm/i915/intel_sdvo.c         |    1 -
 drivers/gpu/drm/i915/intel_tv.c           |    1 -
 drivers/gpu/drm/mgag200/mgag200_fb.c      |   27 +---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c   |   25 +--
 drivers/gpu/drm/radeon/radeon_fb.c        |   25 +--
 drivers/gpu/drm/tegra/fb.c                |    4 -
 drivers/gpu/drm/udl/udl_fb.c              |   26 +--
 drivers/staging/omapdrm/omap_fbdev.c      |   21 +--
 include/drm/drm_crtc.h                    |    1 +
 include/drm/drm_fb_helper.h               |   18 ++-
 27 files changed, 298 insertions(+), 290 deletions(-)
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
