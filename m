Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaJ0TNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:13:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaJ0TDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/105] Input: synaptics - gate forcepad support by DMI check
Date: Mon, 27 Oct 2014 11:57:05 -0700
Message-Id: <1414436240-13879-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit aa972409951e0675e07918620427517cad5090e0 upstream.

Unfortunately, ForcePad capability is not actually exported over PS/2, so
we have to resort to DMI checks.

Reported-by: Nicole Faerber <nicole.faerber@kernelconcepts.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/synaptics.c | 22 +++++++++++++++++++++-
 drivers/input/mouse/synaptics.h |  8 ++------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4b7996e..925e46c 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -538,6 +538,8 @@ static void synaptics_parse_agm(const unsigned char buf[],
 	priv->agm_pending = true;
 }
 
+static bool is_forcepad;
+
 static int synaptics_parse_hw_state(const unsigned char buf[],
 				    struct synaptics_data *priv,
 				    struct synaptics_hw_state *hw)
@@ -567,7 +569,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 
-		if (SYN_CAP_FORCEPAD(priv->ext_cap_0c)) {
+		if (is_forcepad) {
 			/*
 			 * ForcePads, like Clickpads, use middle button
 			 * bits to report primary button clicks.
@@ -1628,6 +1630,18 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 	{ }
 };
 
+static const struct dmi_system_id forcepad_dmi_table[] __initconst = {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook Folio 1040 G1"),
+		},
+	},
+#endif
+	{ }
+};
+
 void __init synaptics_module_init(void)
 {
 	const struct dmi_system_id *min_max_dmi;
@@ -1638,6 +1652,12 @@ void __init synaptics_module_init(void)
 	min_max_dmi = dmi_first_match(min_max_dmi_table);
 	if (min_max_dmi)
 		quirk_min_max = min_max_dmi->driver_data;
+
+	/*
+	 * Unfortunately ForcePad capability is not exported over PS/2,
+	 * so we have to resort to checking DMI.
+	 */
+	is_forcepad = dmi_check_system(forcepad_dmi_table);
 }
 
 static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index fb2e076..1bd01f2 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -77,12 +77,9 @@
  *					for noise.
  * 2	0x08	image sensor		image sensor tracks 5 fingers, but only
  *					reports 2.
+ * 2	0x01	uniform clickpad	whole clickpad moves instead of being
+ *					hinged at the top.
  * 2	0x20	report min		query 0x0f gives min coord reported
- * 2	0x80	forcepad		forcepad is a variant of clickpad that
- *					does not have physical buttons but rather
- *					uses pressure above certain threshold to
- *					report primary clicks. Forcepads also have
- *					clickpad bit set.
  */
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
 #define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPad */
@@ -91,7 +88,6 @@
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
 #define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
-#define SYN_CAP_FORCEPAD(ex0c)		((ex0c) & 0x008000)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
-- 
1.9.1

