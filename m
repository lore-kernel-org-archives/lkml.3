Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3DVOon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:44:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51509 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab3DVO36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:58 -0400
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
Message-ID: <lsq.1366640759.773266578@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [57/75] drm/i915: panel: invert brightness via quirk
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

commit 4dca20efb1a9c2efefc28ad2867e5d6c3f5e1955 upstream.

A machine may need to invert the panel backlight brightness value. This
patch adds the infrastructure for a quirk to do so.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt  |   17 +++++++++++------
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    9 +++++++++
 drivers/gpu/drm/i915/intel_panel.c   |   15 +++++++++++----
 4 files changed, 32 insertions(+), 10 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -948,14 +948,19 @@ bytes respectively. Such letter suffixes
 	i8k.restricted	[HW] Allow controlling fans only if SYS_ADMIN
 			capability is set.
 
-	i915.invert_brightness
+	i915.invert_brightness=
 			[DRM] Invert the sense of the variable that is used to
 			set the brightness of the panel backlight. Normally a
-			value of 0 indicates backlight switched off, and the
-			maximum value sets the backlight to maximum brightness.
-			If this parameter is specified, a value of 0 sets the
-			backlight to maximum brightness, and the maximum value
-			switches the backlight off.
+			brightness value of 0 indicates backlight switched off,
+			and the maximum of the brightness value sets the backlight
+			to maximum brightness. If this parameter is set to 0
+			(default) and the machine requires it, or this parameter
+			is set to 1, a brightness value of 0 sets the backlight
+			to maximum brightness, and the maximum of the brightness
+			value switches the backlight off.
+			-1 -- never invert brightness
+			 0 -- machine default
+			 1 -- force brightness inversion
 
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -274,6 +274,7 @@ enum intel_pch {
 
 #define QUIRK_PIPEA_FORCE (1<<0)
 #define QUIRK_LVDS_SSC_DISABLE (1<<1)
+#define QUIRK_INVERT_BRIGHTNESS (1<<2)
 
 struct intel_fbdev;
 struct intel_fbc_work;
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8831,6 +8831,15 @@ static void quirk_ssc_force_disable(stru
 	dev_priv->quirks |= QUIRK_LVDS_SSC_DISABLE;
 }
 
+/*
+ * A machine may need to invert the panel backlight brightness value
+ */
+static void quirk_invert_brightness(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	dev_priv->quirks |= QUIRK_INVERT_BRIGHTNESS;
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -192,15 +192,22 @@ u32 intel_panel_get_max_backlight(struct
 	return max;
 }
 
-static bool i915_panel_invert_brightness;
-MODULE_PARM_DESC(invert_brightness, "Invert backlight brightness, please "
+static int i915_panel_invert_brightness;
+MODULE_PARM_DESC(invert_brightness, "Invert backlight brightness "
+	"(-1 force normal, 0 machine defaults, 1 force inversion), please "
 	"report PCI device ID, subsystem vendor and subsystem device ID "
 	"to dri-devel@lists.freedesktop.org, if your machine needs it. "
 	"It will then be included in an upcoming module version.");
-module_param_named(invert_brightness, i915_panel_invert_brightness, bool, 0600);
+module_param_named(invert_brightness, i915_panel_invert_brightness, int, 0600);
 static u32 intel_panel_compute_brightness(struct drm_device *dev, u32 val)
 {
-	if (i915_panel_invert_brightness)
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	if (i915_panel_invert_brightness < 0)
+		return val;
+
+	if (i915_panel_invert_brightness > 0 ||
+	    dev_priv->quirks & QUIRK_INVERT_BRIGHTNESS)
 		return intel_panel_get_max_backlight(dev) - val;
 
 	return val;

