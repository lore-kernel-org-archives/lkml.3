Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab3ICRhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:37:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3ICRhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:37:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH] drm/i915: i915.disable_pch_pwm overrides PCH_PWM_ENABLE quirk
Date: Tue,  3 Sep 2013 10:37:28 -0700
Message-Id: <1378229848-29113-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=47941

Some BIOS configurations of Dell XPS13 are adversely affected by e85843b
("drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight") so provide a
boot param to inhibit the quirk, or force it on.

i915.disable_pch_pwm can be set to
 -1: auto (default; allows the disabling of pch_pwm by dmi quirk table match)
  0: inhibits the disabling of pch_pwm (overrides dmi quirk table match)
  1: forces the disabling of pch_pwm

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c      |  4 ++++
 drivers/gpu/drm/i915/i915_drv.h      |  1 +
 drivers/gpu/drm/i915/intel_display.c | 11 ++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 72e2be7..fee05df 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -154,6 +154,10 @@ module_param_named(prefault_disable, i915_prefault_disable, bool, 0600);
 MODULE_PARM_DESC(prefault_disable,
 		"Disable page prefaulting for pread/pwrite/reloc (default:false). For developers only.");
 
+int i915_disable_pch_pwm __read_mostly = -1;
+module_param_named(disable_pch_pwm, i915_disable_pch_pwm, int, 0600);
+MODULE_PARM_DESC(disable_pch_pwm, "disable PCH_PWM (default: -1 (auto))");
+
 static struct drm_driver driver;
 extern int intel_agp_enabled;
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 769c138..e6f2a34 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1726,6 +1726,7 @@ extern bool i915_fastboot __read_mostly;
 extern int i915_enable_pc8 __read_mostly;
 extern int i915_pc8_timeout __read_mostly;
 extern bool i915_prefault_disable __read_mostly;
+extern int i915_disable_pch_pwm __read_mostly;
 
 extern int i915_suspend(struct drm_device *dev, pm_message_t state);
 extern int i915_resume(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 30e5946..86fa722 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9948,9 +9948,8 @@ static void quirk_invert_brightness(struct drm_device *dev)
  */
 static void quirk_no_pcm_pwm_enable(struct drm_device *dev)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	dev_priv->quirks |= QUIRK_NO_PCH_PWM_ENABLE;
-	DRM_INFO("applying no-PCH_PWM_ENABLE quirk\n");
+	if (i915_disable_pch_pwm < 0)
+		i915_disable_pch_pwm = 1;
 }
 
 struct intel_quirk {
@@ -10048,6 +10047,12 @@ static void intel_init_quirks(struct drm_device *dev)
 		if (dmi_check_system(*intel_dmi_quirks[i].dmi_id_list) != 0)
 			intel_dmi_quirks[i].hook(dev);
 	}
+
+	if (i915_disable_pch_pwm == 1) {
+		struct drm_i915_private *dev_priv = dev->dev_private;
+		dev_priv->quirks |= QUIRK_NO_PCH_PWM_ENABLE;
+		DRM_INFO("applying no-PCH_PWM_ENABLE quirk\n");
+	}
 }
 
 /* Disable the VGA plane that we never use */
-- 
1.8.1.2

