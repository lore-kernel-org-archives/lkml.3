Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3DVOpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:45:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51511 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791Ab3DVO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@intel.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Carsten Emde" <C.Emde@osadl.org>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.660811273@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [56/75] drm/i915: panel: invert brightness via parameter
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Carsten Emde <C.Emde@osadl.org>

commit 7bd90909bbf9ce7c40e1da3d72b97b93839c188a upstream.

Following the documentation of the Legacy Backlight Brightness (LBB)
Register in the configuration space of some Intel PCI graphics adapters,
setting the LBB register with the value 0x0 causes the backlight to be
turned off, and 0xFF causes the backlight to be set to 100% intensity
(http://download.intel.com/embedded/processors/Whitepaper/324567.pdf).
The Acer Aspire 5734Z, however, turns the backlight off at 0xFF and sets
it to maximum intensity at 0. In consequence, the screen of this systems
becomes dark at an early boot stage which makes it unusable. The same
inversion applies to the BLC_PWM_CTL I915 register. This problem was
introduced in kernel version 2.6.38 when the PCI device of this system
was first supported by the i915 KMS module.

This patch adds a parameter to the i915 module to enable inversion of
the brightness variable (i915.invert_brightness).

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 drivers/gpu/drm/i915/intel_panel.c  |   17 +++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -948,6 +948,15 @@ bytes respectively. Such letter suffixes
 	i8k.restricted	[HW] Allow controlling fans only if SYS_ADMIN
 			capability is set.
 
+	i915.invert_brightness
+			[DRM] Invert the sense of the variable that is used to
+			set the brightness of the panel backlight. Normally a
+			value of 0 indicates backlight switched off, and the
+			maximum value sets the backlight to maximum brightness.
+			If this parameter is specified, a value of 0 sets the
+			backlight to maximum brightness, and the maximum value
+			switches the backlight off.
+
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -28,6 +28,7 @@
  *      Chris Wilson <chris@chris-wilson.co.uk>
  */
 
+#include <linux/moduleparam.h>
 #include "intel_drv.h"
 
 #define PCI_LBPC 0xf4 /* legacy/combination backlight modes */
@@ -191,6 +192,20 @@ u32 intel_panel_get_max_backlight(struct
 	return max;
 }
 
+static bool i915_panel_invert_brightness;
+MODULE_PARM_DESC(invert_brightness, "Invert backlight brightness, please "
+	"report PCI device ID, subsystem vendor and subsystem device ID "
+	"to dri-devel@lists.freedesktop.org, if your machine needs it. "
+	"It will then be included in an upcoming module version.");
+module_param_named(invert_brightness, i915_panel_invert_brightness, bool, 0600);
+static u32 intel_panel_compute_brightness(struct drm_device *dev, u32 val)
+{
+	if (i915_panel_invert_brightness)
+		return intel_panel_get_max_backlight(dev) - val;
+
+	return val;
+}
+
 u32 intel_panel_get_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -211,6 +226,7 @@ u32 intel_panel_get_backlight(struct drm
 		}
 	}
 
+	val = intel_panel_compute_brightness(dev, val);
 	DRM_DEBUG_DRIVER("get backlight PWM = %d\n", val);
 	return val;
 }
@@ -228,6 +244,7 @@ static void intel_panel_actually_set_bac
 	u32 tmp;
 
 	DRM_DEBUG_DRIVER("set backlight PWM = %d\n", level);
+	level = intel_panel_compute_brightness(dev, level);
 
 	if (HAS_PCH_SPLIT(dev))
 		return intel_pch_panel_set_backlight(dev, level);

