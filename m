Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3CYBSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:18:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34171 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756336Ab3CYBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:42 -0400
Message-Id: <20130325010526.249102184@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Lekensteyn <lekensteyn@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 019/104] i915: initialize CADL in opregion
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_opregion.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -419,6 +419,25 @@ blind_set:
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
@@ -428,8 +447,10 @@ void intel_opregion_init(struct drm_devi
 		return;
 
 	if (opregion->acpi) {
-		if (drm_core_check_feature(dev, DRIVER_MODESET))
+		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 			intel_didl_outputs(dev);
+			intel_setup_cadls(dev);
+		}
 
 		/* Notify BIOS we are ready to handle ACPI video ext notifs.
 		 * Right now, all the events are handled by the ACPI video module.


