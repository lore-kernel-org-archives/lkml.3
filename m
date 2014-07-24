Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbaGXPvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:51:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58204 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaGXPvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:51:22 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [RFC] ACPI: Add GPIO-signaled event simulator.
Date: Thu, 24 Jul 2014 17:51:16 +0200
Message-Id: <1406217076-17150-1-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO signaled events is quite new thing in Linux kernel.
AFAIK, there are not many board which can take advantage of it.
However, GPIO events are very useful feature during work on ACPI
subsystems.

This commit emulates GPIO h/w behaviour and consists on read/write
operation to debugfs file. GPIO device instance is still required in DSDT
table along with _AEI resources and event methods.

Reading from file provides pin to GPIO device map e.g. :
$ cat /sys/kernel/debug/acpi/gpio_event
GPIO device name: /__SB.GPI0
Available GPIO pin map:
/__SB.GPI0 <-> pin 0x100

Based on that, user can trigger method corresponding to device pin number:
$ echo "/__SB.GPI0 0x100" > /sys/kernel/debug/acpi/gpio_event

Please, see Kconfig help and driver head section for more details
regarding tool usage.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/Kconfig        |  11 +++
 drivers/acpi/Makefile       |   1 +
 drivers/acpi/gpio_evt_emu.c | 207 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+)
 create mode 100644 drivers/acpi/gpio_evt_emu.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index fd54a74..59e4c67 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -122,6 +122,17 @@ config ACPI_BUTTON
 	  To compile this driver as a module, choose M here:
 	  the module will be called button.
 
+config ACPI_GPIO_EVT_EMULATE
+        bool "ACPI GPIO-signaled Events Emulation Support"
+        depends on DEBUG_FS
+	default n
+	help
+	  This will enable your system to emulate GPIO-signaled event through
+	  proc file system /sys/kernel/debug/acpi/gpio_event. User needs to print
+	  available GPIO devices and pin map (cat path_to_proc_file) so that he
+	  knows how to trigger given event by echo "XXX YYY" > path_to_proc_file
+	  (where, XXX is a path to GPIO device and YYY is a pin number).
+
 config ACPI_VIDEO
 	tristate "Video"
 	depends on X86 && BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 9fa20ff..fb3c335 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -55,6 +55,7 @@ acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
 ifdef CONFIG_ACPI_VIDEO
 acpi-y				+= video_detect.o
 endif
+acpi-$(CONFIG_ACPI_GPIO_EVT_EMULATE)	+= gpio_evt_emu.o
 
 # These are (potentially) separate modules
 
diff --git a/drivers/acpi/gpio_evt_emu.c b/drivers/acpi/gpio_evt_emu.c
new file mode 100644
index 0000000..a2f762c
--- /dev/null
+++ b/drivers/acpi/gpio_evt_emu.c
@@ -0,0 +1,207 @@
+/*
+ * Code to emulate GPIO-signaled events.
+ *
+ * The sole purpose of this module is to help with GPIO event triggering.
+ * Suggested way of using:
+ * 1. Perform walk of the namespac device tree looking for GPIO devices
+ *    with associated _AEI resources e.g.:
+ *    $ cat /sys/kernel/debug/acpi/gpio_event
+ *    GPIO device name: /__SB.GPI0
+ *    Available GPIO pin map:
+ *    /__SB.GPI0 <-> pin 0x100
+ *
+ * 2. Trigger method corresponding to device pin number:
+ *    $ echo "/__SB.GPI0 0x100" > /sys/kernel/debug/acpi/gpio_event
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
+static struct dentry *gpio_evt_dentry;
+
+static void gpio_trigger_event(char *gpio_path, u32 pin)
+{
+	acpi_handle gpio_handle, evt_handle;
+	char ev_name[5];
+
+	if (ACPI_FAILURE(acpi_get_handle(NULL, gpio_path, &gpio_handle))) {
+		pr_err(PREFIX "getting handle to <%s> failed\n", gpio_path);
+		return;
+	}
+
+	if (pin <= 255)
+		sprintf(ev_name, "_L%02X", pin);
+	else
+		sprintf(ev_name, "_EVT");
+
+
+	if (ACPI_FAILURE(acpi_get_handle(gpio_handle, ev_name, &evt_handle))) {
+		pr_err(PREFIX "getting handle to <%s.%s> failed, there is no method related to 0x%02X pin\n",
+		       gpio_path, ev_name, pin);
+		return;
+	}
+
+	if (ACPI_FAILURE(acpi_execute_simple_method(evt_handle, NULL,
+						    pin <= 255 ? 0 : pin)))
+		pr_err(PREFIX "evaluating <%s._EVT for pin %d> failed\n",
+		       gpio_path, pin);
+
+	return;
+}
+
+static ssize_t gpio_evt_write(struct file *file, const char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	u32 pin_number;
+	char *gpio_path = NULL;
+	char *pin_str = NULL;
+	const char *delim = " ";
+	char *temp_buf = NULL;
+	char *temp_buf_addr = NULL;
+
+	temp_buf = kmalloc(count+1, GFP_ATOMIC);
+	if (!temp_buf) {
+		pr_warn(PREFIX "%s: Memory allocation failed\n", __func__);
+		return count;
+	}
+	temp_buf[count] = '\0';
+	temp_buf_addr = temp_buf;
+	if (copy_from_user(temp_buf, user_buf, count))
+		goto out;
+
+	gpio_path = strsep(&temp_buf, delim);
+	pin_str = strsep(&temp_buf, delim);
+
+	if (gpio_path && pin_str) {
+		ssize_t ret;
+		unsigned long val;
+
+		ret = kstrtoul(pin_str, 10, &val);
+		if (ret) {
+			pr_warn(PREFIX "unknown event\n");
+			goto out;
+		}
+
+		pin_number = (u32)val;
+	} else {
+		pr_warn(PREFIX "unknown device\n");
+		goto out;
+	}
+
+	pr_info(PREFIX "ACPI device name is <%s>, pin number is <%d>\n",
+		gpio_path, pin_number);
+
+	gpio_trigger_event(gpio_path, pin_number);
+
+out:
+	kfree(temp_buf_addr);
+	return count;
+}
+
+static acpi_status gpio_list_resource(struct acpi_resource *ares,
+					   void *context)
+{
+	struct acpi_resource_gpio *agpio;
+	struct seq_file *m = context;
+	int pin;
+
+	if (!m)
+		return AE_OK;
+
+	if (ares->type != ACPI_RESOURCE_TYPE_GPIO)
+		return AE_OK;
+
+	agpio = &ares->data.gpio;
+	if (agpio->connection_type != ACPI_RESOURCE_GPIO_TYPE_INT)
+		return AE_OK;
+
+	pin = agpio->pin_table[0];
+        seq_printf(m, "%s <-> pin %d\n", agpio->resource_source.string_ptr,
+        	   pin);
+
+	return AE_OK;
+}
+
+static acpi_status gpio_find_resource(acpi_handle handle, u32 lvl,
+					  void *context, void **rv)
+{
+	struct acpi_namespace_node *node;
+	struct seq_file *m = context;
+
+	if (ACPI_FAILURE(acpi_walk_resources(handle, METHOD_NAME__AEI,
+					gpio_list_resource, NULL)))
+		return AE_OK;
+
+	node = acpi_ns_validate_handle(handle);
+	if (!node) {
+		pr_err(PREFIX "Mapping GPIO handle to node failed\n");
+		return AE_OK;
+	}
+
+	seq_printf(m, "GPIO device name: %4.4s\nAvailable GPIO pin map:\n",
+		   ACPI_CAST_PTR(char, &node->name));
+	acpi_walk_resources(handle, METHOD_NAME__AEI, gpio_list_resource,
+			    context);
+	return AE_OK;
+}
+
+static int gpio_evt_show(struct seq_file *m, void *v)
+{
+	acpi_get_devices(NULL, gpio_find_resource, m, NULL);
+	return 0;
+}
+
+static int gpio_evt_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, gpio_evt_show, NULL);
+}
+
+static const struct file_operations gpio_evt_emu_fops = {
+	.open = gpio_evt_open,
+	.write = gpio_evt_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init gpio_evt_emu_init(void)
+{
+	if (acpi_debugfs_dir == NULL)
+		return -ENOENT;
+
+	gpio_evt_dentry = debugfs_create_file("gpio_event", S_IWUSR,
+				acpi_debugfs_dir, NULL, &gpio_evt_emu_fops);
+	if (gpio_evt_dentry == NULL)
+		return -ENODEV;
+
+	return 0;
+}
+
+device_initcall(gpio_evt_emu_init);
+ACPI_MODULE_NAME("acpi_evt_emu");
+MODULE_LICENSE("GPL");
-- 
1.9.1

