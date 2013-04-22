Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3DVOqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:46:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51484 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab3DVO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@intel.com>,
        "Egbert Eich" <eich@suse.de>, "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.273946242@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [59/75] DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 drivers/gpu/drm/i915/intel_display.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/cpufreq.h>
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/i2c.h>
@@ -8848,6 +8849,34 @@ struct intel_quirk {
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
 	/* HP Compaq 2730p needs pipe A force quirk (LP: #291555) */
 	{ 0x2a42, 0x103c, 0x30eb, quirk_pipea_force },
@@ -8895,6 +8924,10 @@ static void intel_init_quirks(struct drm
 		     q->subsystem_device == PCI_ANY_ID))
 			q->hook(dev);
 	}
+	for (i = 0; i < ARRAY_SIZE(intel_dmi_quirks); i++) {
+		if (dmi_check_system(*intel_dmi_quirks[i].dmi_id_list) != 0)
+			intel_dmi_quirks[i].hook(dev);
+	}
 }
 
 /* Disable the VGA plane that we never use */

