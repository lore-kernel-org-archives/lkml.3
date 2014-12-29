Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaL2BSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:18:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33148 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Francois Tigeot" <ftigeot@wolfpond.org>,
        "Alexey Orishko" <alexey.orishko@gmail.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Jani Nikula" <jani.nikula@intel.com>,
        "Daniel Vetter" <daniel.vetter@intel.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.856094403@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 01/27] drm/i915: Unlock panel even when LVDS is disabled
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context; comment was duplicated]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -914,6 +914,18 @@ bool intel_lvds_init(struct drm_device *
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
+
 	/* Skip init on machines we know falsely report LVDS */
 	if (dmi_check_system(intel_no_lvds))
 		return false;
@@ -1088,19 +1100,6 @@ out:
 		pwm = I915_READ(BLC_PWM_PCH_CTL1);
 		pwm |= PWM_PCH_ENABLE;
 		I915_WRITE(BLC_PWM_PCH_CTL1, pwm);
-		/*
-		 * Unlock registers and just
-		 * leave them unlocked
-		 */
-		I915_WRITE(PCH_PP_CONTROL,
-			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
-	} else {
-		/*
-		 * Unlock registers and just
-		 * leave them unlocked
-		 */
-		I915_WRITE(PP_CONTROL,
-			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
 	}
 	dev_priv->lid_notifier.notifier_call = intel_lid_notify;
 	if (acpi_lid_notifier_register(&dev_priv->lid_notifier)) {

