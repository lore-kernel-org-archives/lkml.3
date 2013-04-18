Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab3DRJSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:18:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40212 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab3DRJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Egbert Eich <eich@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 43/72] DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
Date: Thu, 18 Apr 2013 10:16:28 +0100
Message-Id: <1366276617-3553-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

commit 5f85f176c2f1c9d2a23f60ca0b99e4d0aa5a26a7 upstream.

NCR machines with LVDS panels using Intel chipsets need to have the
QUIRK_INVERT_BRIGHTNESS bit set.
Unfortunately NCR doesn't set a meaningful subvendor/subdevice ID,
therefore we add a DMI dependent quirk list.

Signed-off-by: Egbert Eich <eich@suse.de>
[danvet: fixup whitespace fail.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 1f06ab4..16c6d6b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6881,6 +6881,34 @@ struct intel_quirk {
 	void (*hook)(struct drm_device *dev);
 };
 
+/* For systems that don't have a meaningful PCI subdevice/subvendor ID */
+struct intel_dmi_quirk {
+	void (*hook)(struct drm_device *dev);
+	const struct dmi_system_id (*dmi_id_list)[];
+};
+
+static int intel_dmi_reverse_brightness(const struct dmi_system_id *id)
+{
+	DRM_INFO("Backlight polarity reversed on %s\n", id->ident);
+	return 1;
+}
+
+static const struct intel_dmi_quirk intel_dmi_quirks[] = {
+	{
+		.dmi_id_list = &(const struct dmi_system_id[]) {
+			{
+				.callback = intel_dmi_reverse_brightness,
+				.ident = "NCR Corporation",
+				.matches = {DMI_MATCH(DMI_SYS_VENDOR, "NCR Corporation"),
+					    DMI_MATCH(DMI_PRODUCT_NAME, ""),
+				},
+			},
+			{ }  /* terminating entry */
+		},
+		.hook = quirk_invert_brightness,
+	},
+};
+
 static struct intel_quirk intel_quirks[] = {
 	/* HP Mini needs pipe A force quirk (LP: #322104) */
 	{ 0x27ae, 0x103c, 0x361a, quirk_pipea_force },
@@ -6929,6 +6957,10 @@ static void intel_init_quirks(struct drm_device *dev)
 		     q->subsystem_device == PCI_ANY_ID))
 			q->hook(dev);
 	}
+	for (i = 0; i < ARRAY_SIZE(intel_dmi_quirks); i++) {
+		if (dmi_check_system(*intel_dmi_quirks[i].dmi_id_list) != 0)
+			intel_dmi_quirks[i].hook(dev);
+	}
 }
 
 /* Disable the VGA plane that we never use */
-- 
1.8.1.2

