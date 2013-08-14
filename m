Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865Ab3HNKne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:43:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34693 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab3HNKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 64/75] drm/i915: do not disable backlight on vgaswitcheroo switch off
Date: Wed, 14 Aug 2013 11:36:53 +0100
Message-Id: <1376476624-10011-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 3f577573cd5482a32f85bd131e52f7cb4b9ac518 upstream.

On muxed systems, the other vgaswitcheroo client may depend on i915 to
handle the backlight. We began switching off the backlight since

commit a261b246ebd552fd5d5a8ed84cc931bb821c427f
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Jul 26 19:21:47 2012 +0200

    drm/i915: disable all crtcs at suspend time

breaking backlight on discreet graphics in (some) muxed systems.

Keep the backlight on when the state is changed through vgaswitcheroo.

Note: The alternative would be to add a quirk table to achieve the same
based on system identifiers, but AFAICS it would asymptotically approach
effectively the same as this patch as more IDs are added, but with the
maintenance burden of the quirk table.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=55311
Tested-by: Fede <fedevx@yahoo.com>
Tested-by: Aximab <laurent.debian@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59785
Tested-by: sfievet <sebastien.fievet@free.fr>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_panel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index d5fd67e..192002f 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -285,6 +285,17 @@ void intel_panel_disable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	/*
+	 * Do not disable backlight on the vgaswitcheroo path. When switching
+	 * away from i915, the other client may depend on i915 to handle the
+	 * backlight. This will leave the backlight on unnecessarily when
+	 * another client is not activated.
+	 */
+	if (dev->switch_power_state == DRM_SWITCH_POWER_CHANGING) {
+		DRM_DEBUG_DRIVER("Skipping backlight disable on vga switch\n");
+		return;
+	}
+
 	dev_priv->backlight_enabled = false;
 	intel_panel_actually_set_backlight(dev, 0);
 }
-- 
1.8.3.2

