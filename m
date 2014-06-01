Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaFAQe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 12:34:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59948 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaFAQe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 12:34:27 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        Matthew Garrett <matthew.garrett@nebula.com>
Date: Sun,  1 Jun 2014 12:33:56 -0400
Message-Id: <1401640436-1947-5-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1401640436-1947-1-git-send-email-matthew.garrett@nebula.com>
References: <1401640436-1947-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-Spam-ASN: 
Subject: [PATCH 4/4] ACPI: Disable smart battery manager on Apple
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:54:46 +0000)
X-SA-Exim-Scanned: Yes (on cavan.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Touching the smart battery manager at all on Apple hardware appears to make
it unhappy - unplugging the AC adapter triggers accesses that hang the
controller for several minutes. Quirk it out via DMI in order to avoid this.
Compensate by changing battery presence if we fail to communicate with the
battery.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/sbs.c | 51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index b1df4ee..32aecea 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -35,6 +35,7 @@
 #include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/power_supply.h>
+#include <linux/dmi.h>
 
 #include "sbshc.h"
 #include "battery.h"
@@ -61,6 +62,8 @@ static unsigned int cache_time = 1000;
 module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
+static bool sbs_manager_broken;
+
 #define MAX_SBS_BAT			4
 #define ACPI_SBS_BLOCK_MAX		32
 
@@ -494,16 +497,21 @@ static int acpi_battery_read(struct acpi_battery *battery)
 				  ACPI_SBS_MANAGER, 0x01, (u8 *)&state, 2);
 	} else if (battery->id == 0)
 		battery->present = 1;
+
 	if (result || !battery->present)
 		return result;
 
 	if (saved_present != battery->present) {
 		battery->update_time = 0;
 		result = acpi_battery_get_info(battery);
-		if (result)
+		if (result) {
+			battery->present = 0;
 			return result;
+		}
 	}
 	result = acpi_battery_get_state(battery);
+	if (result)
+		battery->present = 0;
 	return result;
 }
 
@@ -535,6 +543,7 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 	result = power_supply_register(&sbs->device->dev, &battery->bat);
 	if (result)
 		goto end;
+
 	result = device_create_file(battery->bat.dev, &alarm_attr);
 	if (result)
 		goto end;
@@ -613,12 +622,31 @@ static void acpi_sbs_callback(void *context)
 	}
 }
 
+static int disable_sbs_manager(const struct dmi_system_id *d)
+{
+	sbs_manager_broken = true;
+	return 0;
+}
+
+static struct dmi_system_id acpi_sbs_dmi_table[] = {
+	{
+		.callback = disable_sbs_manager,
+		.ident = "Apple",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc.")
+		},
+	},
+	{ },
+};
+
 static int acpi_sbs_add(struct acpi_device *device)
 {
 	struct acpi_sbs *sbs;
 	int result = 0;
 	int id;
 
+	dmi_check_system(acpi_sbs_dmi_table);
+
 	sbs = kzalloc(sizeof(struct acpi_sbs), GFP_KERNEL);
 	if (!sbs) {
 		result = -ENOMEM;
@@ -637,14 +665,21 @@ static int acpi_sbs_add(struct acpi_device *device)
 	if (result && result != -ENODEV)
 		goto end;
 
-	result = acpi_manager_get_info(sbs);
-	if (!result) {
-		sbs->manager_present = 1;
-		for (id = 0; id < MAX_SBS_BAT; ++id)
-			if ((sbs->batteries_supported & (1 << id)))
-				acpi_battery_add(sbs, id);
-	} else
+	result = 0;
+
+	if (!sbs_manager_broken) {
+		result = acpi_manager_get_info(sbs);
+		if (!result) {
+			sbs->manager_present = 0;
+			for (id = 0; id < MAX_SBS_BAT; ++id)
+				if ((sbs->batteries_supported & (1 << id)))
+					acpi_battery_add(sbs, id);
+		}
+	}
+
+	if (!sbs->manager_present)
 		acpi_battery_add(sbs, 0);
+
 	acpi_smbus_register_callback(sbs->hc, acpi_sbs_callback, sbs);
       end:
 	if (result)
-- 
1.8.5.3

