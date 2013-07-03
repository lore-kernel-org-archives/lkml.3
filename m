Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab3GCEu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 00:50:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47652 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3GCEuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 00:50:25 -0400
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] Add trivial driver to disable Intel Smart Connect
Date: Wed,  3 Jul 2013 00:50:13 -0400
Message-Id: <1372827013-7301-1-git-send-email-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:422c:f4ff:fe92:dff9
X-SA-Exim-Mail-From: mjg59@srcf.ucam.org
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Smart Connect is an Intel-specific ACPI interface for configuring
devices to wake up at regular intervals so they can pull down mail or other
internet updates, and then go to sleep again. If a user enables this in
Windows and then reboots into Linux, the device may wake up if it's put to
sleep. Since there's no Linux userland support for any of this, the machine
will then remain awake until something else puts it back to sleep.

I haven't figured out all that much about how this works (there's a bunch
of different ACPI calls available on the device), but this seems to be
enough to turn it off. We can add more features to this driver if anyone
ever cares about figuring out what the rest of the calls do or writing some
Linux userspace to implement the rest of it.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
---
 drivers/platform/x86/Kconfig              | 14 +++++
 drivers/platform/x86/Makefile             |  1 +
 drivers/platform/x86/intel-smartconnect.c | 90 +++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)
 create mode 100644 drivers/platform/x86/intel-smartconnect.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2365d08..db14408 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -793,6 +793,20 @@ config INTEL_RST
 	  firmware will copy the memory contents back to RAM and resume the OS
 	  as usual.
 
+config INTEL_SMARTCONNECT
+        tristate "Intel Smart Connect disabling driver"
+	depends on ACPI
+	---help---
+	  Intel Smart Connect is a technology intended to permit devices to
+	  update state by resuming for a short period of time at regular
+	  intervals. If a user enables this functionality under Windows and
+	  then reboots into Linux, the system may remain configured to resume
+	  on suspend. In the absence of any userspace to support it, the system
+	  will then remain awake until something triggers another suspend.
+
+	  This driver checks to determine whether the device has Intel Smart
+	  Connect enabled, and if so disables it.
+
 config PVPANIC
 	tristate "pvpanic device support"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 5c669ce..5dbe193 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -52,5 +52,6 @@ obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
 obj-$(CONFIG_APPLE_GMUX)	+= apple-gmux.o
 obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
 obj-$(CONFIG_INTEL_RST)		+= intel-rst.o
+obj-$(CONFIG_INTEL_SMARTCONNECT)	+= intel-smartconnect.o
 
 obj-$(CONFIG_PVPANIC)           += pvpanic.o
diff --git a/drivers/platform/x86/intel-smartconnect.c b/drivers/platform/x86/intel-smartconnect.c
new file mode 100644
index 0000000..f74e93d
--- /dev/null
+++ b/drivers/platform/x86/intel-smartconnect.c
@@ -0,0 +1,90 @@
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
+#include <acpi/acpi_drivers.h>
+
+MODULE_LICENSE("GPL");
+
+static int smartconnect_acpi_init(struct acpi_device *acpi)
+{
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *result;
+	union acpi_object param;
+	acpi_status status;
+
+	status = acpi_evaluate_object(acpi->handle, "GAOS", NULL, &output);
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
+	if (result->integer.value & 0x1) {
+		param.type = ACPI_TYPE_INTEGER;
+		param.integer.value = 0;
+
+		input.count = 1;
+		input.pointer = &param;
+
+		dev_info(&acpi->dev, "Disabling Intel Smart Connect\n");
+		status = acpi_evaluate_object(acpi->handle, "SAOS", &input,
+					      NULL);
+	}
+
+	kfree(result);
+
+	return 0;
+}
+
+static const struct acpi_device_id smartconnect_ids[] = {
+	{"INT33A0", 0},
+	{"", 0}
+};
+
+static struct acpi_driver smartconnect_driver = {
+	.owner = THIS_MODULE,
+	.name = "intel_smart_connect",
+	.class = "intel_smart_connect",
+	.ids = smartconnect_ids,
+	.ops = {
+		.add = smartconnect_acpi_init,
+	},
+};
+
+static int smartconnect_init(void)
+{
+	return acpi_bus_register_driver(&smartconnect_driver);
+}
+
+static void smartconnect_exit(void)
+{
+	acpi_bus_unregister_driver(&smartconnect_driver);
+}
+
+module_init(smartconnect_init);
+module_exit(smartconnect_exit);
+
+MODULE_DEVICE_TABLE(acpi, smartconnect_ids);
-- 
1.8.3.1

