Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbaLBT7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:59:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaLBTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 007/121] ALSA: hda - restore BCLK M/N value as per CDCLK for HSW/BDW display HDA controller
Date: Tue,  2 Dec 2014 11:18:06 -0800
Message-Id: <1417548000-1794-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengdong Lin <mengdong.lin@intel.com>

commit e4d9e513dedb5ac4e166c1053314fa935ddecc8c upstream.

For HSW/BDW display HD-A controller, hda_set_bclk() is defined to set BCLK
by programming the M/N values as per the core display clock (CDCLK) queried from
i915 display driver.

And the audio driver will also set BCLK in azx_first_init() since the display
driver can turn off the shared power in boot phase if only eDP is connected
and M/N values will be lost and must be reprogrammed.

Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
[ 3.13-stable: takashi's backport for 3.{12,13} ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_i915.c  | 16 +++++++++++++
 sound/pci/hda/hda_i915.h  |  2 ++
 sound/pci/hda/hda_intel.c | 60 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_i915.c b/sound/pci/hda/hda_i915.c
index 3ea8b98..9e136be 100644
--- a/sound/pci/hda/hda_i915.c
+++ b/sound/pci/hda/hda_i915.c
@@ -24,6 +24,7 @@
 
 static int (*get_power)(void);
 static int (*put_power)(void);
+static int (*get_cdclk)(void);
 
 int hda_display_power(bool enable)
 {
@@ -38,6 +39,13 @@ int hda_display_power(bool enable)
 		return put_power();
 }
 
+int haswell_get_cdclk(void)
+{
+	if (!get_cdclk)
+		return -EINVAL;
+	return get_cdclk();
+}
+
 int hda_i915_init(void)
 {
 	int err = 0;
@@ -55,6 +63,10 @@ int hda_i915_init(void)
 		return -ENODEV;
 	}
 
+	get_cdclk = symbol_request(i915_get_cdclk_freq);
+	if (!get_cdclk)	/* may have abnormal BCLK and audio playback rate */
+		snd_printd("hda-i915: get_cdclk symbol get fail\n");
+
 	snd_printd("HDA driver get symbol successfully from i915 module\n");
 
 	return err;
@@ -70,6 +82,10 @@ int hda_i915_exit(void)
 		symbol_put(i915_release_power_well);
 		put_power = NULL;
 	}
+	if (get_cdclk) {
+		symbol_put(i915_get_cdclk_freq);
+		get_cdclk = NULL;
+	}
 
 	return 0;
 }
diff --git a/sound/pci/hda/hda_i915.h b/sound/pci/hda/hda_i915.h
index bfd835f..26869fa 100644
--- a/sound/pci/hda/hda_i915.h
+++ b/sound/pci/hda/hda_i915.h
@@ -18,10 +18,12 @@
 
 #ifdef CONFIG_SND_HDA_I915
 int hda_display_power(bool enable);
+int haswell_get_cdclk(void);
 int hda_i915_init(void);
 int hda_i915_exit(void);
 #else
 static inline int hda_display_power(bool enable) { return 0; }
+static inline int haswell_get_cdclk(void) { return -EINVAL; }
 static inline int hda_i915_init(void)
 {
 	return -ENODEV;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 3066ba0..a7431d6 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -748,6 +748,54 @@ static inline void mark_runtime_wc(struct azx *chip, struct azx_dev *azx_dev,
 }
 #endif
 
+#ifdef CONFIG_SND_HDA_I915
+/* Intel HSW/BDW display HDA controller Extended Mode registers.
+ * EM4 (M value) and EM5 (N Value) are used to convert CDClk (Core Display
+ * Clock) to 24MHz BCLK: BCLK = CDCLK * M / N
+ * The values will be lost when the display power well is disabled.
+ */
+#define ICH6_REG_EM4			0x100c
+#define ICH6_REG_EM5			0x1010
+
+static void haswell_set_bclk(struct azx *chip)
+{
+	int cdclk_freq;
+	unsigned int bclk_m, bclk_n;
+
+	cdclk_freq = haswell_get_cdclk();
+	if (cdclk_freq < 0)
+		return;
+
+	switch (cdclk_freq) {
+	case 337500:
+		bclk_m = 16;
+		bclk_n = 225;
+		break;
+
+	case 450000:
+	default: /* default CDCLK 450MHz */
+		bclk_m = 4;
+		bclk_n = 75;
+		break;
+
+	case 540000:
+		bclk_m = 4;
+		bclk_n = 90;
+		break;
+
+	case 675000:
+		bclk_m = 8;
+		bclk_n = 225;
+		break;
+	}
+
+	azx_writew(chip, EM4, bclk_m);
+	azx_writew(chip, EM5, bclk_n);
+}
+#else
+static inline void haswell_set_bclk(struct azx *chip) {}
+#endif
+
 static int azx_acquire_irq(struct azx *chip, int do_disconnect);
 static int azx_send_cmd(struct hda_bus *bus, unsigned int val);
 /*
@@ -2951,8 +2999,10 @@ static int azx_resume(struct device *dev)
 	if (chip->disabled || chip->init_failed)
 		return 0;
 
-	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
+	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
 		hda_display_power(true);
+		haswell_set_bclk(chip);
+	}
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
 	if (pci_enable_device(pci) < 0) {
@@ -3015,8 +3065,10 @@ static int azx_runtime_resume(struct device *dev)
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
 		return 0;
 
-	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
+	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
 		hda_display_power(true);
+		haswell_set_bclk(chip);
+	}
 
 	/* Read STATESTS before controller reset */
 	status = azx_readw(chip, STATESTS);
@@ -3744,6 +3796,10 @@ static int azx_first_init(struct azx *chip)
 
 	/* initialize chip */
 	azx_init_pci(chip);
+
+	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
+		haswell_set_bclk(chip);
+
 	azx_init_chip(chip, (probe_only[dev] & 2) == 0);
 
 	/* codec detection */
-- 
1.9.1

