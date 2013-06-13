Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3FMQfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:35:44 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54007 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab3FMQfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:35:40 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [BUGFIX 5/9] ACPI, DOCK: kill redundant spin lock in dock device object
Date: Fri, 14 Jun 2013 00:32:28 +0800
Message-Id: <1371141152-9468-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All dock device related data structures are created during driver
initialization, so kill the redundant spin lock in dock device object.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 8e578aa..cd2d5df 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -57,7 +57,6 @@ struct dock_station {
 	acpi_handle handle;
 	unsigned long last_dock_time;
 	u32 flags;
-	spinlock_t dd_lock;
 	struct mutex hp_lock;
 	struct task_struct *owner;
 	struct list_head dependent_devices;
@@ -107,10 +106,7 @@ add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 	dd->handle = handle;
 	INIT_LIST_HEAD(&dd->list);
 	INIT_LIST_HEAD(&dd->hotplug_list);
-
-	spin_lock(&ds->dd_lock);
 	list_add_tail(&dd->list, &ds->dependent_devices);
-	spin_unlock(&ds->dd_lock);
 
 	return 0;
 }
@@ -168,14 +164,10 @@ find_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
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
 
@@ -964,7 +956,6 @@ static int __init dock_add(acpi_handle handle)
 	dock_station->last_dock_time = jiffies - HZ;
 
 	mutex_init(&dock_station->hp_lock);
-	spin_lock_init(&dock_station->dd_lock);
 	INIT_LIST_HEAD(&dock_station->sibling);
 	INIT_LIST_HEAD(&dock_station->hotplug_devices);
 	INIT_LIST_HEAD(&dock_station->dependent_devices);
-- 
1.8.1.2

