Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937172Ab3DJWrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937145Ab3DJWrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Jackson <ajax@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 17/64] drm/i915: Be sure to turn hsync/vsync back on at crt enable (v2)
Date: Wed, 10 Apr 2013 15:46:14 -0700
Message-Id: <20130410224337.012108012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit 637f44d24f8868ee5a597a99e7874fdd150d4cba upstream.

commit f40ebd6bcbbd0d30591f42dc16be52b5086a366b
Author: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Date:   Tue Mar 5 14:24:48 2013 +0100

    drm/i915: Turn off hsync and vsync on ADPA when disabling crt

properly disabled the hsync/vsync logic at disable time, but neglected
to re-enable them at enable time.

v2: In the enable hook, restore the connector's expected DPMS level
instead of forcing ON.  Do this by stashing a back pointer to the
connector in the crt (suggested by danvet) since otherwise it's awkward
to look up.

Signed-off-by: Adam Jackson <ajax@redhat.com>
[danvet: Added more verbose commit citation and cc: stable tag. Also,
make it compile. Then self-lart and try to assign the right pointer.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_crt.c |   40 ++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -45,6 +45,9 @@
 
 struct intel_crt {
 	struct intel_encoder base;
+	/* DPMS state is stored in the connector, which we need in the
+	 * encoder's enable/disable callbacks */
+	struct intel_connector *connector;
 	bool force_hotplug_required;
 	u32 adpa_reg;
 };
@@ -81,29 +84,6 @@ static bool intel_crt_get_hw_state(struc
 	return true;
 }
 
-static void intel_disable_crt(struct intel_encoder *encoder)
-{
-	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
-	struct intel_crt *crt = intel_encoder_to_crt(encoder);
-	u32 temp;
-
-	temp = I915_READ(crt->adpa_reg);
-	temp |= ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE;
-	temp &= ~ADPA_DAC_ENABLE;
-	I915_WRITE(crt->adpa_reg, temp);
-}
-
-static void intel_enable_crt(struct intel_encoder *encoder)
-{
-	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
-	struct intel_crt *crt = intel_encoder_to_crt(encoder);
-	u32 temp;
-
-	temp = I915_READ(crt->adpa_reg);
-	temp |= ADPA_DAC_ENABLE;
-	I915_WRITE(crt->adpa_reg, temp);
-}
-
 /* Note: The caller is required to filter out dpms modes not supported by the
  * platform. */
 static void intel_crt_set_dpms(struct intel_encoder *encoder, int mode)
@@ -135,6 +115,19 @@ static void intel_crt_set_dpms(struct in
 	I915_WRITE(crt->adpa_reg, temp);
 }
 
+static void intel_disable_crt(struct intel_encoder *encoder)
+{
+	intel_crt_set_dpms(encoder, DRM_MODE_DPMS_OFF);
+}
+
+static void intel_enable_crt(struct intel_encoder *encoder)
+{
+	struct intel_crt *crt = intel_encoder_to_crt(encoder);
+
+	intel_crt_set_dpms(encoder, crt->connector->base.dpms);
+}
+
+
 static void intel_crt_dpms(struct drm_connector *connector, int mode)
 {
 	struct drm_device *dev = connector->dev;
@@ -746,6 +739,7 @@ void intel_crt_init(struct drm_device *d
 	}
 
 	connector = &intel_connector->base;
+	crt->connector = intel_connector;
 	drm_connector_init(dev, &intel_connector->base,
 			   &intel_crt_connector_funcs, DRM_MODE_CONNECTOR_VGA);
 


