Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaFMT5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:57:40 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:58691 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaFMT5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:57:39 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2014 15:57:39 EDT
From: Christoph Jaeger <christophjaeger@linux.com>
To: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] drm/i915: Fix memory leak in intel_dsi_init() error path
Date: Fri, 13 Jun 2014 21:51:22 +0200
Message-Id: <1402689082-20211-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_dsi_init() bails out without freeing the memory 'intel_dsi' and
'intel_connector' point to. Simply bail out before allocating memory.

Picked up by Coverity - CID 1222750.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/gpu/drm/i915/intel_dsi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dsi.c b/drivers/gpu/drm/i915/intel_dsi.c
index 02f99d7..6965627 100644
--- a/drivers/gpu/drm/i915/intel_dsi.c
+++ b/drivers/gpu/drm/i915/intel_dsi.c
@@ -675,6 +675,13 @@ bool intel_dsi_init(struct drm_device *dev)
 	if (!dev_priv->vbt.has_mipi)
 		return false;
 
+	if (IS_VALLEYVIEW(dev)) {
+		dev_priv->mipi_mmio_base = VLV_MIPI_BASE;
+	} else {
+		DRM_ERROR("Unsupported Mipi device to reg base");
+		return false;
+	}
+
 	intel_dsi = kzalloc(sizeof(*intel_dsi), GFP_KERNEL);
 	if (!intel_dsi)
 		return false;
@@ -689,13 +696,6 @@ bool intel_dsi_init(struct drm_device *dev)
 	encoder = &intel_encoder->base;
 	intel_dsi->attached_connector = intel_connector;
 
-	if (IS_VALLEYVIEW(dev)) {
-		dev_priv->mipi_mmio_base = VLV_MIPI_BASE;
-	} else {
-		DRM_ERROR("Unsupported Mipi device to reg base");
-		return false;
-	}
-
 	connector = &intel_connector->base;
 
 	drm_encoder_init(dev, encoder, &intel_dsi_funcs, DRM_MODE_ENCODER_DSI);
-- 
1.9.3

