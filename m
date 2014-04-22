Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaDVGcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:32:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:23122 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaDVGcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:32:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="421852782"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tianyu.lan@intel.com
Subject: [Resend Patch 8/9] I2C/ACPI: Move ACPI related code to i2c-acpi.c
Date: Tue, 22 Apr 2014 14:24:14 +0800
Message-Id: <1398147855-9868-9-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up ACPI related code in the i2c core.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/i2c/i2c-acpi.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c | 95 --------------------------------------------------
 include/linux/i2c.h    |  3 ++
 3 files changed, 92 insertions(+), 95 deletions(-)

diff --git a/drivers/i2c/i2c-acpi.c b/drivers/i2c/i2c-acpi.c
index 942abdf..a0ae867 100644
--- a/drivers/i2c/i2c-acpi.c
+++ b/drivers/i2c/i2c-acpi.c
@@ -37,6 +37,95 @@ struct gsb_buffer {
 	};
 } __packed;
 
+static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
+{
+	struct i2c_board_info *info = data;
+
+	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+		struct acpi_resource_i2c_serialbus *sb;
+
+		sb = &ares->data.i2c_serial_bus;
+		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
+			info->addr = sb->slave_address;
+			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
+				info->flags |= I2C_CLIENT_TEN;
+		}
+	} else if (info->irq < 0) {
+		struct resource r;
+
+		if (acpi_dev_resource_interrupt(ares, 0, &r))
+			info->irq = r.start;
+	}
+
+	/* Tell the ACPI core to skip this resource */
+	return 1;
+}
+
+static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
+				       void *data, void **return_value)
+{
+	struct i2c_adapter *adapter = data;
+	struct list_head resource_list;
+	struct i2c_board_info info;
+	struct acpi_device *adev;
+	int ret;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return AE_OK;
+	if (acpi_bus_get_status(adev) || !adev->status.present)
+		return AE_OK;
+
+	memset(&info, 0, sizeof(info));
+	info.acpi_node.companion = adev;
+	info.irq = -1;
+
+	INIT_LIST_HEAD(&resource_list);
+	ret = acpi_dev_get_resources(adev, &resource_list,
+				     acpi_i2c_add_resource, &info);
+	acpi_dev_free_resource_list(&resource_list);
+
+	if (ret < 0 || !info.addr)
+		return AE_OK;
+
+	adev->power.flags.ignore_parent = true;
+	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
+	if (!i2c_new_device(adapter, &info)) {
+		adev->power.flags.ignore_parent = false;
+		dev_err(&adapter->dev,
+			"failed to add I2C device %s from ACPI\n",
+			dev_name(&adev->dev));
+	}
+
+	return AE_OK;
+}
+
+/**
+ * acpi_i2c_register_devices - enumerate I2C slave devices behind adapter
+ * @adap: pointer to adapter
+ *
+ * Enumerate all I2C slave devices behind this adapter by walking the ACPI
+ * namespace. When a device is found it will be added to the Linux device
+ * model and bound to the corresponding ACPI handle.
+ */
+void acpi_i2c_register_devices(struct i2c_adapter *adap)
+{
+	acpi_handle handle;
+	acpi_status status;
+
+	if (!adap->dev.parent)
+		return;
+
+	handle = ACPI_HANDLE(adap->dev.parent);
+	if (!handle)
+		return;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
+				     acpi_i2c_add_device, NULL,
+				     adap, NULL);
+	if (ACPI_FAILURE(status))
+		dev_warn(&adap->dev, "failed to enumerate I2C slaves\n");
+}
+
 static int acpi_gsb_i2c_read_bytes(struct i2c_client *client,
 		u8 cmd, u8 *data, u8 data_len)
 {
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index bb9dc56..9ca50c8 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1092,101 +1092,6 @@ EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
 static void of_i2c_register_devices(struct i2c_adapter *adap) { }
 #endif /* CONFIG_OF */
 
-/* ACPI support code */
-
-#if IS_ENABLED(CONFIG_ACPI)
-static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
-{
-	struct i2c_board_info *info = data;
-
-	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
-		struct acpi_resource_i2c_serialbus *sb;
-
-		sb = &ares->data.i2c_serial_bus;
-		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
-			info->addr = sb->slave_address;
-			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
-				info->flags |= I2C_CLIENT_TEN;
-		}
-	} else if (info->irq < 0) {
-		struct resource r;
-
-		if (acpi_dev_resource_interrupt(ares, 0, &r))
-			info->irq = r.start;
-	}
-
-	/* Tell the ACPI core to skip this resource */
-	return 1;
-}
-
-static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
-				       void *data, void **return_value)
-{
-	struct i2c_adapter *adapter = data;
-	struct list_head resource_list;
-	struct i2c_board_info info;
-	struct acpi_device *adev;
-	int ret;
-
-	if (acpi_bus_get_device(handle, &adev))
-		return AE_OK;
-	if (acpi_bus_get_status(adev) || !adev->status.present)
-		return AE_OK;
-
-	memset(&info, 0, sizeof(info));
-	info.acpi_node.companion = adev;
-	info.irq = -1;
-
-	INIT_LIST_HEAD(&resource_list);
-	ret = acpi_dev_get_resources(adev, &resource_list,
-				     acpi_i2c_add_resource, &info);
-	acpi_dev_free_resource_list(&resource_list);
-
-	if (ret < 0 || !info.addr)
-		return AE_OK;
-
-	adev->power.flags.ignore_parent = true;
-	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
-	if (!i2c_new_device(adapter, &info)) {
-		adev->power.flags.ignore_parent = false;
-		dev_err(&adapter->dev,
-			"failed to add I2C device %s from ACPI\n",
-			dev_name(&adev->dev));
-	}
-
-	return AE_OK;
-}
-
-/**
- * acpi_i2c_register_devices - enumerate I2C slave devices behind adapter
- * @adap: pointer to adapter
- *
- * Enumerate all I2C slave devices behind this adapter by walking the ACPI
- * namespace. When a device is found it will be added to the Linux device
- * model and bound to the corresponding ACPI handle.
- */
-static void acpi_i2c_register_devices(struct i2c_adapter *adap)
-{
-	acpi_handle handle;
-	acpi_status status;
-
-	if (!adap->dev.parent)
-		return;
-
-	handle = ACPI_HANDLE(adap->dev.parent);
-	if (!handle)
-		return;
-
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
-				     acpi_i2c_add_device, NULL,
-				     adap, NULL);
-	if (ACPI_FAILURE(status))
-		dev_warn(&adap->dev, "failed to enumerate I2C slaves\n");
-}
-#else
-static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {}
-#endif /* CONFIG_ACPI */
-
 static int i2c_do_add_adapter(struct i2c_driver *driver,
 			      struct i2c_adapter *adap)
 {
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 681e689..fc1ef42 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -586,7 +586,10 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
 #ifdef CONFIG_ACPI
 int acpi_i2c_install_space_handler(struct i2c_adapter *adapter);
 void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter);
+void acpi_i2c_register_devices(struct i2c_adapter *adap);
 #else
+static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {};
+
 static inline void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter)
 { }
 static inline int acpi_i2c_install_space_handler(struct i2c_adapter *adapter)
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

