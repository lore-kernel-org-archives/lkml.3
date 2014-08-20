Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaHTO6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:58:16 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60069 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaHTO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:58:12 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, linus.walleij@linaro.org, gnurou@gmail.com,
        mika.westerberg@linux.intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH] ACPI: Add GPIO-signaled event emulator.
Date: Wed, 20 Aug 2014 16:58:20 +0200
Message-Id: <1408546700-19309-1-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO-signaled events is quite new thing in Linux kernel.
There are not many board which can take advantage of it.
However, GPIO events are very useful feature during work on ACPI
subsystems.

This commit emulates GPIO h/w behaviour and consists on write
operation to debugfs file. GPIO device instance is still required in DSDT
table along with _AEI resources and event methods.

Please, see Kconfig help and driver head section for more details
regarding tool usage.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/Kconfig             |  10 ++
 drivers/acpi/Makefile            |   1 +
 drivers/acpi/gpio-acpi-evt-emu.c | 195 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+)
 create mode 100644 drivers/acpi/gpio-acpi-evt-emu.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index fd54a74..8b9b74d 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -122,6 +122,16 @@ config ACPI_BUTTON
 	  To compile this driver as a module, choose M here:
 	  the module will be called button.
 
+config ACPI_GPIO_EVT_EMULATE
+        bool "ACPI GPIO-signaled Events Emulation Support"
+        depends on DEBUG_FS
+	default n
+	help
+	  This will enable your system to emulate GPIO-signaled event through
+	  proc file system. User needs to trigger event method by
+	  echo 1 >  /sys/kernel/debug/acpi/events/<GPIO DEVICE>/<PIN>
+	  (where, GPIO DEVICE is a GPIO device name and PIN is a pin number).
+
 config ACPI_VIDEO
 	tristate "Video"
 	depends on X86 && BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 9fa20ff..24f9d8f 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -55,6 +55,7 @@ acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
 ifdef CONFIG_ACPI_VIDEO
 acpi-y				+= video_detect.o
 endif
+acpi-$(CONFIG_ACPI_GPIO_EVT_EMULATE)	+= gpio-acpi-evt-emu.o
 
 # These are (potentially) separate modules
 
diff --git a/drivers/acpi/gpio-acpi-evt-emu.c b/drivers/acpi/gpio-acpi-evt-emu.c
new file mode 100644
index 0000000..c39f501
--- /dev/null
+++ b/drivers/acpi/gpio-acpi-evt-emu.c
@@ -0,0 +1,195 @@
+/*
+ * Code to emulate GPIO-signaled events.
+ *
+ * The sole purpose of this module is to help with GPIO event triggering.
+ * Usage:
+ * 1. See the list of available GPIO devices and associated pins under:
+ *    /sys/kernel/debug/acpi/events/<GPIO DEVICE>/<PIN>. Only pins which are to
+ *    be used as GPIO-signaled events will be listed (_AEI resources).
+ *
+ * 2. Trigger method corresponding to device pin number:
+ *    $ echo 1 > /sys/kernel/debug/acpi/events/<GPIO DEVICE>/<PIN>
+ */
+
+/*
+ * Copyright (C) 2014, Linaro Ltd.
+ * Author: Tomasz Nowicki <tomasz.nowicki@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <linux/acpi.h>
+
+#include "acpica/accommon.h"
+#include "acpica/acnamesp.h"
+
+#include "internal.h"
+
+#define _COMPONENT		ACPI_SYSTEM_COMPONENT
+ACPI_MODULE_NAME("gpio_acpi_evt_emu");
+
+struct gpio_pin_parent_data {
+	acpi_handle handle;
+	struct dentry *debugfs_dir;
+	char *name;
+	unsigned int evt_count;
+};
+
+struct gpio_pin_data {
+	struct list_head list;
+	acpi_handle handle;
+	unsigned int pin;
+};
+
+static struct dentry *acpi_evt_debugfs_dir;
+static LIST_HEAD(pin_data_list);
+
+static int gpio_evt_trigger(void *data, u64 val)
+{
+	struct gpio_pin_data *pin_data = (struct gpio_pin_data *)data;
+	int pin = pin_data->pin;
+
+	if (ACPI_FAILURE(acpi_execute_simple_method(pin_data->handle, NULL,
+						    pin <= 255 ? 0 : pin)))
+		pr_err(PREFIX "evaluating event method failed\n");
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(gpio_evt_emu_fops, NULL, gpio_evt_trigger, "%llu\n");
+
+static acpi_status gpio_list_resource(struct acpi_resource *ares, void *context)
+{
+	struct acpi_resource_gpio *agpio = &ares->data.gpio;
+	struct gpio_pin_parent_data *parent_data = context;
+	struct dentry *pin_debugfs_dir;
+	struct gpio_pin_data *pin_data;
+	acpi_handle evt_handle;
+	acpi_status status;
+	char str_pin[5];
+	char ev_name[5];
+	int pin;
+
+	if (ares->type != ACPI_RESOURCE_TYPE_GPIO)
+		return AE_OK;
+
+	if (agpio->connection_type != ACPI_RESOURCE_GPIO_TYPE_INT)
+		return AE_OK;
+
+	pin_data = kmalloc(sizeof(*pin_data), GFP_KERNEL);
+	if (!pin_data)
+		return AE_NO_MEMORY;
+
+	pin = agpio->pin_table[0];
+	snprintf(str_pin, 5, "%d", pin);
+	pin_debugfs_dir = debugfs_create_file(str_pin, S_IWUSR,
+					      parent_data->debugfs_dir,
+					      pin_data,
+					      &gpio_evt_emu_fops);
+	if (!pin_debugfs_dir) {
+		status = AE_NULL_ENTRY;
+		goto fail;
+	}
+
+	if (pin <= 255)
+		sprintf(ev_name, "_%c%02X",
+			agpio->triggering == ACPI_EDGE_SENSITIVE ? 'E' : 'L',
+			pin);
+	else
+		sprintf(ev_name, "_EVT");
+
+	status = acpi_get_handle(parent_data->handle, ev_name, &evt_handle);
+	if (ACPI_FAILURE(status)) {
+		pr_err(PREFIX "getting handle to <%s> of <%s> failed, there is no method related to 0x%02X pin\n",
+		       ev_name, parent_data->name, pin);
+		goto fail;
+	}
+
+	pin_data->handle = evt_handle;
+	pin_data->pin = pin;
+        list_add_tail(&pin_data->list, &pin_data_list);
+
+	parent_data->evt_count++;
+
+	return AE_OK;
+fail:
+	kfree(pin_data);
+	return status;
+}
+
+static acpi_status gpio_find_resource(acpi_handle handle, u32 lvl,
+					  void *context, void **rv)
+{
+	struct acpi_namespace_node *node;
+	struct dentry *gpio_debugfs_dir;
+	struct gpio_pin_parent_data parent_data;
+	char gpio_name[5];
+
+	node = acpi_ns_validate_handle(handle);
+	if (!node) {
+		pr_err(PREFIX "Mapping GPIO handle to node failed\n");
+		return AE_BAD_PARAMETER;
+	}
+
+	snprintf(gpio_name, 5, "%s", node->name.ascii);
+	gpio_debugfs_dir = debugfs_create_dir(gpio_name, acpi_evt_debugfs_dir);
+	if (gpio_debugfs_dir == NULL)
+		return AE_OK;
+
+	parent_data.debugfs_dir = gpio_debugfs_dir;
+	parent_data.handle = handle;
+	parent_data.name = gpio_name;
+	parent_data.evt_count = 0;
+
+	acpi_walk_resources(handle, METHOD_NAME__AEI, gpio_list_resource,
+			    &parent_data);
+
+	if (!parent_data.evt_count)
+		debugfs_remove(gpio_debugfs_dir);
+
+	return AE_OK;
+}
+
+static int __init gpio_evt_emu_init(void)
+{
+	if (acpi_debugfs_dir == NULL)
+		return -ENOENT;
+
+	acpi_evt_debugfs_dir = debugfs_create_dir("events", acpi_debugfs_dir);
+	if (acpi_evt_debugfs_dir == NULL)
+		return -ENOENT;
+
+	acpi_get_devices(NULL, gpio_find_resource, NULL, NULL);
+
+	return 0;
+}
+
+static void __exit gpio_evt_emu_deinit(void)
+{
+	struct gpio_pin_data *pin_data, *temp;
+
+	list_for_each_entry_safe(pin_data, temp, &pin_data_list, list)
+		kfree(pin_data);
+
+	debugfs_remove_recursive(acpi_evt_debugfs_dir);
+}
+
+module_init(gpio_evt_emu_init);
+module_exit(gpio_evt_emu_deinit);
+
+MODULE_DESCRIPTION("GPIO-signaled events emulator");
+MODULE_LICENSE("GPL");
-- 
1.9.1

