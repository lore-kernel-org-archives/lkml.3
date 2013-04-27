Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3D0HGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 03:06:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:4157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab3D0HFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 03:05:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,562,1363158000"; 
   d="scan'208";a="303853872"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Shane Wang <shane.wang@intel.com>, Gang Wei <gang.wei@intel.com>,
        linux-kernel@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Subject: [PATCH 3/5] driver: provide sysfs interfaces to access TXT log
Date: Sat, 27 Apr 2013 22:56:18 +0800
Message-Id: <1367074580-16530-4-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
References: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These interfaces are located in /sys/devices/platform/txt/log/.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 drivers/char/txt/Makefile    |    2 +-
 drivers/char/txt/txt-log.c   |  140 ++++++++++++++++++++++++++++++++++++++++++
 drivers/char/txt/txt-log.h   |   27 ++++++++
 drivers/char/txt/txt-sysfs.c |    5 ++
 4 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 drivers/char/txt/txt-log.c
 create mode 100644 drivers/char/txt/txt-log.h

diff --git a/drivers/char/txt/Makefile b/drivers/char/txt/Makefile
index 3db5a6f..fcb0e81 100644
--- a/drivers/char/txt/Makefile
+++ b/drivers/char/txt/Makefile
@@ -2,4 +2,4 @@
 # Makefile for the intel TXT drivers.
 #
 obj-$(CONFIG_TXT) += txt.o
-txt-y := txt-sysfs.o txt-config.o
+txt-y := txt-sysfs.o txt-config.o txt-log.o
diff --git a/drivers/char/txt/txt-log.c b/drivers/char/txt/txt-log.c
new file mode 100644
index 0000000..10f3918
--- /dev/null
+++ b/drivers/char/txt/txt-log.c
@@ -0,0 +1,140 @@
+/*
+ * txt-log.c
+ *
+ * - log/
+ *   log_header	 -r--r--r-- ; output log header, including max_size and
+ *			      curr_pos.
+ *   block	 -r--r--r-- ; output pure log in block style, 1 page size.
+ *   block_index -rw-rw-r-- ; the block index for output.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfs.h>
+#include <linux/io.h>
+#include <linux/stat.h>
+
+#include "txt-log.h"
+
+static u32 log_block_index;
+
+static int are_uuids_equal(const struct uuid *uuid1,
+			   const struct uuid *uuid2)
+{
+	return (memcmp(uuid1, uuid2, sizeof(*uuid1)) == 0) ? 1 : 0;
+}
+
+static struct tboot_log *get_log(void)
+{
+	struct tboot_log *log;
+
+	log = (struct tboot_log *)ioremap_nocache(TBOOT_SERIAL_LOG_ADDR,
+						    TBOOT_SERIAL_LOG_SIZE);
+	if (!log)
+		return NULL;
+
+	if (!are_uuids_equal(&(log->uuid),
+			     &((struct uuid)TBOOT_LOG_UUID))) {
+		iounmap(log);
+		return NULL;
+	}
+
+	return log;
+}
+
+ssize_t txt_show_log_header(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct tboot_log *log;
+	int ret;
+
+	log = get_log();
+	if (!log)
+		return -EFAULT;
+
+	ret = scnprintf(buf, PAGE_SIZE, "max_size: %x\ncurr_pos: %x\n",
+		       log->max_size, log->curr_pos);
+
+	iounmap(log);
+	return ret;
+}
+static DEVICE_ATTR(log_header, S_IRUGO, txt_show_log_header, NULL);
+
+ssize_t txt_show_block(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct tboot_log *log;
+	char *block;
+	int ret;
+
+	log = get_log();
+	if (!log)
+		return -EFAULT;
+
+	block = log->buf + log_block_index * PAGE_SIZE;
+	ret = scnprintf(buf, PAGE_SIZE, "%s\n", block);
+
+	iounmap(log);
+	return ret;
+}
+static DEVICE_ATTR(block, S_IRUGO, txt_show_block, NULL);
+
+ssize_t txt_show_block_index(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", log_block_index);
+}
+
+ssize_t txt_store_block_index(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	u32 index;
+	struct tboot_log *log;
+
+	log = get_log();
+	if (!log)
+		return -EFAULT;
+
+	sscanf(buf, "%d", &index);
+	if (index > log->curr_pos / PAGE_SIZE)
+		return -EINVAL;
+	log_block_index = index;
+
+	iounmap(log);
+	return count;
+}
+static DEVICE_ATTR(block_index, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_block_index, txt_store_block_index);
+
+static struct attribute *log_attrs[] = {
+	&dev_attr_log_header.attr,
+	&dev_attr_block.attr,
+	&dev_attr_block_index.attr,
+	NULL,
+};
+
+static struct attribute_group log_attr_grp = {
+	.attrs = log_attrs
+};
+
+ssize_t sysfs_create_log(struct kobject *parent)
+{
+	struct kobject *log_kobj;
+	int retval;
+
+	log_kobj = kobject_create_and_add("log", parent);
+	if (!log_kobj)
+		return -ENOMEM;
+
+	retval = sysfs_create_group(log_kobj, &log_attr_grp);
+	if (retval)
+		kobject_put(log_kobj);
+	return retval;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_log);
+
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/char/txt/txt-log.h b/drivers/char/txt/txt-log.h
new file mode 100644
index 0000000..580d71c
--- /dev/null
+++ b/drivers/char/txt/txt-log.h
@@ -0,0 +1,27 @@
+#ifndef __LOG_H__
+#define __LOG_H__
+
+struct uuid {
+	uint32_t data1;
+	uint16_t data2;
+	uint16_t data3;
+	uint16_t data4;
+	uint8_t  data5[6];
+} __packed;
+
+struct tboot_log {
+	struct uuid   uuid;
+	uint32_t      max_size;
+	uint32_t      curr_pos;
+	char          buf[];
+};
+
+#define TBOOT_LOG_UUID		{0xc0192526, 0x6b30, 0x4db4, 0x844c, \
+				{0xa3, 0xe9, 0x53, 0xb8, 0x81, 0x74} }
+#define TBOOT_SERIAL_LOG_ADDR	0x60000
+#define TBOOT_SERIAL_LOG_SIZE	0x08000
+
+extern ssize_t sysfs_create_log(struct kobject *parent);
+
+#endif /* __LOG_H__ */
+
diff --git a/drivers/char/txt/txt-sysfs.c b/drivers/char/txt/txt-sysfs.c
index 99d42d0..e945586 100644
--- a/drivers/char/txt/txt-sysfs.c
+++ b/drivers/char/txt/txt-sysfs.c
@@ -17,6 +17,7 @@
 #include <linux/sysfs.h>
 
 #include "txt-config.h"
+#include "txt-log.h"
 
 #define DEV_NAME "txt"
 struct platform_device *pdev;
@@ -33,6 +34,10 @@ static int __init txt_sysfs_init(void)
 	if (retval)
 		goto err;
 
+	retval = sysfs_create_log(&pdev->dev.kobj);
+	if (retval)
+		goto err;
+
 	pr_info("Loading TXT module successfully\n");
 	return 0;
 
-- 
1.7.9.5

