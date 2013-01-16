Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3APBND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:13:03 -0500
Received: from norkia.v3.sk ([91.210.183.14]:57086 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab3APBNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:13:01 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 1/2] mtd: cmdlinepart: Make it into a module
Date: Wed, 16 Jan 2013 02:12:49 +0100
Message-Id: <1358298770-20286-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other partitioning schemes can be compiled as modules

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/mtd/Kconfig       |    4 ++--
 drivers/mtd/cmdlinepart.c |    8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 73fcbbe..4dd3b38 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -74,8 +74,8 @@ config MTD_REDBOOT_PARTS_READONLY
 endif # MTD_REDBOOT_PARTS
 
 config MTD_CMDLINE_PARTS
-	bool "Command line partition table parsing"
-	depends on MTD = "y"
+	tristate "Command line partition table parsing"
+	depends on MTD
 	---help---
 	  Allow generic configuration of the MTD partition tables via the kernel
 	  command line. Multiple flash resources are supported for hardware where
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index aed1b8a..a2bb2ea 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -70,6 +70,7 @@ struct cmdline_mtd_partition {
 static struct cmdline_mtd_partition *partitions;
 
 /* the command line passed to mtdpart_setup() */
+static char *mtdparts;
 static char *cmdline;
 static int cmdline_parsed;
 
@@ -360,7 +361,7 @@ static int parse_cmdline_partitions(struct mtd_info *master,
  *
  * This function needs to be visible for bootloaders.
  */
-static int mtdpart_setup(char *s)
+static int __init mtdpart_setup(char *s)
 {
 	cmdline = s;
 	return 1;
@@ -376,11 +377,16 @@ static struct mtd_part_parser cmdline_parser = {
 
 static int __init cmdline_parser_init(void)
 {
+	if (mtdparts)
+		mtdpart_setup(mtdparts);
 	return register_mtd_parser(&cmdline_parser);
 }
 
 module_init(cmdline_parser_init);
 
+MODULE_PARM_DESC(mtdparts, "Partitioning specification");
+module_param(mtdparts, charp, 0);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marius Groeger <mag@sysgo.de>");
 MODULE_DESCRIPTION("Command line configuration of MTD partitions");
-- 
1.7.1

