Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaIJIz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:55:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35543 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751105AbaIJIzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:55:54 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <b32955@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] mtd: nand: gpmi: add proper raw access support
Date: Wed, 10 Sep 2014 10:55:39 +0200
Message-Id: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several MTD users (either in user or kernel space) expect a valid raw
access support to NAND chip devices.
This is particularly true for testing tools which are often touching the
data stored in a NAND chip in raw mode to artificially generate errors.

The GPMI drivers do not implemenent raw access functions, and thus rely on
default HW_ECC scheme implementation.
The default implementation consider the data and OOB area as properly
separated in their respective NAND section, which is not true for the GPMI
controller.
In this driver/controller some OOB data are stored at the beginning of the
NAND data area (these data are called metadata in the driver), then ECC
bytes are interleaved with data chunk (which is similar to the
HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
OOB data.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
Hello,

This patch is providing raw access support to the GPMI driver which is
particularly useful to run some tests on the NAND (the one coming in
mind is the mtd_nandbiterrs testsuite).

I know this rework might break several user space tools which are relying
on the default raw access implementation (I already experienced an issue
with the kobs-ng tool provided by freescale), but many other tools will
now work as expected.

Huang, Brian, let me know what you think of this approach ?

Best Regards,

Boris

 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 119 ++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 959cb9b..b26e032 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -831,7 +831,13 @@ static int gpmi_alloc_dma_buffer(struct gpmi_nand_data *this)
 	 * power of two and is much larger than four, which guarantees the
 	 * auxiliary buffer will appear on a 32-bit boundary.
 	 */
-	this->page_buffer_size = geo->payload_size + geo->auxiliary_size;
+	if (geo->payload_size + geo->auxiliary_size >
+	    mtd->writesize + mtd->oobsize)
+		this->page_buffer_size =
+				geo->payload_size + geo->auxiliary_size;
+	else
+		this->page_buffer_size = mtd->writesize + mtd->oobsize;
+
 	this->page_buffer_virt = dma_alloc_coherent(dev, this->page_buffer_size,
 					&this->page_buffer_phys, GFP_DMA);
 	if (!this->page_buffer_virt)
@@ -1347,6 +1353,115 @@ gpmi_ecc_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
 	return status & NAND_STATUS_FAIL ? -EIO : 0;
 }
 
+static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
+				  struct nand_chip *chip, uint8_t *buf,
+				  int oob_required, int page)
+{
+	struct gpmi_nand_data *this = chip->priv;
+	struct bch_geometry *nfc_geo = &this->bch_geometry;
+	int eccsize = nfc_geo->ecc_chunk_size;
+	int eccbytes = DIV_ROUND_UP(nfc_geo->ecc_strength * nfc_geo->gf_len,
+				    8);
+	uint8_t *oob = chip->oob_poi;
+	int step;
+	int column = 0;
+	uint8_t *orig_buf = buf;
+
+	chip->read_buf(mtd, oob, nfc_geo->metadata_size);
+	oob += nfc_geo->metadata_size;
+
+	column += nfc_geo->metadata_size;
+	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
+		chip->read_buf(mtd, buf, eccsize);
+		buf += eccsize;
+		column += eccsize;
+		chip->read_buf(mtd, oob, eccbytes);
+		oob += eccbytes;
+		column += eccbytes;
+	}
+
+	if (column < mtd->writesize + mtd->oobsize)
+		chip->read_buf(mtd, oob,
+			       mtd->writesize + mtd->oobsize - column);
+
+	block_mark_swapping(this, orig_buf, chip->oob_poi);
+
+	return 0;
+}
+
+static int gpmi_ecc_write_page_raw(struct mtd_info *mtd,
+				   struct nand_chip *chip,
+				   const uint8_t *buf,
+				   int oob_required)
+{
+	struct gpmi_nand_data *this = chip->priv;
+	struct bch_geometry *nfc_geo = &this->bch_geometry;
+	int eccsize = nfc_geo->ecc_chunk_size;
+	int eccbytes = DIV_ROUND_UP(nfc_geo->ecc_strength * nfc_geo->gf_len,
+				    8);
+	uint8_t *oob = chip->oob_poi;
+	int step;
+	int column = 0;
+
+	if (this->swap_block_mark) {
+		/*
+		 * If control arrives here, we're doing block mark swapping.
+		 * Since we can't modify the caller's buffers, we must copy them
+		 * into our own.
+		 */
+		memcpy(this->page_buffer_virt, buf, mtd->writesize);
+		if (oob_required)
+			memcpy(this->page_buffer_virt + mtd->writesize,
+			       chip->oob_poi, mtd->oobsize);
+		else
+			memset(this->page_buffer_virt + mtd->writesize,
+			       0xff, mtd->oobsize);
+
+		/* Handle block mark swapping. */
+		block_mark_swapping(this, this->page_buffer_virt,
+				    this->page_buffer_virt + mtd->writesize);
+
+		oob = this->page_buffer_virt + mtd->writesize;
+		buf = this->page_buffer_virt;
+	}
+
+	if (oob_required) {
+		chip->write_buf(mtd, oob, nfc_geo->metadata_size);
+		oob += nfc_geo->metadata_size;
+	} else {
+		/*
+		 * Write the data byte in the OOB area if BB marker swapping
+		 * is requested.
+		 */
+		if (this->swap_block_mark)
+			chip->write_buf(mtd, oob, 1);
+
+		chip->cmdfunc(mtd, NAND_CMD_SEQIN,
+			      column, -1);
+	}
+	column += nfc_geo->metadata_size;
+
+	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
+		chip->write_buf(mtd, buf, eccsize);
+		buf += eccsize;
+		column += eccsize;
+		if (oob_required) {
+			chip->write_buf(mtd, oob, eccbytes);
+			oob += eccbytes;
+		} else {
+			chip->cmdfunc(mtd, NAND_CMD_SEQIN,
+				      column + eccbytes, -1);
+		}
+		column += eccbytes;
+	}
+
+	if (oob_required && column < mtd->writesize + mtd->oobsize)
+		chip->write_buf(mtd, oob,
+				mtd->writesize + mtd->oobsize - column);
+
+	return 0;
+}
+
 static int gpmi_block_markbad(struct mtd_info *mtd, loff_t ofs)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1664,6 +1779,8 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
 	ecc->write_page	= gpmi_ecc_write_page;
 	ecc->read_oob	= gpmi_ecc_read_oob;
 	ecc->write_oob	= gpmi_ecc_write_oob;
+	ecc->read_page_raw = gpmi_ecc_read_page_raw;
+	ecc->write_page_raw = gpmi_ecc_write_page_raw;
 	ecc->mode	= NAND_ECC_HW;
 	ecc->size	= bch_geo->ecc_chunk_size;
 	ecc->strength	= bch_geo->ecc_strength;
-- 
1.9.1

