Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3HUQa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:30:27 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1262 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab3HUQaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:30:25 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
Subject: [PATCH] Add bcm2079x-i2c to drivers/misc
Thread-Topic: [PATCH] Add bcm2079x-i2c to drivers/misc
Thread-Index: Ac6ei7csyLz+FB8DSFCuYQLov9l3iQ==
Date: Wed, 21 Aug 2013 16:30:15 +0000
Message-ID: <90AC93A0CCA054488FFC508D6F62B6F40FF511AE@IRVEXCHMB07.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.208.64]
MIME-Version: 1.0
X-WSS-ID: 7E0A37332L876600432-20-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f41f64e7f668b86e47059a030cbdcf406c70682c Mon Sep 17 00:00:00 2001
From: Jeffrey Chu <jeffchu@broadcom.com>
Date: Wed, 21 Aug 2013 09:41:19 -0400
Subject: [PATCH] Add bcm2079x-i2c to drivers/misc

bcm2079x-i2c is the transport driver that supports bcm2079x Controller.
this driver provides basic read(), write(), and ioctl() for userspace application
to communicate with the bcm2079x controller using i2c transport.

Signed-off-by: Jeffrey Chu <jeffchu@broadcom.com>
---
 Documentation/misc-devices/bcm2079x-i2c.txt |   44 +++
 drivers/misc/Kconfig                        |    9 +
 drivers/misc/Makefile                       |    1 +
 drivers/misc/bcm2079x-i2c.c                 |  420 +++++++++++++++++++++++++++
 include/linux/platform_data/bcm2079x.h      |   34 +++
 5 files changed, 508 insertions(+)
 create mode 100644 Documentation/misc-devices/bcm2079x-i2c.txt
 create mode 100644 drivers/misc/bcm2079x-i2c.c
 create mode 100644 include/linux/platform_data/bcm2079x.h

diff --git a/Documentation/misc-devices/bcm2079x-i2c.txt b/Documentation/misc-devices/bcm2079x-i2c.txt
new file mode 100644
index 0000000..0a08bde
--- /dev/null
+++ b/Documentation/misc-devices/bcm2079x-i2c.txt
@@ -0,0 +1,44 @@
+Kernel driver for the Broadcom bcm2079x contactless
+communication controller
+
+General
+-------
+
+The bcm2079x is an integrated Controller for contactless communication.
+
+Host Interfaces: I2C, SPI and UART, this driver supports I2C.
+
+The Driver
+----------
+
+The bcm2079x-i2c driver can be found under drivers/misc/bcm2079x-i2c.c and its
+header file include/linux/platform_data/bcm2079x.h.
+
+The userspace application uses /dev/bcm2079x-i2c device to communicate with the
+Controller using NCI command messages. In a typical scenario application
+will open /dev/bcm2079x-i2c; power up and wake up the Controller chip using
+ioctl(). write to the Controller using write(). poll() the device to check if
+data is available. Use read() to read the data from the Controller.
+
+The driver waits for bcm2079x Controller's interrupt which occurs if there are
+data to be read.  Then, poll() will indicate the fact to the userspace.  read()
+will return full NCI or HCI packet to the userspace application. Unsolicited
+read() will receive garbage data.
+
+Userspace application may use ioctl() to allow the Controller to enter snooze or
+sleep mode.
+
+Userspace application may use ioctl() to set the client address the driver uses
+to communicate with the Controller.  This allows userspace application to change
+the device address of the Controller.
+
+Platform Data
+-------------
+
+The following platform data should be set when configuring board.
+
+struct bcm2079x_platform_data {
+	unsigned int irq_gpio;
+	unsigned int en_gpio;
+	unsigned int wake_gpio;
+};
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8dacd4c..eac0cab 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -528,6 +528,15 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config BCM2079X_I2C
+	tristate "BCM2079x I2C support"
+	depends on I2C
+	default n
+	---help---
+	  This module adds support for the i2c interface of Broadcom bcm2079x
+	  controller chip.  Select this if your platform is using
+	  the i2c bus.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..8dc4804 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-$(CONFIG_BCM2079X_I2C) += bcm2079x-i2c.o
diff --git a/drivers/misc/bcm2079x-i2c.c b/drivers/misc/bcm2079x-i2c.c
new file mode 100644
index 0000000..838dffb
--- /dev/null
+++ b/drivers/misc/bcm2079x-i2c.c
@@ -0,0 +1,420 @@
+/*
+ * Copyright (C) 2012 Broadcom Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/miscdevice.h>
+#include <linux/spinlock.h>
+#include <linux/poll.h>
+
+#include <linux/platform_data/bcm2079x.h>
+
+/* do not change below */
+#define MAX_BUFFER_SIZE		780
+
+/* Read data */
+#define PACKET_HEADER_SIZE_NCI	(4)
+#define PACKET_HEADER_SIZE_HCI	(3)
+#define PACKET_TYPE_NCI		(16)
+#define PACKET_TYPE_HCIEV	(4)
+#define MAX_PACKET_SIZE		(PACKET_HEADER_SIZE_NCI + 255)
+
+struct bcm2079x_dev {
+	wait_queue_head_t read_wq;
+	struct mutex read_mutex;
+	struct i2c_client *client;
+	struct miscdevice bcm2079x_device;
+	unsigned int wake_gpio;
+	unsigned int en_gpio;
+	unsigned int irq_gpio;
+	bool irq_enabled;
+	spinlock_t irq_enabled_lock;
+	unsigned int count_irq;
+};
+
+static void bcm2079x_init_stat(struct bcm2079x_dev *bcm2079x_dev)
+{
+	bcm2079x_dev->count_irq = 0;
+}
+
+static void bcm2079x_disable_irq(struct bcm2079x_dev *bcm2079x_dev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
+	if (bcm2079x_dev->irq_enabled) {
+		disable_irq_nosync(bcm2079x_dev->client->irq);
+		bcm2079x_dev->irq_enabled = false;
+	}
+	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
+}
+
+static void bcm2079x_enable_irq(struct bcm2079x_dev *bcm2079x_dev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
+	if (!bcm2079x_dev->irq_enabled) {
+		bcm2079x_dev->irq_enabled = true;
+		enable_irq(bcm2079x_dev->client->irq);
+	}
+	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
+}
+
+static void set_client_addr(struct bcm2079x_dev *bcm2079x_dev, int addr)
+{
+	struct i2c_client *client = bcm2079x_dev->client;
+	dev_info(&client->dev,
+		"Set client device address from 0x%04X flag = "\
+		"%02x, to  0x%04X\n",
+		client->addr, client->flags, addr);
+		client->addr = addr;
+		if (addr < 0x80)
+			client->flags &= ~I2C_CLIENT_TEN;
+		else
+			client->flags |= I2C_CLIENT_TEN;
+}
+
+static irqreturn_t bcm2079x_dev_irq_handler(int irq, void *dev_id)
+{
+	struct bcm2079x_dev *bcm2079x_dev = dev_id;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
+	bcm2079x_dev->count_irq++;
+	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
+	wake_up(&bcm2079x_dev->read_wq);
+
+	return IRQ_HANDLED;
+}
+
+static unsigned int bcm2079x_dev_poll(struct file *filp, poll_table *wait)
+{
+	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	poll_wait(filp, &bcm2079x_dev->read_wq, wait);
+
+	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
+	if (bcm2079x_dev->count_irq > 0) {
+		bcm2079x_dev->count_irq--;
+		mask |= POLLIN | POLLRDNORM;
+	}
+	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
+
+	return mask;
+}
+
+static ssize_t bcm2079x_dev_read(struct file *filp, char __user *buf,
+					size_t count, loff_t *offset)
+{
+	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
+	unsigned char tmp[MAX_BUFFER_SIZE];
+	int total, len, ret;
+
+	total = 0;
+	len = 0;
+
+	if (count > MAX_BUFFER_SIZE)
+		count = MAX_BUFFER_SIZE;
+
+	mutex_lock(&bcm2079x_dev->read_mutex);
+
+	/** Read the first 4 bytes to include the length of NCI or HCI packet.
+	**/
+	ret = i2c_master_recv(bcm2079x_dev->client, tmp, 4);
+	if (ret == 4) {
+		total = ret;
+		/** First byte is the packet type
+		**/
+		switch (tmp[0]) {
+		case PACKET_TYPE_NCI:
+			len = tmp[PACKET_HEADER_SIZE_NCI-1];
+			break;
+
+		case PACKET_TYPE_HCIEV:
+			len = tmp[PACKET_HEADER_SIZE_HCI-1];
+			/*If payload is 0, decrement total size (from 4 to 3) */
+			if (len == 0)
+				total--;
+			/*Otherwise, discount payload length byte*/
+			else
+				len--;
+			break;
+
+		default:
+			len = 0;/*Unknown packet byte */
+			break;
+		} /* switch*/
+
+		/** make sure full packet fits in the buffer
+		**/
+		if (len > 0 && (len + total) <= count) {
+			/** read the remainder of the packet.
+			**/
+			ret = i2c_master_recv(bcm2079x_dev->client, tmp+total,
+				len);
+			if (ret == len)
+				total += len;
+		} /* if */
+	} /* if */
+
+	mutex_unlock(&bcm2079x_dev->read_mutex);
+
+	if (total > count || copy_to_user(buf, tmp, total)) {
+		dev_err(&bcm2079x_dev->client->dev,
+			"failed to copy to user space, total = %d\n", total);
+		total = -EFAULT;
+	}
+
+	return total;
+}
+
+static ssize_t bcm2079x_dev_write(struct file *filp, const char __user *buf,
+					size_t count, loff_t *offset)
+{
+	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
+	char tmp[MAX_BUFFER_SIZE];
+	int ret;
+
+	if (count > MAX_BUFFER_SIZE) {
+		dev_err(&bcm2079x_dev->client->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	if (copy_from_user(tmp, buf, count)) {
+		dev_err(&bcm2079x_dev->client->dev,
+			"failed to copy from user space\n");
+		return -EFAULT;
+	}
+
+	mutex_lock(&bcm2079x_dev->read_mutex);
+	/* Write data */
+
+	ret = i2c_master_send(bcm2079x_dev->client, tmp, count);
+	if (ret != count) {
+		dev_err(&bcm2079x_dev->client->dev,
+			"failed to write %d\n", ret);
+		ret = -EIO;
+	}
+	mutex_unlock(&bcm2079x_dev->read_mutex);
+
+	return ret;
+}
+
+static int bcm2079x_dev_open(struct inode *inode, struct file *filp)
+{
+	int ret = 0;
+
+	struct bcm2079x_dev *bcm2079x_dev = container_of(filp->private_data,
+		struct bcm2079x_dev,
+		bcm2079x_device);
+	filp->private_data = bcm2079x_dev;
+	bcm2079x_init_stat(bcm2079x_dev);
+	bcm2079x_enable_irq(bcm2079x_dev);
+	dev_info(&bcm2079x_dev->client->dev,
+		 "%d,%d\n", imajor(inode), iminor(inode));
+
+	return ret;
+}
+
+static long bcm2079x_dev_unlocked_ioctl(struct file *filp,
+					 unsigned int cmd, unsigned long arg)
+{
+	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
+
+	switch (cmd) {
+	case BCMXXC_POWER_CTL:
+		gpio_set_value(bcm2079x_dev->en_gpio, arg);
+		break;
+	case BCMXXC_WAKE_CTL:
+		gpio_set_value(bcm2079x_dev->wake_gpio, arg);
+		break;
+	case BCMXXC_SET_ADDR:
+		set_client_addr(bcm2079x_dev, arg);
+		break;
+	default:
+		dev_err(&bcm2079x_dev->client->dev,
+			"%s, unknown cmd (%x, %lx)\n", __func__, cmd, arg);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
+static const struct file_operations bcm2079x_dev_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.poll = bcm2079x_dev_poll,
+	.read = bcm2079x_dev_read,
+	.write = bcm2079x_dev_write,
+	.open = bcm2079x_dev_open,
+	.unlocked_ioctl = bcm2079x_dev_unlocked_ioctl
+};
+
+static int bcm2079x_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	int ret;
+	struct bcm2079x_platform_data *platform_data;
+	struct bcm2079x_dev *bcm2079x_dev;
+
+	platform_data = client->dev.platform_data;
+
+	dev_info(&client->dev, "%s, probing bcm2079x driver flags = %x\n",
+		__func__, client->flags);
+	if (platform_data == NULL) {
+		dev_err(&client->dev, "device probe fail\n");
+		return -ENODEV;
+	}
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "need I2C_FUNC_I2C\n");
+		return -ENODEV;
+	}
+
+	ret = gpio_request_one(platform_data->irq_gpio, GPIOF_IN, "xxc_irq");
+	if (ret)
+		return -ENODEV;
+	ret = gpio_request_one(platform_data->en_gpio,
+		GPIOF_OUT_INIT_LOW, "xxc_en");
+	if (ret)
+		goto err_en;
+	ret = gpio_request_one(platform_data->wake_gpio,
+		GPIOF_OUT_INIT_LOW, "xxc_wake");
+	if (ret)
+		goto err_wake;
+
+	gpio_set_value(platform_data->en_gpio, 0);
+	gpio_set_value(platform_data->wake_gpio, 0);
+
+	bcm2079x_dev = kzalloc(sizeof(*bcm2079x_dev), GFP_KERNEL);
+	if (bcm2079x_dev == NULL) {
+		dev_err(&client->dev,
+			"failed to allocate memory for module data\n");
+		ret = -ENOMEM;
+		goto err_exit;
+	}
+
+	bcm2079x_dev->wake_gpio = platform_data->wake_gpio;
+	bcm2079x_dev->irq_gpio = platform_data->irq_gpio;
+	bcm2079x_dev->en_gpio = platform_data->en_gpio;
+	bcm2079x_dev->client = client;
+
+	/* init mutex and queues */
+	init_waitqueue_head(&bcm2079x_dev->read_wq);
+	mutex_init(&bcm2079x_dev->read_mutex);
+	spin_lock_init(&bcm2079x_dev->irq_enabled_lock);
+
+	bcm2079x_dev->bcm2079x_device.minor = MISC_DYNAMIC_MINOR;
+	bcm2079x_dev->bcm2079x_device.name = "bcm2079x-i2c";
+	bcm2079x_dev->bcm2079x_device.fops = &bcm2079x_dev_fops;
+
+	ret = misc_register(&bcm2079x_dev->bcm2079x_device);
+	if (ret) {
+		dev_err(&client->dev, "misc_register failed\n");
+		goto err_misc_register;
+	}
+
+	/* request irq.  the irq is set whenever the chip has data available
+	 * for reading.  it is cleared when all data has been read.
+	 */
+	dev_info(&client->dev, "requesting IRQ %d\n", client->irq);
+	bcm2079x_dev->irq_enabled = true;
+	ret = request_irq(client->irq, bcm2079x_dev_irq_handler,
+			IRQF_TRIGGER_RISING, client->name, bcm2079x_dev);
+	if (ret) {
+		dev_err(&client->dev, "request_irq failed\n");
+		goto err_request_irq_failed;
+	}
+	bcm2079x_disable_irq(bcm2079x_dev);
+	i2c_set_clientdata(client, bcm2079x_dev);
+	dev_info(&client->dev,
+		 "%s, probing bcm2079x driver exited successfully\n",
+		 __func__);
+	return 0;
+
+err_request_irq_failed:
+	misc_deregister(&bcm2079x_dev->bcm2079x_device);
+err_misc_register:
+	mutex_destroy(&bcm2079x_dev->read_mutex);
+	kfree(bcm2079x_dev);
+err_exit:
+	gpio_free(platform_data->wake_gpio);
+err_wake:
+	gpio_free(platform_data->en_gpio);
+err_en:
+	gpio_free(platform_data->irq_gpio);
+	return ret;
+}
+
+static int bcm2079x_remove(struct i2c_client *client)
+{
+	struct bcm2079x_dev *bcm2079x_dev;
+
+	bcm2079x_dev = i2c_get_clientdata(client);
+	free_irq(client->irq, bcm2079x_dev);
+	misc_deregister(&bcm2079x_dev->bcm2079x_device);
+	mutex_destroy(&bcm2079x_dev->read_mutex);
+	gpio_free(bcm2079x_dev->irq_gpio);
+	gpio_free(bcm2079x_dev->en_gpio);
+	gpio_free(bcm2079x_dev->wake_gpio);
+	kfree(bcm2079x_dev);
+
+	return 0;
+}
+
+static const struct i2c_device_id bcm2079x_id[] = {
+	{"bcm2079x-i2c", 0},
+	{}
+};
+
+static struct i2c_driver bcm2079x_driver = {
+	.id_table = bcm2079x_id,
+	.probe = bcm2079x_probe,
+	.remove = bcm2079x_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "bcm2079x-i2c",
+	},
+};
+
+/*
+ * module load/unload record keeping
+ */
+
+static int __init bcm2079x_dev_init(void)
+{
+	return i2c_add_driver(&bcm2079x_driver);
+}
+module_init(bcm2079x_dev_init);
+
+static void __exit bcm2079x_dev_exit(void)
+{
+	i2c_del_driver(&bcm2079x_driver);
+}
+module_exit(bcm2079x_dev_exit);
+
+MODULE_AUTHOR("Broadcom");
+MODULE_DESCRIPTION("bcm2079x contrller driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/bcm2079x.h b/include/linux/platform_data/bcm2079x.h
new file mode 100644
index 0000000..4f1bf7f
--- /dev/null
+++ b/include/linux/platform_data/bcm2079x.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2012 Broadcom Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _BCM2079X_H
+#define _BCM2079X_H
+
+#define BCMXXC_MAGIC	0xFA
+
+#define BCMXXC_POWER_CTL	_IO(BCMXXC_MAGIC, 0x01)
+#define BCMXXC_WAKE_CTL	_IO(BCMXXC_MAGIC, 0x05)
+#define BCMXXC_SET_ADDR	_IO(BCMXXC_MAGIC, 0x07)
+
+struct bcm2079x_platform_data {
+	unsigned int irq_gpio;
+	unsigned int en_gpio;
+	unsigned int wake_gpio;
+};
+
+#endif
-- 
1.7.10.4

