Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaDXFZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:25:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43039 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaDXFZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:25:27 -0400
Date: Wed, 23 Apr 2014 22:25:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sheng-Liang Song <ssl@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Shawn Nematbakhsh <shawnn@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atkbd - fix keyboard LG Electronics
Message-ID: <20140424052523.GA29675@core.coreip.homeip.net>
References: <1398217882-29778-1-git-send-email-ssl@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398217882-29778-1-git-send-email-ssl@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 06:51:22PM -0700, Sheng-Liang Song wrote:
> After issuing ATKBD_CMD_RESET_DIS, LG Keyboard stop working.
> The workaround is to remove ATKBD_CMD_RESET_DIS for LG Keyboards.
> 
> In order to keep the minimum changes to the current atkbd driver,
> I add logic to apply the patch if and only if the device is LG LW25-B7HV or P1-J273B.

How about if we rework this just a little bit... Does the version of the
patch below work for you?

Also, I do need your "signed-off-by".

Thanks!

-- 
Dmitry

Input: atkbd - fix keyboard LG Electronics

From: Sheng-Liang Song <ssl@chromium.org>

After issuing ATKBD_CMD_RESET_DIS, LG Keyboard stop working.  The
workaround is to remove ATKBD_CMD_RESET_DIS for LG Keyboards.

In order to keep the minimum changes to the current atkbd driver, I add
logic to apply the patch if and only if the device is LG LW25-B7HV or
P1-J273B.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/atkbd.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 2626773..06a4b0d 100644
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
@@ -698,7 +704,6 @@ static int atkbd_activate(struct atkbd *atkbd)
  * atkbd_deactivate() resets and disables the keyboard from sending
  * keystrokes.
  */
-
 static void atkbd_deactivate(struct atkbd *atkbd)
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
@@ -768,7 +773,8 @@ static int atkbd_probe(struct atkbd *atkbd)
  * Make sure nothing is coming from the keyboard and disturbs our
  * internal state.
  */
-	atkbd_deactivate(atkbd);
+	if (!atkbd_skip_deactivate)
+		atkbd_deactivate(atkbd);
 
 	return 0;
 }
@@ -1638,6 +1644,12 @@ static int __init atkbd_setup_scancode_fixup(const struct dmi_system_id *id)
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
@@ -1775,6 +1787,20 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
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
 
