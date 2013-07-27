Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3G0N4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:56:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9444 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3G0N4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:56:38 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>
Subject: [PATCH] block: support embedded device command line partition
Thread-Topic: [PATCH] block: support embedded device command line partition
Thread-Index: Ac6K0RTEqYNaxbjoQ2ihDHJZj1d9uA==
Date: Sat, 27 Jul 2013 13:56:24 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C06195E@szxeml512-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>

Read block device partition table from command line. This partition used for fixed block device (eMMC) embedded device.
It no MBR, can save storage space. Bootloader can be easily accessed by absolute address of data on the block device. It support partition name, provides partition interface.

This code reference MTD partition, source "./drivers/mtd/cmdlinepart.c"
The format for the command line is just like mtdparts.

Examples: eMMC disk name is "mmcblk0"
bootargs 'cmdlineparts=mmcblk0:1G(data0),1G(data1),-;mmcblk0boot0:1m(boot),-(kernel)'

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 block/partitions/Kconfig   |   6 +
 block/partitions/Makefile  |   1 +
 block/partitions/check.c   |   4 +
 block/partitions/cmdline.c | 346 +++++++++++++++++++++++++++++++++++++++++++++
 block/partitions/cmdline.h |   2 +
 5 files changed, 359 insertions(+)
 create mode 100644 block/partitions/cmdline.c  create mode 100644 block/partitions/cmdline.h

diff --git a/block/partitions/Kconfig b/block/partitions/Kconfig index 4cebb2f..2ebf251 100644
--- a/block/partitions/Kconfig
+++ b/block/partitions/Kconfig
@@ -260,3 +260,9 @@ config SYSV68_PARTITION
 	  partition table format used by Motorola Delta machines (using
 	  sysv68).
 	  Otherwise, say N.
+
+config CMDLINE_PARTITION
+	bool "Command line partition support" if PARTITION_ADVANCED
+	help
+	  Say Y here if you would read the partitions table from bootargs.
+	  The format for the command line is just like mtdparts.
diff --git a/block/partitions/Makefile b/block/partitions/Makefile index 2be4d7b..4e9d584 100644
--- a/block/partitions/Makefile
+++ b/block/partitions/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_EFI_PARTITION) += efi.o
 obj-$(CONFIG_KARMA_PARTITION) += karma.o
 obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
+obj-$(CONFIG_CMDLINE_PARTITION) += cmdline.o
diff --git a/block/partitions/check.c b/block/partitions/check.c index 19ba207..9ac1df7 100644
--- a/block/partitions/check.c
+++ b/block/partitions/check.c
@@ -34,6 +34,7 @@
 #include "efi.h"
 #include "karma.h"
 #include "sysv68.h"
+#include "cmdline.h"
 
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
@@ -65,6 +66,9 @@ static int (*check_part[])(struct parsed_partitions *) = {
 	adfspart_check_ADFS,
 #endif
 
+#ifdef CONFIG_CMDLINE_PARTITION
+	cmdline_partition,
+#endif
 #ifdef CONFIG_EFI_PARTITION
 	efi_partition,		/* this must come before msdos */
 #endif
diff --git a/block/partitions/cmdline.c b/block/partitions/cmdline.c new file mode 100644 index 0000000..05c7e17
--- /dev/null
+++ b/block/partitions/cmdline.c
@@ -0,0 +1,346 @@
+/*
+ * Copyright (C) 2013 HUAWEI
+ * Author: Cai Zhiyong <caizhiyong@huawei.com>
+ *
+ * Read block device partition table from command line.
+ * Design the partition for eMMC device.
+ * This code reference MTD partition, source "./drivers/mtd/cmdlinepart.c"
+ * The format for the command line is just like mtdparts.
+ *
+ * Examples:
+ *
+ * eMMC disk name is "mmcblk0"
+ * bootargs:
+ * 'cmdlineparts=mmcblk0:1G(data0),1G(data1),-;mmcblk0boot0:1m(boot),-(kernel)'
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+
+#include "check.h"
+#include "cmdline.h"
+
+#define SIZE_REMAINING              ULLONG_MAX
+#define OFFSET_CONTINUOUS           ULLONG_MAX
+
+struct cmdline_subpart {
+	char name[BDEVNAME_SIZE]; /* partition name, such as 'rootfs' */
+	uint64_t from;
+	uint64_t size;
+	struct cmdline_subpart *next_subpart;
+};
+
+struct cmdline_parts {
+	char name[BDEVNAME_SIZE]; /* block device, such as 'mmcblk0' */
+	struct cmdline_subpart *subpart;
+	struct cmdline_parts *next_parts;
+};
+
+static DEFINE_MUTEX(cmdline_string_mutex);
+
+static char cmdline_string[512] = { 0 }; static struct cmdline_parts 
+*cmdline_parts;
+
+static int parse_subpart(struct cmdline_subpart **subpart, char
+*cmdline) {
+	int ret = 0;
+	struct cmdline_subpart *new_subpart;
+
+	(*subpart) = NULL;
+
+	new_subpart = kzalloc(sizeof(struct cmdline_subpart), GFP_KERNEL);
+	if (!new_subpart)
+		return -ENOMEM;
+
+	if ((*cmdline) == '-') {
+		new_subpart->size = SIZE_REMAINING;
+		cmdline++;
+	} else {
+		new_subpart->size = memparse(cmdline, &cmdline);
+		if (new_subpart->size < PAGE_SIZE) {
+			pr_warn("cmdline partition size is invalid.");
+			ret = -EFAULT;
+			goto fail;
+		}
+	}
+
+	if ((*cmdline) == '@') {
+		cmdline++;
+		new_subpart->from = memparse(cmdline, &cmdline);
+	} else {
+		new_subpart->from = OFFSET_CONTINUOUS;
+	}
+
+	if ((*cmdline) == '(') {
+
+		int length;
+		char *next = strchr(++cmdline, ')');
+
+		if (!next) {
+			pr_warn("cmdline partition format is invalid.");
+			ret = -EFAULT;
+			goto fail;
+		}
+
+		length = min((int)(next - cmdline),
+			     (int)(sizeof(new_subpart->name) - 1));
+		strncpy(new_subpart->name, cmdline, length);
+		new_subpart->name[length] = '\0';
+
+		cmdline = ++next;
+	} else
+		new_subpart->name[0] = '\0';
+
+	(*subpart) = new_subpart;
+	return 0;
+fail:
+	kfree(new_subpart);
+	return ret;
+}
+
+static void free_subpart(struct cmdline_parts *parts) {
+	struct cmdline_subpart *subpart;
+
+	while (parts->subpart) {
+		subpart = parts->subpart;
+		parts->subpart = subpart->next_subpart;
+		kfree(subpart);
+	}
+}
+
+static void free_parts(struct cmdline_parts **parts) {
+	struct cmdline_parts *next_parts;
+
+	while ((*parts)) {
+		next_parts = (*parts)->next_parts;
+		free_subpart((*parts));
+		kfree((*parts));
+		(*parts) = next_parts;
+	}
+}
+
+static int parse_parts(struct cmdline_parts **parts, const char
+*cmdline) {
+	int ret = -EFAULT;
+	char *next;
+	int length;
+	struct cmdline_subpart **next_subpart;
+	struct cmdline_parts *newparts;
+	char buf[BDEVNAME_SIZE + 32 + 4];
+
+	(*parts) = NULL;
+
+	newparts = kzalloc(sizeof(struct cmdline_parts), GFP_KERNEL);
+	if (!newparts)
+		return -ENOMEM;
+
+	next = strchr(cmdline, ':');
+	if (!next) {
+		pr_warn("cmdline partition has not block device.");
+		goto fail;
+	}
+
+	length = min((int)(next - cmdline), (int)(sizeof(newparts->name) - 1));
+	strncpy(newparts->name, cmdline, length);
+	newparts->name[length] = '\0';
+
+	next_subpart = &newparts->subpart;
+
+	while (next && *(++next)) {
+
+		cmdline = next;
+		next = strchr(cmdline, ',');
+
+		length = (!next) ? (sizeof(buf) - 1) :
+			min((int)(next - cmdline), (int)(sizeof(buf) - 1));
+
+		strncpy(buf, cmdline, length);
+		buf[length] = '\0';
+
+		ret = parse_subpart(next_subpart, buf);
+		if (ret)
+			goto fail;
+
+		next_subpart = &(*next_subpart)->next_subpart;
+	}
+
+	if (!newparts->subpart) {
+		pr_warn("cmdline partition has not valid partition.");
+		goto fail;
+	}
+
+	(*parts) = newparts;
+
+	return 0;
+fail:
+	free_subpart(newparts);
+	kfree(newparts);
+	return ret;
+}
+
+static int parse_cmdline(struct cmdline_parts **parts, const char
+*cmdline) {
+	int ret;
+	char *buf;
+	char *pbuf;
+	char *next;
+	struct cmdline_parts **next_parts;
+
+	(*parts) = NULL;
+
+	next = pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	next_parts = parts;
+
+	while (next && *pbuf) {
+
+		next = strchr(pbuf, ';');
+		if (next)
+			(*next) = '\0';
+
+		ret = parse_parts(next_parts, pbuf);
+		if (ret)
+			goto fail;
+
+		if (next)
+			pbuf = ++next;
+
+		next_parts = &(*next_parts)->next_parts;
+	}
+
+	if (!(*parts)) {
+		pr_warn("cmdline partition has not valid partition.");
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	ret = 0;
+done:
+	kfree(buf);
+	return ret;
+
+fail:
+	free_parts(parts);
+	goto done;
+}
+
+/*
+ * Purpose: allocate cmdline partitions.
+ * Returns:
+ * -1 if unable to read the partition table
+ *  0 if this isn't our partition table
+ *  1 if successful
+ */
+static int parse_partitions(struct parsed_partitions *state,
+			    struct cmdline_parts *parts)
+{
+	int slot;
+	uint64_t from = 0;
+	uint64_t disk_size;
+	char buf[BDEVNAME_SIZE];
+	struct cmdline_subpart *subpart;
+
+	bdevname(state->bdev, buf);
+
+	while (parts && strncmp(buf, parts->name, BDEVNAME_SIZE))
+		parts = parts->next_parts;
+
+	if (!parts)
+		return 0;
+
+	disk_size = (uint64_t) get_capacity(state->bdev->bd_disk) << 9;
+
+	for (slot = 1, subpart = parts->subpart;
+	     subpart && slot < state->limit;
+	     subpart = subpart->next_subpart, slot++) {
+
+		unsigned label_max;
+		struct partition_meta_info *info;
+
+		if (subpart->from == OFFSET_CONTINUOUS)
+			subpart->from = from;
+		else
+			from = subpart->from;
+
+		if (from >= disk_size)
+			break;
+
+		if (subpart->size > (disk_size - from))
+			subpart->size = disk_size - from;
+
+		from += subpart->size;
+
+		put_partition(state, slot, le64_to_cpu(subpart->from >> 9),
+			      le64_to_cpu(subpart->size >> 9));
+
+		info = &state->parts[slot].info;
+
+		label_max = min(sizeof(info->volname) - 1,
+			sizeof(subpart->name));
+		strncpy(info->volname, subpart->name, label_max);
+		info->volname[label_max] = '\0';
+		state->parts[slot].has_info = true;
+	}
+
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
+
+	return 1;
+}
+
+static int set_cmdline_parts(char *str) {
+	strncpy(cmdline_string, str, sizeof(cmdline_string) - 1);
+	cmdline_string[sizeof(cmdline_string) - 1] = '\0';
+	return 1;
+}
+__setup("cmdlineparts=", set_cmdline_parts);
+
+void cmdline_parts_setup(char *str)
+{
+	mutex_lock(&cmdline_string_mutex);
+	set_cmdline_parts(str);
+	mutex_unlock(&cmdline_string_mutex);
+}
+EXPORT_SYMBOL(cmdline_parts_setup);
+
+/*
+ * Purpose: allocate cmdline partitions.
+ * Returns:
+ * -1 if unable to read the partition table
+ *  0 if this isn't our partition table
+ *  1 if successful
+ */
+int cmdline_partition(struct parsed_partitions *state) {
+	int ret;
+
+	mutex_lock(&cmdline_string_mutex);
+	if (cmdline_string[0]) {
+
+		if (cmdline_parts)
+			free_parts(&cmdline_parts);
+
+		if (parse_cmdline(&cmdline_parts, cmdline_string)) {
+			ret = 0;
+			goto fail;
+		}
+		cmdline_string[0] = '\0';
+	}
+	mutex_unlock(&cmdline_string_mutex);
+
+	if (!cmdline_parts)
+		return 0;
+
+	return parse_partitions(state, cmdline_parts);
+
+fail:
+	cmdline_string[0] = '\0';
+	mutex_unlock(&cmdline_string_mutex);
+	return ret;
+}
diff --git a/block/partitions/cmdline.h b/block/partitions/cmdline.h new file mode 100644 index 0000000..26e0f8d
--- /dev/null
+++ b/block/partitions/cmdline.h
@@ -0,0 +1,2 @@
+
+int cmdline_partition(struct parsed_partitions *state);
--
1.8.1.5

