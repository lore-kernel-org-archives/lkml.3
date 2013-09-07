Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3IGKFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 06:05:05 -0400
Received: from mail.kaapeli.fi ([212.16.172.147]:39185 "EHLO mail.kaapeli.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab3IGKFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 06:05:03 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Sep 2013 06:05:02 EDT
Message-ID: <522AF89A.80505@iki.fi>
Date: Sat, 07 Sep 2013 12:57:46 +0300
From: Jyrki Kuoppala <jkp@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>
CC: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Patch for quirking Asus tx300 and others incorrect edp bpp value
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against Linus' latest git, fixing bug 59841 reported at 
https://bugzilla.kernel.org/show_bug.cgi?id=59841

The Intel HD Graphics 4000 PCI display controller id 0x0166 appears to 
return an incorrect edp bpp value 16 instead of the correct 24. This 
patch adds a quirk for the controller.

Date: Sat, 7 Sep 2013 12:18:31 +0300
Subject: [PATCH] i915: add quirk to ignore incorrect edp_bpp value on Asus
  TX300 and others


Signed-off-by: Jyrki Kuoppala <jkp@iki.fi>
---
  drivers/gpu/drm/i915/i915_drv.h      |  1 +
  drivers/gpu/drm/i915/intel_display.c | 16 ++++++++++++++++
  drivers/gpu/drm/i915/intel_dp.c      |  3 ++-
  3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h 
b/drivers/gpu/drm/i915/i915_drv.h
index 52a3785..3784be1 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -651,6 +651,7 @@ enum intel_sbi_destination {
  #define QUIRK_LVDS_SSC_DISABLE (1<<1)
  #define QUIRK_INVERT_BRIGHTNESS (1<<2)
  #define QUIRK_NO_PCH_PWM_ENABLE (1<<3)
+#define QUIRK_IGNORE_EDP_BPP (1<<4)

  struct intel_fbdev;
  struct intel_fbc_work;
diff --git a/drivers/gpu/drm/i915/intel_display.c 
b/drivers/gpu/drm/i915/intel_display.c
index 38452d8..2a8cec3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9907,6 +9907,17 @@ static void quirk_no_pcm_pwm_enable(struct 
drm_device *dev)
      DRM_INFO("applying no-PCH_PWM_ENABLE quirk\n");
  }

+/*
+ * Some machines (e.g. Asus TX300) incorrectly return 18bpp in UEFI mode
+ * from vbe edp data
+ */
+static void quirk_no_edp_bpp_enable(struct drm_device *dev)
+{
+    struct drm_i915_private *dev_priv = dev->dev_private;
+    dev_priv->quirks |= QUIRK_IGNORE_EDP_BPP;
+    DRM_INFO("applying IGNORE_EDP_BPP quirk\n");
+}
+
  struct intel_quirk {
      int device;
      int subsystem_vendor;
@@ -9981,6 +9992,11 @@ static struct intel_quirk intel_quirks[] = {
      { 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
      /* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
      { 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },
+
+    /* at least Asus TX300 (0x1042 0x15b7),
+       UX32VD (0x1042 0x1507), Dell XPS13 and Toshiba Kirabook,
+       see https://bugzilla.kernel.org/show_bug.cgi?id=59841 */
+    { 0x0166, PCI_ANY_ID, PCI_ANY_ID, quirk_no_edp_bpp_enable },
  };

  static void intel_init_quirks(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/intel_dp.c 
b/drivers/gpu/drm/i915/intel_dp.c
index 2151d13..0e0fc37 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -731,7 +731,8 @@ intel_dp_compute_config(struct intel_encoder *encoder,
      /* Walk through all bpp values. Luckily they're all nicely spaced 
with 2
       * bpc in between. */
      bpp = pipe_config->pipe_bpp;
-    if (is_edp(intel_dp) && dev_priv->vbt.edp_bpp) {
+    if (is_edp(intel_dp) && dev_priv->vbt.edp_bpp
+        && !(dev_priv->quirks & QUIRK_IGNORE_EDP_BPP)) {
          DRM_DEBUG_KMS("clamping bpp for eDP panel to BIOS-provided %i\n",
                    dev_priv->vbt.edp_bpp);
          bpp = min_t(int, bpp, dev_priv->vbt.edp_bpp);
-- 
1.8.1.2


