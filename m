Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663Ab3IHDVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab3IHDS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kent Baxley" <kent.baxley@canonical.com>,
        "Eric Griffith" <EGriffith92@gmail.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Kamal Mostafa" <kamal@canonical.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.109140456@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [005/121] drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.2 ]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_drv.h      |  1 +
 drivers/gpu/drm/i915/intel_display.c | 16 ++++++++++++++++
 drivers/gpu/drm/i915/intel_lvds.c    |  3 ++-
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -275,6 +275,7 @@ enum intel_pch {
 #define QUIRK_PIPEA_FORCE (1<<0)
 #define QUIRK_LVDS_SSC_DISABLE (1<<1)
 #define QUIRK_INVERT_BRIGHTNESS (1<<2)
+#define QUIRK_NO_PCH_PWM_ENABLE (1<<3)
 
 struct intel_fbdev;
 struct intel_fbc_work;
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8842,6 +8842,17 @@ static void quirk_invert_brightness(stru
 	dev_priv->quirks |= QUIRK_INVERT_BRIGHTNESS;
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
@@ -8916,6 +8927,11 @@ struct intel_quirk intel_quirks[] = {
 
 	/* Acer/Packard Bell NCL20 */
 	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
+
+	/* Dell XPS13 HD Sandy Bridge */
+	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
+	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
+	{ 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -1075,7 +1075,8 @@ bool intel_lvds_init(struct drm_device *
 		goto failed;
 
 out:
-	if (HAS_PCH_SPLIT(dev)) {
+	if (HAS_PCH_SPLIT(dev) &&
+	    !(dev_priv->quirks & QUIRK_NO_PCH_PWM_ENABLE)) {
 		u32 pwm;
 
 		pipe = (I915_READ(PCH_LVDS) & LVDS_PIPEB_SELECT) ? 1 : 0;

