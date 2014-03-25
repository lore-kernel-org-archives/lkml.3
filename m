Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaCYIrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:47:49 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50686 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaCYIVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 23/47] mtd: nand: stm_nand_bch: read and write page (BCH)
Date: Tue, 25 Mar 2014 08:19:40 +0000
Message-Id: <1395735604-26706-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DMA to read and/or write a single page of data.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 119 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 7874d85..6323590 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/stm_nand.h>
@@ -345,6 +346,124 @@ static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
 	return zeros;
 }
 
+/* Returns the number of ECC errors, or '-1' for uncorrectable error */
+static int bch_read_page(struct nandi_controller *nandi,
+			 loff_t offs,
+			 uint8_t *buf)
+{
+	struct bch_prog *prog = &bch_prog_read_page;
+	uint32_t page_size = nandi->info.mtd.writesize;
+	unsigned long list_phys;
+	unsigned long buf_phys;
+	uint32_t ecc_err;
+	int ret = 0;
+
+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
+
+	BUG_ON((unsigned long)buf & (NANDI_BCH_DMA_ALIGNMENT - 1));
+	BUG_ON(offs & (NANDI_BCH_DMA_ALIGNMENT - 1));
+
+	emiss_nandi_select(STM_NANDI_BCH);
+
+	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+	reinit_completion(&nandi->seq_completed);
+
+	/* Reset ECC stats */
+	writel(CFG_RESET_ECC_ALL | CFG_ENABLE_AFM,
+	       nandi->base + NANDBCH_CONTROLLER_CFG);
+	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
+
+	prog->addr = (uint32_t)((offs >> (nandi->page_shift - 8)) & 0xffffff00);
+
+	buf_phys = dma_map_single(NULL, buf, page_size, DMA_FROM_DEVICE);
+
+	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
+	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
+
+	list_phys = dma_map_single(NULL, nandi->buf_list,
+				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);
+
+	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
+
+	bch_load_prog_cpu(nandi, prog);
+
+	bch_wait_seq(nandi);
+
+	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+
+	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
+			 DMA_TO_DEVICE);
+	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
+
+	/* Use the maximum per-sector ECC count! */
+	ecc_err = readl(nandi->base + NANDBCH_ECC_SCORE_REG_A) & 0xff;
+	if (ecc_err == 0xff) {
+		/*
+		 * Downgrade uncorrectable ECC error for an erased page,
+		 * tolerating 'sectors_per_page' bits at zero.
+		 */
+		ret = check_erased_page(buf, page_size,
+					nandi->sectors_per_page);
+		if (ret >= 0)
+			dev_dbg(nandi->dev,
+				"%s: erased page detected: \n"
+				"  downgrading uncorrectable ECC error.\n",
+				__func__);
+	} else {
+		ret = (int)ecc_err;
+	}
+
+	return ret;
+}
+
+/* Returns the status of the NAND device following the write operation */
+static uint8_t bch_write_page(struct nandi_controller *nandi,
+			      loff_t offs, const uint8_t *buf)
+{
+	struct bch_prog *prog = &bch_prog_write_page;
+	uint32_t page_size = nandi->info.mtd.writesize;
+	uint8_t *p = (uint8_t *)buf;
+	unsigned long list_phys;
+	unsigned long buf_phys;
+	uint8_t status;
+
+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
+
+	BUG_ON((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1));
+	BUG_ON(offs & (page_size - 1));
+
+	emiss_nandi_select(STM_NANDI_BCH);
+
+	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+	reinit_completion(&nandi->seq_completed);
+
+	prog->addr = (uint32_t)((offs >> (nandi->page_shift - 8)) & 0xffffff00);
+
+	buf_phys = dma_map_single(NULL, p, page_size, DMA_TO_DEVICE);
+	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
+	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
+
+	list_phys = dma_map_single(NULL, nandi->buf_list,
+				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);
+
+	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
+
+	bch_load_prog_cpu(nandi, prog);
+
+	bch_wait_seq(nandi);
+
+	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+
+	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
+			 DMA_TO_DEVICE);
+	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
+
+	status = (uint8_t)(readl(nandi->base +
+				 NANDBCH_CHECK_STATUS_REG_A) & 0xff);
+
+	return status;
+}
+
 /*
  * Initialisation
  */
-- 
1.8.3.2

