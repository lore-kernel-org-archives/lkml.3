Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbbA1ESU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:18:20 -0500
Received: from mail.kernel.org ([198.145.29.136]:38361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbbA1ESL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:18:11 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 050/177] Input: synaptics - gate forcepad support by DMI check
Date: Wed, 28 Jan 2015 12:07:46 +0800
Message-Id: <1422418236-12852-99-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit aa972409951e0675e07918620427517cad5090e0 upstream.

Unfortunately, ForcePad capability is not actually exported over PS/2, so
we have to resort to DMI checks.

Reported-by: Nicole Faerber <nicole.faerber@kernelconcepts.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/input/mouse/synaptics.c | 22 +++++++++++++++++++++-
 drivers/input/mouse/synaptics.h |  8 ++------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 32b1363..97e5f6f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -506,6 +506,8 @@ static void synaptics_parse_agm(const unsigned char buf[],
 	priv->agm_pending = true;
 }
 
+static bool is_forcepad;
+
 static int synaptics_parse_hw_state(const unsigned char buf[],
 				    struct synaptics_data *priv,
 				    struct synaptics_hw_state *hw)
@@ -535,7 +537,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 
-		if (SYN_CAP_FORCEPAD(priv->ext_cap_0c)) {
+		if (is_forcepad) {
 			/*
 			 * ForcePads, like Clickpads, use middle button
 			 * bits to report primary button clicks.
@@ -1512,6 +1514,18 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
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
@@ -1522,6 +1536,12 @@ void __init synaptics_module_init(void)
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
index ac1b773..20d861b 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -76,12 +76,9 @@
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
@@ -90,7 +87,6 @@
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
 #define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
-#define SYN_CAP_FORCEPAD(ex0c)		((ex0c) & 0x008000)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
-- 
1.9.1

