Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbaKTTSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:18:14 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:65088 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaKTTSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:18:12 -0500
X-IronPort-AV: E=Sophos;i="5.07,425,1413270000"; 
   d="scan'208";a="51255234"
From: Scott Branden <sbranden@broadcom.com>
To: Scott Branden <sbranden@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: Ray Jui <rjui@broadcom.com>, Corneliu Doban <cdoban@broadcom.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd: nand: added nand_shutdown
Date: Thu, 20 Nov 2014 11:18:05 -0800
Message-ID: <1416511085-3930-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nand_shutdown to wait for current nand operations to finish and prevent
further operations by changing the nand flash state to FL_SHUTDOWN.

This is addressing a problem observed during reboot tests using UBIFS
root file system: NAND erase operations that are in progress during
system reboot/shutdown are causing partial erased blocks. Although UBI should
be able to detect and recover from this error, this change will avoid
the creation of partial erased blocks on reboot in the middle of a NAND erase
operation.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mtd/nand/nand_base.c | 11 +++++++++++
 include/linux/mtd/nand.h     |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 5b5c627..100a967 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -4236,6 +4236,17 @@ void nand_release(struct mtd_info *mtd)
 }
 EXPORT_SYMBOL_GPL(nand_release);
 
+/**
+ * nand_shutdown - [NAND Interface] finish the current nand operation and
+ *                 prevent further operations
+ * @mtd: MTD device structure
+ */
+int nand_shutdown(struct mtd_info *mtd)
+{
+	return nand_get_device(mtd, FL_SHUTDOWN);
+}
+EXPORT_SYMBOL_GPL(nand_shutdown);
+
 static int __init nand_base_init(void)
 {
 	led_trigger_register_simple("nand-disk", &nand_led_trigger);
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index e4d451e..80e4367 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -48,6 +48,13 @@ extern int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
 /* unlocks specified locked blocks */
 extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
 
+/*
+ * Internal helper for board drivers which need to make sure that the current
+ * nand operation is finished and further operations are prevented before
+ * rebooting the system.
+ */
+extern int nand_shutdown(struct mtd_info *mtd);
+
 /* The maximum number of NAND chips in an array */
 #define NAND_MAX_CHIPS		8
 
-- 
2.1.3

