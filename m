Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaGXPSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:18:51 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37777 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbaGXPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:18:24 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: gregkh@linuxfoundation.org
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH 1/1] Managed Devices devres_debugfs file system
Date: Thu, 24 Jul 2014 16:18:01 +0100
Message-Id: <1406215081-15113-2-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406215081-15113-1-git-send-email-rob.jones@codethink.co.uk>
References: <1406215081-15113-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
Suggested-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 Documentation/driver-model/devres-debugfs.txt |  140 +++++++++
 drivers/base/Kconfig                          |   18 ++
 drivers/base/devres.c                         |  387 +++++++++++++++++++++++++
 3 files changed, 545 insertions(+)
 create mode 100644 Documentation/driver-model/devres-debugfs.txt

diff --git a/Documentation/driver-model/devres-debugfs.txt b/Documentation/driver-model/devres-debugfs.txt
new file mode 100644
index 0000000..7004ebd
--- /dev/null
+++ b/Documentation/driver-model/devres-debugfs.txt
@@ -0,0 +1,140 @@
+
+Introduction
+============
+
+This document describes a file system that can be enabled to assist
+with the debugging of devices that use managed reources
+
+Outline of Operation
+====================
+
+Setting the flag DEVRES_DEBUGFS (depends on DEBUG_DEVRES) enables a
+debug facility for device managed resources. This takes the form of
+a directory in the debugfs file system which is a pseudo file system
+(typically mounted at /sys/kernel/debug) similar in concept to sysfs
+but with no restrictions on the format of the data read from a file.
+
+The directory (devres/) is created the first time a managed resource
+is allocated for any device.
+
+The first time a managed resource is allocated for a device, a file
+with the same name as the device is created in devres/.
+
+The file is read only and can be read by normal userspace utilities
+(such as cat).
+
+The data returned is in ASCII text format and has one header line for
+the device followed by one line per allocated resource.
+
+It is possible to seek to a given line within the file: position 0
+(zero) goes directly to the device line, position 1 goes to the first
+resource line and so on. Attempting to seek to a line that does not
+exist returns EOF.
+
+If opened and read sequentially, a file will initially give Line 0 (see
+below) and then each subsequent read will give a Resource Line until
+EOF. Note that the data may change on the fly (see Notes below).
+
+Data Format
+===========
+
+Device Line (Line 0)
+--------------------
+
+dev: <address> <name>
+
+There is a single space between each field.
+
+dev: = literal text identifying this as a device line.
+
+<address> = the address in kernel memory of the device data structure.
+The layout of "struct device" can be found in include/linux/device.h.
+This value is displayed in hexadecimal format using the "%p" format
+specifier and thus will vary in length depending on the word size of
+the kernel, e.g. 8 characters for a 32 bit kernel.
+
+<name> = the name of the device. This should be the same as the file
+name, it is included to facilitate identification when multiple
+devices are being listed. The length of this field can vary.
+
+Resource Line (Line 1 et seq.)
+------------------------------
+
+res: <address> <length> <data> <name>
+
+There is a single space between each field.
+
+res: = literal text identifying this as a resource line.
+
+<address> = the address in kernel memory of the resource data. The
+structure pointed to can vary depending on the type of resource.
+This field is encoded in hexadecimal format using the "%p" format
+specifier and thus will vary in length depending on the word size of
+the kernel, e.g. 8 characters for a 32 bit kernel.
+
+<length> = the length of the resource data. This field is encoded
+in decimal format, right justified, space filled and is always 9
+characters long.
+
+<data> = a hexadecimal display of the first 16 (or <length> if less)
+bytes of data starting for location <address>. If <length> is less
+than 16, this field is padded with spaces on the right to the full
+32 characters.
+
+<name> = a string indentifying the resource type. This is often a
+string containing the name of the function to be used to free the
+resource. Typical examples are "devm_kzalloc_release" which identifies
+a memory resource and "devm_gpio_release" which identifies a gpio
+resource. The length of this field can vary.
+
+Notes
+=====
+
+1. Once created, a file persists until the device is removed even
+   if all allocated resources are freed. This means that the existence
+   of the file is confirmation that at least one resource has been
+   allocated at some point, even if the device now has none allocated.
+
+2. Opening a file and holding it open will prevent the freeing up of
+   of the device - the final removal is held off until the file is
+   closed. Managed resources can still be freed if, say, a driver is
+   removed.
+
+3. Resources can, in principle, be allocated and freed on the fly so
+   it should not be assumed in general that seeking to a particular
+   resource line will always return the same resource. However, that is
+   a function of the device driver concerned and it may be a valid
+   assumption for some drivers, e.g. one that only allocates resources
+   during its .probe function.
+
+4. The device's list of resources is traversed from its base to the
+   requested item each time the file is read. During this scan resources
+   are spinlocked, which may have implications if resources can be
+   allocated during time critical code at the same time as a read is
+   taking place.
+
+5. A copy is taken of (up to) 16 bytes of resource data while the
+   spinlock (see note 4, above) is still in place and so can be relied
+   upon as an accurate snapshot at the time of the read but it must be
+   remembered that resources may change dynamically (see note 3, above)
+   so the memory may have changed subsequently.
+
+Sample Output
+=============
+
+root@arm:~# cat /sys/kernel/debug/devres/mmc0
+dev: ed980008 mmc0
+res: ed95a618        50 000000004884e8800001000039a695ed devm_kzalloc_release
+res: ed95cc58         4 02000000                         devm_gpio_release
+res: ed95cc98         8 a2000000000098ed                 devm_irq_release
+root@arm:~#
+
+This shows three managed resources allocated to device "mmc0".
+
+1. A block of memory 50 bytes long (the first 16 byte are displayed).
+2. A GPIO.
+3. An IRQ.
+
+If 16 bytes of data is insufficient, you can try using other debugging
+tools to examine the data.
+
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 8fa8dea..6a2f125 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -177,6 +177,24 @@ config DEBUG_DEVRES
 
 	  If you are unsure about this, Say N here.
 
+config DEVRES_DEBUGFS
+	bool "Managed device resources debugfs file system"
+	depends on DEBUG_DEVRES
+	help
+	  This option enables a debugfs file system related to Managed
+	  Resources. When a device allocates a managed resource, with
+	  this option enabled, a read-only file with the same name as
+	  the device is created in the file system. Reading this file
+	  provides some basic debug information about the managed
+	  resources allocated to the device.
+
+	  The overhead caused by enabling this option is quite small.
+	  Specifically, a small memory overhead for each device and a
+	  small time overhead at each resource allocation and
+	  de-allocation.
+
+	  If you are unsure about this, Say N here.
+
 config SYS_HYPERVISOR
 	bool
 	default n
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 5c88a27..41b6465 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -7,9 +7,13 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
 
 #include "base.h"
 
@@ -58,6 +62,383 @@ static void devres_log(struct device *dev, struct devres_node *node,
 #define devres_log(dev, node, op)	do {} while (0)
 #endif /* CONFIG_DEBUG_DEVRES */
 
+#ifdef CONFIG_DEVRES_DEBUGFS
+static const char * const devres_dbgfs_rootname = "devres";
+static struct dentry *devres_dbgfs_root;
+
+struct devres_dbgfs_link {
+	struct list_head list;
+	struct device *dev;
+	struct dentry *dp;
+};
+
+struct devres_dbgfs_private {
+	struct device *dev;
+	loff_t pos;
+	bool eof;
+};
+
+static struct devres_dbgfs_link *devres_dbgfs_lastused;
+static DEFINE_SPINLOCK(devres_dbgfs_lock);
+
+/**
+ * devres_dbgfs_seq_start - seq file iterator init for a devres debugfs file
+ * @s:   pointer to seq file structure
+ * @pos: pointer to current file position.
+ *
+ * returns: pointer to private data fo use by devres_dbgfs_seq_next().
+ *
+ * Static debug function called when the user first reads from a device
+ * managed resources debugfs file. It initializes the file position in
+ * the private data structure and returns a pointer to a private structure
+ * for use by devres_dbgfs_seq_next().
+ */
+static void *devres_dbgfs_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct devres_dbgfs_private *priv = s->private;
+
+	priv->pos = *pos;
+	priv->eof = false;
+
+	return priv;
+}
+
+/**
+ * devres_dbgfs_seq_next - seq file iterator routine for a devres debugfs file
+ * @s:   pointer to seq file structure
+ * @v:   pointer to private data set up by devres_dbgfs_seq_next().
+ * @pos: pointer to current file position.
+ *
+ * Static debug function called when the user reads from a device managed
+ * resources debugfs file. It returns a pointer to a private structure used
+ * by devres_dbgfs_seq_next() and uppdates the file pointer.
+ */
+static void *devres_dbgfs_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct devres_dbgfs_private *priv = v;
+
+	if (priv->eof)
+		return NULL;
+
+	*pos = ++priv->pos;
+
+	return priv;
+}
+
+static void devres_dbgfs_seq_stop(struct seq_file *s, void *v)
+{
+}
+
+/**
+ * devres_dbgfs_seq_show - seq file output routine for a devres debugfs file
+ * @s: pointer to seq file structure
+ * @v: pointer to private data set up by devres_dbgfs_seq_next().
+ *
+ * Static debug function called when the user reads from a device managed
+ * resources debugfs file. It outputs to the user buffer using seq_file
+ * function seq_printf();
+ *
+ * This function locks devres_lock in the device structure.
+ */
+static int devres_dbgfs_seq_show(struct seq_file *s, void *v)
+{
+	struct devres_dbgfs_private *priv = v;
+	struct device *dev = priv->dev;
+	int size, i, pos = priv->pos;
+	struct devres *dr;
+	struct list_head *head;
+	struct list_head *item;
+	unsigned long flags;
+	char data[16];
+	char *dataptr;
+
+	if (pos == 0) {
+		seq_printf(s, "dev: %p %s\n", dev, dev_name(dev));
+		return 0;
+	}
+
+	spin_lock_irqsave(&dev->devres_lock, flags);
+
+	head = &dev->devres_head;
+	if (!head || list_empty(head))
+		goto out_eof;
+	item = head;
+
+	/* Walk the device resource list to item number *position */
+	while (pos--) {
+		item = item->next;
+		/* Check for end of list before required item */
+		if (item == head)
+			goto out_eof;
+	}
+
+	/* Node found, grab the details */
+	dr = container_of(item, struct devres, node.entry);
+	size = dr->node.size;
+	dataptr = (char *)dr->data;
+
+	/* Take a copy of the data before unlock */
+	memcpy(data, dataptr, (size < 16 ? size : 16));
+
+	spin_unlock_irqrestore(&dev->devres_lock, flags);
+
+	/* Print the node details */
+	seq_printf(s, "res: %p %9d ", dataptr, size);
+
+	for (i = 0; i < 16; i++) {
+		if (size-- > 0)
+			seq_printf(s, "%02x", data[i]);
+		else
+			seq_puts(s, "  ");
+	}
+
+	if (dr->node.name)
+		seq_printf(s, " %s", dr->node.name);
+
+	seq_putc(s, '\n');
+
+	return 0;
+
+out_eof:
+	spin_unlock_irqrestore(&dev->devres_lock, flags);
+	priv->eof = true;
+	return 0; /* Seek past EOF */
+}
+
+static const struct seq_operations devres_dbgfs_seq_ops = {
+	.start = devres_dbgfs_seq_start,
+	.show  = devres_dbgfs_seq_show,
+	.next  = devres_dbgfs_seq_next,
+	.stop  = devres_dbgfs_seq_stop,
+};
+
+/**
+ * devres_dbgfs_seq_open - open seq file for a devres debugfs file
+ * @ino: pointer to debugfs inode
+ * @fp:  pointer to file structure
+ *
+ * Static debug function called when the user opens a device managed
+ * resources debugfs file. It registers with the device to ensure that
+ * the device usage count never drops to zero while the file is open.
+ * This prevents the device from being released if the file is held
+ * open even if its device driver deregisters. This can be useful for
+ * debugging a device even after its driver has been removed with rmmod.
+ *
+ * It then kmallocs a private structure used to keep track of the file
+ * position and the struct device, it exits via seq_open().
+ */
+static int devres_dbgfs_seq_open(struct inode *ino, struct file *fp)
+{
+	struct devres_dbgfs_private *priv;
+	struct device *dev = ino->i_private;
+	struct seq_file *seq;
+	int err = -ENOMEM;
+
+	/* Register as a user of the device to prevent it from */
+	/* going away while the file is still open */
+	if (!get_device(dev))
+		return -ENODEV;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		goto out;
+
+	priv->dev = dev; /* no need to set pos & eof */
+
+	err = seq_open(fp, &devres_dbgfs_seq_ops);
+	if (err)
+		goto out;
+
+	seq = fp->private_data;
+	seq->private = priv;
+
+	return 0;
+
+out:
+	kfree(priv);
+
+	return err;
+}
+
+/**
+ * devres_dbgfs_seq_release - release seq file for a devres debugfs file
+ * @ino: pointer to debugfs inode
+ * @fp:  pointer to file structure
+ *
+ * Static debug function called when the user closes a device managed
+ * resources debugfs file. It de-registers from the device to allow
+ * the device to be released.
+ */
+static int devres_dbgfs_seq_release(struct inode *ino, struct file *fp)
+{
+	struct device *dev = fp->f_inode->i_private;
+	struct seq_file *seq = fp->private_data;
+
+	kfree(seq->private);
+
+	/* Deregister from the device to allow it to go away when ready */
+	put_device(dev);
+
+	return seq_release(ino, fp);
+}
+
+static const struct file_operations devres_dbgfs_seq_fops = {
+	.owner   = THIS_MODULE,
+	.open    = devres_dbgfs_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = devres_dbgfs_seq_release,
+};
+
+/**
+ * devres_dbgfs_get_dir - find dentry of the managed devices debugfs directory
+ *
+ * Static debug function that returns a pointer to the dentry of the debugfs
+ * directory used to contain the debugfs files for devices that use managed
+ * resources.
+ *
+ * This function must only be called if devres_dbgfs_lock is held.
+ *
+ * A return value of NULL means that the directory did not exist and cannot
+ * be created.
+ */
+static struct dentry *devres_dbgfs_get_dir(void)
+{
+	struct dentry *root;
+
+	if (devres_dbgfs_root)
+		return devres_dbgfs_root;
+
+	root = debugfs_create_dir(devres_dbgfs_rootname, NULL);
+	if (!IS_ERR(root))
+		devres_dbgfs_root = root;
+
+	return devres_dbgfs_root;
+}
+
+/**
+ * devres_dbgfs_find_filelink - find the filelink for a device's debugfs file
+ * @dev: device
+ *
+ * Static debug function that locates a link pointing to the dentry
+ * of a device's debugfs file.
+ *
+ * This function must only be called if devres_dbgfs_lock is held.
+ *
+ * Safe to call even if no such file or link exists, just returns
+ * NULL. For speed, the function always starts the scan of the list
+ * of links at the last one accessed, on the assumption that such
+ * searches will occur in clusters for the same device and there will
+ * only be an occasional change of device.
+ */
+static struct devres_dbgfs_link *devres_dbgfs_find_filelink(struct device *dev)
+{
+	struct devres_dbgfs_link *link;
+
+	link = devres_dbgfs_lastused;
+
+	if (!link)
+		return NULL;
+
+	while (1) {
+		if (link->dev == dev) {
+			devres_dbgfs_lastused = link;
+			break;
+		}
+		if (list_is_last(&link->list, &devres_dbgfs_lastused->list)) {
+			link = NULL; /* Not found */
+			break;
+		}
+		link = list_next_entry(link, list);
+	};
+
+	return link;
+}
+
+/**
+ * devres_dbgfs_remove_file - remove a device's debugfs file.
+ * @dev: device
+ *
+ * Static debug function called as part of the device release procedure
+ * IFF at least one managed reource has been allocated resulting in a
+ * file being created.
+ *
+ * It is safe to call without checking that the file has actually been
+ * created.
+ *
+ * This function locks devres_dbgfs_lock.
+ */
+static void devres_remove_debugfs_file(struct device *dev)
+{
+	struct devres_dbgfs_link *link;
+	unsigned long flags;
+
+	spin_lock_irqsave(&devres_dbgfs_lock, flags);
+	link = devres_dbgfs_find_filelink(dev);
+	if (link) {
+		debugfs_remove(link->dp);
+		if (list_empty(&link->list))
+			devres_dbgfs_lastused = NULL;
+		else {
+			devres_dbgfs_lastused = list_next_entry(link, list);
+			list_del(&link->list);
+		}
+		kfree(link);
+	}
+	spin_unlock_irqrestore(&devres_dbgfs_lock, flags);
+}
+
+/**
+ * devres_dbgfs_create_file - create debugfs file for a device
+ * @dev: device
+ *
+ * Static debug function that will automatically create a debugfs file
+ * with the same name as the supplied device IFF the said file has not
+ * already been created.
+ *
+ * This function locks devres_dbgfs_lock.
+ */
+static void devres_dbgfs_create_file(struct device *dev)
+{
+	struct dentry *debugfsfile = NULL;
+	struct devres_dbgfs_link *link;
+	struct dentry *debugfsdir;
+	unsigned long flags;
+
+	spin_lock_irqsave(&devres_dbgfs_lock, flags);
+
+	link = devres_dbgfs_find_filelink(dev);
+	if (link)
+		goto out_unlock;
+
+	debugfsdir = devres_dbgfs_get_dir();
+	if (debugfsdir)
+		/* Create file, n.b. dev goes into inode->i_private */
+		debugfsfile = debugfs_create_file(dev_name(dev), 0444,
+						  debugfsdir, dev,
+						  &devres_dbgfs_seq_fops);
+	if (!debugfsfile)
+		goto out_unlock;
+
+	/* Success: now create filelink entry in linked list */
+	link = kmalloc(sizeof(*link), GFP_KERNEL);
+	if (!link) {
+		debugfs_remove(debugfsfile);
+		goto out_unlock;
+	}
+
+	INIT_LIST_HEAD(&link->list);
+	link->dev = dev;
+	link->dp = debugfsfile;
+	if (devres_dbgfs_lastused)
+		list_add(&link->list, &devres_dbgfs_lastused->list);
+	devres_dbgfs_lastused = link;
+
+out_unlock:
+	spin_unlock_irqrestore(&devres_dbgfs_lock, flags);
+}
+#endif /* CONFIG_DEVRES_DEBUGFS */
+
 /*
  * Release functions for devres group.  These callbacks are used only
  * for identification.
@@ -220,6 +601,9 @@ void devres_add(struct device *dev, void *res)
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	add_dr(dev, &dr->node);
 	spin_unlock_irqrestore(&dev->devres_lock, flags);
+#ifdef CONFIG_DEVRES_DEBUGFS
+	devres_dbgfs_create_file(dev);
+#endif /* CONFIG_DEVRES_DEBUGFS */
 }
 EXPORT_SYMBOL_GPL(devres_add);
 
@@ -511,6 +895,9 @@ int devres_release_all(struct device *dev)
 	/* Looks like an uninitialized device structure */
 	if (WARN_ON(dev->devres_head.next == NULL))
 		return -ENODEV;
+#ifdef CONFIG_DEVRES_DEBUGFS
+	devres_remove_debugfs_file(dev);
+#endif /* CONFIG_DEVRES_DEBUGFS */
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	return release_nodes(dev, dev->devres_head.next, &dev->devres_head,
 			     flags);
-- 
1.7.10.4

