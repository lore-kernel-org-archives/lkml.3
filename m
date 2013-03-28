Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3C1MEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:04:51 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:50854 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3C1MEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:04:44 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, rodrigo.vivi@gmail.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/4] compat-drivers: backport fb_info->skip_vt_switch using ifdefs
Date: Thu, 28 Mar 2013 05:04:27 -0700
Message-Id: <1364472270-9297-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Commit 3cf2667 as of next-20130301 extended the struct fb_info
with a skip_vt_switch to allow drivers to skip the VT switch
at suspend/resume time. For older kernels we can skip this
as all this switch does is call pm_vt_switch_required() with true
or false depending on this new flag and later
pm_vt_switch_unregister() would not have been made.

This patch cannot be broken down further so I'm pegging
this as the first one with 4 digits under the DRM folder
for collateral evolutions. This reflects its as atomic as
is possible. As we'll see on the next commit, these type
of collateral evolutions can best be backported not by
keeping ifdef's as below but instead by using a wrapper
caller, to help reduce with the amount of lines of code
we need. If a static inline is added upstream for these
changes, then no code is required for backporting, at all,
we'd just implement the static inline later upstream as
a no-op.

The tradeoffs to consider for this is if we can live with
these practices upstream, we may be able to support full
subsystems only with a compat module, and no need for
patches. This also means less code and likely less bugs
on the distribution front when backporting is required.
At least IMHO this may be worthy to consider at least to
support kernels listed as supported on kernel.org. We could
just leave the ifdef hell to older unsupported kernels.

Relevant commits below, starting with the first one that
added this new collateral evolution.

commit 3cf2667b9f8b2c2fe298a427deb399e52321da6b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 4 13:37:21 2013 +0000

    fb: add support for drivers not needing VT switch at suspend/resume time

    Use the new PM routines to indicate whether we need to VT switch at suspend
    and resume time.  When a new driver is bound, set its flag accordingly,
    and when unbound, remove it from the PM's console tracking list.

    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 24576d23976746cb52e7700c4cadbf4bc1bc3472
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Mar 26 09:25:45 2013 -0700

    drm/i915: enable VT switchless resume v3

    With the other bits in place, we can do this safely.

    v2: disable backlight on suspend to prevent premature enablement on resume
    v3: disable CRTCs on suspend to allow RTD3 (Kristen)

    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

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
 .../drm/0001-fb-info-vt_switch.patch               |   73 ++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch

diff --git a/patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch b/patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch
new file mode 100644
index 0000000..cdced87
--- /dev/null
+++ b/patches/collateral-evolutions/drm/0001-fb-info-vt_switch.patch
@@ -0,0 +1,73 @@
+Commit 3cf2667 as of next-20130301 extended the struct fb_info
+with a skip_vt_switch to allow drivers to skip the VT switch
+at suspend/resume time. For older kernels we can skip this
+as all this switch does is call pm_vt_switch_required() with true
+or false depending on this new flag and later
+pm_vt_switch_unregister() would not have been made.
+
+This patch cannot be broken down further so I'm pegging
+this as the first one with 4 digits under the DRM folder
+for collateral evolutions. This reflects its as atomic as
+is possible. As we'll see on the next commit, these type
+of collateral evolutions can best be backported not by
+keeping ifdef's as below but instead by using a wrapper
+caller, to help reduce with the amount of lines of code
+we need. If a static inline is added upstream for these
+changes, then no code is required for backporting, at all,
+we'd just implement the static inline later upstream as
+a no-op.
+
+The tradeoffs to consider for this is if we can live with
+these practices upstream, we may be able to support full
+subsystems only with a compat module, and no need for
+patches. This also means less code and likely less bugs
+on the distribution front when backporting is required.
+At least IMHO this may be worthy to consider at least to
+support kernels listed as supported on kernel.org. We could
+just leave the ifdef hell to older unsupported kernels.
+
+Relevant commits below, starting with the first one that
+added this new collateral evolution.
+
+commit 3cf2667b9f8b2c2fe298a427deb399e52321da6b
+Author: Jesse Barnes <jbarnes@virtuousgeek.org>
+Date:   Mon Feb 4 13:37:21 2013 +0000
+
+    fb: add support for drivers not needing VT switch at suspend/resume time
+    
+    Use the new PM routines to indicate whether we need to VT switch at suspend
+    and resume time.  When a new driver is bound, set its flag accordingly,
+    and when unbound, remove it from the PM's console tracking list.
+    
+    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
+    Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
+
+commit 24576d23976746cb52e7700c4cadbf4bc1bc3472
+Author: Jesse Barnes <jbarnes@virtuousgeek.org>
+Date:   Tue Mar 26 09:25:45 2013 -0700
+
+    drm/i915: enable VT switchless resume v3
+    
+    With the other bits in place, we can do this safely.
+    
+    v2: disable backlight on suspend to prevent premature enablement on resume
+    v3: disable CRTCs on suspend to allow RTD3 (Kristen)
+    
+    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
+    Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
+    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
+
+--- a/drivers/gpu/drm/i915/intel_fb.c
++++ b/drivers/gpu/drm/i915/intel_fb.c
+@@ -150,8 +150,10 @@ static int intelfb_create(struct drm_fb_
+ 	}
+ 	info->screen_size = size;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0))
+ 	/* This driver doesn't need a VT switch to restore the mode on resume */
+ 	info->skip_vt_switch = true;
++#endif
+ 
+ 	drm_fb_helper_fill_fix(info, fb->pitches[0], fb->depth);
+ 	drm_fb_helper_fill_var(info, &ifbdev->helper, sizes->fb_width, sizes->fb_height);
-- 
1.7.10.4

