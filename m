Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162115Ab3LFNFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:05:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162077Ab3LFNFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 245/272] drm/i915/dvo: call ->mode_set callback only when the port is running
Date: Fri,  6 Dec 2013 12:58:54 +0000
Message-Id: <1386334761-25517-246-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_dvo.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index eb2020e..df2ff29 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -172,11 +172,16 @@ static void intel_enable_dvo(struct intel_encoder *encoder)
 {
 	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
 	struct intel_dvo *intel_dvo = enc_to_intel_dvo(&encoder->base);
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
 
@@ -185,6 +190,7 @@ static void intel_dvo_dpms(struct drm_connector *connector, int mode)
 {
 	struct intel_dvo *intel_dvo = intel_attached_dvo(connector);
 	struct drm_crtc *crtc;
+	struct intel_crtc_config *config;
 
 	/* dvo supports only 2 dpms states. */
 	if (mode != DRM_MODE_DPMS_ON)
@@ -205,10 +211,16 @@ static void intel_dvo_dpms(struct drm_connector *connector, int mode)
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
@@ -298,8 +310,6 @@ static void intel_dvo_mode_set(struct drm_encoder *encoder,
 		break;
 	}
 
-	intel_dvo->dev.dev_ops->mode_set(&intel_dvo->dev, mode, adjusted_mode);
-
 	/* Save the data order, since I don't know what it should be set to. */
 	dvo_val = I915_READ(dvo_reg) &
 		  (DVO_PRESERVE_MASK | DVO_DATA_ORDER_GBRG);
-- 
1.8.3.2

