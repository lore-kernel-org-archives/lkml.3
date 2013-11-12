Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3KLI1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:27:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:54032 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3KLI1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:27:46 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Karel Zak <kzak@redhat.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH] block: cmdline-parser: perfect cmdline format checking
Thread-Topic: [PATCH] block: cmdline-parser: perfect cmdline format checking
Thread-Index: Ac7ff96cU4wm9hxMTwivuvPk9MMnzg==
Date: Tue, 12 Nov 2013 08:19:13 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08B6DD@szxeml512-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>
Date: Tue, 12 Nov 2013 15:50:42 +0800
Subject: [PATCH] block: cmdline-parser: perfect cmdline format checking

 -Fix compile warning with value and function undeclared.
  this reported by <fengguang.wu@intel.com> and
  Randy Dunlap <rdunlap@infradead.org>

 -perfect cmdline format checking, make the error information clear
  for understand, make this lib fully equivalent to the old parser
  in drivers/mtd/cmdlinepart.c

I tested each branch of this patch change, it is ok.

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 block/cmdline-parser.c         | 83 +++++++++++++++++++++++++++++++-----------
 include/linux/cmdline-parser.h |  1 +
 2 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/block/cmdline-parser.c b/block/cmdline-parser.c
index 9dbc67e..4833936 100644
--- a/block/cmdline-parser.c
+++ b/block/cmdline-parser.c
@@ -4,12 +4,17 @@
  * Written by Cai Zhiyong <caizhiyong@huawei.com>
  *
  */
+#define pr_fmt(fmt) "cmdline-parser: " fmt
+
 #include <linux/export.h>
 #include <linux/cmdline-parser.h>
+#include <linux/slab.h>
 
 static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
 {
 	int ret = 0;
+	int lastpart = 0;
+	char *partorg = partdef;
 	struct cmdline_subpart *new_subpart;
 
 	*subpart = NULL;
@@ -21,10 +26,12 @@ static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
 	if (*partdef == '-') {
 		new_subpart->size = (sector_t)(~0ULL);
 		partdef++;
+		lastpart = 1;
 	} else {
 		new_subpart->size = (sector_t)memparse(partdef, &partdef);
 		if (new_subpart->size < (sector_t)PAGE_SIZE) {
-			pr_warn("cmdline partition size is invalid.");
+			pr_warn("partition '%s' size '0x%llx' too small.\n",
+				partorg, new_subpart->size);
 			ret = -EINVAL;
 			goto fail;
 		}
@@ -42,13 +49,19 @@ static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
 		char *next = strchr(++partdef, ')');
 
 		if (!next) {
-			pr_warn("cmdline partition format is invalid.");
+			pr_warn("partition '%s' has no closing ')' found in partition name.\n",
+				partorg);
 			ret = -EINVAL;
 			goto fail;
 		}
 
-		length = min_t(int, next - partdef,
-			       sizeof(new_subpart->name) - 1);
+		length = (int)(next - partdef);
+		if (length > sizeof(new_subpart->name) - 1) {
+			pr_warn("partition '%s' partition name too long, truncating.\n",
+				partorg);
+			length = sizeof(new_subpart->name) - 1;
+		}
+
 		strncpy(new_subpart->name, partdef, length);
 		new_subpart->name[length] = '\0';
 
@@ -68,8 +81,15 @@ static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
 		partdef += 2;
 	}
 
+	if (*partdef) {
+		pr_warn("partition '%s' has bad character '%c' after partition.\n",
+			partorg, *partdef);
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	*subpart = new_subpart;
-	return 0;
+	return lastpart;
 fail:
 	kfree(new_subpart);
 	return ret;
@@ -86,14 +106,13 @@ static void free_subpart(struct cmdline_parts *parts)
 	}
 }
 
-static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
+static int parse_parts(struct cmdline_parts **parts, char *bdevdef)
 {
 	int ret = -EINVAL;
 	char *next;
 	int length;
 	struct cmdline_subpart **next_subpart;
 	struct cmdline_parts *newparts;
-	char buf[BDEVNAME_SIZE + 32 + 4];
 
 	*parts = NULL;
 
@@ -102,14 +121,21 @@ static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
 		return -ENOMEM;
 
 	next = strchr(bdevdef, ':');
-	if (!next) {
-		pr_warn("cmdline partition has no block device.");
+	if (!next || next == bdevdef) {
+		pr_warn("partition '%s' has no block device.\n", bdevdef);
 		goto fail;
 	}
 
-	length = min_t(int, next - bdevdef, sizeof(newparts->name) - 1);
+	length = (int)(next - bdevdef);
+	if (length > sizeof(newparts->name) - 1) {
+		pr_warn("partition '%s' device name too long, truncating.\n",
+			bdevdef);
+		length = sizeof(newparts->name) - 1;
+	}
+
 	strncpy(newparts->name, bdevdef, length);
 	newparts->name[length] = '\0';
+
 	newparts->nr_subparts = 0;
 
 	next_subpart = &newparts->subpart;
@@ -117,23 +143,25 @@ static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
 	while (next && *(++next)) {
 		bdevdef = next;
 		next = strchr(bdevdef, ',');
+		if (next)
+			*next = '\0';
 
-		length = (!next) ? (sizeof(buf) - 1) :
-			min_t(int, next - bdevdef, sizeof(buf) - 1);
-
-		strncpy(buf, bdevdef, length);
-		buf[length] = '\0';
-
-		ret = parse_subpart(next_subpart, buf);
-		if (ret)
+		ret = parse_subpart(next_subpart, bdevdef);
+		if (ret < 0) {
 			goto fail;
+		} else if (ret > 0 && next) {
+			pr_warn("no partitions allowed after a fill-up partition.\n");
+			ret = -EINVAL;
+			goto fail;
+		}
 
 		newparts->nr_subparts++;
 		next_subpart = &(*next_subpart)->next_subpart;
 	}
 
 	if (!newparts->subpart) {
-		pr_warn("cmdline partition has no valid partition.");
+		pr_warn("block device '%s' has no valid partition.\n",
+			newparts->name);
 		ret = -EINVAL;
 		goto fail;
 	}
@@ -192,7 +220,7 @@ int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline)
 	}
 
 	if (!*parts) {
-		pr_warn("cmdline partition has no valid partition.");
+		pr_warn("no found valid partition.\n");
 		ret = -EINVAL;
 		goto fail;
 	}
@@ -237,11 +265,22 @@ int cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
 		else
 			from = subpart->from;
 
-		if (from >= disk_size)
+		if (subpart->name[0] == '\0')
+			snprintf(subpart->name, sizeof(subpart->name),
+				 "partition%03d", slot);
+
+		if (from >= disk_size) {
+			pr_warn("partition '%s' offset exceeds device '%s' size '0x%llx', ignoring.\n",
+				subpart->name, parts->name, disk_size);
 			break;
+		}
 
-		if (subpart->size > (disk_size - from))
+		if (subpart->size > (disk_size - from)) {
+			if (subpart->size != (sector_t)(~0ULL))
+				pr_warn("partition '%s' size exceeds device '%s' size '0x%llx', truncating.\n",
+					subpart->name, parts->name, disk_size);
 			subpart->size = disk_size - from;
+		}
 
 		from += subpart->size;
 
diff --git a/include/linux/cmdline-parser.h b/include/linux/cmdline-parser.h
index 43b65a9..c6491b2 100644
--- a/include/linux/cmdline-parser.h
+++ b/include/linux/cmdline-parser.h
@@ -8,6 +8,7 @@
 #define CMDLINEPARSEH
 
 #include <linux/blkdev.h>
+#include <linux/fs.h>
 
 /* partition flags */
 #define PF_RDONLY                   0x01 /* Device is read only */
-- 
1.8.1.5

