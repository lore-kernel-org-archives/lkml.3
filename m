Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaCYI5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:57:24 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:64037 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCYIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 01/47] mtd: nand: export useful functions from core driver
Date: Tue, 25 Mar 2014 08:19:18 +0000
Message-Id: <1395735604-26706-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are utilised by the STM BCH NAND Controller driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/nand_base.c | 18 +++++++++++-------
 include/linux/mtd/nand.h     |  6 ++++++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index bd39f7b..070505d 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -90,7 +90,7 @@ static struct nand_ecclayout nand_oob_128 = {
 		 .length = 78} }
 };
 
-static int nand_get_device(struct mtd_info *mtd, int new_state);
+int nand_get_device(struct mtd_info *mtd, int new_state);
 
 static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 			     struct mtd_oob_ops *ops);
@@ -128,7 +128,7 @@ static int check_offs_len(struct mtd_info *mtd,
  *
  * Release chip lock and wake up anyone waiting on the device.
  */
-static void nand_release_device(struct mtd_info *mtd)
+void nand_release_device(struct mtd_info *mtd)
 {
 	struct nand_chip *chip = mtd->priv;
 
@@ -139,6 +139,7 @@ static void nand_release_device(struct mtd_info *mtd)
 	wake_up(&chip->controller->wq);
 	spin_unlock(&chip->controller->lock);
 }
+EXPORT_SYMBOL_GPL(nand_release_device);
 
 /**
  * nand_read_byte - [DEFAULT] read one byte from the chip
@@ -736,8 +737,7 @@ static void panic_nand_get_device(struct nand_chip *chip,
  *
  * Get the device and lock it for exclusive access
  */
-static int
-nand_get_device(struct mtd_info *mtd, int new_state)
+int nand_get_device(struct mtd_info *mtd, int new_state)
 {
 	struct nand_chip *chip = mtd->priv;
 	spinlock_t *lock = &chip->controller->lock;
@@ -769,6 +769,7 @@ retry:
 	remove_wait_queue(wq, &wait);
 	goto retry;
 }
+EXPORT_SYMBOL_GPL(nand_get_device);
 
 /**
  * panic_nand_wait - [GENERIC] wait until the command is done
@@ -2665,7 +2666,7 @@ erase_exit:
  *
  * Sync is actually a wait for chip ready function.
  */
-static void nand_sync(struct mtd_info *mtd)
+void nand_sync(struct mtd_info *mtd)
 {
 	pr_debug("%s: called\n", __func__);
 
@@ -2674,6 +2675,7 @@ static void nand_sync(struct mtd_info *mtd)
 	/* Release it and go back */
 	nand_release_device(mtd);
 }
+EXPORT_SYMBOL_GPL(nand_sync);
 
 /**
  * nand_block_isbad - [MTD Interface] Check if block at offset is bad
@@ -2757,16 +2759,17 @@ static int nand_onfi_get_features(struct mtd_info *mtd, struct nand_chip *chip,
  * nand_suspend - [MTD Interface] Suspend the NAND flash
  * @mtd: MTD device structure
  */
-static int nand_suspend(struct mtd_info *mtd)
+int nand_suspend(struct mtd_info *mtd)
 {
 	return nand_get_device(mtd, FL_PM_SUSPENDED);
 }
+EXPORT_SYMBOL(nand_suspend);
 
 /**
  * nand_resume - [MTD Interface] Resume the NAND flash
  * @mtd: MTD device structure
  */
-static void nand_resume(struct mtd_info *mtd)
+void nand_resume(struct mtd_info *mtd)
 {
 	struct nand_chip *chip = mtd->priv;
 
@@ -2776,6 +2779,7 @@ static void nand_resume(struct mtd_info *mtd)
 		pr_err("%s called for a chip which is not in suspended state\n",
 			__func__);
 }
+EXPORT_SYMBOL(nand_resume);
 
 /* Set default functions */
 static void nand_set_defaults(struct nand_chip *chip, int busw)
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 9e6c8f9..f7b6a53 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -698,6 +698,12 @@ extern int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
 			   int allowbbt);
 extern int nand_do_read(struct mtd_info *mtd, loff_t from, size_t len,
 			size_t *retlen, uint8_t *buf);
+extern void nand_sync(struct mtd_info *mtd);
+extern int nand_suspend(struct mtd_info *mtd);
+extern void nand_resume(struct mtd_info *mtd);
+
+extern int nand_get_device(struct mtd_info *mtd, int new_state);
+extern void nand_release_device(struct mtd_info *mtd);
 
 /**
  * struct platform_nand_chip - chip level device structure
-- 
1.8.3.2

