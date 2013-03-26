Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3CZW5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:57:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab3CZWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Wu <lekensteyn@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 69/72] i915: initialize CADL in opregion
Date: Tue, 26 Mar 2013 15:51:52 -0700
Message-Id: <20130326224926.771805972@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


