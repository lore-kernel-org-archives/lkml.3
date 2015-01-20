Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbbATKtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:00 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42772 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbbATKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:48:58 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 00/36] drm/tegra: Atomic mode-setting conversion
Date: Tue, 20 Jan 2015 11:48:19 +0100
Message-Id: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This series converts the Tegra DRM driver to atomic mode-setting. The
size of the is somewhat misleading, because a bunch of preparatory work
is included.

The first patch adds a new function to the clk API that allows checking
that setting a parent clock can succeed. This is needed to make sure an
atomic state can be applied before actually making any changes to the
hardware.

Patch 2 makes the plane's ->atomic_update() callback mandatory because
there is no use-case in which it makes sense to omit it.

Patches 3 and 4 add additional callbacks for planes and encoders, which
are needed by subsequent patches.

Patch 5 adds a helper to obtain the state of the CRTC that a plane is
being attached to. This is non-trivial, so a new helper is warranted.

Patches 6 to 21 are preparatory work and cleanup needed to simplify the
atomic mode-setting transition.

Patches 22 to 32 are the actual conversion to atomic mode-setting. This
is followed-up by patch 33 removing now unused code. Patches 34 and 35
use the ->atomic_check() callbacks to store data that can be reused at
the commit stage to avoid having to recompute it. Finally patch 36 can
now move some duplicate code from the output drivers to the display
controller.

Thierry

Thierry Reding (36):
  clk: Introduce clk_try_parent()
  drm/plane: Make ->atomic_update() mandatory
  drm/plane: Add optional ->atomic_disable() callback
  drm/atomic: Add ->atomic_check() to encoder helpers
  drm/atomic: Add drm_atomic_plane_get_crtc_state()
  drm/tegra: Use tegra_commit_dc() in output drivers
  drm/tegra: Stop CRTC at CRTC disable time
  drm/tegra: dc: Wait for idle when disabled
  drm/tegra: Move tegra_drm_mode_funcs to the core
  drm/tegra: dc: No longer disable planes at CRTC disable
  drm/tegra: Convert output midlayer to helpers
  drm/tegra: output: Make ->setup_clock() optional
  drm/tegra: Add tegra_dc_setup_clock() helper
  drm/tegra: rgb: Demidlayer
  drm/tegra: hdmi: Demidlayer
  drm/tegra: dsi: Demidlayer
  drm/tegra: sor: Demidlayer
  drm/tegra: debugfs cleanup cannot fail
  drm/tegra: Remove remnants of the output midlayer
  drm/tegra: Output cleanup functions cannot fail
  drm/tegra: dc: Do not needlessly deassert reset
  drm/tegra: Atomic conversion, phase 1
  drm/tegra: Atomic conversion, phase 2
  drm/tegra: Atomic conversion, phase 3, step 1
  drm/tegra: dc: Store clock setup in atomic state
  drm/tegra: rgb: Implement ->atomic_check()
  drm/tegra: dsi: Implement ->atomic_check()
  drm/tegra: hdmi: Implement ->atomic_check()
  drm/tegra: sor: Implement ->atomic_check()
  drm/tegra: dc: Use atomic clock state in modeset
  drm/tegra: Atomic conversion, phase 3, step 2
  drm/tegra: Atomic conversion, phase 3, step 3
  drm/tegra: Remove unused ->mode_fixup() callbacks
  drm/tegra: Track active planes in CRTC state
  drm/tegra: Track tiling and format in plane state
  drm/tegra: dc: Unify enabling the display controller

 drivers/clk/clk.c                   |   36 ++
 drivers/gpu/drm/drm_atomic_helper.c |   34 +-
 drivers/gpu/drm/drm_plane_helper.c  |   10 +-
 drivers/gpu/drm/tegra/dc.c          |  916 +++++++++++++++++------------
 drivers/gpu/drm/tegra/drm.c         |  105 +++-
 drivers/gpu/drm/tegra/drm.h         |   91 +--
 drivers/gpu/drm/tegra/dsi.c         |  516 ++++++++--------
 drivers/gpu/drm/tegra/fb.c          |   25 +-
 drivers/gpu/drm/tegra/hdmi.c        |  291 +++++----
 drivers/gpu/drm/tegra/output.c      |  156 +----
 drivers/gpu/drm/tegra/rgb.c         |  218 +++----
 drivers/gpu/drm/tegra/sor.c         | 1105 ++++++++++++++++++-----------------
 include/drm/drm_atomic.h            |   21 +
 include/drm/drm_atomic_helper.h     |   37 ++
 include/drm/drm_crtc_helper.h       |    6 +
 include/drm/drm_plane_helper.h      |    3 +
 include/linux/clk.h                 |   14 +
 17 files changed, 1963 insertions(+), 1621 deletions(-)

-- 
2.1.3

