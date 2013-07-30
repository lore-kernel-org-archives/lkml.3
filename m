Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3G3PSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:18:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 13/75] drm/i915: Preserve the DDI_A_4_LANES bit from the bios
Date: Tue, 30 Jul 2013 08:16:42 -0700
Message-Id: <1375197464-27962-14-git-send-email-kamal@canonical.com>
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

From: =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>

commit bcf53de4e60d9000b82f541d654529e2902a4c2c upstream.

Otherwise the DDI_A_4_LANES bit gets lost and we can't use > 2 lanes
on eDP. This fixes eDP on hsw with > 2 lanes.

Also s/port_reversal/saved_port_bits/ since the current name is
confusing.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ddi.c | 10 ++++++----
 drivers/gpu/drm/i915/intel_drv.h |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index bd37fe0..b8e53d9 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -681,7 +681,7 @@ static void intel_ddi_mode_set(struct drm_encoder *encoder,
 		struct intel_digital_port *intel_dig_port =
 			enc_to_dig_port(encoder);
 
-		intel_dp->DP = intel_dig_port->port_reversal |
+		intel_dp->DP = intel_dig_port->saved_port_bits |
 			       DDI_BUF_CTL_ENABLE | DDI_BUF_EMP_400MV_0DB_HSW;
 		switch (intel_dp->lane_count) {
 		case 1:
@@ -1303,7 +1303,8 @@ static void intel_enable_ddi(struct intel_encoder *intel_encoder)
 		 * enabling the port.
 		 */
 		I915_WRITE(DDI_BUF_CTL(port),
-			   intel_dig_port->port_reversal | DDI_BUF_CTL_ENABLE);
+			   intel_dig_port->saved_port_bits |
+			   DDI_BUF_CTL_ENABLE);
 	} else if (type == INTEL_OUTPUT_EDP) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
@@ -1496,8 +1497,9 @@ void intel_ddi_init(struct drm_device *dev, enum port port)
 	intel_encoder->get_hw_state = intel_ddi_get_hw_state;
 
 	intel_dig_port->port = port;
-	intel_dig_port->port_reversal = I915_READ(DDI_BUF_CTL(port)) &
-					DDI_BUF_PORT_REVERSAL;
+	intel_dig_port->saved_port_bits = I915_READ(DDI_BUF_CTL(port)) &
+					  (DDI_BUF_PORT_REVERSAL |
+					   DDI_A_4_LANES);
 	intel_dig_port->dp.output_reg = DDI_BUF_CTL(port);
 
 	intel_encoder->type = INTEL_OUTPUT_UNKNOWN;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index a803234..2d8fff3 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -377,7 +377,7 @@ struct intel_dp {
 struct intel_digital_port {
 	struct intel_encoder base;
 	enum port port;
-	u32 port_reversal;
+	u32 saved_port_bits;
 	struct intel_dp dp;
 	struct intel_hdmi hdmi;
 };
-- 
1.8.1.2

