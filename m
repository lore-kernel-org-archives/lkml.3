Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaKWPKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:10:39 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59242 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaKWPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:09:52 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/3] platform: x86: dell-rbtn: Dell Airplane Mode Switch driver
Date: Sun, 23 Nov 2014 16:09:19 +0100
Message-Id: <1416755361-17357-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an ACPI driver for Dell laptops which receive HW switch events.
It exports rfkill device dell-rbtn which provide correct hard rfkill state.

It does not provide support for setting soft rfkill state yet.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/platform/x86/Kconfig     |   13 +++
 drivers/platform/x86/Makefile    |    1 +
 drivers/platform/x86/dell-rbtn.c |  179 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 193 insertions(+)
 create mode 100644 drivers/platform/x86/dell-rbtn.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 4dcfb71..5a2ba64 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -137,6 +137,19 @@ config DELL_SMO8800
 	  To compile this driver as a module, choose M here: the module will
 	  be called dell-smo8800.
 
+config DELL_RBTN
+	tristate "Dell Airplane Mode Switch driver"
+	depends on ACPI
+	depends on RFKILL
+	---help---
+	  Say Y here if you want to support Dell Airplane Mode Switch ACPI
+	  device on Dell laptops. Sometimes it has names: DELLABCE or DELRBTN.
+	  This driver register rfkill device and receives HW rfkill events
+	  (when wifi/bluetooth was enabled) and set correct hard rfkill state.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called dell-rbtn.
+
 
 config FUJITSU_LAPTOP
 	tristate "Fujitsu Laptop Extras"
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index f82232b..b3e54ed 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
 obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
 obj-$(CONFIG_DELL_WMI_AIO)	+= dell-wmi-aio.o
 obj-$(CONFIG_DELL_SMO8800)	+= dell-smo8800.o
+obj-$(CONFIG_DELL_RBTN)		+= dell-rbtn.o
 obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
 obj-$(CONFIG_ACERHDF)		+= acerhdf.o
 obj-$(CONFIG_HP_ACCEL)		+= hp_accel.o
diff --git a/drivers/platform/x86/dell-rbtn.c b/drivers/platform/x86/dell-rbtn.c
new file mode 100644
index 0000000..f1f039a
--- /dev/null
+++ b/drivers/platform/x86/dell-rbtn.c
@@ -0,0 +1,179 @@
+/*
+    Dell Airplane Mode Switch driver
+    Copyright (C) 2014  Pali Rohár <pali.rohar@gmail.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+*/
+
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <linux/rfkill.h>
+
+/*** helper functions ***/
+
+static int rbtn_check(struct acpi_device *device)
+{
+	acpi_status status;
+	unsigned long long output;
+
+	status = acpi_evaluate_integer(device->handle, "CRBT", NULL, &output);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	if (output > 3)
+		return -EINVAL;
+
+	return 0;
+}
+
+
+/*** rfkill ops ***/
+
+static void rbtn_query(struct rfkill *rfkill, void *data)
+{
+	struct acpi_device *device = data;
+	acpi_status status;
+	unsigned long long output;
+
+	status = acpi_evaluate_integer(device->handle, "GRBT", NULL, &output);
+	if (ACPI_FAILURE(status))
+		return;
+
+	rfkill_set_states(rfkill, !output, !output);
+}
+
+static int rbtn_set_block(void *data, bool blocked)
+{
+	/* FIXME: setting soft rfkill cause problems, so disable it for now */
+	return -EINVAL;
+}
+
+struct rfkill_ops rbtn_ops = {
+	.query = rbtn_query,
+	.set_block = rbtn_set_block,
+};
+
+
+/*** acpi driver ***/
+
+static int rbtn_add(struct acpi_device *device);
+static int rbtn_remove(struct acpi_device *device);
+static void rbtn_notify(struct acpi_device *device, u32 event);
+
+static const struct acpi_device_id rbtn_ids[] = {
+	{ "DELRBTN", 0 },
+	{ "DELLABCE", 0 },
+	{ "", 0 },
+};
+
+static struct acpi_driver rbtn_driver = {
+	.name = "dell-rbtn",
+	.ids = rbtn_ids,
+	.ops = {
+		.add = rbtn_add,
+		.remove = rbtn_remove,
+		.notify = rbtn_notify,
+	},
+	.owner = THIS_MODULE,
+};
+
+
+/*** rfkill enable/disable ***/
+
+static int rbtn_enable(struct acpi_device *device)
+{
+	struct rfkill *rfkill = device->driver_data;
+	int ret;
+
+	if (rfkill)
+		return 0;
+
+	/* NOTE: rbtn controls all radio devices, not only WLAN
+	         but rfkill interface does not support "ANY" type
+	         so "WLAN" type is used
+	 */
+	rfkill = rfkill_alloc("dell-rbtn", &device->dev, RFKILL_TYPE_WLAN,
+			      &rbtn_ops, device);
+	if (!rfkill)
+		return -ENOMEM;
+
+	ret = rfkill_register(rfkill);
+	if (ret) {
+		rfkill_destroy(rfkill);
+		return ret;
+	}
+
+	device->driver_data = rfkill;
+	return 0;
+}
+
+static void rbtn_disable(struct acpi_device *device)
+{
+	struct rfkill *rfkill = device->driver_data;
+
+	if (!rfkill)
+		return;
+
+	rfkill_unregister(rfkill);
+	rfkill_destroy(rfkill);
+	device->driver_data = NULL;
+}
+
+
+/*** acpi driver functions ***/
+
+static int rbtn_add(struct acpi_device *device)
+{
+	int ret;
+
+	ret = rbtn_check(device);
+	if (ret < 0)
+		return ret;
+
+	return rbtn_enable(device);
+}
+
+static int rbtn_remove(struct acpi_device *device)
+{
+	rbtn_disable(device);
+	return 0;
+}
+
+static void rbtn_notify(struct acpi_device *device, u32 event)
+{
+	struct rfkill *rfkill = device->driver_data;
+
+	if (event == 0x80)
+		rbtn_query(rfkill, device);
+	else
+		dev_info(&device->dev, "Received unknown event (0x%x)\n", event);
+}
+
+
+/*** module functions ***/
+
+static int __init rbtn_init(void)
+{
+	return acpi_bus_register_driver(&rbtn_driver);
+}
+
+static void __exit rbtn_exit(void)
+{
+	acpi_bus_unregister_driver(&rbtn_driver);
+}
+
+module_init(rbtn_init);
+module_exit(rbtn_exit);
+
+MODULE_DEVICE_TABLE(acpi, rbtn_ids);
+MODULE_DESCRIPTION("Dell Airplane Mode Switch driver");
+MODULE_AUTHOR("Pali Rohár <pali.rohar@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

