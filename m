Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaECKtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 06:49:12 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64392 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaECKtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 06:49:08 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-doc@vger.kernel.org, Sonal Santan <sonal.santan@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/2] platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
Date: Sat,  3 May 2014 12:47:56 +0200
Message-Id: <1399114077-19314-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com>
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This acpi driver provide supports for freefall sensors SMO8800/SMO8810 which
can be found on Dell Latitude laptops. Driver register /dev/freefall misc
device which has same interface as driver hp_accel freefall driver. So any
existing applications for HP freefall sensor /dev/freefall will work for with
this new driver for Dell Latitude laptops too.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Cc: Sonal Santan <sonal.santan@gmail.com>
---
 drivers/platform/x86/Kconfig        |   10 ++
 drivers/platform/x86/Makefile       |    1 +
 drivers/platform/x86/dell-smo8800.c |  253 +++++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+)
 create mode 100644 drivers/platform/x86/dell-smo8800.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 27df2c5..f0c2e45 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -127,6 +127,16 @@ config DELL_WMI_AIO
 	  To compile this driver as a module, choose M here: the module will
 	  be called dell-wmi-aio.
 
+config DELL_SMO8800
+	tristate "Dell Latitude freefall driver (ACPI SMO8800/SMO8810)"
+	depends ON ACPI
+	---help---
+	  Say Y here if you want to support SMO8800/SMO8810 freefall device
+	  on Dell Latitude laptops.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called dell-smo8800.
+
 
 config FUJITSU_LAPTOP
 	tristate "Fujitsu Laptop Extras"
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 1a2eafc..c4ca428 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
 obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
 obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
 obj-$(CONFIG_DELL_WMI_AIO)	+= dell-wmi-aio.o
+obj-$(CONFIG_DELL_SMO8800)	+= dell-smo8800.o
 obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
 obj-$(CONFIG_ACERHDF)		+= acerhdf.o
 obj-$(CONFIG_HP_ACCEL)		+= hp_accel.o
diff --git a/drivers/platform/x86/dell-smo8800.c b/drivers/platform/x86/dell-smo8800.c
new file mode 100644
index 0000000..4aabb74
--- /dev/null
+++ b/drivers/platform/x86/dell-smo8800.c
@@ -0,0 +1,253 @@
+/*
+ *  dell-smo8800.c - Dell Latitude ACPI SMO8800/SMO8810 freefall sensor driver
+ *
+ *  Copyright (C) 2012 Sonal Santan <sonal.santan@gmail.com>
+ *  Copyright (C) 2014 Pali Rohár <pali.rohar@gmail.com>
+ *
+ *  This is loosely based on lis3lv02d driver.
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
+ */
+
+#define DRIVER_NAME "smo8800"
+#define pr_fmt(fmt) DRIVER_NAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <linux/interrupt.h>
+#include <linux/miscdevice.h>
+
+struct smo8800_device {
+	u32 irq;                     /* acpi device irq */
+	atomic_t count;              /* count after last read */
+	struct miscdevice miscdev;   /* for /dev/freefall */
+	unsigned long misc_opened;   /* whether the device is open */
+	wait_queue_head_t misc_wait; /* Wait queue for the misc dev */
+	struct device *dev;          /* acpi device */
+};
+
+static irqreturn_t smo8800_interrupt_quick(int irq, void *data)
+{
+	struct smo8800_device *smo8800 = data;
+	atomic_inc(&smo8800->count);
+	wake_up_interruptible(&smo8800->misc_wait);
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t smo8800_interrupt_thread(int irq, void *data)
+{
+	struct smo8800_device *smo8800 = data;
+	dev_info(smo8800->dev, "detected free fall\n");
+	return IRQ_HANDLED;
+}
+
+static acpi_status smo8800_get_resource(struct acpi_resource *resource,
+					void *context)
+{
+	struct acpi_resource_extended_irq *irq;
+
+	if (resource->type != ACPI_RESOURCE_TYPE_EXTENDED_IRQ)
+		return AE_OK;
+
+	irq = &resource->data.extended_irq;
+	if (!irq || !irq->interrupt_count)
+		return AE_OK;
+
+	*((u32 *)context) = irq->interrupts[0];
+	return AE_CTRL_TERMINATE;
+}
+
+static u32 smo8800_get_irq(struct acpi_device *device)
+{
+	u32 irq = 0;
+	acpi_status status;
+
+	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+				     smo8800_get_resource, &irq);
+	if (ACPI_FAILURE(status)) {
+		dev_err(&device->dev, "acpi_walk_resources failed\n");
+		return 0;
+	}
+
+	return irq;
+}
+
+static ssize_t smo8800_misc_read(struct file *file, char __user *buf,
+				 size_t count, loff_t *pos)
+{
+	struct smo8800_device *smo8800 = container_of(file->private_data,
+					 struct smo8800_device, miscdev);
+
+	DECLARE_WAITQUEUE(wait, current);
+	u32 data;
+	unsigned char byte_data;
+	ssize_t retval = 1;
+
+	if (count < 1)
+		return -EINVAL;
+
+	add_wait_queue(&smo8800->misc_wait, &wait);
+	while (true) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		data = atomic_xchg(&smo8800->count, 0);
+		if (data)
+			break;
+
+		if (file->f_flags & O_NONBLOCK) {
+			retval = -EAGAIN;
+			goto out;
+		}
+
+		if (signal_pending(current)) {
+			retval = -ERESTARTSYS;
+			goto out;
+		}
+
+		schedule();
+	}
+
+	if (data < 255)
+		byte_data = data;
+	else
+		byte_data = 255;
+
+	/* make sure we are not going into copy_to_user() with
+	 * TASK_INTERRUPTIBLE state */
+	set_current_state(TASK_RUNNING);
+	if (copy_to_user(buf, &byte_data, sizeof(byte_data)))
+		retval = -EFAULT;
+
+out:
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&smo8800->misc_wait, &wait);
+
+	return retval;
+}
+
+static int smo8800_misc_open(struct inode *inode, struct file *file)
+{
+	struct smo8800_device *smo8800 = container_of(file->private_data,
+					 struct smo8800_device, miscdev);
+
+	if (test_and_set_bit(0, &smo8800->misc_opened))
+		return -EBUSY; /* already open */
+
+	atomic_set(&smo8800->count, 0);
+	return 0;
+}
+
+static int smo8800_misc_release(struct inode *inode, struct file *file)
+{
+	struct smo8800_device *smo8800 = container_of(file->private_data,
+					 struct smo8800_device, miscdev);
+
+	clear_bit(0, &smo8800->misc_opened); /* release the device */
+	return 0;
+}
+
+static const struct file_operations smo8800_misc_fops = {
+	.owner = THIS_MODULE,
+	.read = smo8800_misc_read,
+	.open = smo8800_misc_open,
+	.release = smo8800_misc_release,
+};
+
+static int smo8800_add(struct acpi_device *device)
+{
+	int err;
+	struct smo8800_device *smo8800;
+
+	if (!device)
+		return -EINVAL;
+
+	smo8800 = devm_kzalloc(&device->dev, sizeof(*smo8800), GFP_KERNEL);
+	if (!smo8800) {
+		dev_err(&device->dev, "failed to allocate device data\n");
+		return -ENOMEM;
+	}
+
+	smo8800->dev = &device->dev;
+	smo8800->miscdev.minor = MISC_DYNAMIC_MINOR;
+	smo8800->miscdev.name = "freefall";
+	smo8800->miscdev.fops = &smo8800_misc_fops;
+
+	init_waitqueue_head(&smo8800->misc_wait);
+
+	err = misc_register(&smo8800->miscdev);
+	if (err) {
+		dev_err(&device->dev, "failed to register misc dev: %d\n", err);
+		return err;
+	}
+
+	atomic_set(&smo8800->count, 0);
+	device->driver_data = smo8800;
+
+	smo8800->irq = smo8800_get_irq(device);
+	if (!smo8800->irq) {
+		dev_err(&device->dev, "failed to obtain IRQ\n");
+		err = -EINVAL;
+		goto error;
+	}
+
+	err = request_threaded_irq(smo8800->irq, smo8800_interrupt_quick,
+				   smo8800_interrupt_thread,
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				   DRIVER_NAME, smo8800);
+	if (err) {
+		dev_err(&device->dev,
+			"failed to request thread for IRQ %d: %d\n",
+			smo8800->irq, err);
+		goto error;
+	}
+
+	dev_info(&device->dev, "device /dev/freefall registered with IRQ %d\n",
+		 smo8800->irq);
+	return 0;
+
+error:
+	misc_deregister(&smo8800->miscdev);
+	return err;
+}
+
+static int smo8800_remove(struct acpi_device *device)
+{
+	struct smo8800_device *smo8800 = device->driver_data;
+	free_irq(smo8800->irq, smo8800);
+	misc_deregister(&smo8800->miscdev);
+	dev_info(&device->dev, "device /dev/freefall unregistered\n");
+	return 0;
+}
+
+static const struct acpi_device_id smo8800_ids[] = {
+	{ "SMO8800", 0 },
+	{ "SMO8810", 0 },
+	{ "", 0 },
+};
+
+MODULE_DEVICE_TABLE(acpi, smo8800_ids);
+
+static struct acpi_driver smo8800_driver = {
+	.name = DRIVER_NAME,
+	.class = "Latitude",
+	.ids = smo8800_ids,
+	.ops = {
+		.add = smo8800_add,
+		.remove = smo8800_remove,
+	},
+	.owner = THIS_MODULE,
+};
+
+module_acpi_driver(smo8800_driver);
+
+MODULE_DESCRIPTION("Dell Latitude freefall driver (ACPI SMO8800/SMO8810)");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sonal Santan, Pali Rohár");
-- 
1.7.9.5

