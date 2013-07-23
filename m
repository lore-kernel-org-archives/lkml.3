Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab3GWILG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:11:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:28284 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab3GWIKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="271952430"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH 13/13] ACPI/IPMI: Add IPMI operation region test device driver
Date: Tue, 23 Jul 2013 16:10:44 +0800
Message-Id: <5fb4a29d99393e18305d3b25eaff31cd12fe7cf7.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is only used for test purpose and should not be merged by any
public Linux kernel repositories.

This patch contains one driver that can drive a fake test device accessing
IPMI operation region fields.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/Kconfig     |   68 +++++++++++++
 drivers/acpi/Makefile    |    1 +
 drivers/acpi/ipmi_test.c |  254 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 323 insertions(+)
 create mode 100644 drivers/acpi/ipmi_test.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index d129869..e3dd3fd 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -377,6 +377,74 @@ config ACPI_BGRT
 	  data from the firmware boot splash. It will appear under
 	  /sys/firmware/acpi/bgrt/ .
 
+config ACPI_IPMI_TEST
+	tristate "IPMI operation region tester"
+	help
+	  This is a test device written for such fake ACPI namespace device.
+	    Device (PMIT)
+	    {
+	        Name (_HID, "ZETA0000")  // _HID: Hardware ID
+	        Name (_STA, 0x0F)  // _STA: Status
+	        OperationRegion (SYSI, IPMI, 0x0600, 0x0100)
+	        Field (SYSI, BufferAcc, Lock, Preserve)
+	        {
+	            AccessAs (BufferAcc, 0x01),
+                   Offset (0x01),
+	            GDIC,   8,	// Get Device ID Command
+	        }
+	        Method (GDIM, 0, NotSerialized)  // GDIM: Get Device ID Method
+	        {
+	            Name (GDIR, Package (0x08)
+	            {
+	                0x00,
+	                0x00,
+	                0x0000,
+	                0x00,
+	                0x00,
+	                Buffer (0x03) {0x00, 0x00, 0x00},
+	                Buffer (0x02) {0x00, 0x00},
+	                0x00000000
+	            })
+	            Name (BUFF, Buffer (0x42) {})
+	            CreateByteField (BUFF, 0x00, STAT)
+	            CreateByteField (BUFF, 0x01, LENG)
+	            CreateByteField (BUFF, 0x02, CMPC)
+	            CreateByteField (BUFF, 0x03, DID)
+	            CreateByteField (BUFF, 0x04, DREV)
+	            CreateWordField (BUFF, 0x05, FREV)
+	            CreateByteField (BUFF, 0x07, SREV)
+	            CreateByteField (BUFF, 0x08, ADS)
+	            CreateByteField (BUFF, 0x09, VID0)
+	            CreateByteField (BUFF, 0x0A, VID1)
+	            CreateByteField (BUFF, 0x0B, VID2)
+	            CreateByteField (BUFF, 0x0C, PID0)
+	            CreateByteField (BUFF, 0x0D, PID1)
+	            CreateDWordField (BUFF, 0x0E, AFRI)
+	            Store (0x00, LENG)
+	            Store (Store (BUFF, GDIC), BUFF)
+	            If (LAnd (LEqual (STAT, 0x00), LEqual (CMPC, 0x00)))
+	            {
+	                Name (VBUF, Buffer (0x03) { 0x00, 0x00, 0x00 })
+	                Name (PBUF, Buffer (0x02) { 0x00, 0x00 })
+	                Store (DID, Index (GDIR, 0x00))
+	                Store (DREV, Index (GDIR, 0x01))
+	                Store (FREV, Index (GDIR, 0x02))
+	                Store (SREV, Index (GDIR, 0x03))
+	                Store (ADS, Index (GDIR, 0x04))
+	                Store (VID0, Index (VBUF, 0x00))
+	                Store (VID1, Index (VBUF, 0x01))
+	                Store (VID2, Index (VBUF, 0x02))
+	                Store (VBUF, Index (GDIR, 0x05))
+	                Store (PID0, Index (PBUF, 0x00))
+	                Store (PID1, Index (PBUF, 0x01))
+	                Store (PBUF, Index (GDIR, 0x06))
+	                Store (AFRI, Index (GDIR, 0x07))
+	            }
+	            Return (GDIR)
+	        }
+	    }
+	  It is for validation purpose, only calls "Get Device ID" command.
+
 source "drivers/acpi/apei/Kconfig"
 
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 81dbeb8..1476623 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
 obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
 obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
 obj-$(CONFIG_ACPI_I2C)		+= acpi_i2c.o
+obj-$(CONFIG_ACPI_IPMI_TEST)	+= ipmi_test.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_driver.o processor_throttling.o
diff --git a/drivers/acpi/ipmi_test.c b/drivers/acpi/ipmi_test.c
new file mode 100644
index 0000000..5d144e4
--- /dev/null
+++ b/drivers/acpi/ipmi_test.c
@@ -0,0 +1,254 @@
+/*
+ * An IPMI operation region tester driver
+ *
+ * Copyright (C) 2013 Intel Corporation
+ *   Author: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/acpi.h>
+
+#define ACPI_IPMI_TEST_NAME		"ipmi_test"
+ACPI_MODULE_NAME(ACPI_IPMI_TEST_NAME);
+
+#define ACPI_IPMI_TEST_DEVICE		"IPMI Test"
+#define ACPI_IPMI_TEST_CLASS		"ipmi_tester"
+
+static const struct acpi_device_id acpi_ipmi_test_ids[] = {
+	{"ZETA0000", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, acpi_ipmi_test_ids);
+
+struct acpi_ipmi_device_id {
+	u64	device_id;
+	u64	device_rev;
+	u64	firmware_rev;
+	u64	ipmi_version;
+	u64	additional_dev_support;
+	u8	*vendor_id;
+	u8	*product_id;
+	u64	aux_firm_rev_info;
+	u8	extra_buf[5];
+} __packed;
+
+struct acpi_ipmi_tester {
+	struct acpi_device	*adev;
+	acpi_bus_id		name;
+	struct acpi_ipmi_device_id	device_id;
+	int			registered_group;
+};
+
+#define ipmi_err(tester, fmt, ...)	\
+	dev_err(&(tester)->adev->dev, fmt, ##__VA_ARGS__)
+#define ipmi_info(tester, fmt, ...)	\
+	dev_info(&(tester)->adev->dev, fmt, ##__VA_ARGS__)
+#define IPMI_ACPI_HANDLE(tester)	((tester)->adev->handle)
+
+static int acpi_ipmi_update_device_id(struct acpi_ipmi_tester *tester)
+{
+	int res = 0;
+	acpi_status status;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer format = { sizeof("NNNNNBBN"), "NNNNNBBN" };
+	struct acpi_buffer device_id = { 0, NULL };
+	union acpi_object *did;
+
+	status = acpi_evaluate_object(IPMI_ACPI_HANDLE(tester), "GDIM", NULL,
+				      &buffer);
+	if (ACPI_FAILURE(status) || !buffer.pointer) {
+		ipmi_err(tester, "Evaluating GDIM, status - %d\n", status);
+		return -ENODEV;
+	}
+
+	did = buffer.pointer;
+	if (did->type != ACPI_TYPE_PACKAGE || did->package.count != 8) {
+		ipmi_err(tester, "Invalid GDIM data, type - %d, count - %d\n",
+			 did->type, did->package.count);
+		res = -EFAULT;
+		goto err_buf;
+	}
+
+	device_id.length = sizeof(struct acpi_ipmi_device_id);
+	device_id.pointer = &tester->device_id;
+
+	status = acpi_extract_package(did, &format, &device_id);
+	if (ACPI_FAILURE(status)) {
+		ipmi_err(tester, "Invalid GDIM data\n");
+		res = -EFAULT;
+		goto err_buf;
+	}
+
+err_buf:
+	kfree(buffer.pointer);
+	return res;
+}
+
+static ssize_t show_device_id(struct device *device,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(device);
+	struct acpi_ipmi_tester *tester = adev->driver_data;
+
+	acpi_ipmi_update_device_id(tester);
+	return sprintf(buf, "%llu\n", tester->device_id.device_id);
+}
+
+static ssize_t show_device_rev(struct device *device,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(device);
+	struct acpi_ipmi_tester *tester = adev->driver_data;
+
+	acpi_ipmi_update_device_id(tester);
+	return sprintf(buf, "%llu\n", tester->device_id.device_rev);
+}
+
+static ssize_t show_firmware_rev(struct device *device,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(device);
+	struct acpi_ipmi_tester *tester = adev->driver_data;
+
+	acpi_ipmi_update_device_id(tester);
+	return sprintf(buf, "%llu\n", tester->device_id.firmware_rev);
+}
+
+static ssize_t show_ipmi_version(struct device *device,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(device);
+	struct acpi_ipmi_tester *tester = adev->driver_data;
+
+	acpi_ipmi_update_device_id(tester);
+	return sprintf(buf, "%llu\n", tester->device_id.ipmi_version);
+}
+
+static ssize_t show_vendor_id(struct device *device,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(device);
+	struct acpi_ipmi_tester *tester = adev->driver_data;
+
+	acpi_ipmi_update_device_id(tester);
+	return sprintf(buf, "%02x %02x %02x\n",
+		       tester->device_id.vendor_id[0],
+		       tester->device_id.vendor_id[1],
+		       tester->device_id.vendor_id[2]);
+}
+
+static ssize_t show_product_id(struct device *device,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(device);
+	struct acpi_ipmi_tester *tester = adev->driver_data;
+
+	acpi_ipmi_update_device_id(tester);
+	return sprintf(buf, "%02x %02x\n",
+		       tester->device_id.product_id[0],
+		       tester->device_id.product_id[1]);
+}
+
+static DEVICE_ATTR(device_id, S_IRUGO, show_device_id, NULL);
+static DEVICE_ATTR(device_rev, S_IRUGO, show_device_rev, NULL);
+static DEVICE_ATTR(firmware_rev, S_IRUGO, show_firmware_rev, NULL);
+static DEVICE_ATTR(ipmi_version, S_IRUGO, show_ipmi_version, NULL);
+static DEVICE_ATTR(vendor_id, S_IRUGO, show_vendor_id, NULL);
+static DEVICE_ATTR(product_id, S_IRUGO, show_product_id, NULL);
+
+static struct attribute *acpi_ipmi_test_attrs[] = {
+	&dev_attr_device_id.attr,
+	&dev_attr_device_rev.attr,
+	&dev_attr_firmware_rev.attr,
+	&dev_attr_ipmi_version.attr,
+	&dev_attr_vendor_id.attr,
+	&dev_attr_product_id.attr,
+	NULL,
+};
+
+static struct attribute_group acpi_ipmi_test_group = {
+	.attrs	= acpi_ipmi_test_attrs,
+};
+
+static int acpi_ipmi_test_add(struct acpi_device *device)
+{
+	struct acpi_ipmi_tester *tester;
+
+	if (!device)
+		return -EINVAL;
+
+	tester = kzalloc(sizeof(struct acpi_ipmi_tester), GFP_KERNEL);
+	if (!tester)
+		return -ENOMEM;
+
+	tester->adev = device;
+	strcpy(acpi_device_name(device), ACPI_IPMI_TEST_DEVICE);
+	strcpy(acpi_device_class(device), ACPI_IPMI_TEST_CLASS);
+	device->driver_data = tester;
+	if (sysfs_create_group(&device->dev.kobj, &acpi_ipmi_test_group) == 0)
+		tester->registered_group = 1;
+
+	return 0;
+}
+
+static int acpi_ipmi_test_remove(struct acpi_device *device)
+{
+	struct acpi_ipmi_tester *tester;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	tester = acpi_driver_data(device);
+
+	if (tester->registered_group)
+		sysfs_remove_group(&device->dev.kobj, &acpi_ipmi_test_group);
+
+	kfree(tester);
+	return 0;
+}
+
+static struct acpi_driver acpi_ipmi_test_driver = {
+	.name = "ipmi_test",
+	.class = ACPI_IPMI_TEST_CLASS,
+	.ids = acpi_ipmi_test_ids,
+	.ops = {
+		.add = acpi_ipmi_test_add,
+		.remove = acpi_ipmi_test_remove,
+	},
+};
+
+static int __init acpi_ipmi_test_init(void)
+{
+	return acpi_bus_register_driver(&acpi_ipmi_test_driver);
+}
+module_init(acpi_ipmi_test_init);
+
+static void __exit acpi_ipmi_test_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_ipmi_test_driver);
+}
+module_exit(acpi_ipmi_test_exit);
+
+MODULE_AUTHOR("Lv Zheng <lv.zheng@intel.com>");
+MODULE_DESCRIPTION("ACPI IPMI operation region tester driver");
+MODULE_LICENSE("GPL");
-- 
1.7.10

