Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaLOTd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:33:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaLOTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:33:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Orishko <alexey.orishko@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Francois Tigeot <ftigeot@wolfpond.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 73/96] drm/i915: Unlock panel even when LVDS is disabled
Date: Mon, 15 Dec 2014 11:26:33 -0800
Message-Id: <1418671616-25482-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b0616c5306b342ceca07044dbc4f917d95c4f825 upstream.

Otherwise we'll have backtraces in assert_panel_unlocked because the
BIOS locks the register. In the reporter's case this regression was
introduced in

commit c31407a3672aaebb4acddf90944a114fa5c8af7b
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Oct 18 21:07:01 2012 +0100

    drm/i915: Add no-lvds quirk for Supermicro X7SPA-H

Reported-by: Alexey Orishko <alexey.orishko@gmail.com>
Cc: Alexey Orishko <alexey.orishko@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Francois Tigeot <ftigeot@wolfpond.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Tested-by: Alexey Orishko <alexey.orishko@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index b76a0be..a837510 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -945,6 +945,17 @@ void intel_lvds_init(struct drm_device *dev)
 	int pipe;
 	u8 pin;
 
+	/*
+	 * Unlock registers and just leave them unlocked. Do this before
+	 * checking quirk lists to avoid bogus WARNINGs.
+	 */
+	if (HAS_PCH_SPLIT(dev)) {
+		I915_WRITE(PCH_PP_CONTROL,
+			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
+	} else {
+		I915_WRITE(PP_CONTROL,
+			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
+	}
 	if (!intel_lvds_supported(dev))
 		return;
 
@@ -1124,17 +1135,6 @@ out:
 	DRM_DEBUG_KMS("detected %s-link lvds configuration\n",
 		      lvds_encoder->is_dual_link ? "dual" : "single");
 
-	/*
-	 * Unlock registers and just
-	 * leave them unlocked
-	 */
-	if (HAS_PCH_SPLIT(dev)) {
-		I915_WRITE(PCH_PP_CONTROL,
-			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
-	} else {
-		I915_WRITE(PP_CONTROL,
-			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
-	}
 	lvds_connector->lid_notifier.notifier_call = intel_lid_notify;
 	if (acpi_lid_notifier_register(&lvds_connector->lid_notifier)) {
 		DRM_DEBUG_KMS("lid notifier registration failed\n");
-- 
1.9.1

