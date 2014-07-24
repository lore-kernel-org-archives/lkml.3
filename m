Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787AbaGXJtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:49:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbaGXJs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 106/128] ACPI / battery: Retry to get battery information if failed during probing
Date: Thu, 24 Jul 2014 10:45:55 +0100
Message-Id: <1406195177-8656-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 75646e758a0ecbed5024454507d5be5b9ea9dcbf upstream.

Some machines (eg. Lenovo Z480) ECs are not stable during boot up
and causes battery driver fails to be loaded due to failure of getting
battery information from EC sometimes. After several retries, the
operation will work. This patch is to retry to get battery information 5
times if the first try fails.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=75581
Reported-and-tested-by: naszar <naszar@ya.ru>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ luis: backported to 3.11:
  - acpi_battery_update() has only one parameter in 3.11 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/battery.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index cb2ba88fcac3..06523d5743b6 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -34,6 +34,7 @@
 #include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/delay.h>
 #include <asm/unaligned.h>
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
@@ -1081,6 +1082,28 @@ static struct dmi_system_id bat_dmi_table[] = {
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
@@ -1100,9 +1123,11 @@ static int acpi_battery_add(struct acpi_device *device)
 	if (ACPI_SUCCESS(acpi_get_handle(battery->device->handle,
 			"_BIX", &handle)))
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
1.9.1

