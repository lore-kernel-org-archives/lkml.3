Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaDAL3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:29:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaDALSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/144] Input: synaptics - add manual min/max quirk
Date: Tue,  1 Apr 2014 12:15:27 +0100
Message-Id: <1396350948-29910-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 421e08c41fda1f0c2ff6af81a67b491389b653a5 upstream.

The new Lenovo Haswell series (-40's) contains a new Synaptics touchpad.
However, these new Synaptics devices report bad axis ranges.
Under Windows, it is not a problem because the Windows driver uses RMI4
over SMBus to talk to the device. Under Linux, we are using the PS/2
fallback interface and it occurs the reported ranges are wrong.

Of course, it would be too easy to have only one range for the whole
series, each touchpad seems to be calibrated in a different way.

We can not use SMBus to get the actual range because I suspect the firmware
will switch into the SMBus mode and stop talking through PS/2 (this is the
case for hybrid HID over I2C / PS/2 Synaptics touchpads).

So as a temporary solution (until RMI4 land into upstream), start a new
list of quirks with the min/max manually set.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/synaptics.c | 47 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index b2420ae..1844ce0 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -265,11 +265,22 @@ static int synaptics_identify(struct psmouse *psmouse)
  * Read touchpad resolution and maximum reported coordinates
  * Resolution is left zero if touchpad does not support the query
  */
+
+static const int *quirk_min_max;
+
 static int synaptics_resolution(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
 	unsigned char resp[3];
 
+	if (quirk_min_max) {
+		priv->x_min = quirk_min_max[0];
+		priv->x_max = quirk_min_max[1];
+		priv->y_min = quirk_min_max[2];
+		priv->y_max = quirk_min_max[3];
+		return 0;
+	}
+
 	if (SYN_ID_MAJOR(priv->identity) < 4)
 		return 0;
 
@@ -1485,10 +1496,46 @@ static const struct dmi_system_id __initconst olpc_dmi_table[] = {
 	{ }
 };
 
+static const struct dmi_system_id min_max_dmi_table[] __initconst = {
+#if defined(CONFIG_DMI)
+	{
+		/* Lenovo ThinkPad Helix */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Helix"),
+		},
+		.driver_data = (int []){1024, 5052, 2258, 4832},
+	},
+	{
+		/* Lenovo ThinkPad T440s */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T440"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
+		/* Lenovo ThinkPad T540p */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T540"),
+		},
+		.driver_data = (int []){1024, 5056, 2058, 4832},
+	},
+#endif
+	{ }
+};
+
 void __init synaptics_module_init(void)
 {
+	const struct dmi_system_id *min_max_dmi;
+
 	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
 	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
+
+	min_max_dmi = dmi_first_match(min_max_dmi_table);
+	if (min_max_dmi)
+		quirk_min_max = min_max_dmi->driver_data;
 }
 
 static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
-- 
1.9.1

