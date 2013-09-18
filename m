Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3IRBft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:35:49 -0400
Received: from mail1.windriver.com ([147.11.146.13]:37894 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3IRBfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:35:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jens Axboe <axboe@kernel.dk>, Cai Zhiyong <caizhiyong@huawei.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] block: change config option name for cmdline partition parsing
Date: Tue, 17 Sep 2013 21:32:26 -0400
Message-ID: <1379467946-5372-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently added commit bab55417b10c95e6bff8cea315c315adfa009487
("block: support embedded device command line partition") introduced
CONFIG_CMDLINE_PARSER.  However, that name is too generic and sounds
like it enables/disables generic kernel boot arg processing, when it
really is block specific.

Before this option becomes a part of a full/final release, add the
BLK_ prefix to it so that it is clear in absence of any other context
that it is block specific.

In addition, fix up the following less critical items:
 - help text was not really at all helpful.
 - index file for Documentation was not updated
 - add the new arg to Documentation/kernel-parameters.txt
 - clarify wording in source comments

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Cai Zhiyong <caizhiyong@huawei.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/block/00-INDEX              | 2 ++
 Documentation/block/cmdline-partition.txt | 8 ++++----
 Documentation/kernel-parameters.txt       | 4 ++++
 block/Kconfig                             | 9 +++++++--
 block/Makefile                            | 2 +-
 block/partitions/Kconfig                  | 4 ++--
 block/partitions/cmdline.c                | 8 ++++----
 7 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/Documentation/block/00-INDEX b/Documentation/block/00-INDEX
index d18ecd8..929d990 100644
--- a/Documentation/block/00-INDEX
+++ b/Documentation/block/00-INDEX
@@ -6,6 +6,8 @@ capability.txt
 	- Generic Block Device Capability (/sys/block/<device>/capability)
 cfq-iosched.txt
 	- CFQ IO scheduler tunables
+cmdline-partition.txt
+	- how to specify block device partitions on kernel command line
 data-integrity.txt
 	- Block data integrity
 deadline-iosched.txt
diff --git a/Documentation/block/cmdline-partition.txt b/Documentation/block/cmdline-partition.txt
index 2bbf4cc..525b9f6 100644
--- a/Documentation/block/cmdline-partition.txt
+++ b/Documentation/block/cmdline-partition.txt
@@ -1,9 +1,9 @@
-Embedded device command line partition
+Embedded device command line partition parsing
 =====================================================================
 
-Read block device partition table from command line.
-The partition used for fixed block device (eMMC) embedded device.
-It is no MBR, save storage space. Bootloader can be easily accessed
+Support for reading the block device partition table from the command line.
+It is typically used for fixed block (eMMC) embedded devices.
+It has no MBR, so saves storage space. Bootloader can be easily accessed
 by absolute address of data on the block device.
 Users can easily change the partition.
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1a036cd9..9e5ca2a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -480,6 +480,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <io>,<irq>,<mode>
 			See header of drivers/net/hamradio/baycom_ser_hdx.c.
 
+	blkdevparts=	Manual partition parsing of block device(s) for
+			embedded devices based on command line input.
+			See Documentation/block/cmdline-partition.txt
+
 	boot_delay=	Milliseconds to delay each printk during boot.
 			Values larger than 10 seconds (10000) are changed to
 			no delay (0).
diff --git a/block/Kconfig b/block/Kconfig
index 7f38e40..2429515 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -99,11 +99,16 @@ config BLK_DEV_THROTTLING
 
 	See Documentation/cgroups/blkio-controller.txt for more information.
 
-config CMDLINE_PARSER
+config BLK_CMDLINE_PARSER
 	bool "Block device command line partition parser"
 	default n
 	---help---
-	Parsing command line, get the partitions information.
+	Enabling this option allows you to specify the partition layout from
+	the kernel boot args.  This is typically of use for embedded devices
+	which don't otherwise have any standardized method for listing the
+	partitions on a block device.
+
+	See Documentation/block/cmdline-partition.txt for more information.
 
 menu "Partition Types"
 
diff --git a/block/Makefile b/block/Makefile
index 4fa4be5..671a83d 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -18,4 +18,4 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
-obj-$(CONFIG_CMDLINE_PARSER)	+= cmdline-parser.o
+obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
diff --git a/block/partitions/Kconfig b/block/partitions/Kconfig
index 87a3208..9b29a99 100644
--- a/block/partitions/Kconfig
+++ b/block/partitions/Kconfig
@@ -263,7 +263,7 @@ config SYSV68_PARTITION
 
 config CMDLINE_PARTITION
 	bool "Command line partition support" if PARTITION_ADVANCED
-	select CMDLINE_PARSER
+	select BLK_CMDLINE_PARSER
 	help
-	  Say Y here if you would read the partitions table from bootargs.
+	  Say Y here if you want to read the partition table from bootargs.
 	  The format for the command line is just like mtdparts.
diff --git a/block/partitions/cmdline.c b/block/partitions/cmdline.c
index 56cf4ff..5141b56 100644
--- a/block/partitions/cmdline.c
+++ b/block/partitions/cmdline.c
@@ -2,15 +2,15 @@
  * Copyright (C) 2013 HUAWEI
  * Author: Cai Zhiyong <caizhiyong@huawei.com>
  *
- * Read block device partition table from command line.
- * The partition used for fixed block device (eMMC) embedded device.
- * It is no MBR, save storage space. Bootloader can be easily accessed
+ * Read block device partition table from the command line.
+ * Typically used for fixed block (eMMC) embedded devices.
+ * It has no MBR, so saves storage space. Bootloader can be easily accessed
  * by absolute address of data on the block device.
  * Users can easily change the partition.
  *
  * The format for the command line is just like mtdparts.
  *
- * Verbose config please reference "Documentation/block/cmdline-partition.txt"
+ * For further information, see "Documentation/block/cmdline-partition.txt"
  *
  */
 
-- 
1.8.1.2

