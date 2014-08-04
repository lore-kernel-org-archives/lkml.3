Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaHDQ6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:58:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56583 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Lan Tianyu" <tianyu.lan@intel.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.351054547@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 37/94] ACPI / battery: Retry to get battery
 information if failed during probing
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: acpi_battery_update() doesn't take a second parameter]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/battery.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -34,6 +34,7 @@
 #include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/delay.h>
 #include <asm/unaligned.h>
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
@@ -1055,6 +1056,28 @@ static int battery_notify(struct notifie
 	return 0;
 }
 
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
@@ -1074,9 +1097,11 @@ static int acpi_battery_add(struct acpi_
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

