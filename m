Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaLATMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:12:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54960 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753138AbaLATMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:12:44 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH] mtd: gpmi: properly handle bitflips in erased pages
Date: Mon,  1 Dec 2014 20:12:39 +0100
Message-Id: <1417461159-2972-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware ECC engine embedded in freescale SoCs can fix a few bitflips
in written pages.
In the other hand, erased pages are filled with ones, and, as the ECC
engine does not generate all one ECC bits for this pattern, it considers
an empty page as uncorrectable (too many bitflips to be  corrected).

To address this, the NAND controller test for empty page pattern (page
filled with 0xff) before enabling the ECC engine.
While this work in most cases, it fails when at least one bit flip occurred
in an erased page (because the controller consider it as not empty/erased).

This patch read the NAND page in raw mode if the controller has returned
an UNCORRECTABLE status, and, if the page looks like an empty page with a
few bitflips (less than the ECC strength), fixes those bitflips instead of
returning an error.

Reported-by: Elie De Brauwer <eliedebrauwer@gmail.com>
Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
Hi Brian, Huang,

I'm reviving the 'fix bitflips in erased pages' patch (I've experienced such
bitflips on an SLC NAND).

I've mixed both of your implementations to make this patch, hence the SoB tags
(maybe I should even keep one of you in author...).

Brian, I really like the idea of having a generic implementation for this
feature (using read_page_raw) as you suggested here [1], but this implies
having a temporary buffer to store the page read in raw mode and keep the page
read in normal (HW ECC engine eanbled) mode, and I'm not sure we want to
allocate more buffers than we already have.

Huang, I remember you wanted to limit the bitflips strength on erased pages
compared to the normal ECC strength.
This version just consider it can fix up to ECC strength bits, but I can change
that to something else (ecc_strength / 2 ?).

Feel free to suggest any alternative, to this implementation.

Best Regards,

Boris

[1]http://article.gmane.org/gmane.linux.drivers.mtd/52183/raw

 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 108 ++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 4f3851a..647b28b 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -991,6 +991,69 @@ static void block_mark_swapping(struct gpmi_nand_data *this,
 	p[1] = (p[1] & mask) | (from_oob >> (8 - bit));
 }
 
+/*
+ * Check a page to see if it is erased (w/ bitflips) after an uncorrectable ECC
+ * error
+ *
+ * On a real error, return a negative error code (-EBADMSG for ECC error).
+ * Otherwise, fill chunk with 0xff and return the number of corrected
+ * bitflips.
+ *
+ */
+static int gpmi_verify_erased_page(struct gpmi_nand_data *this,
+				   unsigned int chunk)
+{
+	struct bch_geometry *nfc_geo = &this->bch_geometry;
+	int eccsize = nfc_geo->ecc_chunk_size;
+	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
+	unsigned int bitflips = 0;
+	unsigned char *data = this->raw_buffer;
+	unsigned int threshold = nfc_geo->ecc_strength;
+	int data_nbits, bit_off;
+	int i;
+
+	data_nbits = (eccsize * 8) + eccbits;
+	bit_off = chunk * data_nbits;
+
+	/* First chunk also embeds metadata */
+	if (!chunk)
+		data_nbits += (nfc_geo->metadata_size * 8);
+	else
+		bit_off += (nfc_geo->metadata_size * 8);
+
+	data = this->raw_buffer + (bit_off % 8);
+	if (bit_off % 8) {
+		bitflips += hweight8(~(*data | GENMASK(bit_off - 1, 0)));
+		if (bitflips > threshold)
+			return -EBADMSG;
+
+		data_nbits -= bit_off;
+	}
+
+	for (i = 0; i < data_nbits / 8; i++) {
+		bitflips += hweight8(~data[i]);
+		if (bitflips > threshold)
+			return -EBADMSG;
+	}
+
+	data_nbits %= 8;
+	data += data_nbits / 8;
+	if (data_nbits) {
+		bitflips += hweight8(~(*data | GENMASK(7, data_nbits)));
+		if (bitflips > threshold)
+			return -EBADMSG;
+	}
+
+	memset(this->payload_virt + (chunk * eccsize), 0xff, eccsize);
+
+	if (!chunk)
+		memset(this->auxiliary_virt, 0xff, nfc_geo->metadata_size);
+
+	pr_debug("correcting %u bitflips in erased page\n", bitflips);
+
+	return bitflips;
+}
+
 static int gpmi_ecc_read_page(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int oob_required, int page)
 {
@@ -1036,13 +1099,54 @@ static int gpmi_ecc_read_page(struct mtd_info *mtd, struct nand_chip *chip,
 	status = auxiliary_virt + nfc_geo->auxiliary_status_offset;
 
 	for (i = 0; i < nfc_geo->ecc_chunk_count; i++, status++) {
+		bool raw_read_done = false;
+
 		if ((*status == STATUS_GOOD) || (*status == STATUS_ERASED))
 			continue;
 
 		if (*status == STATUS_UNCORRECTABLE) {
-			mtd->ecc_stats.failed++;
-			continue;
+			if (!raw_read_done) {
+				bool direct_dma_map_ok;
+
+				/*
+				 * Reading a page will override the current
+				 * direct_dma_map_ok field.
+				 * Save direct_dma_map_ok and restore it after
+				 * raw page read has completed.
+				 */
+				direct_dma_map_ok = this->direct_dma_map_ok;
+				chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
+				chip->read_buf(mtd, this->raw_buffer,
+					       mtd->writesize + mtd->oobsize);
+				this->direct_dma_map_ok = direct_dma_map_ok;
+
+				/*
+				 * Swap bad block marker if needed.
+				 */
+				if (this->swap_block_mark) {
+					u8 *raw_buf = this->raw_buffer;
+					u8 swap = raw_buf[0];
+
+					raw_buf[0] = raw_buf[mtd->writesize];
+					raw_buf[mtd->writesize] = swap;
+				}
+
+				raw_read_done = true;
+			}
+
+			/*
+			 * Analyse the current chunk to handle the "bitflips in
+			 * erased page" case.
+			 */
+			ret = gpmi_verify_erased_page(this, i);
+			if (ret < 0) {
+				mtd->ecc_stats.failed++;
+				continue;
+			}
+
+			*status = ret;
 		}
+
 		mtd->ecc_stats.corrected += *status;
 		max_bitflips = max_t(unsigned int, max_bitflips, *status);
 	}
-- 
1.9.1

