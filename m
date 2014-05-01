Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaEAJ6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:58:42 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51342 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaEAJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 45/47] mtd: nand: stm_nand_bch: catch unhandled calls to read and write to the OOB
Date: Thu,  1 May 2014 10:56:52 +0100
Message-Id: <1398938214-17847-46-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OOB is filled with ECC data which is handled by the hardware
controller. It's a mistake for the framework to attempt to read or
write to the OOB area. If that happens, we'll BUG() out.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 89f1263..bec7e23 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1441,6 +1441,20 @@ static int bch_scan_bbt(struct mtd_info *mtd)
 	return 0;
 }
 
+static int bch_mtd_read_oob(struct mtd_info *mtd,
+			    struct nand_chip *chip, int page)
+{
+	BUG();
+	return 0;
+}
+
+static int bch_mtd_write_oob(struct mtd_info *mtd,
+			     struct nand_chip *chip, int page)
+{
+	BUG();
+	return 0;
+}
+
 static int bch_block_isbad(struct mtd_info *mtd, loff_t offs, int getchip)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1598,6 +1612,9 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	mtd->ecclayout = &info->ecclayout;
 	mtd->subpage_sft = 0;
 
+	chip->ecc.read_oob = bch_mtd_read_oob;
+	chip->ecc.write_oob = bch_mtd_write_oob;
+
 	chip->ecc.read_page = bch_read;
 	chip->write_page = bch_write;
 	chip->erase = bch_erase;
-- 
1.8.3.2

