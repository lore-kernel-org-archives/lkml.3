Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161785Ab3DEOYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:24:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:51314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161547Ab3DEOYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:24:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="289918683"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: add debugfs hooks
Date: Fri,  5 Apr 2013 17:23:09 +0300
Message-Id: <1365171789-21288-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs exposes device state and list of me clients and their
properties

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2:
1. don't use DEBUGFS_ADD_FILE macro
2. compile debugfs.c only if CONFIG_DEBUG_FS is set

 drivers/misc/mei/Makefile  |   1 +
 drivers/misc/mei/debugfs.c | 155 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/main.c    |  18 ++++--
 drivers/misc/mei/mei_dev.h |  20 +++++-
 drivers/misc/mei/pci-me.c  |   5 +-
 5 files changed, 191 insertions(+), 8 deletions(-)
 create mode 100644 drivers/misc/mei/debugfs.c

diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 1b29f7c..3612d57 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -11,6 +11,7 @@ mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
 mei-objs += bus.o
+mei-$(CONFIG_DEBUG_FS) += debugfs.o
 
 obj-$(CONFIG_INTEL_MEI_ME) += mei-me.o
 mei-me-objs := pci-me.o
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
new file mode 100644
index 0000000..7164ffa
--- /dev/null
+++ b/drivers/misc/mei/debugfs.c
@@ -0,0 +1,155 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2012-2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/debugfs.h>
+#include <linux/pci.h>
+
+#include <linux/mei.h>
+
+#include "mei_dev.h"
+#include "hw.h"
+
+
+
+#define DEBUGFS_ADD_FILE(_mei, name, parent, mode)	\
+	debugfs_create_file(#name, mode, parent,	\
+			_mei, &mei_dbgfs_fops_##name)
+
+static int mei_dbgfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	struct mei_device *dev = fp->private_data;
+	struct mei_me_client *cl;
+	const size_t bufsz = 1024;
+	char *buf = kzalloc(bufsz, GFP_KERNEL);
+	int i;
+	int pos = 0;
+	int ret;
+
+	if  (!buf)
+		return -ENOMEM;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"  |id|addr|         UUID                       |con|msg len|\n");
+
+	mutex_lock(&dev->device_lock);
+
+	/*  if the driver is not enabled the list won't b consitent */
+	if (dev->dev_state != MEI_DEV_ENABLED)
+		goto out;
+
+	for (i = 0; i < dev->me_clients_num; i++) {
+		cl = &dev->me_clients[i];
+
+		/* skip me clients that cannot be connected */
+		if (cl->props.max_number_of_connections == 0)
+			continue;
+
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"%2d|%2d|%4d|%pUl|%3d|%7d|\n",
+			i, cl->client_id,
+			cl->props.fixed_address,
+			&cl->props.protocol_name,
+			cl->props.max_number_of_connections,
+			cl->props.max_msg_length);
+	}
+out:
+	mutex_unlock(&dev->device_lock);
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations mei_dbgfs_fops_meclients = {
+	.open = mei_dbgfs_open,
+	.read = mei_dbgfs_read_meclients,
+	.llseek = generic_file_llseek,
+};
+
+static ssize_t mei_dbgfs_read_devstate(struct file *fp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	struct mei_device *dev = fp->private_data;
+	const size_t bufsz = 1024;
+	char *buf = kzalloc(bufsz, GFP_KERNEL);
+	int pos = 0;
+	int ret;
+
+	if  (!buf)
+		return -ENOMEM;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
+			mei_dev_state_str(dev->dev_state));
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+static const struct file_operations mei_dbgfs_fops_devstate = {
+	.open = mei_dbgfs_open,
+	.read = mei_dbgfs_read_devstate,
+	.llseek = generic_file_llseek,
+};
+
+/**
+ * mei_dbgfs_deregister - Remove the debugfs files and directories
+ * @mei - pointer to mei device private dat
+ */
+void mei_dbgfs_deregister(struct mei_device *dev)
+{
+	if (!dev->dbgfs_dir)
+		return;
+	debugfs_remove_recursive(dev->dbgfs_dir);
+	dev->dbgfs_dir = NULL;
+}
+
+/**
+ * Add the debugfs files
+ *
+ */
+int mei_dbgfs_register(struct mei_device *dev, const char *name)
+{
+	struct dentry *dir, *f;
+	dir = debugfs_create_dir(name, NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	f = debugfs_create_file("meclients", S_IRUSR, dir,
+				dev, &mei_dbgfs_fops_meclients);
+	if (!f) {
+		dev_err(&dev->pdev->dev, "meclients: registration failed\n");
+		goto err;
+	}
+	f = debugfs_create_file("devstate", S_IRUSR, dir,
+				dev, &mei_dbgfs_fops_devstate);
+	if (!f) {
+		dev_err(&dev->pdev->dev, "devstate: registration failed\n");
+		goto err;
+	}
+	dev->dbgfs_dir = dir;
+	return 0;
+err:
+	mei_dbgfs_deregister(dev);
+	return -ENODEV;
+}
+
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 872de9d..329fb86 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -753,15 +753,25 @@ static struct miscdevice  mei_misc_device = {
 		.minor = MISC_DYNAMIC_MINOR,
 };
 
-int mei_register(struct device *dev)
+
+int mei_register(struct mei_device *dev)
 {
-	mei_misc_device.parent = dev;
-	return misc_register(&mei_misc_device);
+	int ret;
+	mei_misc_device.parent = &dev->pdev->dev;
+	ret = misc_register(&mei_misc_device);
+	if (ret)
+		return ret;
+
+	if (mei_dbgfs_register(dev, mei_misc_device.name))
+		dev_err(&dev->pdev->dev, "cannot register debugfs\n");
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mei_register);
 
-void mei_deregister(void)
+void mei_deregister(struct mei_device *dev)
 {
+	mei_dbgfs_deregister(dev);
 	misc_deregister(&mei_misc_device);
 	mei_misc_device.parent = NULL;
 }
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 325f71a..8806be4 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -437,6 +437,11 @@ struct mei_device {
 	/* List of bus devices */
 	struct list_head device_list;
 
+#if IS_ENABLED(CONFIG_DEBUG_FS)
+	struct dentry *dbgfs_dir;
+#endif /* CONFIG_DEBUG_FS */
+
+
 	const struct mei_hw_ops *ops;
 	char hw[0] __aligned(sizeof(void *));
 };
@@ -603,8 +608,19 @@ static inline int mei_count_full_read_slots(struct mei_device *dev)
 	return dev->ops->rdbuf_full_slots(dev);
 }
 
-int mei_register(struct device *dev);
-void mei_deregister(void);
+#if IS_ENABLED(CONFIG_DEBUG_FS)
+int mei_dbgfs_register(struct mei_device *dev, const char *name);
+void mei_dbgfs_deregister(struct mei_device *dev);
+#else
+static inline int mei_dbgfs_register(struct mei_device *dev, const char *name)
+{
+	return 0;
+}
+static inline void mei_dbgfs_deregister(struct mei_device *dev) {}
+#endif /* CONFIG_DEBUG_FS */
+
+int mei_register(struct mei_device *dev);
+void mei_deregister(struct mei_device *dev);
 
 #define MEI_HDR_FMT "hdr:host=%02d me=%02d len=%d comp=%1d"
 #define MEI_HDR_PRM(hdr)                  \
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a1a582b..88aec6a 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -190,7 +190,7 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto release_irq;
 	}
 
-	err = mei_register(&pdev->dev);
+	err = mei_register(dev);
 	if (err)
 		goto release_irq;
 
@@ -262,12 +262,13 @@ static void mei_me_remove(struct pci_dev *pdev)
 	if (hw->mem_addr)
 		pci_iounmap(pdev, hw->mem_addr);
 
+	mei_deregister(dev);
+
 	kfree(dev);
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 
-	mei_deregister();
 
 }
 #ifdef CONFIG_PM
-- 
1.8.1.2

