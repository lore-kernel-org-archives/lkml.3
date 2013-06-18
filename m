Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab3FRVs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:48:58 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38221 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3FRVsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:48:55 -0400
Date: Tue, 18 Jun 2013 23:48:07 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH V3 6/6] FMC: add a char-device mezzanine driver
Message-ID: <f37c83a1131b6bb4e4afd95523f3d5a957aa5f50.1371591538.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1371591538.git.rubini@gnudd.com>
In-Reply-To: <cover.1371591538.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver exports the memory area associated with the mezzanine card
as a misc device, so users can access registers.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 Documentation/fmc/00-INDEX        |    5 +-
 Documentation/fmc/fmc-chardev.txt |   64 ++++++++++++
 drivers/fmc/Kconfig               |    8 ++
 drivers/fmc/Makefile              |    1 +
 drivers/fmc/fmc-chardev.c         |  197 +++++++++++++++++++++++++++++++++++++
 5 files changed, 274 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/fmc/fmc-chardev.txt
 create mode 100644 drivers/fmc/fmc-chardev.c

diff --git a/Documentation/fmc/00-INDEX b/Documentation/fmc/00-INDEX
index 177c3e4..431c695 100644
--- a/Documentation/fmc/00-INDEX
+++ b/Documentation/fmc/00-INDEX
@@ -32,4 +32,7 @@ fmc-trivial.txt
 	- about drivers/fmc/fmc-trivial.ko
 
 fmc-write-eeprom.txt
-        - about drivers/fmc/fmc-write-eeprom.ko
+	- about drivers/fmc/fmc-write-eeprom.ko
+
+fmc-chardev.txt
+	- about drivers/fmc/fmc-chardev.ko
diff --git a/Documentation/fmc/fmc-chardev.txt b/Documentation/fmc/fmc-chardev.txt
new file mode 100644
index 0000000..d9ccb27
--- /dev/null
+++ b/Documentation/fmc/fmc-chardev.txt
@@ -0,0 +1,64 @@
+fmc-chardev
+===========
+
+This is a simple generic driver, that allows user access by means of a
+character device (actually, one for each mezzanine it takes hold of).
+
+The char device is created as a misc device. Its name in /dev (as
+created by udev) is the same name as the underlying FMC device. Thus,
+the name can be a silly fmc-0000 look-alike if the device has no
+identifiers nor bus_id, a more specific fmc-0400 if the device has a
+bus-specific address but no associated name, or something like
+fdelay-0400 if the FMC core can rely on both a mezzanine name and a bus
+address.
+
+Currently the driver only supports read and write: you can lseek to the
+desired address and read or write a register.
+
+The driver assumes all registers are 32-bit in size, and only accepts a
+single read or write per system call. However, as a result of Unix read
+and write semantics, users can simply fread or fwrite bigger areas in
+order to dump or store bigger memory areas.
+
+There is currently no support for mmap, user-space interrupt management
+and DMA buffers. They may be added in later versions, if the need
+arises.
+
+The example below shows raw access to a SPEC card programmed with its
+golden FPGA file, that features an SDB structure at offset 256 - i.e.
+64 words.  The mezzanine's EEPROM in this case is not programmed, so the
+default name is fmc-<bus><devfn>, and there are two cards in the system:
+
+  spusa.root# insmod fmc-chardev.ko
+  [ 1073.339332] spec 0000:02:00.0: Driver has no ID: matches all
+  [ 1073.345051] spec 0000:02:00.0: Created misc device "fmc-0200"
+  [ 1073.350821] spec 0000:04:00.0: Driver has no ID: matches all
+  [ 1073.356525] spec 0000:04:00.0: Created misc device "fmc-0400"
+  spusa.root# ls -l /dev/fmc*
+  crw------- 1 root root 10, 58 Nov 20 19:23 /dev/fmc-0200
+  crw------- 1 root root 10, 57 Nov 20 19:23 /dev/fmc-0400
+  spusa.root# dd bs=4 skip=64 count=1 if=/dev/fmc-0200 2> /dev/null | od -t x1z
+  0000000 2d 42 44 53                                      >-BDS<
+  0000004
+
+The simple program tools/fmc-mem in this package can access an FMC char
+device and read or write a word or a whole area.  Actually, the program
+is not specific to FMC at all, it just uses lseek, read and write.
+
+Its first argument is the device name, the second the offset, the third
+(if any) the value to write and the optional last argument that must
+begin with "+" is the number of bytes to read or write.  In case of
+repeated reading data is written to stdout; repeated writes read from
+stdin and the value argument is ignored.
+
+The following examples show reading the SDB magic number and the first
+SDB record from a SPEC device programmed with its golden image:
+
+     spusa.root# ./fmc-mem /dev/fmc-0200 100
+     5344422d
+     spusa.root# ./fmc-mem /dev/fmc-0200 100 +40 | od -Ax -t x1z
+     000000 2d 42 44 53 00 01 02 00 00 00 00 00 00 00 00 00  >-BDS............<
+     000010 00 00 00 00 ff 01 00 00 00 00 00 00 51 06 00 00  >............Q...<
+     000020 c9 42 a5 e6 02 00 00 00 11 05 12 20 2d 34 42 57  >.B......... -4BW<
+     000030 73 6f 72 43 72 61 62 73 49 53 47 2d 00 20 20 20  >sorCrabsISG-.   <
+     000040
diff --git a/drivers/fmc/Kconfig b/drivers/fmc/Kconfig
index 2bb1953..c01cf45 100644
--- a/drivers/fmc/Kconfig
+++ b/drivers/fmc/Kconfig
@@ -40,4 +40,12 @@ config FMC_WRITE_EEPROM
 	  its binary and the function carrier->reprogram to actually do it.
 	  It is useful when the mezzanines are produced.
 
+config FMC_CHARDEV
+	tristate "FMC mezzanine driver that registers a char device"
+	help
+	  This driver matches every mezzanine device and allows user
+	  space to read and write registers using a char device. It
+	  can be used to write user-space drivers, or just get
+	  aquainted with a mezzanine before writing its specific driver.
+
 endif # FMC
diff --git a/drivers/fmc/Makefile b/drivers/fmc/Makefile
index 13701fa..b945291 100644
--- a/drivers/fmc/Makefile
+++ b/drivers/fmc/Makefile
@@ -10,3 +10,4 @@ fmc-y += fmc-dump.o
 obj-$(CONFIG_FMC_FAKEDEV) += fmc-fakedev.o
 obj-$(CONFIG_FMC_TRIVIAL) += fmc-trivial.o
 obj-$(CONFIG_FMC_WRITE_EEPROM) += fmc-write-eeprom.o
+obj-$(CONFIG_FMC_CHARDEV) += fmc-chardev.o
diff --git a/drivers/fmc/fmc-chardev.c b/drivers/fmc/fmc-chardev.c
new file mode 100644
index 0000000..b071039
--- /dev/null
+++ b/drivers/fmc/fmc-chardev.c
@@ -0,0 +1,197 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/spinlock.h>
+#include <linux/fmc.h>
+#include <linux/uaccess.h>
+
+static LIST_HEAD(fc_devices);
+static DEFINE_SPINLOCK(fc_lock);
+
+struct fc_instance {
+	struct list_head list;
+	struct fmc_device *fmc;
+	struct miscdevice misc;
+};
+
+/* at open time, we must identify our device */
+static int fc_open(struct inode *ino, struct file *f)
+{
+	struct fmc_device *fmc;
+	struct fc_instance *fc;
+	int minor = iminor(ino);
+
+	list_for_each_entry(fc, &fc_devices, list)
+		if (fc->misc.minor == minor)
+			break;
+	if (fc->misc.minor != minor)
+		return -ENODEV;
+	fmc = fc->fmc;
+	if (try_module_get(fmc->owner) == 0)
+		return -ENODEV;
+
+	f->private_data = fmc;
+	return 0;
+}
+
+static int fc_release(struct inode *ino, struct file *f)
+{
+	struct fmc_device *fmc = f->private_data;
+	module_put(fmc->owner);
+	return 0;
+}
+
+/* read and write are simple after the default llseek has been used */
+static ssize_t fc_read(struct file *f, char __user *buf, size_t count,
+		       loff_t *offp)
+{
+	struct fmc_device *fmc = f->private_data;
+	unsigned long addr;
+	uint32_t val;
+
+	if (count < sizeof(val))
+		return -EINVAL;
+	count = sizeof(val);
+
+	addr = *offp;
+	if (addr > fmc->memlen)
+		return -ESPIPE; /* Illegal seek */
+	val = fmc_readl(fmc, addr);
+	if (copy_to_user(buf, &val, count))
+		return -EFAULT;
+	*offp += count;
+	return count;
+}
+
+static ssize_t fc_write(struct file *f, const char __user *buf, size_t count,
+			loff_t *offp)
+{
+	struct fmc_device *fmc = f->private_data;
+	unsigned long addr;
+	uint32_t val;
+
+	if (count < sizeof(val))
+		return -EINVAL;
+	count = sizeof(val);
+
+	addr = *offp;
+	if (addr > fmc->memlen)
+		return -ESPIPE; /* Illegal seek */
+	if (copy_from_user(&val, buf, count))
+		return -EFAULT;
+	fmc_writel(fmc, val, addr);
+	*offp += count;
+	return count;
+}
+
+static const struct file_operations fc_fops = {
+	.owner = THIS_MODULE,
+	.open = fc_open,
+	.release = fc_release,
+	.llseek = generic_file_llseek,
+	.read = fc_read,
+	.write = fc_write,
+};
+
+
+/* Device part .. */
+static int fc_probe(struct fmc_device *fmc);
+static int fc_remove(struct fmc_device *fmc);
+
+static struct fmc_driver fc_drv = {
+	.version = FMC_VERSION,
+	.driver.name = KBUILD_MODNAME,
+	.probe = fc_probe,
+	.remove = fc_remove,
+	/* no table: we want to match everything */
+};
+
+/* We accept the generic busid parameter */
+FMC_PARAM_BUSID(fc_drv);
+
+/* probe and remove must allocate and release a misc device */
+static int fc_probe(struct fmc_device *fmc)
+{
+	int ret;
+	int index = 0;
+
+	struct fc_instance *fc;
+
+	if (fmc->op->validate)
+		index = fmc->op->validate(fmc, &fc_drv);
+	if (index < 0)
+		return -EINVAL; /* not our device: invalid */
+
+	/* Create a char device: we want to create it anew */
+	fc = kzalloc(sizeof(*fc), GFP_KERNEL);
+	fc->fmc = fmc;
+	fc->misc.minor = MISC_DYNAMIC_MINOR;
+	fc->misc.fops = &fc_fops;
+	fc->misc.name = kstrdup(dev_name(&fmc->dev), GFP_KERNEL);
+
+	spin_lock(&fc_lock);
+	ret = misc_register(&fc->misc);
+	if (ret < 0) {
+		kfree(fc->misc.name);
+		kfree(fc);
+	} else {
+		list_add(&fc->list, &fc_devices);
+	}
+	spin_unlock(&fc_lock);
+	dev_info(&fc->fmc->dev, "Created misc device \"%s\"\n",
+		 fc->misc.name);
+	return ret;
+}
+
+static int fc_remove(struct fmc_device *fmc)
+{
+	struct fc_instance *fc;
+
+	list_for_each_entry(fc, &fc_devices, list)
+		if (fc->fmc == fmc)
+			break;
+	if (fc->fmc != fmc) {
+		dev_err(&fmc->dev, "remove called but not found\n");
+		return -ENODEV;
+	}
+
+	spin_lock(&fc_lock);
+	list_del(&fc->list);
+	misc_deregister(&fc->misc);
+	kfree(fc->misc.name);
+	kfree(fc);
+	spin_unlock(&fc_lock);
+
+	return 0;
+}
+
+
+static int fc_init(void)
+{
+	int ret;
+
+	ret = fmc_driver_register(&fc_drv);
+	return ret;
+}
+
+static void fc_exit(void)
+{
+	fmc_driver_unregister(&fc_drv);
+}
+
+module_init(fc_init);
+module_exit(fc_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.7.2
