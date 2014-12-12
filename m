Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbaLLGSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:18:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51876 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759988AbaLLGRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:18 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Nicole Faerber" <nicole.faerber@kernelconcepts.de>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.766634924@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 055/164] Input: synaptics - gate forcepad support by
 DMI check
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit aa972409951e0675e07918620427517cad5090e0 upstream.

Unfortunately, ForcePad capability is not actually exported over PS/2, so
we have to resort to DMI checks.

Reported-by: Nicole Faerber <nicole.faerber@kernelconcepts.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/synaptics.c | 22 +++++++++++++++++++++-
 drivers/input/mouse/synaptics.h |  8 ++------
 2 files changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -495,6 +495,8 @@ static void synaptics_parse_agm(const un
 	priv->agm_pending = true;
 }
 
+static bool is_forcepad;
+
 static int synaptics_parse_hw_state(const unsigned char buf[],
 				    struct synaptics_data *priv,
 				    struct synaptics_hw_state *hw)
@@ -524,7 +526,7 @@ static int synaptics_parse_hw_state(cons
 		hw->left  = (buf[0] & 0x01) ? 1 : 0;
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 
-		if (SYN_CAP_FORCEPAD(priv->ext_cap_0c)) {
+		if (is_forcepad) {
 			/*
 			 * ForcePads, like Clickpads, use middle button
 			 * bits to report primary button clicks.
@@ -1507,6 +1509,18 @@ static const struct dmi_system_id min_ma
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
@@ -1517,6 +1531,12 @@ void __init synaptics_module_init(void)
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
 
 int synaptics_init(struct psmouse *psmouse)
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

