Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbaGRNnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:43:22 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17611 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934548AbaGRNMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 170/170] ACPI / battery: Retry to get battery information if failed during probing
Date: Fri, 18 Jul 2014 14:12:55 +0200
Message-Id: <00c03d41bf0de7683a9f82d971ece2645405792c.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 75646e758a0ecbed5024454507d5be5b9ea9dcbf upstream.

Some machines (eg. Lenovo Z480) ECs are not stable during boot up
and causes battery driver fails to be loaded due to failure of getting
battery information from EC sometimes. After several retries, the
operation will work. This patch is to retry to get battery information 5
times if the first try fails.

[ backport to 3.14.5: removed second parameter in acpi_battery_update(),
introduced by the commit 9e50bc14a7f58b5d8a55973b2d69355852ae2dae (ACPI /
battery: Accelerate battery resume callback)]

[naszar <naszar@ya.ru>: backport to 3.14.5]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=75581
Reported-and-tested-by: naszar <naszar@ya.ru>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/battery.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index ffa5af4c221a..a59d3d3fbcdc 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -34,6 +34,7 @@
 #include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/delay.h>
 #include <asm/unaligned.h>
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
@@ -1071,6 +1072,28 @@ static struct dmi_system_id bat_dmi_table[] = {
 	{},
 };
 
+/*
+ * Some machines'(E,G Lenovo Z480) ECs are not stable
+ * during boot up and this causes battery driver fails to be
+ * probed due to failure of getting battery information
+ * from EC sometimes. After several retries, the operation
+ * may work. So add retry code here and 20ms sleep between
+ * every retries.
+ */
+static int acpi_battery_update_retry(struct acpi_battery *battery)
+{
+	int retry, ret;
+
+	for (retry = 5; retry; retry--) {
+		ret = acpi_battery_update(battery);
+		if (!ret)
+			break;
+
+		msleep(20);
+	}
+	return ret;
+}
+
 static int acpi_battery_add(struct acpi_device *device)
 {
 	int result = 0;
@@ -1089,9 +1112,11 @@ static int acpi_battery_add(struct acpi_device *device)
 	mutex_init(&battery->sysfs_lock);
 	if (acpi_has_method(battery->device->handle, "_BIX"))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
-	result = acpi_battery_update(battery);
+
+	result = acpi_battery_update_retry(battery);
 	if (result)
 		goto fail;
+
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	result = acpi_battery_add_fs(device);
 #endif
-- 
2.0.0

