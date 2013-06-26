Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3FZQdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:33:49 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57412 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3FZQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:33:46 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v2 2/9] ACPI, DOCK: kill redundant spin lock in dock station object
Date: Thu, 27 Jun 2013 00:30:54 +0800
Message-Id: <1372264261-17442-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
References: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

All dock station objects are created during initialization and don't
change at runtime, so kill the redundant spin lock in dock station
object.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index e944e39..a73571f 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -63,7 +63,6 @@ struct dock_station {
 	acpi_handle handle;
 	unsigned long last_dock_time;
 	u32 flags;
-	spinlock_t dd_lock;
 	struct mutex hp_lock;
 	struct list_head dependent_devices;
 
@@ -112,10 +111,7 @@ add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 
 	dd->handle = handle;
 	INIT_LIST_HEAD(&dd->list);
-
-	spin_lock(&ds->dd_lock);
 	list_add_tail(&dd->list, &ds->dependent_devices);
-	spin_unlock(&ds->dd_lock);
 
 	return 0;
 }
@@ -220,14 +216,10 @@ find_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 {
 	struct dock_dependent_device *dd;
 
-	spin_lock(&ds->dd_lock);
-	list_for_each_entry(dd, &ds->dependent_devices, list) {
-		if (handle == dd->handle) {
-			spin_unlock(&ds->dd_lock);
+	list_for_each_entry(dd, &ds->dependent_devices, list)
+		if (handle == dd->handle)
 			return dd;
-		}
-	}
-	spin_unlock(&ds->dd_lock);
+
 	return NULL;
 }
 
@@ -1005,7 +997,6 @@ static int __init dock_add(acpi_handle handle)
 	dock_station->last_dock_time = jiffies - HZ;
 
 	mutex_init(&dock_station->hp_lock);
-	spin_lock_init(&dock_station->dd_lock);
 	INIT_LIST_HEAD(&dock_station->sibling);
 	INIT_LIST_HEAD(&dock_station->dependent_devices);
 
-- 
1.8.1.2

