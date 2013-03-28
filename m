Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3C1ME7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:04:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56876 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3C1ME4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:04:56 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, rodrigo.vivi@gmail.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/4] compat-drivers: simplify backport fb_info->skip_vt_switch CE
Date: Thu, 28 Mar 2013 05:04:29 -0700
Message-Id: <1364472270-9297-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The collateral evolution (CE) on the fb_info data structure
that added the skip_vt_switch element can be simplified
further by replacing the #ifdef hell with a static inline.

Furthermore, if the static inline is added upstream it'd mean
we can get rid of all these static inline replacements for
this data structure element CE.

Cc: cocci@systeme.lip6.fr
Cc: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 .../drm/0001-fb-info-vt_switch.patch               |   25 ++++----------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch b/patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch
index cdced87..39b13d1 100644
--- a/patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch
+++ b/patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch
@@ -8,23 +8,7 @@ pm_vt_switch_unregister() would not have been made.
 This patch cannot be broken down further so I'm pegging
 this as the first one with 4 digits under the DRM folder
 for collateral evolutions. This reflects its as atomic as
-is possible. As we'll see on the next commit, these type
-of collateral evolutions can best be backported not by
-keeping ifdef's as below but instead by using a wrapper
-caller, to help reduce with the amount of lines of code
-we need. If a static inline is added upstream for these
-changes, then no code is required for backporting, at all,
-we'd just implement the static inline later upstream as
-a no-op.
-
-The tradeoffs to consider for this is if we can live with
-these practices upstream, we may be able to support full
-subsystems only with a compat module, and no need for
-patches. This also means less code and likely less bugs
-on the distribution front when backporting is required.
-At least IMHO this may be worthy to consider at least to
-support kernels listed as supported on kernel.org. We could
-just leave the ifdef hell to older unsupported kernels.
+is possible.
 
 Relevant commits below, starting with the first one that
 added this new collateral evolution.
@@ -60,14 +44,13 @@ Date:   Tue Mar 26 09:25:45 2013 -0700
 
 --- a/drivers/gpu/drm/i915/intel_fb.c
 +++ b/drivers/gpu/drm/i915/intel_fb.c
-@@ -150,8 +150,10 @@ static int intelfb_create(struct drm_fb_
+@@ -150,8 +150,8 @@ static int intelfb_create(struct drm_fb_
  	}
  	info->screen_size = size;
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0))
  	/* This driver doesn't need a VT switch to restore the mode on resume */
- 	info->skip_vt_switch = true;
-+#endif
+- 	info->skip_vt_switch = true;
++ 	fb_enable_skip_vt_switch(info);
  
  	drm_fb_helper_fill_fix(info, fb->pitches[0], fb->depth);
  	drm_fb_helper_fill_var(info, &ifbdev->helper, sizes->fb_width, sizes->fb_height);
-- 
1.7.10.4

