Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaLNUbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:31:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLNUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Orishko <alexey.orishko@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Francois Tigeot <ftigeot@wolfpond.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.17 19/47] drm/i915: Unlock panel even when LVDS is disabled
Date: Sun, 14 Dec 2014 12:20:54 -0800
Message-Id: <20141214201819.208437379@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -900,6 +900,17 @@ void intel_lvds_init(struct drm_device *
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
 
@@ -1098,17 +1109,6 @@ out:
 	lvds_encoder->a3_power = I915_READ(lvds_encoder->reg) &
 				 LVDS_A3_POWER_MASK;
 
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


