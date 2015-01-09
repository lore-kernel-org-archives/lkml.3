Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbbAIKed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:34:33 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44628 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757522AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alexey Orishko <alexey.orishko@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Francois Tigeot <ftigeot@wolfpond.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 25/78] drm/i915: Unlock panel even when LVDS is disabled
Date: Fri,  9 Jan 2015 11:31:34 +0100
Message-Id: <aa4e539e52e4a364cc599b69240c473fd6e9f445.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_lvds.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 667f2117e1d9..e5473daab676 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -934,6 +934,17 @@ void intel_lvds_init(struct drm_device *dev)
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
 
@@ -1113,17 +1124,6 @@ out:
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
2.2.1

