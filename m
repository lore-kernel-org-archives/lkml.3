Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaK3SLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 13:11:18 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47375 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490AbaK3SKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:10:45 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 2/3] mtd: nand: gpmi: add proper raw access support
Date: Sun, 30 Nov 2014 19:10:29 +0100
Message-Id: <1417371030-24015-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
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

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Tested-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 183 +++++++++++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   2 +
 2 files changed, 185 insertions(+)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 959cb9b..987de1e 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -791,6 +791,7 @@ static void gpmi_free_dma_buffer(struct gpmi_nand_data *this)
 					this->page_buffer_phys);
 	kfree(this->cmd_buffer);
 	kfree(this->data_buffer_dma);
+	kfree(this->raw_buffer);
 
 	this->cmd_buffer	= NULL;
 	this->data_buffer_dma	= NULL;
@@ -837,6 +838,9 @@ static int gpmi_alloc_dma_buffer(struct gpmi_nand_data *this)
 	if (!this->page_buffer_virt)
 		goto error_alloc;
 
+	this->raw_buffer = kzalloc(mtd->writesize + mtd->oobsize, GFP_KERNEL);
+	if (!this->raw_buffer)
+		goto error_alloc;
 
 	/* Slice up the page buffer. */
 	this->payload_virt = this->page_buffer_virt;
@@ -1347,6 +1351,183 @@ gpmi_ecc_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
 	return status & NAND_STATUS_FAIL ? -EIO : 0;
 }
 
+/*
+ * This function reads a NAND page without involving the ECC engine (no HW
+ * ECC correction).
+ * The tricky part in the GPMI/BCH controller is that it stores ECC bits
+ * inline (interleaved with payload DATA), and do not align data chunk on
+ * byte boundaries.
+ * We thus need to take care moving the payload data and ECC bits stored in the
+ * page into the provided buffers, which is why we're using gpmi_copy_bits.
+ *
+ * See set_geometry_by_ecc_info inline comments to have a full description
+ * of the layout used by the GPMI controller.
+ */
+static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
+				  struct nand_chip *chip, uint8_t *buf,
+				  int oob_required, int page)
+{
+	struct gpmi_nand_data *this = chip->priv;
+	struct bch_geometry *nfc_geo = &this->bch_geometry;
+	int eccsize = nfc_geo->ecc_chunk_size;
+	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
+	u8 *tmp_buf = this->raw_buffer;
+	size_t src_bit_off;
+	size_t oob_bit_off;
+	size_t oob_byte_off;
+	uint8_t *oob = chip->oob_poi;
+	int step;
+
+	chip->read_buf(mtd, tmp_buf,
+		       mtd->writesize + mtd->oobsize);
+
+	/*
+	 * If required, swap the bad block marker and the data stored in the
+	 * metadata section, so that we don't wrongly consider a block as bad.
+	 *
+	 * See the layout description for a detailed explanation on why this
+	 * is needed.
+	 */
+	if (this->swap_block_mark) {
+		u8 swap = tmp_buf[0];
+
+		tmp_buf[0] = tmp_buf[mtd->writesize];
+		tmp_buf[mtd->writesize] = swap;
+	}
+
+	/*
+	 * Copy the metadata section into the oob buffer (this section is
+	 * guaranteed to be aligned on a byte boundary).
+	 */
+	if (oob_required)
+		memcpy(oob, tmp_buf, nfc_geo->metadata_size);
+
+	oob_bit_off = nfc_geo->metadata_size * 8;
+	src_bit_off = oob_bit_off;
+
+	/* Extract interleaved payload data and ECC bits */
+	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
+		if (buf)
+			gpmi_copy_bits(buf, step * eccsize * 8,
+				       tmp_buf, src_bit_off,
+				       eccsize * 8);
+		src_bit_off += eccsize * 8;
+
+		/* Align last ECC block to align a byte boundary */
+		if (step == nfc_geo->ecc_chunk_count - 1 &&
+		    (oob_bit_off + eccbits) % 8)
+			eccbits += 8 - ((oob_bit_off + eccbits) % 8);
+
+		if (oob_required)
+			gpmi_copy_bits(oob, oob_bit_off,
+				       tmp_buf, src_bit_off,
+				       eccbits);
+
+		src_bit_off += eccbits;
+		oob_bit_off += eccbits;
+	}
+
+	if (oob_required) {
+		oob_byte_off = oob_bit_off / 8;
+
+		if (oob_byte_off < mtd->oobsize)
+			memcpy(oob + oob_byte_off,
+			       tmp_buf + mtd->writesize + oob_byte_off,
+			       mtd->oobsize - oob_byte_off);
+	}
+
+	return 0;
+}
+
+/*
+ * This function writes a NAND page without involving the ECC engine (no HW
+ * ECC generation).
+ * The tricky part in the GPMI/BCH controller is that it stores ECC bits
+ * inline (interleaved with payload DATA), and do not align data chunk on
+ * byte boundaries.
+ * We thus need to take care moving the OOB area at the right place in the
+ * final page, which is why we're using gpmi_copy_bits.
+ *
+ * See set_geometry_by_ecc_info inline comments to have a full description
+ * of the layout used by the GPMI controller.
+ */
+static int gpmi_ecc_write_page_raw(struct mtd_info *mtd,
+				   struct nand_chip *chip,
+				   const uint8_t *buf,
+				   int oob_required)
+{
+	struct gpmi_nand_data *this = chip->priv;
+	struct bch_geometry *nfc_geo = &this->bch_geometry;
+	int eccsize = nfc_geo->ecc_chunk_size;
+	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
+	u8 *tmp_buf = this->raw_buffer;
+	uint8_t *oob = chip->oob_poi;
+	size_t dst_bit_off;
+	size_t oob_bit_off;
+	size_t oob_byte_off;
+	int step;
+
+	/*
+	 * Initialize all bits to 1 in case we don't have a buffer for the
+	 * payload or oob data in order to leave unspecified bits of data
+	 * to their initial state.
+	 */
+	if (!buf || !oob_required)
+		memset(tmp_buf, 0xff, mtd->writesize + mtd->oobsize);
+
+	/*
+	 * First copy the metadata section (stored in oob buffer) at the
+	 * beginning of the page, as imposed by the GPMI layout.
+	 */
+	memcpy(tmp_buf, oob, nfc_geo->metadata_size);
+	oob_bit_off = nfc_geo->metadata_size * 8;
+	dst_bit_off = oob_bit_off;
+
+	/* Interleave payload data and ECC bits */
+	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
+		if (buf)
+			gpmi_copy_bits(tmp_buf, dst_bit_off,
+				       buf, step * eccsize * 8, eccsize * 8);
+		dst_bit_off += eccsize * 8;
+
+		/* Align last ECC block to align a byte boundary */
+		if (step == nfc_geo->ecc_chunk_count - 1 &&
+		    (oob_bit_off + eccbits) % 8)
+			eccbits += 8 - ((oob_bit_off + eccbits) % 8);
+
+		if (oob_required)
+			gpmi_copy_bits(tmp_buf, dst_bit_off,
+				       oob, oob_bit_off, eccbits);
+
+		dst_bit_off += eccbits;
+		oob_bit_off += eccbits;
+	}
+
+	oob_byte_off = oob_bit_off / 8;
+
+	if (oob_required && oob_byte_off < mtd->oobsize)
+		memcpy(tmp_buf + mtd->writesize + oob_byte_off,
+		       oob + oob_byte_off, mtd->oobsize - oob_byte_off);
+
+	/*
+	 * If required, swap the bad block marker and the first byte of the
+	 * metadata section, so that we don't modify the bad block marker.
+	 *
+	 * See the layout description for a detailed explanation on why this
+	 * is needed.
+	 */
+	if (this->swap_block_mark) {
+		u8 swap = tmp_buf[0];
+
+		tmp_buf[0] = tmp_buf[mtd->writesize];
+		tmp_buf[mtd->writesize] = swap;
+	}
+
+	chip->write_buf(mtd, tmp_buf, mtd->writesize + mtd->oobsize);
+
+	return 0;
+}
+
 static int gpmi_block_markbad(struct mtd_info *mtd, loff_t ofs)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1664,6 +1845,8 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
 	ecc->write_page	= gpmi_ecc_write_page;
 	ecc->read_oob	= gpmi_ecc_read_oob;
 	ecc->write_oob	= gpmi_ecc_write_oob;
+	ecc->read_page_raw = gpmi_ecc_read_page_raw;
+	ecc->write_page_raw = gpmi_ecc_write_page_raw;
 	ecc->mode	= NAND_ECC_HW;
 	ecc->size	= bch_geo->ecc_chunk_size;
 	ecc->strength	= bch_geo->ecc_strength;
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
index 20da1f1..544062f 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
@@ -189,6 +189,8 @@ struct gpmi_nand_data {
 	void			*auxiliary_virt;
 	dma_addr_t		auxiliary_phys;
 
+	void			*raw_buffer;
+
 	/* DMA channels */
 #define DMA_CHANS		8
 	struct dma_chan		*dma_chans[DMA_CHANS];
-- 
1.9.1

