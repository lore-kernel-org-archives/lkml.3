Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab3LBTz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:55:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3LBTSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Richter <thor@math.tu-berlin.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 128/212] drm/i915/dvo: call ->mode_set callback only when the port is running
Date: Mon,  2 Dec 2013 11:15:19 -0800
Message-Id: <20131202191301.306827719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 48f34e10169dbb3dd7a19af64e328492b7f54af4 upstream.

The ns2501 controller seems to need the dpll and dvo port to accept
the timing update commands. Quick testing on my x30 here seems to
indicate that other dvo controllers don't mind. So let's move the
->mode_set callback to a place where we have the port up and running
already.

Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Thomas Richter <thor@math.tu-berlin.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dvo.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -171,11 +171,16 @@ static void intel_enable_dvo(struct inte
 {
 	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
 	struct intel_dvo *intel_dvo = enc_to_dvo(encoder);
+	struct intel_crtc *crtc = to_intel_crtc(encoder->base.crtc);
 	u32 dvo_reg = intel_dvo->dev.dvo_reg;
 	u32 temp = I915_READ(dvo_reg);
 
 	I915_WRITE(dvo_reg, temp | DVO_ENABLE);
 	I915_READ(dvo_reg);
+	intel_dvo->dev.dev_ops->mode_set(&intel_dvo->dev,
+					 &crtc->config.requested_mode,
+					 &crtc->config.adjusted_mode);
+
 	intel_dvo->dev.dev_ops->dpms(&intel_dvo->dev, true);
 }
 
@@ -184,6 +189,7 @@ static void intel_dvo_dpms(struct drm_co
 {
 	struct intel_dvo *intel_dvo = intel_attached_dvo(connector);
 	struct drm_crtc *crtc;
+	struct intel_crtc_config *config;
 
 	/* dvo supports only 2 dpms states. */
 	if (mode != DRM_MODE_DPMS_ON)
@@ -204,10 +210,16 @@ static void intel_dvo_dpms(struct drm_co
 	/* We call connector dpms manually below in case pipe dpms doesn't
 	 * change due to cloning. */
 	if (mode == DRM_MODE_DPMS_ON) {
+		config = &to_intel_crtc(crtc)->config;
+
 		intel_dvo->base.connectors_active = true;
 
 		intel_crtc_update_dpms(crtc);
 
+		intel_dvo->dev.dev_ops->mode_set(&intel_dvo->dev,
+						 &config->requested_mode,
+						 &config->adjusted_mode);
+
 		intel_dvo->dev.dev_ops->dpms(&intel_dvo->dev, true);
 	} else {
 		intel_dvo->dev.dev_ops->dpms(&intel_dvo->dev, false);
@@ -299,10 +311,6 @@ static void intel_dvo_mode_set(struct in
 		break;
 	}
 
-	intel_dvo->dev.dev_ops->mode_set(&intel_dvo->dev,
-					 &crtc->config.requested_mode,
-					 adjusted_mode);
-
 	/* Save the data order, since I don't know what it should be set to. */
 	dvo_val = I915_READ(dvo_reg) &
 		  (DVO_PRESERVE_MASK | DVO_DATA_ORDER_GBRG);


