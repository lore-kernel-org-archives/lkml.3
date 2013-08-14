Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab3HNKy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:54:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3HNKhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 24/75] drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight
Date: Wed, 14 Aug 2013 11:36:13 +0100
Message-Id: <1376476624-10011-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

commit e85843bec6c2ea7c10ec61238396891cc2b753a9 upstream.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=47941
BugLink: https://bugs.launchpad.net/bugs/1163720
BugLink: https://bugs.launchpad.net/bugs/1162026

Some machines suffer from non-functional backlight controls if
BLM_PCH_PWM_ENABLE is set, so provide a quirk to avoid doing so.
Apply this quirk to Dell XPS 13 models.

Tested-by: Eric Griffith <EGriffith92@gmail.com>
Tested-by: Kent Baxley <kent.baxley@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.5 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.h      |  1 +
 drivers/gpu/drm/i915/intel_display.c | 16 ++++++++++++++++
 drivers/gpu/drm/i915/intel_lvds.c    |  3 ++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index d85db22..bb95eda 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -329,6 +329,7 @@ enum intel_pch {
 #define QUIRK_PIPEA_FORCE (1<<0)
 #define QUIRK_LVDS_SSC_DISABLE (1<<1)
 #define QUIRK_INVERT_BRIGHTNESS (1<<2)
+#define QUIRK_NO_PCH_PWM_ENABLE (1<<3)
 
 struct intel_fbdev;
 struct intel_fbc_work;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 290d89d..05f75ff 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6874,6 +6874,17 @@ static void quirk_invert_brightness(struct drm_device *dev)
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
@@ -6949,6 +6960,11 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer/Packard Bell NCL20 */
 	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
+
+	/* Dell XPS13 HD Sandy Bridge */
+	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
+	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
+	{ 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index d18c49a..440ed88 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -1097,7 +1097,8 @@ bool intel_lvds_init(struct drm_device *dev)
 		goto failed;
 
 out:
-	if (HAS_PCH_SPLIT(dev)) {
+	if (HAS_PCH_SPLIT(dev) &&
+	    !(dev_priv->quirks & QUIRK_NO_PCH_PWM_ENABLE)) {
 		u32 pwm;
 
 		pipe = (I915_READ(PCH_LVDS) & LVDS_PIPEB_SELECT) ? 1 : 0;
-- 
1.8.3.2

