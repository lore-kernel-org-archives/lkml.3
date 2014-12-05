Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaLEXS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:18:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaLEXGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.17 110/122] drm/i915: Kick fbdev before vgacon
Date: Fri,  5 Dec 2014 14:44:44 -0800
Message-Id: <20141205223322.689302837@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_dma.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1670,15 +1670,17 @@ int i915_driver_load(struct drm_device *
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


