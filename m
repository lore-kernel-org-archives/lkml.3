Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3HMGCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:02:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51500 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3HMGCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:02:33 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>
Subject: [PATCH] block: add command line partition parser
Thread-Topic: [PATCH] block: add command line partition parser
Thread-Index: AQHOl+qqJeZC0CvH906unOBo+NYxZA==
Date: Tue, 13 Aug 2013 06:02:17 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C06237C@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
 <20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
In-Reply-To: <20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: FWI= COWv CojJ D5R0 IjPX I9UQ LaT7 NpQL TRlo USIZ VRd0
 WvDW Xh8C ZTuP bDq0
 btry;3;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGsAegBhAGsAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{A343A532-190C-4AE5-8118-59A22F1C53B5};YwBhAGkAegBoAGkAeQBvAG4AZwBAAGgAdQBhAHcAZQBpAC4AYwBvAG0A;Tue,
 13 Aug 2013 06:02:09
 GMT;WwBQAEEAVABDAEgAXQAgAGIAbABvAGMAawA6ACAAYQBkAGQAIABjAG8AbQBtAGEAbgBkACAAbABpAG4AZQAgAHAAYQByAHQAaQB0AGkAbwBuACAAcABhAHIAcwBlAHIA
x-cr-puzzleid: {A343A532-190C-4AE5-8118-59A22F1C53B5}
x-originating-ip: [10.67.223.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>

move the command line parser to a separate module, and change it into
library-style code.

reference: https://lkml.org/lkml/2013/8/6/550

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 block/Kconfig                  |   6 +
 block/Makefile                 |   1 +
 block/cmdline-parser.c         | 249 +++++++++++++++++++++++++++++++++
 block/partitions/Kconfig       |   1 +
 block/partitions/cmdline.c     | 311 ++++++-----------------------------------
 include/linux/cmdline-parser.h |  43 ++++++
 6 files changed, 342 insertions(+), 269 deletions(-)
 create mode 100644 block/cmdline-parser.c
 create mode 100644 include/linux/cmdline-parser.h

diff --git a/block/Kconfig b/block/Kconfig
index a7e40a7..7f38e40 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -99,6 +99,12 @@ config BLK_DEV_THROTTLING
 
 	See Documentation/cgroups/blkio-controller.txt for more information.
 
+config CMDLINE_PARSER
+	bool "Block device command line partition parser"
+	default n
+	---help---
+	Parsing command line, get the partitions information.
+
 menu "Partition Types"
 
 source "block/partitions/Kconfig"
diff --git a/block/Makefile b/block/Makefile
index 39b76ba..4fa4be5 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
+obj-$(CONFIG_CMDLINE_PARSER)	+= cmdline-parser.o
diff --git a/block/cmdline-parser.c b/block/cmdline-parser.c
new file mode 100644
index 0000000..18fb435
--- /dev/null
+++ b/block/cmdline-parser.c
@@ -0,0 +1,249 @@
+/*
+ * Parse command line, get partition information
+ *
+ * Written by Cai Zhiyong <caizhiyong@huawei.com>
+ *
+ */
+#include <linux/buffer_head.h>
+#include <linux/module.h>
+#include <linux/cmdline-parser.h>
+
+static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
+{
+	int ret = 0;
+	struct cmdline_subpart *new_subpart;
+
+	*subpart = NULL;
+
+	new_subpart = kzalloc(sizeof(struct cmdline_subpart), GFP_KERNEL);
+	if (!new_subpart)
+		return -ENOMEM;
+
+	if (*partdef == '-') {
+		new_subpart->size = (sector_t)(~0ULL);
+		partdef++;
+	} else {
+		new_subpart->size = (sector_t)memparse(partdef, &partdef);
+		if (new_subpart->size < (sector_t)PAGE_SIZE) {
+			pr_warn("cmdline partition size is invalid.");
+			ret = -EINVAL;
+			goto fail;
+		}
+	}
+
+	if (*partdef == '@') {
+		partdef++;
+		new_subpart->from = (sector_t)memparse(partdef, &partdef);
+	} else {
+		new_subpart->from = (sector_t)(~0ULL);
+	}
+
+	if (*partdef == '(') {
+		int length;
+		char *next = strchr(++partdef, ')');
+
+		if (!next) {
+			pr_warn("cmdline partition format is invalid.");
+			ret = -EINVAL;
+			goto fail;
+		}
+
+		length = min_t(int, next - partdef,
+			       sizeof(new_subpart->name) - 1);
+		strncpy(new_subpart->name, partdef, length);
+		new_subpart->name[length] = '\0';
+
+		partdef = ++next;
+	} else
+		new_subpart->name[0] = '\0';
+
+	new_subpart->flags = 0;
+
+	if (!strncmp(partdef, "ro", 2)) {
+		new_subpart->flags |= PF_RDONLY;
+		partdef += 2;
+	}
+
+	if (!strncmp(partdef, "lk", 2)) {
+		new_subpart->flags |= PF_POWERUP_LOCK;
+		partdef += 2;
+	}
+
+	*subpart = new_subpart;
+	return 0;
+fail:
+	kfree(new_subpart);
+	return ret;
+}
+
+static void free_subpart(struct cmdline_parts *parts)
+{
+	struct cmdline_subpart *subpart;
+
+	while (parts->subpart) {
+		subpart = parts->subpart;
+		parts->subpart = subpart->next_subpart;
+		kfree(subpart);
+	}
+}
+
+static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
+{
+	int ret = -EINVAL;
+	char *next;
+	int length;
+	struct cmdline_subpart **next_subpart;
+	struct cmdline_parts *newparts;
+	char buf[BDEVNAME_SIZE + 32 + 4];
+
+	*parts = NULL;
+
+	newparts = kzalloc(sizeof(struct cmdline_parts), GFP_KERNEL);
+	if (!newparts)
+		return -ENOMEM;
+
+	next = strchr(bdevdef, ':');
+	if (!next) {
+		pr_warn("cmdline partition has no block device.");
+		goto fail;
+	}
+
+	length = min_t(int, next - bdevdef, sizeof(newparts->name) - 1);
+	strncpy(newparts->name, bdevdef, length);
+	newparts->name[length] = '\0';
+	newparts->nr_subparts = 0;
+
+	next_subpart = &newparts->subpart;
+
+	while (next && *(++next)) {
+		bdevdef = next;
+		next = strchr(bdevdef, ',');
+
+		length = (!next) ? (sizeof(buf) - 1) :
+			min_t(int, next - bdevdef, sizeof(buf) - 1);
+
+		strncpy(buf, bdevdef, length);
+		buf[length] = '\0';
+
+		ret = parse_subpart(next_subpart, buf);
+		if (ret)
+			goto fail;
+
+		newparts->nr_subparts++;
+		next_subpart = &(*next_subpart)->next_subpart;
+	}
+
+	if (!newparts->subpart) {
+		pr_warn("cmdline partition has no valid partition.");
+		goto fail;
+	}
+
+	*parts = newparts;
+
+	return 0;
+fail:
+	free_subpart(newparts);
+	kfree(newparts);
+	return ret;
+}
+
+void cmdline_parts_free(struct cmdline_parts **parts)
+{
+	struct cmdline_parts *next_parts;
+
+	while (*parts) {
+		next_parts = (*parts)->next_parts;
+		free_subpart(*parts);
+		kfree(*parts);
+		*parts = next_parts;
+	}
+}
+
+int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline)
+{
+	int ret;
+	char *buf;
+	char *pbuf;
+	char *next;
+	struct cmdline_parts **next_parts;
+
+	*parts = NULL;
+
+	next = pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	next_parts = parts;
+
+	while (next && *pbuf) {
+		next = strchr(pbuf, ';');
+		if (next)
+			*next = '\0';
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
+	if (!*parts) {
+		pr_warn("cmdline partition has no valid partition.");
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	ret = 0;
+done:
+	kfree(buf);
+	return ret;
+
+fail:
+	cmdline_parts_free(parts);
+	goto done;
+}
+
+struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
+					 const char *bdev)
+{
+	while (parts && strncmp(bdev, parts->name, sizeof(parts->name)))
+		parts = parts->next_parts;
+	return parts;
+}
+
+/*
+ *  add_part()
+ *    0 success.
+ *    1 can not add so many partitions.
+ */
+void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		       int slot,
+		       int (*add_part)(int, struct cmdline_subpart *, void *),
+		       void *param)
+
+{
+	sector_t from = 0;
+	struct cmdline_subpart *subpart;
+
+	for (subpart = parts->subpart; subpart;
+	     subpart = subpart->next_subpart, slot++) {
+		if (subpart->from == (sector_t)(~0ULL))
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
+		if (add_part(slot, subpart, param))
+			break;
+	}
+}
diff --git a/block/partitions/Kconfig b/block/partitions/Kconfig
index 2ebf251..87a3208 100644
--- a/block/partitions/Kconfig
+++ b/block/partitions/Kconfig
@@ -263,6 +263,7 @@ config SYSV68_PARTITION
 
 config CMDLINE_PARTITION
 	bool "Command line partition support" if PARTITION_ADVANCED
+	select CMDLINE_PARSER
 	help
 	  Say Y here if you would read the partitions table from bootargs.
 	  The format for the command line is just like mtdparts.
diff --git a/block/partitions/cmdline.c b/block/partitions/cmdline.c
index 1a1eac7..56cf4ff 100644
--- a/block/partitions/cmdline.c
+++ b/block/partitions/cmdline.c
@@ -8,219 +8,54 @@
  * by absolute address of data on the block device.
  * Users can easily change the partition.
  *
- * This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
  * The format for the command line is just like mtdparts.
  *
  * Verbose config please reference "Documentation/block/cmdline-partition.txt"
  *
  */
 
-#include <linux/buffer_head.h>
-#include <linux/module.h>
-#include <linux/ctype.h>
+#include <linux/cmdline-parser.h>
 
 #include "check.h"
 #include "cmdline.h"
 
-struct cmdline_subpart {
-	char name[BDEVNAME_SIZE]; /* partition name, such as 'rootfs' */
-	sector_t from;
-	sector_t size;
-	struct cmdline_subpart *next_subpart;
-};
+static char *cmdline;
+static struct cmdline_parts *bdev_parts;
 
-struct cmdline_parts {
-	char name[BDEVNAME_SIZE]; /* block device, such as 'mmcblk0' */
-	struct cmdline_subpart *subpart;
-	struct cmdline_parts *next_parts;
-};
-
-static char *cmdline_string;
-static struct cmdline_parts *cmdline_parts;
-
-static int parse_subpart(struct cmdline_subpart **subpart, char *cmdline)
-{
-	int ret = 0;
-	struct cmdline_subpart *new_subpart;
-
-	*subpart = NULL;
-
-	new_subpart = kzalloc(sizeof(struct cmdline_subpart), GFP_KERNEL);
-	if (!new_subpart)
-		return -ENOMEM;
-
-	if (*cmdline == '-') {
-		new_subpart->size = (sector_t)(~0ULL);
-		cmdline++;
-	} else {
-		new_subpart->size = (sector_t)memparse(cmdline, &cmdline);
-		if (new_subpart->size < (sector_t)PAGE_SIZE) {
-			pr_warn("cmdline partition size is invalid.");
-			ret = -EINVAL;
-			goto fail;
-		}
-	}
-
-	if (*cmdline == '@') {
-		cmdline++;
-		new_subpart->from = (sector_t)memparse(cmdline, &cmdline);
-	} else {
-		new_subpart->from = (sector_t)(~0ULL);
-	}
-
-	if (*cmdline == '(') {
-		int length;
-		char *next = strchr(++cmdline, ')');
-
-		if (!next) {
-			pr_warn("cmdline partition format is invalid.");
-			ret = -EINVAL;
-			goto fail;
-		}
-
-		length = min_t(int, next - cmdline,
-			       sizeof(new_subpart->name) - 1);
-		strncpy(new_subpart->name, cmdline, length);
-		new_subpart->name[length] = '\0';
-
-		cmdline = ++next;
-	} else
-		new_subpart->name[0] = '\0';
-
-	*subpart = new_subpart;
-	return 0;
-fail:
-	kfree(new_subpart);
-	return ret;
-}
-
-static void free_subpart(struct cmdline_parts *parts)
-{
-	struct cmdline_subpart *subpart;
-
-	while (parts->subpart) {
-		subpart = parts->subpart;
-		parts->subpart = subpart->next_subpart;
-		kfree(subpart);
-	}
-}
-
-static void free_parts(struct cmdline_parts **parts)
-{
-	struct cmdline_parts *next_parts;
-
-	while (*parts) {
-		next_parts = (*parts)->next_parts;
-		free_subpart(*parts);
-		kfree(*parts);
-		*parts = next_parts;
-	}
-}
-
-static int parse_parts(struct cmdline_parts **parts, const char *cmdline)
+static int add_part(int slot, struct cmdline_subpart *subpart, void *param)
 {
-	int ret = -EINVAL;
-	char *next;
-	int length;
-	struct cmdline_subpart **next_subpart;
-	struct cmdline_parts *newparts;
-	char buf[BDEVNAME_SIZE + 32 + 4];
+	int label_min;
+	struct partition_meta_info *info;
+	char tmp[sizeof(info->volname) + 4];
+	struct parsed_partitions *state = (struct parsed_partitions *)param;
 
-	*parts = NULL;
+	if (slot >= state->limit)
+		return 1;
 
-	newparts = kzalloc(sizeof(struct cmdline_parts), GFP_KERNEL);
-	if (!newparts)
-		return -ENOMEM;
+	put_partition(state, slot, subpart->from >> 9,
+		      subpart->size >> 9);
 
-	next = strchr(cmdline, ':');
-	if (!next) {
-		pr_warn("cmdline partition has no block device.");
-		goto fail;
-	}
-
-	length = min_t(int, next - cmdline, sizeof(newparts->name) - 1);
-	strncpy(newparts->name, cmdline, length);
-	newparts->name[length] = '\0';
-
-	next_subpart = &newparts->subpart;
+	info = &state->parts[slot].info;
 
-	while (next && *(++next)) {
-		cmdline = next;
-		next = strchr(cmdline, ',');
+	label_min = min_t(int, sizeof(info->volname) - 1,
+			  sizeof(subpart->name));
+	strncpy(info->volname, subpart->name, label_min);
+	info->volname[label_min] = '\0';
 
-		length = (!next) ? (sizeof(buf) - 1) :
-			min_t(int, next - cmdline, sizeof(buf) - 1);
+	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
+	strlcat(state->pp_buf, tmp, PAGE_SIZE);
 
-		strncpy(buf, cmdline, length);
-		buf[length] = '\0';
-
-		ret = parse_subpart(next_subpart, buf);
-		if (ret)
-			goto fail;
-
-		next_subpart = &(*next_subpart)->next_subpart;
-	}
-
-	if (!newparts->subpart) {
-		pr_warn("cmdline partition has no valid partition.");
-		goto fail;
-	}
-
-	*parts = newparts;
+	state->parts[slot].has_info = true;
 
 	return 0;
-fail:
-	free_subpart(newparts);
-	kfree(newparts);
-	return ret;
 }
 
-static int parse_cmdline(struct cmdline_parts **parts, const char *cmdline)
+static int __init cmdline_parts_setup(char *s)
 {
-	int ret;
-	char *buf;
-	char *pbuf;
-	char *next;
-	struct cmdline_parts **next_parts;
-
-	*parts = NULL;
-
-	next = pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	next_parts = parts;
-
-	while (next && *pbuf) {
-		next = strchr(pbuf, ';');
-		if (next)
-			*next = '\0';
-
-		ret = parse_parts(next_parts, pbuf);
-		if (ret)
-			goto fail;
-
-		if (next)
-			pbuf = ++next;
-
-		next_parts = &(*next_parts)->next_parts;
-	}
-
-	if (!*parts) {
-		pr_warn("cmdline partition has no valid partition.");
-		ret = -EINVAL;
-		goto fail;
-	}
-
-	ret = 0;
-done:
-	kfree(buf);
-	return ret;
-
-fail:
-	free_parts(parts);
-	goto done;
+	cmdline = s;
+	return 1;
 }
+__setup("blkdevparts=", cmdline_parts_setup);
 
 /*
  * Purpose: allocate cmdline partitions.
@@ -229,98 +64,36 @@ fail:
  *  0 if this isn't our partition table
  *  1 if successful
  */
-static int parse_partitions(struct parsed_partitions *state,
-			    struct cmdline_parts *parts)
+int cmdline_partition(struct parsed_partitions *state)
 {
-	int slot;
-	sector_t from = 0;
 	sector_t disk_size;
-	char buf[BDEVNAME_SIZE];
-	struct cmdline_subpart *subpart;
+	char bdev[BDEVNAME_SIZE];
+	struct cmdline_parts *parts;
+
+	if (cmdline) {
+		if (bdev_parts)
+			cmdline_parts_free(&bdev_parts);
 
-	bdevname(state->bdev, buf);
+		if (cmdline_parts_parse(&bdev_parts, cmdline)) {
+			cmdline = NULL;
+			return -1;
+		}
+		cmdline = NULL;
+	}
 
-	while (parts && strncmp(buf, parts->name, BDEVNAME_SIZE))
-		parts = parts->next_parts;
+	if (!bdev_parts)
+		return 0;
 
+	bdevname(state->bdev, bdev);
+	parts = cmdline_parts_find(bdev_parts, bdev);
 	if (!parts)
 		return 0;
 
 	disk_size = get_capacity(state->bdev->bd_disk) << 9;
 
-	for (slot = 1, subpart = parts->subpart;
-	     subpart && slot < state->limit;
-	     subpart = subpart->next_subpart, slot++) {
-		int label_min;
-		struct partition_meta_info *info;
-		char tmp[sizeof(info->volname) + 4];
-
-		if (subpart->from == (sector_t)(~0ULL))
-			subpart->from = from;
-		else
-			from = subpart->from;
-
-		if (from >= disk_size)
-			break;
-
-		if (subpart->size > (disk_size - from))
-			subpart->size = disk_size - from;
-
-		from += subpart->size;
-
-		put_partition(state, slot, subpart->from >> 9,
-			      subpart->size >> 9);
-
-		info = &state->parts[slot].info;
-
-		label_min = min_t(int, sizeof(info->volname) - 1,
-				  sizeof(subpart->name));
-		strncpy(info->volname, subpart->name, label_min);
-		info->volname[label_min] = '\0';
-
-		snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
-
-		state->parts[slot].has_info = true;
-	}
+	cmdline_parts_set(parts, disk_size, 1, add_part, (void *)state);
 
 	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 
 	return 1;
 }
-
-static int __init cmdline_parts_setup(char *s)
-{
-	cmdline_string = s;
-	return 1;
-}
-__setup("blkdevparts=", cmdline_parts_setup);
-
-/*
- * Purpose: allocate cmdline partitions.
- * Returns:
- * -1 if unable to read the partition table
- *  0 if this isn't our partition table
- *  1 if successful
- */
-int cmdline_partition(struct parsed_partitions *state)
-{
-	if (cmdline_string) {
-		if (cmdline_parts)
-			free_parts(&cmdline_parts);
-
-		if (parse_cmdline(&cmdline_parts, cmdline_string))
-			goto fail;
-
-		cmdline_string = NULL;
-	}
-
-	if (!cmdline_parts)
-		return 0;
-
-	return parse_partitions(state, cmdline_parts);
-
-fail:
-	cmdline_string = NULL;
-	return -1;
-}
diff --git a/include/linux/cmdline-parser.h b/include/linux/cmdline-parser.h
new file mode 100644
index 0000000..98e892e
--- /dev/null
+++ b/include/linux/cmdline-parser.h
@@ -0,0 +1,43 @@
+/*
+ * Parsing command line, get the partitions information.
+ *
+ * Written by Cai Zhiyong <caizhiyong@huawei.com>
+ *
+ */
+#ifndef CMDLINEPARSEH
+#define CMDLINEPARSEH
+
+#include <linux/blkdev.h>
+
+/* partition flags */
+#define PF_RDONLY                   0x01 /* Device is read only */
+#define PF_POWERUP_LOCK             0x02 /* Always locked after reset */
+
+struct cmdline_subpart {
+	char name[BDEVNAME_SIZE]; /* partition name, such as 'rootfs' */
+	sector_t from;
+	sector_t size;
+	int flags;
+	struct cmdline_subpart *next_subpart;
+};
+
+struct cmdline_parts {
+	char name[BDEVNAME_SIZE]; /* block device, such as 'mmcblk0' */
+	unsigned int nr_subparts;
+	struct cmdline_subpart *subpart;
+	struct cmdline_parts *next_parts;
+};
+
+void cmdline_parts_free(struct cmdline_parts **parts);
+
+int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline);
+
+struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
+					 const char *bdev);
+
+void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		       int slot,
+		       int (*add_part)(int, struct cmdline_subpart *, void *),
+		       void *param);
+
+#endif /* CMDLINEPARSEH */
-- 
1.8.1.5

