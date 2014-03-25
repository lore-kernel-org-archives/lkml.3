Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaCYIVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:08 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:56943 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaCYIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 20/47] mtd: nand: stm_nand_bch: initialise working buffers
Date: Tue, 25 Mar 2014 08:19:37 +0000
Message-Id: <1395735604-26706-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialise working buffers, accomodating DMA alignment constraints.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 45 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 351f5e2..fafde22 100644
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
@@ -762,6 +765,44 @@ static void nandi_init_controller(struct nandi_controller *nandi,
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
@@ -990,6 +1031,10 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
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

