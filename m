Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3GSWCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 18:02:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42125 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3GSWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 18:02:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH] drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight
Date: Fri, 19 Jul 2013 15:02:01 -0700
Message-Id: <1374271321-7907-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=47941
BugLink: https://bugs.launchpad.net/bugs/1163720
BugLink: https://bugs.launchpad.net/bugs/1162026

Some machines suffer from non-functional backlight controls if
BLM_PCH_PWM_ENABLE is set, so provide a quirk to avoid doing so.
Apply this quirk to Dell XPS 13 models.

Tested-by: Eric Griffith <EGriffith92@gmail.com>
Tested-by: Kent Baxley <kent.baxley@canonical.com>
Cc: <stable@vger.kernel.org> # v3.8+
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.h      |  1 +
 drivers/gpu/drm/i915/intel_display.c | 16 ++++++++++++++++
 drivers/gpu/drm/i915/intel_panel.c   |  3 ++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index a416645..204c3ec 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -555,6 +555,7 @@ enum intel_sbi_destination {
 #define QUIRK_PIPEA_FORCE (1<<0)
 #define QUIRK_LVDS_SSC_DISABLE (1<<1)
 #define QUIRK_INVERT_BRIGHTNESS (1<<2)
+#define QUIRK_NO_PCH_PWM_ENABLE (1<<3)
 
 struct intel_fbdev;
 struct intel_fbc_work;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 85f3eb7..42e207e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9398,6 +9398,17 @@ static void quirk_invert_brightness(struct drm_device *dev)
 	DRM_INFO("applying inverted panel brightness quirk\n");
 }
 
+/*
+ * Some machines (Dell XPS13) suffer broken backlight controls if
+ * BLM_PCH_PWM_ENABLE is set.
+ */
+static void quirk_no_pcm_pwm_enable(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	dev_priv->quirks |= QUIRK_NO_PCH_PWM_ENABLE;
+	DRM_INFO("applying no-PCH_PWM_ENABLE quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -9467,6 +9478,11 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer Aspire 4736Z */
 	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
+
+	/* Dell XPS13 HD Sandy Bridge */
+	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
+	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
+	{ 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 80bea1d..01b5a51 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -580,7 +580,8 @@ void intel_panel_enable_backlight(struct drm_device *dev,
 		POSTING_READ(reg);
 		I915_WRITE(reg, tmp | BLM_PWM_ENABLE);
 
-		if (HAS_PCH_SPLIT(dev)) {
+		if (HAS_PCH_SPLIT(dev) &&
+		    !(dev_priv->quirks & QUIRK_NO_PCH_PWM_ENABLE)) {
 			tmp = I915_READ(BLC_PWM_PCH_CTL1);
 			tmp |= BLM_PCH_PWM_ENABLE;
 			tmp &= ~BLM_PCH_OVERRIDE_ENABLE;
-- 
1.8.1.2

