Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab3IDSYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:24:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3IDSYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:24:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH] drm/i915: i915.quirks_set/quirks_mask overrides dmi match
Date: Wed,  4 Sep 2013 11:23:55 -0700
Message-Id: <1378319035-10997-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot params quirks_set and quirks_mask allow the user to enable or
inhibit any dmi-matched quirks, overriding the dmi match table.  Examples:

  i915.quirks_set=0x2   - enables QUIRK_LVDS_SSC_DISABLE
  i915.quirks_set=0x8   - enables QUIRK_NO_PCH_PWM_ENABLE
  i915.quirks_mask=0x8  - disables QUIRK_NO_PCH_PWM_ENABLE
  i915.quirks_mask=0xFF - disables all quirks

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/intel_display.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d88057e..a6af11c 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10028,8 +10028,19 @@ static struct intel_quirk intel_quirks[] = {
 	{ 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },
 };
 
+unsigned long i915_quirks_set __read_mostly = 0;
+module_param_named(quirks_set, i915_quirks_set, ulong, 0600);
+MODULE_PARM_DESC(quirks_set,
+		"Enable specified quirks bits.");
+
+unsigned long i915_quirks_mask __read_mostly = 0;
+module_param_named(quirks_mask, i915_quirks_mask, ulong, 0600);
+MODULE_PARM_DESC(quirks_mask,
+		"Disable specified quirks bits (override dmi match).");
+
 static void intel_init_quirks(struct drm_device *dev)
 {
+	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct pci_dev *d = dev->pdev;
 	int i;
 
@@ -10047,6 +10058,10 @@ static void intel_init_quirks(struct drm_device *dev)
 		if (dmi_check_system(*intel_dmi_quirks[i].dmi_id_list) != 0)
 			intel_dmi_quirks[i].hook(dev);
 	}
+
+	/* handle user-specified quirks overrides */
+	dev_priv->quirks |= i915_quirks_set;
+	dev_priv->quirks &= ~i915_quirks_mask;
 }
 
 /* Disable the VGA plane that we never use */
-- 
1.8.1.2

