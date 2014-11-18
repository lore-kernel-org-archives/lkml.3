Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaKRP3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:29:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbaKROJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/206] drm/i915, HD-audio: Don't continue probing when nomodeset is given
Date: Tue, 18 Nov 2014 15:05:59 +0100
Message-Id: <fcb1eed7baee724ca62f157df7684e99edd4145a.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: <stable@vger.kernel.org> [3.15]
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_pm.c | 15 +++++++++------
 include/drm/i915_powerwell.h    |  4 ++--
 sound/pci/hda/hda_i915.c        | 12 ++++++------
 sound/pci/hda/hda_i915.h        |  4 ++--
 sound/pci/hda/hda_intel.c       |  6 +++++-
 5 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 71a831ae73e9..aa99bb61778c 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5347,24 +5347,26 @@ static void __intel_set_power_well(struct drm_device *dev, bool enable)
 static struct i915_power_well *hsw_pwr;
 
 /* Display audio driver power well request */
-void i915_request_power_well(void)
+int i915_request_power_well(void)
 {
-	if (WARN_ON(!hsw_pwr))
-		return;
+	if (!hsw_pwr)
+		return -ENODEV;
 
 	spin_lock_irq(&hsw_pwr->lock);
 	if (!hsw_pwr->count++ &&
 			!hsw_pwr->i915_request)
 		__intel_set_power_well(hsw_pwr->device, true);
 	spin_unlock_irq(&hsw_pwr->lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(i915_request_power_well);
 
 /* Display audio driver power well release */
-void i915_release_power_well(void)
+int i915_release_power_well(void)
 {
-	if (WARN_ON(!hsw_pwr))
-		return;
+	if (!hsw_pwr)
+		return -ENODEV;
+
 
 	spin_lock_irq(&hsw_pwr->lock);
 	WARN_ON(!hsw_pwr->count);
@@ -5372,6 +5374,7 @@ void i915_release_power_well(void)
 		       !hsw_pwr->i915_request)
 		__intel_set_power_well(hsw_pwr->device, false);
 	spin_unlock_irq(&hsw_pwr->lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(i915_release_power_well);
 
diff --git a/include/drm/i915_powerwell.h b/include/drm/i915_powerwell.h
index cfdc884405b7..2baba9996094 100644
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
index 76c13d5b3ca0..3ea8b980460e 100644
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
index 5a63da2c53e5..bfd835f8f1aa 100644
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
index 37806a97c878..3eb2976824a8 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3902,8 +3902,12 @@ static int azx_probe_continue(struct azx *chip)
 			snd_printk(KERN_ERR SFX "Error request power-well from i915\n");
 			goto out_free;
 		}
+		err = hda_display_power(true);
+		if (err < 0) {
+			snd_printk(KERN_ERR SFX "Cannot turn on display power on i915\n");
+			goto out_free;
+		}
 #endif
-		hda_display_power(true);
 	}
 
 	err = azx_first_init(chip);
-- 
2.1.3

