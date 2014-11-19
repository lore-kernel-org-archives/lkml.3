Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbaKSW0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:26:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbaKSUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Auty <mike.auty@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.17 062/141] drm/i915: safeguard against too high minimum brightness
Date: Wed, 19 Nov 2014 12:51:25 -0800
Message-Id: <20141119205152.701534076@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit e1c412e75754ab7b7002f3e18a2652d999c40d4b upstream.

Never trust (your interpretation of) the VBT. Regression from

commit 6dda730e55f412a6dfb181cae6784822ba463847
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Tue Jun 24 18:27:40 2014 +0300

    drm/i915: respect the VBT minimum backlight brightness

causing div by zero if VBT minimum brightness equals maximum brightness.

Despite my attempts I've failed in my detective work to figure out what
the root cause is. This is not the real fix, but we have to do
something.

Reported-by: Mike Auty <mike.auty@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=86551
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_panel.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -1074,12 +1074,25 @@ static u32 get_backlight_min_vbt(struct
 	struct drm_device *dev = connector->base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_panel *panel = &connector->panel;
+	int min;
 
 	WARN_ON(panel->backlight.max == 0);
 
+	/*
+	 * XXX: If the vbt value is 255, it makes min equal to max, which leads
+	 * to problems. There are such machines out there. Either our
+	 * interpretation is wrong or the vbt has bogus data. Or both. Safeguard
+	 * against this by letting the minimum be at most (arbitrarily chosen)
+	 * 25% of the max.
+	 */
+	min = clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);
+	if (min != dev_priv->vbt.backlight.min_brightness) {
+		DRM_DEBUG_KMS("clamping VBT min backlight %d/255 to %d/255\n",
+			      dev_priv->vbt.backlight.min_brightness, min);
+	}
+
 	/* vbt value is a coefficient in range [0..255] */
-	return scale(dev_priv->vbt.backlight.min_brightness, 0, 255,
-		     0, panel->backlight.max);
+	return scale(min, 0, 255, 0, panel->backlight.max);
 }
 
 static int bdw_setup_backlight(struct intel_connector *connector)


