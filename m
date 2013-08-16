Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3HPX7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:59:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3HPWkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 106/133] drm/i915: do not disable backlight on vgaswitcheroo switch off
Date: Fri, 16 Aug 2013 15:34:08 -0700
Message-Id: <1376692475-28413-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_panel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index cc6346d..8df501a 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -295,6 +295,17 @@ void intel_panel_disable_backlight(struct drm_device *dev)
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
 
-- 
1.8.1.2

