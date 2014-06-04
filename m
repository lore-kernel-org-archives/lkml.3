Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaFEAWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:22:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaFDXW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sheng-Liang Song <ssl@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 140/228] Input: atkbd - fix keyboard not working on some LG laptops
Date: Wed,  4 Jun 2014 16:22:49 -0700
Message-Id: <20140604232352.507460417@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/atkbd.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -243,6 +243,12 @@ static void (*atkbd_platform_fixup)(stru
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
@@ -768,7 +774,8 @@ static int atkbd_probe(struct atkbd *atk
  * Make sure nothing is coming from the keyboard and disturbs our
  * internal state.
  */
-	atkbd_deactivate(atkbd);
+	if (!atkbd_skip_deactivate)
+		atkbd_deactivate(atkbd);
 
 	return 0;
 }
@@ -1638,6 +1645,12 @@ static int __init atkbd_setup_scancode_f
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
@@ -1775,6 +1788,20 @@ static const struct dmi_system_id atkbd_
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
 


