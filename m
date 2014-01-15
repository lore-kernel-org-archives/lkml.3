Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaAOV5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaAOV5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 134/166] ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS
Date: Wed, 15 Jan 2014 13:52:28 -0800
Message-Id: <1389822780-4729-135-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit a90b40385735af0d3031f98e97b439e8944a31b3 upstream.

The AML method _BIX of NEC LZ750/LS returns a broken package which
skips the first member "Revision" (ACPI 5.0, Table 10-234).

Add a quirk for this machine to skip member "Revision" during parsing
the package returned by _BIX.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=67351
Reported-and-tested-by: Francisco Castro <fcr@adinet.com.uy>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: backport to 3.8 (context in acpi_battery_init_async) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/battery.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 7663df7..a16a725 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -68,6 +68,7 @@ MODULE_AUTHOR("Alexey Starikovskiy <astarikovskiy@suse.de>");
 MODULE_DESCRIPTION("ACPI Battery Driver");
 MODULE_LICENSE("GPL");
 
+static int battery_bix_broken_package;
 static unsigned int cache_time = 1000;
 module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
@@ -443,7 +444,12 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
 		ACPI_EXCEPTION((AE_INFO, status, "Evaluating %s", name));
 		return -ENODEV;
 	}
-	if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
+
+	if (battery_bix_broken_package)
+		result = extract_package(battery, buffer.pointer,
+				extended_info_offsets + 1,
+				ARRAY_SIZE(extended_info_offsets) - 1);
+	else if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
 		result = extract_package(battery, buffer.pointer,
 				extended_info_offsets,
 				ARRAY_SIZE(extended_info_offsets));
@@ -1064,6 +1070,17 @@ static int battery_notify(struct notifier_block *nb,
 	return 0;
 }
 
+static struct dmi_system_id bat_dmi_table[] = {
+	{
+		.ident = "NEC LZ750/LS",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "NEC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PC-LZ750LS"),
+		},
+	},
+	{},
+};
+
 static int acpi_battery_add(struct acpi_device *device)
 {
 	int result = 0;
@@ -1169,6 +1186,10 @@ static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
 {
 	if (acpi_disabled)
 		return;
+
+	if (dmi_check_system(bat_dmi_table))
+		battery_bix_broken_package = 1;
+
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	acpi_battery_dir = acpi_lock_battery_dir();
 	if (!acpi_battery_dir)
-- 
1.8.3.2

