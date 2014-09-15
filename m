Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaIOUYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:24:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41269 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755106AbaIOUYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:24:10 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 2/2] mtd: nand: gpmi: add proper raw access support
Date: Mon, 15 Sep 2014 22:24:03 +0200
Message-Id: <1410812643-14041-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410812643-14041-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1410812643-14041-1-git-send-email-boris.brezillon@free-electrons.com>
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
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 118 ++++++++++++++++++++++++++++++++-
 1 file changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 959cb9b..4945273 100644
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
@@ -1347,6 +1353,114 @@ gpmi_ecc_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
 	return status & NAND_STATUS_FAIL ? -EIO : 0;
 }
 
+static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
+				  struct nand_chip *chip, uint8_t *buf,
+				  int oob_required, int page)
+{
+	struct gpmi_nand_data *this = chip->priv;
+	struct bch_geometry *nfc_geo = &this->bch_geometry;
+	int eccsize = nfc_geo->ecc_chunk_size;
+	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
+	u8 *tmp_buf = this->page_buffer_virt;
+	size_t src_bit_off;
+	size_t oob_bit_off;
+	size_t oob_byte_off;
+	uint8_t *oob = chip->oob_poi;
+	int step;
+
+	chip->read_buf(mtd, tmp_buf,
+		       mtd->writesize + mtd->oobsize);
+
+	if (this->swap_block_mark) {
+		u8 swap = tmp_buf[0];
+
+		tmp_buf[0] = tmp_buf[mtd->writesize];
+		tmp_buf[mtd->writesize] = swap;
+	}
+
+	memcpy(oob, tmp_buf, nfc_geo->metadata_size);
+	oob_bit_off = nfc_geo->metadata_size * 8;
+	src_bit_off = oob_bit_off;
+
+	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
+		gpmi_move_bits(buf, step * eccsize * 8,
+			       tmp_buf, src_bit_off,
+			       eccsize * 8);
+		src_bit_off += eccsize * 8;
+		gpmi_move_bits(oob, oob_bit_off,
+			       tmp_buf, src_bit_off,
+			       eccbits);
+		src_bit_off += eccbits;
+		oob_bit_off += eccbits;
+	}
+
+	if (oob_bit_off % 8)
+		oob[oob_bit_off / 8] &= GENMASK(oob_bit_off - 1, 0);
+
+	oob_byte_off = DIV_ROUND_UP(oob_bit_off, 8);
+
+	if (oob_byte_off  < mtd->oobsize)
+		memcpy(oob + oob_byte_off,
+		       tmp_buf + mtd->writesize + oob_byte_off,
+		       mtd->oobsize - oob_byte_off);
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
+	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
+	u8 *tmp_buf = this->page_buffer_virt;
+	uint8_t *oob = chip->oob_poi;
+	size_t dst_bit_off;
+	size_t oob_bit_off;
+	size_t oob_byte_off;
+	int step;
+
+	memcpy(tmp_buf, oob, nfc_geo->metadata_size);
+	oob_bit_off = nfc_geo->metadata_size * 8;
+	dst_bit_off = oob_bit_off;
+
+	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
+		gpmi_move_bits(tmp_buf, dst_bit_off,
+			       buf, step * eccsize * 8, eccsize * 8);
+		dst_bit_off += eccsize * 8;
+
+		/* Pad last ECC block to align following data on a byte */
+		if (step == nfc_geo->ecc_chunk_count - 1 &&
+		    (oob_bit_off + eccbits) % 8)
+			eccbits += 8 - ((oob_bit_off + eccbits) % 8);
+
+		gpmi_move_bits(tmp_buf, dst_bit_off,
+			       oob, oob_bit_off, eccbits);
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
@@ -1664,6 +1778,8 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
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

