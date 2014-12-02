Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbaLBTUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:20:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46429 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaLBTUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 005/121] drm/i915, HD-audio: Don't continue probing when nomodeset is given
Date: Tue,  2 Dec 2014 11:18:04 -0800
Message-Id: <1417548000-1794-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 74b0c2d75fb4cc89173944e6d8f9eb47aca0c343 upstream.

When a machine is booted with nomodeset option, i915 driver skips the
whole initialization.  Meanwhile, HD-audio tries to bind wth i915 just
by request_symbol() without knowing that the initialization was
skipped, and eventually it hits WARN_ON() in i915_request_power_well()
and i915_release_power_well() wrongly but still continues probing,
even though it doesn't work at all.

In this patch, both functions are changed to return an error in case
of uninitialized state instead of WARN_ON(), so that HD-audio driver
can give up HDMI controller initialization at the right time.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 14 ++++++++------
 include/drm/i915_powerwell.h    |  4 ++--
 sound/pci/hda/hda_i915.c        | 12 ++++++------
 sound/pci/hda/hda_i915.h        |  4 ++--
 sound/pci/hda/hda_intel.c       |  7 ++++++-
 5 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 1218c44..839e581 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5849,12 +5849,12 @@ void intel_display_power_put(struct drm_device *dev,
 static struct i915_power_domains *hsw_pwr;
 
 /* Display audio driver power well request */
-void i915_request_power_well(void)
+int i915_request_power_well(void)
 {
 	struct drm_i915_private *dev_priv;
 
-	if (WARN_ON(!hsw_pwr))
-		return;
+	if (!hsw_pwr)
+		return -ENODEV;
 
 	dev_priv = container_of(hsw_pwr, struct drm_i915_private,
 				power_domains);
@@ -5862,16 +5862,17 @@ void i915_request_power_well(void)
 	mutex_lock(&hsw_pwr->lock);
 	__intel_power_well_get(dev_priv->dev, &hsw_pwr->power_wells[0]);
 	mutex_unlock(&hsw_pwr->lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(i915_request_power_well);
 
 /* Display audio driver power well release */
-void i915_release_power_well(void)
+int i915_release_power_well(void)
 {
 	struct drm_i915_private *dev_priv;
 
-	if (WARN_ON(!hsw_pwr))
-		return;
+	if (!hsw_pwr)
+		return -ENODEV;
 
 	dev_priv = container_of(hsw_pwr, struct drm_i915_private,
 				power_domains);
@@ -5879,6 +5880,7 @@ void i915_release_power_well(void)
 	mutex_lock(&hsw_pwr->lock);
 	__intel_power_well_put(dev_priv->dev, &hsw_pwr->power_wells[0]);
 	mutex_unlock(&hsw_pwr->lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(i915_release_power_well);
 
diff --git a/include/drm/i915_powerwell.h b/include/drm/i915_powerwell.h
index cfdc884..2baba99 100644
--- a/include/drm/i915_powerwell.h
+++ b/include/drm/i915_powerwell.h
@@ -30,7 +30,7 @@
 #define _I915_POWERWELL_H_
 
 /* For use by hda_i915 driver */
-extern void i915_request_power_well(void);
-extern void i915_release_power_well(void);
+extern int i915_request_power_well(void);
+extern int i915_release_power_well(void);
 
 #endif				/* _I915_POWERWELL_H_ */
diff --git a/sound/pci/hda/hda_i915.c b/sound/pci/hda/hda_i915.c
index 76c13d5..3ea8b98 100644
--- a/sound/pci/hda/hda_i915.c
+++ b/sound/pci/hda/hda_i915.c
@@ -22,20 +22,20 @@
 #include <drm/i915_powerwell.h>
 #include "hda_i915.h"
 
-static void (*get_power)(void);
-static void (*put_power)(void);
+static int (*get_power)(void);
+static int (*put_power)(void);
 
-void hda_display_power(bool enable)
+int hda_display_power(bool enable)
 {
 	if (!get_power || !put_power)
-		return;
+		return -ENODEV;
 
 	snd_printdd("HDA display power %s \n",
 			enable ? "Enable" : "Disable");
 	if (enable)
-		get_power();
+		return get_power();
 	else
-		put_power();
+		return put_power();
 }
 
 int hda_i915_init(void)
diff --git a/sound/pci/hda/hda_i915.h b/sound/pci/hda/hda_i915.h
index 5a63da2..bfd835f 100644
--- a/sound/pci/hda/hda_i915.h
+++ b/sound/pci/hda/hda_i915.h
@@ -17,11 +17,11 @@
 #define __SOUND_HDA_I915_H
 
 #ifdef CONFIG_SND_HDA_I915
-void hda_display_power(bool enable);
+int hda_display_power(bool enable);
 int hda_i915_init(void);
 int hda_i915_exit(void);
 #else
-static inline void hda_display_power(bool enable) {}
+static inline int hda_display_power(bool enable) { return 0; }
 static inline int hda_i915_init(void)
 {
 	return -ENODEV;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index f319b8c..3066ba0 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3903,8 +3903,13 @@ static int azx_probe_continue(struct azx *chip)
 			snd_printk(KERN_ERR SFX "Error request power-well from i915\n");
 			goto out_free;
 		}
+		err = hda_display_power(true);
+		if (err < 0) {
+			dev_err(chip->card->dev,
+				"Cannot turn on display power on i915\n");
+			goto out_free;
+		}
 #endif
-		hda_display_power(true);
 	}
 
 	err = azx_first_init(chip);
-- 
1.9.1

