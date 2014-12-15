Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaLOPMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:12:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaLOO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 031/168] drm/i915: Kick fbdev before vgacon
Date: Mon, 15 Dec 2014 14:24:45 +0000
Message-Id: <1418653622-21105-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 0485c9dc24ec0939b42ca5104c0373297506b555 upstream.

It's magic, but it seems to work.

This fixes a regression introduced in

commit 1bb9e632a0aeee1121e652ee4dc80e5e6f14bcd2
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Jul 8 10:02:43 2014 +0200

    drm/i915: Only unbind vgacon, not other console drivers

My best guess is that the vga fbdev driver falls over if we rip out
parts of vgacon. Hooray.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=82439
Reported-and-tested-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 0663fb4fa606..646b68a58979 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1662,15 +1662,17 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		goto out_regs;
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
-		ret = i915_kick_out_vgacon(dev_priv);
+		/* WARNING: Apparently we must kick fbdev drivers before vgacon,
+		 * otherwise the vga fbdev driver falls over. */
+		ret = i915_kick_out_firmware_fb(dev_priv);
 		if (ret) {
-			DRM_ERROR("failed to remove conflicting VGA console\n");
+			DRM_ERROR("failed to remove conflicting framebuffer drivers\n");
 			goto out_gtt;
 		}
 
-		ret = i915_kick_out_firmware_fb(dev_priv);
+		ret = i915_kick_out_vgacon(dev_priv);
 		if (ret) {
-			DRM_ERROR("failed to remove conflicting framebuffer drivers\n");
+			DRM_ERROR("failed to remove conflicting VGA console\n");
 			goto out_gtt;
 		}
 	}
-- 
2.1.3

