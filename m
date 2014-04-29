Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbaD2NPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:15:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaD2NPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:15:39 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Federico Vecchiarelli <fedev@gmx.net>
Subject: [PATCH] toshiba_acpi: Add alternative keymap support for Satellite M840
Date: Tue, 29 Apr 2014 15:15:38 +0200
Message-Id: <1398777338-26952-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiba Satellite M840 laptop has a complete different keymap although
it's bound with the same ACPI ID "TOS1900".  This patch provides an
alternative keymap specific to this machine by identifying via DMI
matching.  The keymap table doesn't fill all entries that were used
before since some keys aren't found on this machine at all.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=69761
Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=812209
Reported-and-tested-by: Federico Vecchiarelli <fedev@gmx.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/platform/x86/toshiba_acpi.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 46473ca7566b..76441dcbe5ff 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -56,6 +56,7 @@
 #include <linux/workqueue.h>
 #include <linux/i8042.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 #include <asm/uaccess.h>
 
 MODULE_AUTHOR("John Belmonte");
@@ -213,6 +214,30 @@ static const struct key_entry toshiba_acpi_keymap[] = {
 	{ KE_END, 0 },
 };
 
+/* alternative keymap */
+static const struct dmi_system_id toshiba_alt_keymap_dmi[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite M840"),
+		},
+	},
+	{}
+};
+
+static const struct key_entry toshiba_acpi_alt_keymap[] = {
+	{ KE_KEY, 0x157, { KEY_MUTE } },
+	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
+	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
+	{ KE_KEY, 0x139, { KEY_ZOOMRESET } },
+	{ KE_KEY, 0x13e, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x13c, { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, 0x13d, { KEY_BRIGHTNESSUP } },
+	{ KE_KEY, 0x158, { KEY_WLAN } },
+	{ KE_KEY, 0x13f, { KEY_TOUCHPAD_TOGGLE } },
+	{ KE_END, 0 },
+};
+
 /* utility
  */
 
@@ -1440,6 +1465,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	acpi_handle ec_handle;
 	int error;
 	u32 hci_result;
+	const struct key_entry *keymap = toshiba_acpi_keymap;
 
 	dev->hotkey_dev = input_allocate_device();
 	if (!dev->hotkey_dev)
@@ -1449,7 +1475,9 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	dev->hotkey_dev->phys = "toshiba_acpi/input0";
 	dev->hotkey_dev->id.bustype = BUS_HOST;
 
-	error = sparse_keymap_setup(dev->hotkey_dev, toshiba_acpi_keymap, NULL);
+	if (dmi_check_system(toshiba_alt_keymap_dmi))
+		keymap = toshiba_acpi_alt_keymap;
+	error = sparse_keymap_setup(dev->hotkey_dev, keymap, NULL);
 	if (error)
 		goto err_free_dev;
 
-- 
1.9.2

