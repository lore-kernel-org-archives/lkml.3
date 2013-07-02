Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3GBWl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:41:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44903 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3GBWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:41:20 -0400
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH V2] Add support driver for Intel Rapid Start Technology
Date: Tue,  2 Jul 2013 18:41:03 -0400
Message-Id: <1372804863-2861-1-git-send-email-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:422c:f4ff:fe92:dff9
X-SA-Exim-Mail-From: mjg59@srcf.ucam.org
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Rapid Start Technology is a firmware-based suspend-to-disk
implementation. Once placed in S3, the device will wake once either a
timeout elapses or the battery reaches a critical level. It will then resume
to the firmware and copy the contents of RAM to a specialised partition, and
then power off the machine. If the user turns the machine back on the
firmware will copy the contents of the partition back to RAM and then resume
from S3 as normal.

This driver provides an interface for configuring the wakeup events and
timeout. It still requires firmware support and an appropriate suspend
partition.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
---

V2 with the Makefile and Kconfig.

 .../ABI/testing/sysfs-driver-intel-rapid-start     |  21 +++
 drivers/platform/x86/Kconfig                       |  12 ++
 drivers/platform/x86/Makefile                      |   1 +
 drivers/platform/x86/intel-rst.c                   | 209 +++++++++++++++++++++
 4 files changed, 243 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-intel-rapid-start
 create mode 100644 drivers/platform/x86/intel-rst.c

diff --git a/Documentation/ABI/testing/sysfs-driver-intel-rapid-start b/Documentation/ABI/testing/sysfs-driver-intel-rapid-start
new file mode 100644
index 0000000..5a7d2e2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-intel-rapid-start
@@ -0,0 +1,21 @@
+What:		/sys/bus/acpi/intel-rapid-start/wakeup_events
+Date:		July 2, 2013
+KernelVersion:	3.11
+Contact:	Matthew Garrett <mjg59@srcf.ucam.org>
+Description:	An integer representing a set of wakeup events as follows:
+		1: Wake to enter hibernation when the wakeup timer expires
+		2: Wake to enter hibernation when the battery reaches a
+		critical level
+
+		These values are ORed together. For example, a value of 3
+		indicates that the system will wake to enter hibernation when
+		either the wakeup timer expires or the battery reaches a
+		critical level.
+
+What:		/sys/bus/acpi/intel-rapid-start/wakeup_time
+Date:		July 2, 2013
+KernelVersion:	3.11
+Contact:	Matthew Garrett <mjg59@srcf.ucam.org>
+Description:	An integer representing the length of time the system will
+		remain asleep before waking up to enter hibernation.
+		This value is in minutes.
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 8577261..2365d08 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -781,6 +781,18 @@ config APPLE_GMUX
 	  graphics as well as the backlight. Currently only backlight
 	  control is supported by the driver.
 
+config INTEL_RST
+        tristate "Intel Rapid Start Technology Driver"
+	depends on ACPI
+	---help---
+	  This driver provides support for modifying paramaters on systems
+	  equipped with Intel's Rapid Start Technology. When put in an ACPI
+	  sleep state, these devices will wake after either a configured
+	  timeout or when the system battery reaches a critical state,
+	  automatically copying memory contents to disk. On resume, the
+	  firmware will copy the memory contents back to RAM and resume the OS
+	  as usual.
+
 config PVPANIC
 	tristate "pvpanic device support"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index ef0ec74..5c669ce 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -51,5 +51,6 @@ obj-$(CONFIG_INTEL_OAKTRAIL)	+= intel_oaktrail.o
 obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
 obj-$(CONFIG_APPLE_GMUX)	+= apple-gmux.o
 obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
+obj-$(CONFIG_INTEL_RST)		+= intel-rst.o
 
 obj-$(CONFIG_PVPANIC)           += pvpanic.o
diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
new file mode 100644
index 0000000..9385afd
--- /dev/null
+++ b/drivers/platform/x86/intel-rst.c
@@ -0,0 +1,209 @@
+/*
+ *  Copyright 2013 Matthew Garrett <mjg59@srcf.ucam.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <acpi/acpi_drivers.h>
+
+MODULE_LICENSE("GPL");
+
+static ssize_t irst_show_wakeup_events(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct acpi_device *acpi;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *result;
+	acpi_status status;
+
+	acpi = to_acpi_device(dev);
+
+	status = acpi_evaluate_object(acpi->handle, "GFFS", NULL, &output);
+	if (!ACPI_SUCCESS(status))
+		return -EINVAL;
+
+	result = output.pointer;
+
+	if (result->type != ACPI_TYPE_INTEGER) {
+		kfree(result);
+		return -EINVAL;
+	}
+
+	return sprintf(buf, "%lld\n", result->integer.value);
+}
+
+static ssize_t irst_store_wakeup_events(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct acpi_device *acpi;
+	struct acpi_object_list input;
+	union acpi_object param;
+	acpi_status status;
+	unsigned long value;
+	int error;
+
+	acpi = to_acpi_device(dev);
+
+	error = kstrtoul(buf, 0, &value);
+
+	if (error)
+		return error;
+
+	param.type = ACPI_TYPE_INTEGER;
+	param.integer.value = value;
+
+	input.count = 1;
+	input.pointer = &param;
+
+	status = acpi_evaluate_object(acpi->handle, "SFFS", &input, NULL);
+
+	if (!ACPI_SUCCESS(status))
+		return -EINVAL;
+
+	return count;
+}
+
+static struct device_attribute irst_wakeup_attr = {
+	.attr = { .name = "wakeup_events", .mode = 0600 },
+	.show = irst_show_wakeup_events,
+	.store = irst_store_wakeup_events
+};
+
+static ssize_t irst_show_wakeup_time(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct acpi_device *acpi;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *result;
+	acpi_status status;
+
+	acpi = to_acpi_device(dev);
+
+	status = acpi_evaluate_object(acpi->handle, "GFTV", NULL, &output);
+	if (!ACPI_SUCCESS(status))
+		return -EINVAL;
+
+	result = output.pointer;
+
+	if (result->type != ACPI_TYPE_INTEGER) {
+		kfree(result);
+		return -EINVAL;
+	}
+
+	return sprintf(buf, "%lld\n", result->integer.value);
+}
+
+static ssize_t irst_store_wakeup_time(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct acpi_device *acpi;
+	struct acpi_object_list input;
+	union acpi_object param;
+	acpi_status status;
+	unsigned long value;
+	int error;
+
+	acpi = to_acpi_device(dev);
+
+	error = kstrtoul(buf, 0, &value);
+
+	if (error)
+		return error;
+
+	param.type = ACPI_TYPE_INTEGER;
+	param.integer.value = value;
+
+	input.count = 1;
+	input.pointer = &param;
+
+	status = acpi_evaluate_object(acpi->handle, "SFTV", &input, NULL);
+
+	if (!ACPI_SUCCESS(status))
+		return -EINVAL;
+
+	return count;
+}
+
+static struct device_attribute irst_timeout_attr = {
+	.attr = { .name = "wakeup_time", .mode = 0600 },
+	.show = irst_show_wakeup_time,
+	.store = irst_store_wakeup_time
+};
+
+static int irst_add(struct acpi_device *acpi)
+{
+	int error = 0;
+
+	error = device_create_file(&acpi->dev, &irst_timeout_attr);
+	if (error)
+		goto out;
+
+	error = device_create_file(&acpi->dev, &irst_wakeup_attr);
+	if (error)
+		goto out_timeout;
+
+	return 0;
+
+out_timeout:
+	device_remove_file(&acpi->dev, &irst_timeout_attr);
+out:
+	return error;
+}
+
+static int irst_remove(struct acpi_device *acpi)
+{
+	device_remove_file(&acpi->dev, &irst_wakeup_attr);
+	device_remove_file(&acpi->dev, &irst_timeout_attr);
+
+	return 0;
+}
+
+static const struct acpi_device_id irst_ids[] = {
+	{"INT3392", 0},
+	{"", 0}
+};
+
+static struct acpi_driver irst_driver = {
+	.owner = THIS_MODULE,
+	.name = "intel_rapid_start",
+	.class = "intel_rapid_start",
+	.ids = irst_ids,
+	.ops = {
+		.add = irst_add,
+		.remove = irst_remove,
+	},
+};
+
+static int irst_init(void)
+{
+	return acpi_bus_register_driver(&irst_driver);
+}
+
+static void irst_exit(void)
+{
+	acpi_bus_unregister_driver(&irst_driver);
+}
+
+module_init(irst_init);
+module_exit(irst_exit);
+
+MODULE_DEVICE_TABLE(acpi, irst_ids);
-- 
1.8.3.1

