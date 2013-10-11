Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3JKF2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:28:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51906 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab3JKF2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:28:49 -0400
Date: Fri, 11 Oct 2013 06:28:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1310110622460.14758@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

all over the map,
nouveau: disable MSI, needs more work, will try again next merge window,
radeon: audio + uvd regression fixes, dpm fixes, reset fixes
i915: dpms one might fix your haswell,

and one pain in the ass revert, so we have VGA arbitration that when 
implemented 4-5 years ago really hoped that GPUs could remove themselves 
from arbitration completely once they had a kernel driver, it seems Intel 
hw designers decided that was too nice a facility to allow us to have so 
they removed it when they went on-die (so since Ironlake at least), now
Alex Williamson added support for VGA arbitration for newer GPUs however
this now exposes itself to userspace as requireing arbitration of GPU VGA 
regions and the X server gets involved and disables things that it can't 
handle when VGA access is possibly required around every operation, so in 
order to break userspace we just reverted things back to the old known 
broken status so maybe we can try and design out way out. Ville also had a 
patch to use stop machine for the two times Intel needs to access VGA 
space, that might be acceptable with some rework, but for now myself and 
Daniel agreed to just go back.

Dave.

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to ebff5fa9d545574324095d9c6a3cb80c9157abc5:

  Revert "i915: Update VGA arbiter support for newer devices" (2013-10-11 15:19:22 +1000)

----------------------------------------------------------------
Alex Deucher (10):
      drm/edid: catch kmalloc failure in drm_edid_to_speaker_allocation
      drm/radeon: use 64-bit math to calculate CTS values for audio (v2)
      drm/radeon: fix N/CTS clock matching for audio
      drm/radeon: use hw generated CTS/N values for audio
      drm/radeon/dpm: disable multiple UVD states
      drm/radeon: fix typo in CP DMA register headers
      drm/radeon: improve soft reset on SI
      drm/radeon: improve soft reset on CIK
      drm/radeon/dpm: disable bapm on TN asics
      drm/radeon: re-enable sw ACR support on pre-DCE4

Ben Skeggs (1):
      drm/nouveau/mc: disable msi support by default, it's busted in tons of places

Chris Wilson (1):
      drm/i915: Only apply DPMS to the encoder if enabled

Dan Carpenter (3):
      drm/radeon: forever loop on error in radeon_do_test_moves()
      drm/radeon/dpm/btc: off by one in btc_set_mc_special_registers()
      drm/radeon/dpm: off by one in si_set_mc_special_registers()

Dave Airlie (6):
      Merge tag 'drm-intel-fixes-2013-10-07' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge remote-tracking branch 'nouveau/drm-nouveau-next' into drm-fixes
      Revert "drm/fb-helper: don't sleep for screen unblank when an oops is in progress"
      Merge branch 'drm-fixes-3.12' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Revert "drm/i915: Delay disabling of VGA memory until vgacon->fbcon handoff is done"
      Revert "i915: Update VGA arbiter support for newer devices"

Francisco Jerez (1):
      drm/i915/hsw: Disable L3 caching of atomic memory operations.

Imre Deak (1):
      drm/i915: fix rps.vlv_work initialization

Rob Clark (1):
      drm/gma500: fix things after get/put page helpers

Rodrigo Vivi (1):
      drm/i915: Mask LPSP to get PSR working even with Power Well in use by audio.

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics

 drivers/gpu/drm/drm_edid.c                    |  2 ++
 drivers/gpu/drm/drm_fb_helper.c               |  8 ------
 drivers/gpu/drm/gma500/gtt.c                  |  1 +
 drivers/gpu/drm/i915/i915_dma.c               | 15 +++--------
 drivers/gpu/drm/i915/i915_reg.h               |  6 +++++
 drivers/gpu/drm/i915/intel_display.c          | 38 ++-------------------------
 drivers/gpu/drm/i915/intel_dp.c               |  2 +-
 drivers/gpu/drm/i915/intel_drv.h              |  1 -
 drivers/gpu/drm/i915/intel_pm.c               |  9 +++++--
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c |  2 +-
 drivers/gpu/drm/radeon/btc_dpm.c              |  6 ++---
 drivers/gpu/drm/radeon/cik.c                  |  6 +++++
 drivers/gpu/drm/radeon/evergreen.c            |  2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c       |  3 +--
 drivers/gpu/drm/radeon/evergreend.h           |  4 +--
 drivers/gpu/drm/radeon/r600_hdmi.c            | 21 ++++++++++-----
 drivers/gpu/drm/radeon/r600d.h                |  2 +-
 drivers/gpu/drm/radeon/radeon_pm.c            |  3 +++
 drivers/gpu/drm/radeon/radeon_test.c          |  4 +--
 drivers/gpu/drm/radeon/radeon_uvd.c           |  3 ++-
 drivers/gpu/drm/radeon/si.c                   | 10 +++++++
 drivers/gpu/drm/radeon/si_dpm.c               |  6 ++---
 drivers/gpu/drm/radeon/sid.h                  |  4 +--
 drivers/gpu/drm/radeon/trinity_dpm.c          |  2 +-
 include/linux/vgaarb.h                        |  7 -----
 25 files changed, 74 insertions(+), 93 deletions(-)
