Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaFQHK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:10:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:7035 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbaFQHK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="446376890"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org, naszar@ya.ru, rientjes@google.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, <stable@vger.kernel.org>
Subject: [PATCH V2] ACPI/Battery: Retry to get Battery information if failed during probing
Date: Tue, 17 Jun 2014 15:09:54 +0800
Message-Id: <1402988994-27067-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines'(E,G Lenovo Z480) ECs are not stable during boot up
and causes battery driver fails to be loaded due to failure of getting
battery information from EC sometimes. After several retries, the
operation will work. This patch is to retry to get battery information 5
times if the first try fails.

Reported-and-tested-by: naszar <naszar@ya.ru>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=75581
Cc: <stable@vger.kernel.org>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
Change since V2:
	Change code style and add comment.

 drivers/acpi/battery.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index e48fc98..8ed93a3 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -34,6 +34,7 @@
 #include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/delay.h>
 #include <asm/unaligned.h>
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
@@ -1119,7 +1120,7 @@ static struct dmi_system_id bat_dmi_table[] = {
 
 static int acpi_battery_add(struct acpi_device *device)
 {
-	int result = 0;
+	int result = 0, retry = 5;
 	struct acpi_battery *battery = NULL;
 
 	if (!device)
@@ -1135,9 +1136,20 @@ static int acpi_battery_add(struct acpi_device *device)
 	mutex_init(&battery->sysfs_lock);
 	if (acpi_has_method(battery->device->handle, "_BIX"))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
-	result = acpi_battery_update(battery, false);
+
+	/*
+	 * Some machines'(E,G Lenovo Z480) ECs are not stable
+	 * during boot up and this causes battery driver fails to be
+	 * probed due to failure of getting battery information
+	 * from EC sometimes. After several retries, the operation
+	 * may work. So add retry code here and 20ms sleep between
+	 * every retries.
+	 */
+	while ((result = acpi_battery_update(battery, false)) && retry--)
+		msleep(20);
 	if (result)
 		goto fail;
+
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	result = acpi_battery_add_fs(device);
 #endif
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

