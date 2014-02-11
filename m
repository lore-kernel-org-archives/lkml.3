Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaBKT0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:26:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaBKTIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Todd Previte <tprevite@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.10 61/79] drm/i915: VLV2 - Fix hotplug detect bits
Date: Tue, 11 Feb 2014 11:06:05 -0800
Message-Id: <20140211184722.733495063@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |   10 +++++++---
 drivers/gpu/drm/i915/intel_dp.c |   40 ++++++++++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1682,9 +1682,13 @@
  * Please check the detailed lore in the commit message for for experimental
  * evidence.
  */
-#define   PORTD_HOTPLUG_LIVE_STATUS               (1 << 29)
-#define   PORTC_HOTPLUG_LIVE_STATUS               (1 << 28)
-#define   PORTB_HOTPLUG_LIVE_STATUS               (1 << 27)
+#define   PORTD_HOTPLUG_LIVE_STATUS_G4X		(1 << 29)
+#define   PORTC_HOTPLUG_LIVE_STATUS_G4X		(1 << 28)
+#define   PORTB_HOTPLUG_LIVE_STATUS_G4X		(1 << 27)
+/* VLV DP/HDMI bits again match Bspec */
+#define   PORTD_HOTPLUG_LIVE_STATUS_VLV		(1 << 27)
+#define   PORTC_HOTPLUG_LIVE_STATUS_VLV		(1 << 28)
+#define   PORTB_HOTPLUG_LIVE_STATUS_VLV		(1 << 29)
 #define   PORTD_HOTPLUG_INT_STATUS		(3 << 21)
 #define   PORTC_HOTPLUG_INT_STATUS		(3 << 19)
 #define   PORTB_HOTPLUG_INT_STATUS		(3 << 17)
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2277,18 +2277,34 @@ g4x_dp_detect(struct intel_dp *intel_dp)
 		return status;
 	}
 
-	switch (intel_dig_port->port) {
-	case PORT_B:
-		bit = PORTB_HOTPLUG_LIVE_STATUS;
-		break;
-	case PORT_C:
-		bit = PORTC_HOTPLUG_LIVE_STATUS;
-		break;
-	case PORT_D:
-		bit = PORTD_HOTPLUG_LIVE_STATUS;
-		break;
-	default:
-		return connector_status_unknown;
+	if (IS_VALLEYVIEW(dev)) {
+		switch (intel_dig_port->port) {
+		case PORT_B:
+			bit = PORTB_HOTPLUG_LIVE_STATUS_VLV;
+			break;
+		case PORT_C:
+			bit = PORTC_HOTPLUG_LIVE_STATUS_VLV;
+			break;
+		case PORT_D:
+			bit = PORTD_HOTPLUG_LIVE_STATUS_VLV;
+			break;
+		default:
+			return connector_status_unknown;
+		}
+	} else {
+		switch (intel_dig_port->port) {
+		case PORT_B:
+			bit = PORTB_HOTPLUG_LIVE_STATUS_G4X;
+			break;
+		case PORT_C:
+			bit = PORTC_HOTPLUG_LIVE_STATUS_G4X;
+			break;
+		case PORT_D:
+			bit = PORTD_HOTPLUG_LIVE_STATUS_G4X;
+			break;
+		default:
+			return connector_status_unknown;
+		}
 	}
 
 	if ((I915_READ(PORT_HOTPLUG_STAT) & bit) == 0)


