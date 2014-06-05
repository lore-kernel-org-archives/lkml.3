Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaFEEdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:33:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaFEEWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Egbert Eich <eich@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 176/214] DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
Date: Wed,  4 Jun 2014 21:18:59 -0700
Message-Id: <20140605041703.210037395@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Acked-by: Jani Nikula <jani.nikula@intel.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Add #include <linux/dmi.h>]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/cpufreq.h>
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/i2c.h>
@@ -9217,6 +9218,34 @@ struct intel_quirk {
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
 struct intel_quirk intel_quirks[] = {
 	/* HP Mini needs pipe A force quirk (LP: #322104) */
 	{ 0x27ae, 0x103c, 0x361a, quirk_pipea_force },
@@ -9276,6 +9305,10 @@ static void intel_init_quirks(struct drm
 		     q->subsystem_device == PCI_ANY_ID))
 			q->hook(dev);
 	}
+	for (i = 0; i < ARRAY_SIZE(intel_dmi_quirks); i++) {
+		if (dmi_check_system(*intel_dmi_quirks[i].dmi_id_list) != 0)
+			intel_dmi_quirks[i].hook(dev);
+	}
 }
 
 /* Disable the VGA plane that we never use */


