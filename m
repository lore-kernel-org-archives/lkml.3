Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3F1Q1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:27:42 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64711 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3F1Q1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:27:40 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v3 07/10] ACPI: introduce two helper functions to simplify code
Date: Sat, 29 Jun 2013 00:24:40 +0800
Message-Id: <1372436683-31711-8-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce two helper functions, acpi_evaluate_ej0() and acpi_evaluate_lck()
to simplify code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/scan.c     | 31 ++++++-------------------------
 drivers/acpi/utils.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  2 ++
 3 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 84d88a0..101a267 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -194,8 +194,6 @@ static acpi_status acpi_bus_online_companions(acpi_handle handle, u32 lvl,
 static int acpi_scan_hot_remove(struct acpi_device *device)
 {
 	acpi_handle handle = device->handle;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 	struct device *errdev;
 	acpi_status status;
 	unsigned long long sta;
@@ -258,32 +256,15 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
 	put_device(&device->dev);
 	device = NULL;
 
-	if (acpi_has_method(handle, "_LCK")) {
-		arg_list.count = 1;
-		arg_list.pointer = &arg;
-		arg.type = ACPI_TYPE_INTEGER;
-		arg.integer.value = 0;
-		acpi_evaluate_object(handle, "_LCK", &arg_list, NULL);
-	}
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = 1;
-
+	acpi_evaluate_lck(handle, 0);
 	/*
 	 * TBD: _EJD support.
 	 */
-	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
-	if (ACPI_FAILURE(status)) {
-		if (status == AE_NOT_FOUND) {
-			return -ENODEV;
-		} else {
-			acpi_handle_warn(handle, "Eject failed (0x%x)\n",
-								status);
-			return -EIO;
-		}
-	}
+	status = acpi_evaluate_ej0(handle);
+	if (status == AE_NOT_FOUND)
+		return -ENODEV;
+	else if (ACPI_FAILURE(status))
+		return -EIO;
 
 	/*
 	 * Verify if eject was indeed successful.  If not, log an error
diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 87b8588..552248b 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -522,3 +522,46 @@ acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
 	return acpi_evaluate_object(handle, method, &arg_list, NULL);
 }
 EXPORT_SYMBOL(acpi_execute_simple_method);
+
+/**
+ * acpi_evaluate_ej0: Evaluate _EJ0 method for hotplug operations
+ * @handle: ACPI device handle
+ *
+ * Evaluate device's _EJ0 method for hotplug operations.
+ */
+acpi_status acpi_evaluate_ej0(acpi_handle handle)
+{
+	acpi_status status;
+
+	status = acpi_execute_simple_method(handle, "_EJ0", 1);
+	if (status == AE_NOT_FOUND)
+		acpi_handle_warn(handle, "No _EJ0 support for device\n");
+	else if (ACPI_FAILURE(status))
+		acpi_handle_warn(handle, "Eject failed (0x%x)\n", status);
+
+	return status;
+}
+
+/**
+ * acpi_evaluate_lck: Evaluate _LCK method to lock/unlock device
+ * @handle: ACPI device handle
+ * @lock: lock device if non-zero, otherwise unlock device
+ *
+ * Evaluate device's _LCK method if present to lock/unlock device
+ */
+acpi_status acpi_evaluate_lck(acpi_handle handle, int lock)
+{
+	acpi_status status;
+
+	status = acpi_execute_simple_method(handle, "_LCK", !!lock);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		if (lock)
+			acpi_handle_warn(handle,
+				"Locking device failed (0x%x)\n", status);
+		else
+			acpi_handle_warn(handle,
+				"Unlocking device failed (0x%x)\n", status);
+	}
+
+	return status;
+}
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index d3d5fc1..6c378d9 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -60,6 +60,8 @@ acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld
 bool acpi_has_method(acpi_handle handle, char *name);
 acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
 				       u64 arg);
+acpi_status acpi_evaluate_ej0(acpi_handle handle);
+acpi_status acpi_evaluate_lck(acpi_handle handle, int lock);
 
 #ifdef CONFIG_ACPI
 
-- 
1.8.1.2

