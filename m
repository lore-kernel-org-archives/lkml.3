Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab3EOJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:09:57 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:44961
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602Ab3EOJJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:09:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v5 11/11] mtd: gpmi: set the BCH's geometry with the ecc info
Date: Wed, 15 May 2013 16:54:02 +0800
Message-ID: <1368608042-9558-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368607232-2210-1-git-send-email-b32955@freescale.com>
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the nand chip provides us the ECC info, we can use it firstly.
The set_geometry_by_ecc_info() will use the ECC info, and
calculate the parameters we need.

Rename the old code to lagacy_set_geometry() which will takes effect
when there is no ECC info from the nand chip or we fails in the ECC info case.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |  128 +++++++++++++++++++++++++++++++-
 1 files changed, 127 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 25ecfa1..53180da 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -112,7 +112,128 @@ static inline bool gpmi_check_ecc(struct gpmi_nand_data *this)
 	return true;
 }
 
-int common_nfc_set_geometry(struct gpmi_nand_data *this)
+/*
+ * If we can get the ECC information from the nand chip, we do not
+ * need to calculate them ourselves.
+ *
+ * We may have available oob space in this case.
+ */
+static bool set_geometry_by_ecc_info(struct gpmi_nand_data *this)
+{
+	struct bch_geometry *geo = &this->bch_geometry;
+	struct mtd_info *mtd = &this->mtd;
+	struct nand_chip *chip = mtd->priv;
+	struct nand_oobfree *of = gpmi_hw_ecclayout.oobfree;
+	unsigned int block_mark_bit_offset;
+
+	if (!(chip->ecc_strength > 0 && chip->ecc_step > 0))
+		return false;
+
+	switch (chip->ecc_step) {
+	case SZ_512:
+		geo->gf_len = 13;
+		break;
+	case SZ_1K:
+		geo->gf_len = 14;
+		break;
+	default:
+		dev_err(this->dev,
+			"unsupported nand chip. ecc bits : %d, ecc size : %d\n",
+			chip->ecc_strength, chip->ecc_step);
+		return false;
+	}
+	geo->ecc_chunk_size = chip->ecc_step;
+	geo->ecc_strength = round_up(chip->ecc_strength, 2);
+	if (!gpmi_check_ecc(this))
+		return false;
+
+	/* Keep the C >= O */
+	if (geo->ecc_chunk_size < mtd->oobsize) {
+		dev_err(this->dev,
+			"unsupported nand chip. ecc size: %d, oob size : %d\n",
+			chip->ecc_step, mtd->oobsize);
+		return false;
+	}
+
+	/* The default value, see comment in the lagacy_set_geometry(). */
+	geo->metadata_size = 10;
+
+	geo->ecc_chunk_count = mtd->writesize / geo->ecc_chunk_size;
+
+	/*
+	 * Now, the NAND chip with 2K page(data chunk is 512byte) shows below:
+	 *
+	 *    |                          P                            |
+	 *    |<----------------------------------------------------->|
+	 *    |                                                       |
+	 *    |                                        (Block Mark)   |
+	 *    |                      P'                      |      | |     |
+	 *    |<-------------------------------------------->|  D   | |  O' |
+	 *    |                                              |<---->| |<--->|
+	 *    V                                              V      V V     V
+	 *    +---+----------+-+----------+-+----------+-+----------+-+-----+
+	 *    | M |   data   |E|   data   |E|   data   |E|   data   |E|     |
+	 *    +---+----------+-+----------+-+----------+-+----------+-+-----+
+	 *
+	 *	P : the page size for BCH module.
+	 *	E : The ECC strength.
+	 *	G : the length of Galois Field.
+	 *	N : The chunk count of per page.
+	 *	M : the metasize of per page.
+	 *	C : the ecc chunk size, aka the "data" above.
+	 *	P': the nand chip's page size.
+	 *	O : the nand chip's oob size.
+	 *	O': the free oob.
+	 *
+	 *	The formula for P is :
+	 *
+	 *	            E * G * N
+	 *	       P = ------------ + P' + M
+	 *                      8
+	 *
+	 * The position of block mark moves forward in the ECC-based view
+	 * of page, and the delta is:
+	 *
+	 *                   E * G * (N - 1)
+	 *             D = (---------------- + M)
+	 *                          8
+	 *
+	 * Please see the comment in lagacy_set_geometry().
+	 * With the condition C >= O , we still can get same result.
+	 * So the bit position of the physical block mark within the ECC-based
+	 * view of the page is :
+	 *             (P' - D) * 8
+	 */
+	geo->page_size = mtd->writesize + geo->metadata_size +
+		(geo->gf_len * geo->ecc_strength * geo->ecc_chunk_count) / 8;
+
+	/* The available oob size we have. */
+	if (geo->page_size < mtd->writesize + mtd->oobsize) {
+		of->offset = geo->page_size - mtd->writesize;
+		of->length = mtd->oobsize - of->offset;
+		mtd->oobavail = gpmi_hw_ecclayout.oobavail = of->length;
+	}
+
+	geo->payload_size = mtd->writesize;
+
+	geo->auxiliary_status_offset = ALIGN(geo->metadata_size, 4);
+	geo->auxiliary_size = ALIGN(geo->metadata_size, 4)
+				+ ALIGN(geo->ecc_chunk_count, 4);
+
+	if (!this->swap_block_mark)
+		return true;
+
+	/* For bit swap. */
+	block_mark_bit_offset = mtd->writesize * 8 -
+		(geo->ecc_strength * geo->gf_len * (geo->ecc_chunk_count - 1)
+				+ geo->metadata_size * 8);
+
+	geo->block_mark_byte_offset = block_mark_bit_offset / 8;
+	geo->block_mark_bit_offset  = block_mark_bit_offset % 8;
+	return true;
+}
+
+static int lagacy_set_geometry(struct gpmi_nand_data *this)
 {
 	struct bch_geometry *geo = &this->bch_geometry;
 	struct mtd_info *mtd = &this->mtd;
@@ -224,6 +345,11 @@ int common_nfc_set_geometry(struct gpmi_nand_data *this)
 	return 0;
 }
 
+int common_nfc_set_geometry(struct gpmi_nand_data *this)
+{
+	return set_geometry_by_ecc_info(this) ? 0 : lagacy_set_geometry(this);
+}
+
 struct dma_chan *get_dma_chan(struct gpmi_nand_data *this)
 {
 	int chipnr = this->current_chip;
-- 
1.7.1


