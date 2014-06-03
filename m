Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaFCMZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:25:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaFCLj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:39:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sheng-Liang Song <ssl@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 004/138] Input: atkbd - fix keyboard not working on some LG laptops
Date: Tue,  3 Jun 2014 12:37:30 +0100
Message-Id: <1401795584-22664-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng-Liang Song <ssl@chromium.org>

commit 3d725caa9dcc78c3dc9e7ea0c04f626468edd9c9 upstream.

After issuing ATKBD_CMD_RESET_DIS, keyboard on some LG laptops stops
working. The workaround is to stop issuing ATKBD_CMD_RESET_DIS commands.

In order to keep changes in atkbd driver to the minimum we check DMI
signature and only skip ATKBD_CMD_RESET_DIS if we are running on LG
LW25-B7HV or P1-J273B.

Signed-off-by: Sheng-Liang Song <ssl@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/keyboard/atkbd.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 2626773ff29b..2dd1d0dd4f7d 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -243,6 +243,12 @@ static void (*atkbd_platform_fixup)(struct atkbd *, const void *data);
 static void *atkbd_platform_fixup_data;
 static unsigned int (*atkbd_platform_scancode_fixup)(struct atkbd *, unsigned int);
 
+/*
+ * Certain keyboards to not like ATKBD_CMD_RESET_DIS and stop responding
+ * to many commands until full reset (ATKBD_CMD_RESET_BAT) is performed.
+ */
+static bool atkbd_skip_deactivate;
+
 static ssize_t atkbd_attr_show_helper(struct device *dev, char *buf,
 				ssize_t (*handler)(struct atkbd *, char *));
 static ssize_t atkbd_attr_set_helper(struct device *dev, const char *buf, size_t count,
@@ -768,7 +774,8 @@ static int atkbd_probe(struct atkbd *atkbd)
  * Make sure nothing is coming from the keyboard and disturbs our
  * internal state.
  */
-	atkbd_deactivate(atkbd);
+	if (!atkbd_skip_deactivate)
+		atkbd_deactivate(atkbd);
 
 	return 0;
 }
@@ -1638,6 +1645,12 @@ static int __init atkbd_setup_scancode_fixup(const struct dmi_system_id *id)
 	return 1;
 }
 
+static int __init atkbd_deactivate_fixup(const struct dmi_system_id *id)
+{
+	atkbd_skip_deactivate = true;
+	return 1;
+}
+
 static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		.matches = {
@@ -1775,6 +1788,20 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 		.callback = atkbd_setup_scancode_fixup,
 		.driver_data = atkbd_oqo_01plus_scancode_fixup,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LW25-B7HV"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P1-J273B"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 
-- 
1.9.1

