Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936601Ab3DHKWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:22:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935463Ab3DHJvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Wu <lekensteyn@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 016/102] i915: initialize CADL in opregion
Date: Mon,  8 Apr 2013 10:49:31 +0100
Message-Id: <1365414657-29191-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lekensteyn <lekensteyn@gmail.com>

commit d627b62ff8d4d36761adbcd90ff143d79c94ab22 upstream.

This is rather a hack to fix brightness hotkeys on a Clevo laptop. CADL is not
used anywhere in the driver code at the moment, but it could be used in BIOS as
is the case with the Clevo laptop.

The Clevo B7130 requires the CADL field to contain at least the ID of
the LCD device. If this field is empty, the ACPI methods that are called
on pressing brightness / display switching hotkeys will not trigger a
notification. As a result, it appears as no hotkey has been pressed.

Reference: https://bugs.freedesktop.org/show_bug.cgi?id=45452
Tested-by: Peter Wu <lekensteyn@gmail.com>
Signed-off-by: Peter Wu <lekensteyn@gmail.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_opregion.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 18bd0af..e27c170 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -427,6 +427,25 @@ blind_set:
 	goto end;
 }
 
+static void intel_setup_cadls(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_opregion *opregion = &dev_priv->opregion;
+	int i = 0;
+	u32 disp_id;
+
+	/* Initialize the CADL field by duplicating the DIDL values.
+	 * Technically, this is not always correct as display outputs may exist,
+	 * but not active. This initialization is necessary for some Clevo
+	 * laptops that check this field before processing the brightness and
+	 * display switching hotkeys. Just like DIDL, CADL is NULL-terminated if
+	 * there are less than eight devices. */
+	do {
+		disp_id = ioread32(&opregion->acpi->didl[i]);
+		iowrite32(disp_id, &opregion->acpi->cadl[i]);
+	} while (++i < 8 && disp_id != 0);
+}
+
 void intel_opregion_init(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -436,8 +455,10 @@ void intel_opregion_init(struct drm_device *dev)
 		return;
 
 	if (opregion->acpi) {
-		if (drm_core_check_feature(dev, DRIVER_MODESET))
+		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 			intel_didl_outputs(dev);
+			intel_setup_cadls(dev);
+		}
 
 		/* Notify BIOS we are ready to handle ACPI video ext notifs.
 		 * Right now, all the events are handled by the ACPI video module.
-- 
1.8.1.2

