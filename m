Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaBJTne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:43:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaBJTna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Todd Previte <tprevite@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 088/124] drm/i915: VLV2 - Fix hotplug detect bits
Date: Mon, 10 Feb 2014 11:40:28 -0800
Message-Id: <1392061264-28124-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Todd Previte <tprevite@gmail.com>

commit 232a6ee9af8adb185640f67fcaaa9014a9aa0573 upstream.

Add new definitions for hotplug live status bits for VLV2 since they're
in reverse order from the gen4x ones.

Changelog:
- Restored gen4 bit definitions
- Added new definitions for VLV2
- Added platform check for IS_VALLEYVIEW() in dp_detect to use the correct
  bit defintions
- Replaced a lost trailing brace for the added switch()

Signed-off-by: Todd Previte <tprevite@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=73951
[danvet: Switch to _VLV postfix instead of prefix and regroupg
comments again so that the g4x warning is right next to those defines.
Also add a _G4X suffix for those special ones. Also cc stable.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 (renamed constants; also merged PORTD/PORTB mixup per
  0ce99f7 "drm/i915: fix gen4 digital port hotplug definitions" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 18 ++++++++++++++----
 drivers/gpu/drm/i915/intel_dp.c | 40 ++++++++++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 854f215..1a2ef33 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1660,10 +1660,20 @@
 #define CRT_HOTPLUG_DETECT_VOLTAGE_475MV	(1 << 2)
 
 #define PORT_HOTPLUG_STAT	0x61114
-/* HDMI/DP bits are gen4+ */
-#define   DPB_HOTPLUG_LIVE_STATUS               (1 << 29)
-#define   DPC_HOTPLUG_LIVE_STATUS               (1 << 28)
-#define   DPD_HOTPLUG_LIVE_STATUS               (1 << 27)
+/*
+ * HDMI/DP bits are gen4+
+ *
+ * WARNING: Bspec for hpd status bits on gen4 seems to be completely confused.
+ * Please check the detailed lore in the commit message for for experimental
+ * evidence.
+ */
+#define   DPD_HOTPLUG_LIVE_STATUS_G4X		(1 << 29)
+#define   DPC_HOTPLUG_LIVE_STATUS_G4X		(1 << 28)
+#define   DPB_HOTPLUG_LIVE_STATUS_G4X		(1 << 27)
+/* VLV DP/HDMI bits again match Bspec */
+#define   DPD_HOTPLUG_LIVE_STATUS_VLV		(1 << 27)
+#define   DPC_HOTPLUG_LIVE_STATUS_VLV		(1 << 28)
+#define   DPB_HOTPLUG_LIVE_STATUS_VLV		(1 << 29)
 #define   DPD_HOTPLUG_INT_STATUS		(3 << 21)
 #define   DPC_HOTPLUG_INT_STATUS		(3 << 19)
 #define   DPB_HOTPLUG_INT_STATUS		(3 << 17)
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 37c6d3f..a671223 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2247,18 +2247,34 @@ g4x_dp_detect(struct intel_dp *intel_dp)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	uint32_t bit;
 
-	switch (intel_dp->output_reg) {
-	case DP_B:
-		bit = DPB_HOTPLUG_LIVE_STATUS;
-		break;
-	case DP_C:
-		bit = DPC_HOTPLUG_LIVE_STATUS;
-		break;
-	case DP_D:
-		bit = DPD_HOTPLUG_LIVE_STATUS;
-		break;
-	default:
-		return connector_status_unknown;
+	if (IS_VALLEYVIEW(dev)) {
+		switch (intel_dp->output_reg) {
+		case DP_B:
+			bit = DPB_HOTPLUG_LIVE_STATUS_VLV;
+			break;
+		case DP_C:
+			bit = DPC_HOTPLUG_LIVE_STATUS_VLV;
+			break;
+		case DP_D:
+			bit = DPD_HOTPLUG_LIVE_STATUS_VLV;
+			break;
+		default:
+			return connector_status_unknown;
+		}
+	} else {
+		switch (intel_dp->output_reg) {
+		case DP_B:
+			bit = DPB_HOTPLUG_LIVE_STATUS_G4X;
+			break;
+		case DP_C:
+			bit = DPC_HOTPLUG_LIVE_STATUS_G4X;
+			break;
+		case DP_D:
+			bit = DPD_HOTPLUG_LIVE_STATUS_G4X;
+			break;
+		default:
+			return connector_status_unknown;
+		}
 	}
 
 	if ((I915_READ(PORT_HOTPLUG_STAT) & bit) == 0)
-- 
1.8.3.2

