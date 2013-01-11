Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3AKWlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:41:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38436 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3AKWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 14/22] ACPI: update ej_event interface to take acpi_device
Date: Fri, 11 Jan 2013 14:40:41 -0800
Message-Id: <1357944049-29620-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should use acpi_device pointer directly instead of use handle and
get the device pointer again later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/acpi_memhotplug.c  |    2 +-
 drivers/acpi/processor_driver.c |    2 +-
 drivers/acpi/scan.c             |   14 ++++----------
 include/acpi/acpi_bus.h         |    2 +-
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 327ab44..eaddb7a 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -361,7 +361,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			break;
 		}
 
-		ej_event->handle = handle;
+		ej_event->device = device;
 		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
 		acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
 					(void *)ej_event);
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 0777663..a24ee43 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -733,7 +733,7 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 			break;
 		}
 
-		ej_event->handle = handle;
+		ej_event->device = device;
 		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
 		acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
 					(void *)ej_event);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 8883539..f4c6305 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -116,20 +116,14 @@ static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 void acpi_bus_hot_remove_device(void *context)
 {
 	struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
-	struct acpi_device *device;
-	acpi_handle handle = ej_event->handle;
+	struct acpi_device *device = ej_event->device;
+	acpi_handle handle = device->handle;
 	acpi_handle temp;
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	acpi_status status = AE_OK;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 
-	if (acpi_bus_get_device(handle, &device))
-		goto err_out;
-
-	if (!device)
-		goto err_out;
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 		"Hot-removing device %s...\n", dev_name(&device->dev)));
 
@@ -215,7 +209,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
 		goto err;
 	}
 
-	ej_event->handle = acpi_device->handle;
+	ej_event->device = acpi_device;
 	if (acpi_device->flags.eject_pending) {
 		/* event originated from ACPI eject notification */
 		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
@@ -223,7 +217,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
 	} else {
 		/* event originated from user */
 		ej_event->event = ACPI_OST_EC_OSPM_EJECT;
-		(void) acpi_evaluate_hotplug_ost(ej_event->handle,
+		(void) acpi_evaluate_hotplug_ost(acpi_device->handle,
 			ej_event->event, ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	}
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 2246ba9..181ff2d 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -309,7 +309,7 @@ struct acpi_bus_event {
 };
 
 struct acpi_eject_event {
-	acpi_handle	handle;
+	struct acpi_device	*device;
 	u32		event;
 };
 
-- 
1.7.10.4

