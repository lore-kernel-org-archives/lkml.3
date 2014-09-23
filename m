Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaIWOHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:07:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58042 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756033AbaIWOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:07:44 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 3/3] mtd: nand: gpmi: add raw oob access functions
Date: Tue, 23 Sep 2014 16:07:36 +0200
Message-Id: <1411481256-29141-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement raw OOB access functions to retrieve OOB bytes when accessing the
NAND in raw mode.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 7921ba7..850356a 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1471,6 +1471,22 @@ static int gpmi_ecc_write_page_raw(struct mtd_info *mtd,
 	return 0;
 }
 
+static int gpmi_ecc_read_oob_raw(struct mtd_info *mtd, struct nand_chip *chip,
+				 int page)
+{
+	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
+
+	return gpmi_ecc_read_page_raw(mtd, chip, NULL, 1, page);
+}
+
+static int gpmi_ecc_write_oob_raw(struct mtd_info *mtd, struct nand_chip *chip,
+				 int page)
+{
+	chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0, page);
+
+	return gpmi_ecc_write_page_raw(mtd, chip, NULL, 1);
+}
+
 static int gpmi_block_markbad(struct mtd_info *mtd, loff_t ofs)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1790,6 +1806,8 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
 	ecc->write_oob	= gpmi_ecc_write_oob;
 	ecc->read_page_raw = gpmi_ecc_read_page_raw;
 	ecc->write_page_raw = gpmi_ecc_write_page_raw;
+	ecc->read_oob_raw = gpmi_ecc_read_oob_raw;
+	ecc->write_oob_raw = gpmi_ecc_write_oob_raw;
 	ecc->mode	= NAND_ECC_HW;
 	ecc->size	= bch_geo->ecc_chunk_size;
 	ecc->strength	= bch_geo->ecc_strength;
-- 
1.9.1

