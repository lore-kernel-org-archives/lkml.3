Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3KILqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 06:46:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:60099 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3KILqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 06:46:15 -0500
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
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: [PATCH 2/2] mtd: cmdlinepart: support master name is not set when
 parser partition
Thread-Topic: [PATCH 2/2] mtd: cmdlinepart: support master name is not set
 when parser partition
Thread-Index: Ac7dQNrmaepPFNCzTfSQ2Rn2iobZJg==
Date: Sat, 9 Nov 2013 11:43:06 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08B3EA@szxeml512-mbs.china.huawei.com>
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
Date: Sat, 9 Nov 2013 17:54:12 +0800
Subject: [PATCH 2/2] mtd: cmdlinepart: support master name is not set when parser partition

 -Fix compile warning with value and function undeclared.
  this reported by <fengguang.wu@intel.com> and
  Randy Dunlap <rdunlap@infradead.org>

 -support master name is not set when parser partition.
  this feature is supported in the old parser.

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 drivers/mtd/Kconfig       |  1 +
 drivers/mtd/cmdlinepart.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index daf544a..f8f45e0 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -76,6 +76,7 @@ endif # MTD_REDBOOT_PARTS
 config MTD_CMDLINE_PARTS
 	tristate "Command line partition table parsing"
 	select BLK_CMDLINE_PARSER
+	depends on BLOCK
 	depends on MTD
 	---help---
 	  Allow generic configuration of the MTD partition tables via the kernel
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index ba934a4..2074164 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -54,6 +54,7 @@
   */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/module.h>
@@ -108,7 +109,12 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 	if (!mtd_cmdline_parts)
 		return 0;
 
-	parts = cmdline_parts_find(mtd_cmdline_parts, master->name);
+	/* If master->name is not set, return the first device partition. */
+	if (!master->name)
+		parts = mtd_cmdline_parts->next_parts;
+	else
+		parts = cmdline_parts_find(mtd_cmdline_parts, master->name);
+
 	if (!parts)
 		return 0;
 
@@ -143,5 +149,5 @@ MODULE_PARM_DESC(mtdparts, "Partitioning specification");
 module_param(mtdparts, charp, 0);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marius Groeger <mag@sysgo.de>");
+MODULE_AUTHOR("Cai Zhiyong <caizhiyong@huawei.com>");
 MODULE_DESCRIPTION("Command line configuration of MTD partitions");
-- 
1.8.1.5

