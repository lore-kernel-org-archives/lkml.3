Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3G3P1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:27:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 12/75] drm/i915: don't setup hdmi for port D edp in ddi_init
Date: Tue, 30 Jul 2013 08:16:41 -0700
Message-Id: <1375197464-27962-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 21a8e6a4853b2ed39fa4c5188a710f2cf1b92026 upstream.

dp_init_connector adjusts the encoder type if it is a eDP panel. Use
that to decide whether we should set up a hdmi connector or not.

To do so reorder the hdmi connector setup sequence in ddi_init a bit.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: 3.8.y-stable prereq for:
  bcf53de4 "drm/i915: Preserve the DDI_A_4_LANES bit from the bios" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ddi.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index 0724662..bd37fe0 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1482,16 +1482,6 @@ void intel_ddi_init(struct drm_device *dev, enum port port)
 		return;
 	}
 
-	if (port != PORT_A) {
-		hdmi_connector = kzalloc(sizeof(struct intel_connector),
-					 GFP_KERNEL);
-		if (!hdmi_connector) {
-			kfree(dp_connector);
-			kfree(intel_dig_port);
-			return;
-		}
-	}
-
 	intel_encoder = &intel_dig_port->base;
 	encoder = &intel_encoder->base;
 
@@ -1508,8 +1498,6 @@ void intel_ddi_init(struct drm_device *dev, enum port port)
 	intel_dig_port->port = port;
 	intel_dig_port->port_reversal = I915_READ(DDI_BUF_CTL(port)) &
 					DDI_BUF_PORT_REVERSAL;
-	if (hdmi_connector)
-		intel_dig_port->hdmi.hdmi_reg = DDI_BUF_CTL(port);
 	intel_dig_port->dp.output_reg = DDI_BUF_CTL(port);
 
 	intel_encoder->type = INTEL_OUTPUT_UNKNOWN;
@@ -1517,7 +1505,16 @@ void intel_ddi_init(struct drm_device *dev, enum port port)
 	intel_encoder->cloneable = false;
 	intel_encoder->hot_plug = intel_ddi_hot_plug;
 
-	if (hdmi_connector)
-		intel_hdmi_init_connector(intel_dig_port, hdmi_connector);
 	intel_dp_init_connector(intel_dig_port, dp_connector);
+
+	if (intel_encoder->type != INTEL_OUTPUT_EDP) {
+		hdmi_connector = kzalloc(sizeof(struct intel_connector),
+					 GFP_KERNEL);
+		if (!hdmi_connector) {
+			return;
+		}
+
+		intel_dig_port->hdmi.hdmi_reg = DDI_BUF_CTL(port);
+		intel_hdmi_init_connector(intel_dig_port, hdmi_connector);
+	}
 }
-- 
1.8.1.2

