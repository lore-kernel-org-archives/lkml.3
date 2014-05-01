Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaEAJ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:59 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52747 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaEAJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/47] mtd: nand: stm_nand_bch: initialise working buffers
Date: Thu,  1 May 2014 10:56:28 +0100
Message-Id: <1398938214-17847-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialise working buffers, accomodating DMA alignment constraints.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 45 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index cf57b90..5be7889 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -31,6 +31,9 @@
 
 /* NANDi BCH Controller properties */
 #define NANDI_BCH_SECTOR_SIZE			1024
+#define NANDI_BCH_DMA_ALIGNMENT			64
+#define NANDI_BCH_MAX_BUF_LIST			8
+#define NANDI_BCH_BUF_LIST_SIZE			(4 * NANDI_BCH_MAX_BUF_LIST)
 
 /* BCH ECC sizes */
 static int bch_ecc_sizes[] = {
@@ -920,6 +923,44 @@ static void nandi_init_controller(struct nandi_controller *nandi,
 	nandi_init_hamming(nandi, emi_bank);
 }
 
+/* Initialise working buffers, accomodating DMA alignment constraints */
+static int nandi_init_working_buffers(struct nandi_controller *nandi,
+				      struct nandi_bbt_info *bbt_info,
+				      struct mtd_info *mtd)
+{
+	uint32_t bbt_buf_size;
+	uint32_t buf_size;
+
+	/*	- Page and OOB */
+	buf_size = mtd->writesize + mtd->oobsize + NANDI_BCH_DMA_ALIGNMENT;
+
+	/*	- BBT data (page-size aligned) */
+	bbt_info->bbt_size = nandi->blocks_per_device >> 2; /* 2 bits/block */
+	bbt_buf_size = ALIGN(bbt_info->bbt_size, mtd->writesize);
+	buf_size += bbt_buf_size + NANDI_BCH_DMA_ALIGNMENT;
+
+	/*	- BCH BUF list */
+	buf_size += NANDI_BCH_BUF_LIST_SIZE + NANDI_BCH_DMA_ALIGNMENT;
+
+	/* Allocate bufffer */
+	nandi->buf = devm_kzalloc(nandi->dev, buf_size, GFP_KERNEL);
+	if (!nandi->buf) {
+		dev_err(nandi->dev, "failed to allocate working buffers\n");
+		return -ENOMEM;
+	}
+
+	/* Set/Align buffer pointers */
+	nandi->page_buf = PTR_ALIGN(nandi->buf, NANDI_BCH_DMA_ALIGNMENT);
+	nandi->oob_buf  = nandi->page_buf + mtd->writesize;
+	bbt_info->bbt   = PTR_ALIGN(nandi->oob_buf + mtd->oobsize,
+				    NANDI_BCH_DMA_ALIGNMENT);
+	nandi->buf_list = (uint32_t *)PTR_ALIGN(bbt_info->bbt + bbt_buf_size,
+						NANDI_BCH_DMA_ALIGNMENT);
+	nandi->cached_page = -1;
+
+	return 0;
+}
+
 static int remap_named_resource(struct platform_device *pdev,
 				char *name,
 				void __iomem **io_ptr)
@@ -1140,6 +1181,10 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	/* Tune BCH programs according to device found and ECC mode */
 	bch_configure_progs(nandi);
 
+	err = nandi_init_working_buffers(nandi, bbt_info, mtd);
+	if (err)
+		return err;
+
 	return 0;
 }
 
-- 
1.8.3.2

