Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab3FMQfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:35:34 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64379 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab3FMQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:35:30 -0400
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
Subject: [BUGFIX 3/9] ACPI, DOCK: clean up unused module related code
Date: Fri, 14 Jun 2013 00:32:26 +0800
Message-Id: <1371141152-9468-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI dock driver can't be built as a module any more, so clean up
module related code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 41 -----------------------------------------
 1 file changed, 41 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 79c8d9e..50e38b7 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -53,12 +53,6 @@ MODULE_PARM_DESC(immediate_undock, "1 (default) will cause the driver to "
 
 static struct atomic_notifier_head dock_notifier_list;
 
-static const struct acpi_device_id dock_device_ids[] = {
-	{"LNXDOCK", 0},
-	{"", 0},
-};
-MODULE_DEVICE_TABLE(acpi, dock_device_ids);
-
 struct dock_station {
 	acpi_handle handle;
 	unsigned long last_dock_time;
@@ -1013,30 +1007,6 @@ err_unregister:
 }
 
 /**
- * dock_remove - free up resources related to the dock station
- */
-static int dock_remove(struct dock_station *ds)
-{
-	struct dock_dependent_device *dd, *tmp;
-	struct platform_device *dock_device = ds->dock_device;
-
-	if (!dock_station_count)
-		return 0;
-
-	/* remove dependent devices */
-	list_for_each_entry_safe(dd, tmp, &ds->dependent_devices, list)
-		kfree(dd);
-
-	list_del(&ds->sibling);
-
-	/* cleanup sysfs */
-	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
-	platform_device_unregister(dock_device);
-
-	return 0;
-}
-
-/**
  * find_dock_and_bay - look for dock stations and bays
  * @handle: acpi handle of a device
  * @lvl: unused
@@ -1073,14 +1043,3 @@ int __init acpi_dock_init(void)
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
 	return 0;
 }
-
-static void __exit dock_exit(void)
-{
-	struct dock_station *tmp, *dock_station;
-
-	unregister_acpi_bus_notifier(&dock_acpi_notifier);
-	list_for_each_entry_safe(dock_station, tmp, &dock_stations, sibling)
-		dock_remove(dock_station);
-}
-
-module_exit(dock_exit);
-- 
1.8.1.2

