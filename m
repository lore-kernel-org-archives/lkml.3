Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120AbaFQQZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:25:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193AbaFQQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:25:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 119/121] Input: elantech - fix touchpad initialization on Gigabyte U2442
Date: Tue, 17 Jun 2014 09:18:17 -0700
Message-Id: <1403021899-16708-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 36189cc3cd57ab0f1cd75241f93fe01de928ac06 upstream.

The hw_version 3 Elantech touchpad on the Gigabyte U2442 does not accept
0x0b as initialization value for r10, this stand-alone version of the
driver: http://planet76.com/drivers/elantech/psmouse-elantech-v6.tar.bz2

Uses 0x03 which does work, so this means not setting bit 3 of r10 which
sets: "Enable Real H/W Resolution In Absolute mode"

Which will result in half the x and y resolution we get with that bit set,
so simply not setting it everywhere is not a solution. We've been unable to
find a way to identify touchpads where setting the bit will fail, so this
patch uses a dmi based blacklist for this.

https://bugzilla.kernel.org/show_bug.cgi?id=61151

Reported-by: Philipp Wolfer <ph.wolfer@gmail.com>
Tested-by: Philipp Wolfer <ph.wolfer@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/input/elantech.txt |  5 ++++-
 drivers/input/mouse/elantech.c   | 26 +++++++++++++++++++++++++-
 drivers/input/mouse/elantech.h   |  1 +
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/input/elantech.txt b/Documentation/input/elantech.txt
index 5602eb7..e1ae127 100644
--- a/Documentation/input/elantech.txt
+++ b/Documentation/input/elantech.txt
@@ -504,9 +504,12 @@ byte 5:
 * reg_10
 
    bit   7   6   5   4   3   2   1   0
-         0   0   0   0   0   0   0   A
+         0   0   0   0   R   F   T   A
 
          A: 1 = enable absolute tracking
+         T: 1 = enable two finger mode auto correct
+         F: 1 = disable ABS Position Filter
+         R: 1 = enable real hardware resolution
 
 6.2 Native absolute mode 6 byte packet format
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 57b2637..c7bd58e 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
@@ -800,7 +801,11 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
 		break;
 
 	case 3:
-		etd->reg_10 = 0x0b;
+		if (etd->set_hw_resolution)
+			etd->reg_10 = 0x0b;
+		else
+			etd->reg_10 = 0x03;
+
 		if (elantech_write_reg(psmouse, 0x10, etd->reg_10))
 			rc = -1;
 
@@ -1262,6 +1267,22 @@ static int elantech_reconnect(struct psmouse *psmouse)
 }
 
 /*
+ * Some hw_version 3 models go into error state when we try to set bit 3 of r10
+ */
+static const struct dmi_system_id no_hw_res_dmi_table[] = {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+	{
+		/* Gigabyte U2442 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "U2442"),
+		},
+	},
+#endif
+	{ }
+};
+
+/*
  * determine hardware version and set some properties according to it.
  */
 static int elantech_set_properties(struct elantech_data *etd)
@@ -1313,6 +1334,9 @@ static int elantech_set_properties(struct elantech_data *etd)
 			etd->reports_pressure = true;
 	}
 
+	/* Enable real hardware resolution on hw_version 3 ? */
+	etd->set_hw_resolution = !dmi_check_system(no_hw_res_dmi_table);
+
 	return 0;
 }
 
diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
index 46db3be..c1c15ab 100644
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
@@ -129,6 +129,7 @@ struct elantech_data {
 	bool paritycheck;
 	bool jumpy_cursor;
 	bool reports_pressure;
+	bool set_hw_resolution;
 	unsigned char hw_version;
 	unsigned int fw_version;
 	unsigned int single_finger_reports;
-- 
1.9.1

