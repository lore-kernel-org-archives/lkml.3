Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaEAKEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:04:06 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:53263 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbaEAJ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/47] mtd: nand: stm_nand_bch: provide write functionality (BCH)
Date: Thu,  1 May 2014 10:56:33 +0100
Message-Id: <1398938214-17847-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DMA to write a single page of data.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 76 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 72c9734..e875446 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -606,6 +606,81 @@ static int bch_read(struct mtd_info *mtd, struct nand_chip *chip,
 	return ret;
 }
 
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
+	bool bounce = false;
+
+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
+
+	BUG_ON(offs & (page_size - 1));
+
+	if (((unsigned long)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
+	    !virt_addr_valid(buf)) { /* vmalloc'd buffer! */
+		bounce = true;
+	}
+
+	if (bounce) {
+		memcpy(nandi->page_buf, buf, page_size);
+		p = nandi->page_buf;
+		nandi->cached_page = -1;
+	}
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
+static int bch_write(struct mtd_info *mtd, struct nand_chip *chip,
+		     uint32_t offset, int data_len, const uint8_t *buf,
+		     int oob_required, int page, int cached, int raw)
+{
+	struct nandi_controller *nandi = chip->priv;
+	uint32_t page_size = mtd->writesize;
+	loff_t offs = page * page_size;
+	int ret;
+
+	ret = bch_write_page(nandi, offs, buf);
+	if (ret & NAND_STATUS_FAIL)
+		return -EIO;
+
+	return 0;
+}
+
 /*
  * Initialisation
  */
@@ -686,6 +761,7 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	mtd->subpage_sft = 0;
 
 	chip->ecc.read_page = bch_read;
+	chip->write_page = bch_write;
 }
 
 /*
-- 
1.8.3.2

