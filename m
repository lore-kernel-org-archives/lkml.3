Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3FZQf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:35:59 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40557 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3FZQd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:33:57 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v2 5/9] ACPI: introduce three helper functions
Date: Thu, 27 Jun 2013 00:30:57 +0800
Message-Id: <1372264261-17442-6-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
References: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce three helper functions, which will be used to simplify code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/utils.c    | 72 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  5 ++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 74437130..5bcf068 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -495,3 +495,75 @@ acpi_handle_printk(const char *level, acpi_handle handle, const char *fmt, ...)
 	kfree(buffer.pointer);
 }
 EXPORT_SYMBOL(acpi_handle_printk);
+
+static acpi_status
+acpi_evaluate_object_with_int_arg(acpi_handle handle, char *method, u64 val)
+{
+	union acpi_object arg;
+	struct acpi_object_list arg_list;
+
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = val;
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+
+	return acpi_evaluate_object(handle, method, &arg_list, NULL);
+}
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
+	status = acpi_evaluate_object_with_int_arg(handle, "_EJ0", 1);
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
+	status = acpi_evaluate_object_with_int_arg(handle, "_LCK", !!lock);
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
+
+/**
+ * acpi_has_method: Check whether @handle has a method named @name
+ * @handle: ACPI device handle
+ * @name: name of object or method
+ *
+ * Check whether @handle has a method named @name.
+ */
+bool acpi_has_method(acpi_handle handle, char *name)
+{
+	acpi_handle tmp;
+
+	return ACPI_SUCCESS(acpi_get_handle(handle, name, &tmp));
+}
+EXPORT_SYMBOL(acpi_has_method);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index ca081ac..3db3b97 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -56,6 +56,11 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
 
 acpi_status
 acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
+
+acpi_status acpi_evaluate_ej0(acpi_handle handle);
+acpi_status acpi_evaluate_lck(acpi_handle handle, int lock);
+bool acpi_has_method(acpi_handle handle, char *name);
+
 #ifdef CONFIG_ACPI
 
 #include <linux/proc_fs.h>
-- 
1.8.1.2

