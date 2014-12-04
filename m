Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbaLDWho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:37:44 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:44089 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbaLDWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:37:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,518,1413270000"; 
   d="scan'208";a="52159021"
From: Scott Branden <sbranden@broadcom.com>
To: Scott Branden <sbranden@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: Ray Jui <rjui@broadcom.com>, Corneliu Doban <cdoban@broadcom.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd: add reboot notifier to mtdcore and register nand_shutdown with notifier
Date: Thu, 4 Dec 2014 14:37:38 -0800
Message-ID: <1417732658-4563-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add (optional) reboot notifier field to struct mtd_info, and use it to
register a system reboot notifier on behalf of the lower layers.

Add nand_shutdown to wait for current nand operations to finish and prevent
further operations by changing the nand flash state to FL_SHUTDOWN.
Register the nand_shutdown with the reboot notifier in nand_base.c

This is addressing a problem observed during reboot tests using UBIFS
root file system: NAND erase operations that are in progress during
system reboot/shutdown are causing partial erased blocks. Although UBI should
be able to detect and recover from this error, this change will avoid
the creation of partial erased blocks on reboot in the middle of a NAND erase
operation.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Corneliu Doban <cdoban@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mtd/mtdcore.c        | 20 ++++++++++++++++++++
 drivers/mtd/nand/nand_base.c | 11 +++++++++++
 include/linux/mtd/mtd.h      |  1 +
 3 files changed, 32 insertions(+)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 4c61187..b80d44f 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -37,6 +37,7 @@
 #include <linux/backing-dev.h>
 #include <linux/gfp.h>
 #include <linux/slab.h>
+#include <linux/reboot.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
@@ -365,6 +366,17 @@ static struct device_type mtd_devtype = {
 	.release	= mtd_release,
 };
 
+static int mtd_reboot_notifier(struct notifier_block *n, unsigned long state,
+			       void *cmd)
+{
+       struct mtd_info *mtd;
+
+       mtd = container_of(n, struct mtd_info, reboot_notifier);
+       mtd->_reboot(mtd);
+
+       return NOTIFY_DONE;
+}
+
 /**
  *	add_mtd_device - register an MTD device
  *	@mtd: pointer to new MTD device info structure
@@ -565,6 +577,11 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
 			err = -ENODEV;
 	}
 
+	if (mtd->_reboot) {
+		mtd->reboot_notifier.notifier_call = mtd_reboot_notifier;
+		register_reboot_notifier(&mtd->reboot_notifier);
+	}
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(mtd_device_parse_register);
@@ -579,6 +596,9 @@ int mtd_device_unregister(struct mtd_info *master)
 {
 	int err;
 
+	if (master->_reboot)
+		unregister_reboot_notifier(&master->reboot_notifier);
+
 	err = del_mtd_partitions(master);
 	if (err)
 		return err;
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 5b5c627..e18165b 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2944,6 +2944,16 @@ static void nand_resume(struct mtd_info *mtd)
 			__func__);
 }
 
+/**
+ * nand_shutdown - [MTD Interface] Finish the current NAND operation and
+ *                 prevent further operations
+ * @mtd: MTD device structure
+ */
+static void nand_shutdown(struct mtd_info *mtd)
+{
+	nand_get_device(mtd, FL_SHUTDOWN);
+}
+
 /* Set default functions */
 static void nand_set_defaults(struct nand_chip *chip, int busw)
 {
@@ -4146,6 +4156,7 @@ int nand_scan_tail(struct mtd_info *mtd)
 	mtd->_unlock = NULL;
 	mtd->_suspend = nand_suspend;
 	mtd->_resume = nand_resume;
+	mtd->_reboot = nand_shutdown;
 	mtd->_block_isreserved = nand_block_isreserved;
 	mtd->_block_isbad = nand_block_isbad;
 	mtd->_block_markbad = nand_block_markbad;
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 031ff3a..c06f537 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -227,6 +227,7 @@ struct mtd_info {
 	int (*_block_markbad) (struct mtd_info *mtd, loff_t ofs);
 	int (*_suspend) (struct mtd_info *mtd);
 	void (*_resume) (struct mtd_info *mtd);
+	void (*_reboot) (struct mtd_info *mtd);
 	/*
 	 * If the driver is something smart, like UBI, it may need to maintain
 	 * its own reference counting. The below functions are only for driver.
-- 
2.2.0

