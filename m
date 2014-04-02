Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbaDBU1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:27:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42817 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758868AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 28/40] Input: synaptics - add manual min/max quirk
Date: Wed,  2 Apr 2014 22:13:14 +0200
Message-Id: <5f3841f6872e8a666e9584f7ed29984c05714088.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 47 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 26386f9d2569..ef148f997c84 100644
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
 
@@ -1485,10 +1496,46 @@ static const struct dmi_system_id olpc_dmi_table[] __initconst = {
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

