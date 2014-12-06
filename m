Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaLFPLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:11:55 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47656 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752389AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 06/66] Input: synaptics - change min/max quirk table to pnp-id matching
Date: Sat,  6 Dec 2014 16:06:58 +0100
Message-Id: <a847eeed11769b29fa4a944e269cf89a08f32c26.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0f68f39c393bc06ac5ccc8794f0e2ed841e41c3e upstream.

Most of the affected models share pnp-ids for the touchpad. So switching
to pnp-ids give us 2 advantages:
1) It shrinks the quirk list
2) It will lower the new quirk addition frequency, ie the recently added W540
   quirk would not have been necessary since it uses the same LEN0034 pnp ids
   as other models already added before it

As an added bonus it actually puts the quirk on the actual psmouse, rather
then on the machine, which is technically more correct.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 149 ++++++++++------------------------------
 1 file changed, 36 insertions(+), 113 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 069c4fd1d0bb..87ec0f49ae98 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -117,6 +117,31 @@ void synaptics_reset(struct psmouse *psmouse)
 }
 
 #ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+struct min_max_quirk {
+	const char * const *pnp_ids;
+	int x_min, x_max, y_min, y_max;
+};
+
+static const struct min_max_quirk min_max_pnpid_table[] = {
+	{
+		(const char * const []){"LEN0033", NULL},
+		1024, 5052, 2258, 4832
+	},
+	{
+		(const char * const []){"LEN0035", "LEN0042", NULL},
+		1232, 5710, 1156, 4696
+	},
+	{
+		(const char * const []){"LEN0034", "LEN0036", "LEN2004", NULL},
+		1024, 5112, 2024, 4832
+	},
+	{
+		(const char * const []){"LEN2001", NULL},
+		1024, 5022, 2508, 4832
+	},
+	{ }
+};
+
 /* This list has been kindly provided by Synaptics. */
 static const char * const topbuttonpad_pnp_ids[] = {
 	"LEN0017",
@@ -129,7 +154,7 @@ static const char * const topbuttonpad_pnp_ids[] = {
 	"LEN002D",
 	"LEN002E",
 	"LEN0033", /* Helix */
-	"LEN0034", /* T431s, T540, X1 Carbon 2nd */
+	"LEN0034", /* T431s, L440, L540, T540, W540, X1 Carbon 2nd */
 	"LEN0035", /* X240 */
 	"LEN0036", /* T440 */
 	"LEN0037",
@@ -142,7 +167,7 @@ static const char * const topbuttonpad_pnp_ids[] = {
 	"LEN0048",
 	"LEN0049",
 	"LEN2000",
-	"LEN2001",
+	"LEN2001", /* Edge E431 */
 	"LEN2002",
 	"LEN2003",
 	"LEN2004", /* L440 */
@@ -316,20 +341,20 @@ static int synaptics_identify(struct psmouse *psmouse)
  * Resolution is left zero if touchpad does not support the query
  */
 
-static const int *quirk_min_max;
-
 static int synaptics_resolution(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
 	unsigned char resp[3];
+	int i;
 
-	if (quirk_min_max) {
-		priv->x_min = quirk_min_max[0];
-		priv->x_max = quirk_min_max[1];
-		priv->y_min = quirk_min_max[2];
-		priv->y_max = quirk_min_max[3];
-		return 0;
-	}
+	for (i = 0; min_max_pnpid_table[i].pnp_ids; i++)
+		if (matches_pnp_id(psmouse, min_max_pnpid_table[i].pnp_ids)) {
+			priv->x_min = min_max_pnpid_table[i].x_min;
+			priv->x_max = min_max_pnpid_table[i].x_max;
+			priv->y_min = min_max_pnpid_table[i].y_min;
+			priv->y_max = min_max_pnpid_table[i].y_max;
+			return 0;
+		}
 
 	if (SYN_ID_MAJOR(priv->identity) < 4)
 		return 0;
@@ -1586,112 +1611,10 @@ static const struct dmi_system_id olpc_dmi_table[] __initconst = {
 	{ }
 };
 
-static const struct dmi_system_id min_max_dmi_table[] __initconst = {
-#if defined(CONFIG_DMI)
-	{
-		/* Lenovo ThinkPad Helix */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Helix"),
-		},
-		.driver_data = (int []){1024, 5052, 2258, 4832},
-	},
-	{
-		/* Lenovo ThinkPad X240 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X240"),
-		},
-		.driver_data = (int []){1232, 5710, 1156, 4696},
-	},
-	{
-		/* Lenovo ThinkPad Edge E431 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Edge E431"),
-		},
-		.driver_data = (int []){1024, 5022, 2508, 4832},
-	},
-	{
-		/* Lenovo ThinkPad T431s */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T431"),
-		},
-		.driver_data = (int []){1024, 5112, 2024, 4832},
-	},
-	{
-		/* Lenovo ThinkPad T440s */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T440"),
-		},
-		.driver_data = (int []){1024, 5112, 2024, 4832},
-	},
-	{
-		/* Lenovo ThinkPad L440 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L440"),
-		},
-		.driver_data = (int []){1024, 5112, 2024, 4832},
-	},
-	{
-		/* Lenovo ThinkPad T540p */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T540"),
-		},
-		.driver_data = (int []){1024, 5112, 2024, 4832},
-	},
-	{
-		/* Lenovo ThinkPad L540 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L540"),
-		},
-		.driver_data = (int []){1024, 5112, 2024, 4832},
-	},
-	{
-		/* Lenovo ThinkPad W540 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W540"),
-		},
-		.driver_data = (int []){1024, 5112, 2024, 4832},
-	},
-	{
-		/* Lenovo Yoga S1 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
-					"ThinkPad S1 Yoga"),
-		},
-		.driver_data = (int []){1232, 5710, 1156, 4696},
-	},
-	{
-		/* Lenovo ThinkPad X1 Carbon Haswell (3rd generation) */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION,
-					"ThinkPad X1 Carbon 2nd"),
-		},
-		.driver_data = (int []){1024, 5112, 2024, 4832},
-	},
-#endif
-	{ }
-};
-
 void __init synaptics_module_init(void)
 {
-	const struct dmi_system_id *min_max_dmi;
-
 	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
 	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
-
-	min_max_dmi = dmi_first_match(min_max_dmi_table);
-	if (min_max_dmi)
-		quirk_min_max = min_max_dmi->driver_data;
 }
 
 static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
-- 
2.1.3

