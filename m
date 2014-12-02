Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbaLBTU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:20:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaLBTUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 004/121] Revert "ALSA: hda - restore BCLK M/N values when resuming HSW/BDW display controller"
Date: Tue,  2 Dec 2014 11:18:03 -0800
Message-Id: <1417548000-1794-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

This reverts commit 72f0c0f47341ac4c86132fe7f7338a3122ac1418.

[ kamal: 3.13-stable: to be replaced by Takashi backport ]

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 63 ++++++-----------------------------------------
 1 file changed, 7 insertions(+), 56 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e8de8a3..f319b8c 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -663,22 +663,6 @@ static char *driver_short_names[] = {
 	[AZX_DRIVER_GENERIC] = "HD-Audio Generic",
 };
 
-/* Intel HSW/BDW display HDA controller Extended Mode registers.
- * EM4 (M value) and EM5 (N Value) are used to convert CDClk (Core Display
- * Clock) to 24MHz BCLK: BCLK = CDCLK * M / N
- * The values will be lost when the display power well is disabled.
- */
-#define ICH6_REG_EM4			0x100c
-#define ICH6_REG_EM5			0x1010
-
-struct hda_intel {
-	struct azx chip;
-
-	/* HSW/BDW display HDA controller to restore BCLK from CDCLK */
-	unsigned int bclk_m;
-	unsigned int bclk_n;
-};
-
 /*
  * macros for easy use
  */
@@ -2922,22 +2906,6 @@ static int param_set_xint(const char *val, const struct kernel_param *kp)
 #define azx_del_card_list(chip) /* NOP */
 #endif /* CONFIG_PM */
 
-static void haswell_save_bclk(struct azx *chip)
-{
-	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
-
-	hda->bclk_m = azx_readw(chip, EM4);
-	hda->bclk_n = azx_readw(chip, EM5);
-}
-
-static void haswell_restore_bclk(struct azx *chip)
-{
-	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
-
-	azx_writew(chip, EM4, hda->bclk_m);
-	azx_writew(chip, EM5, hda->bclk_n);
-}
-
 #if defined(CONFIG_PM_SLEEP) || defined(SUPPORT_VGA_SWITCHEROO)
 /*
  * power management
@@ -2964,13 +2932,6 @@ static int azx_suspend(struct device *dev)
 		free_irq(chip->irq, chip);
 		chip->irq = -1;
 	}
-
-	/* Save BCLK M/N values before they become invalid in D3.
-	 * Will test if display power well can be released now.
-	 */
-	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
-		haswell_save_bclk(chip);
-
 	if (chip->msi)
 		pci_disable_msi(chip->pci);
 	pci_disable_device(pci);
@@ -2990,10 +2951,8 @@ static int azx_resume(struct device *dev)
 	if (chip->disabled || chip->init_failed)
 		return 0;
 
-	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
+	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
 		hda_display_power(true);
-		haswell_restore_bclk(chip);
-	}
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
 	if (pci_enable_device(pci) < 0) {
@@ -3037,10 +2996,8 @@ static int azx_runtime_suspend(struct device *dev)
 	azx_stop_chip(chip);
 	azx_enter_link_reset(chip);
 	azx_clear_irq_pending(chip);
-	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
-		haswell_save_bclk(chip);
+	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
 		hda_display_power(false);
-	}
 	return 0;
 }
 
@@ -3058,10 +3015,8 @@ static int azx_runtime_resume(struct device *dev)
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
 		return 0;
 
-	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
+	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
 		hda_display_power(true);
-		haswell_restore_bclk(chip);
-	}
 
 	/* Read STATESTS before controller reset */
 	status = azx_readw(chip, STATESTS);
@@ -3258,8 +3213,6 @@ static int register_vga_switcheroo(struct azx *chip)
 static int azx_free(struct azx *chip)
 {
 	struct pci_dev *pci = chip->pci;
-	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
-
 	int i;
 
 	if ((chip->driver_caps & AZX_DCAPS_PM_RUNTIME)
@@ -3321,7 +3274,7 @@ static int azx_free(struct azx *chip)
 		hda_display_power(false);
 		hda_i915_exit();
 	}
-	kfree(hda);
+	kfree(chip);
 
 	return 0;
 }
@@ -3568,7 +3521,6 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 	static struct snd_device_ops ops = {
 		.dev_free = azx_dev_free,
 	};
-	struct hda_intel *hda;
 	struct azx *chip;
 	int err;
 
@@ -3578,14 +3530,13 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 	if (err < 0)
 		return err;
 
-	hda = kzalloc(sizeof(*hda), GFP_KERNEL);
-	if (!hda) {
-		snd_printk(KERN_ERR SFX "%s: Cannot allocate hda\n", pci_name(pci));
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip) {
+		snd_printk(KERN_ERR SFX "%s: Cannot allocate chip\n", pci_name(pci));
 		pci_disable_device(pci);
 		return -ENOMEM;
 	}
 
-	chip = &hda->chip;
 	spin_lock_init(&chip->reg_lock);
 	mutex_init(&chip->open_mutex);
 	chip->card = card;
-- 
1.9.1

