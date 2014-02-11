Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaBKVrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:47:31 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:41166 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaBKVr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:47:26 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gupta Pekon <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 2/4] mtd: nand: add support for NAND partitions
Date: Tue, 11 Feb 2014 22:46:47 +0100
Message-Id: <1392155209-14495-3-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for NAND partitions, and inderectly for per partition ECC
config.
Provide helper functions to add/delete/allocate nand partitions.
NAND core code now make use of the partition specific nand_ecc_ctrl struct
(if available) when doing read/write operations.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/Kconfig     |    4 +
 drivers/mtd/nand/Makefile    |    2 +
 drivers/mtd/nand/nand_base.c |  691 ++++++++++++++++++++++++++++++++++--------
 include/linux/mtd/nand.h     |   37 +++
 4 files changed, 602 insertions(+), 132 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 784dd42..aa62ca3 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -22,6 +22,10 @@ menuconfig MTD_NAND
 
 if MTD_NAND
 
+config MTD_OF_NAND_PARTS
+	tristate
+	default n
+
 config MTD_NAND_BCH
 	tristate
 	select BCH
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index e3b4a34..992de88 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -51,4 +51,6 @@ obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
 obj-$(CONFIG_MTD_NAND_SUNXI)		+= sunxi_nand.o
 
+obj-$(CONFIG_MTD_OF_NAND_PARTS)		+= ofnandpart.o
+
 nand-objs := nand_base.o nand_bbt.o
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index f2e9312..b4f8268 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1031,26 +1031,26 @@ static int nand_read_page_raw_syndrome(struct mtd_info *mtd,
 				       struct nand_chip *chip, uint8_t *buf,
 				       int oob_required, int page)
 {
-	int eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
+	int eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
 	uint8_t *oob = chip->oob_poi;
 	int steps, size;
 
-	for (steps = chip->ecc.steps; steps > 0; steps--) {
+	for (steps = chip->cur_ecc->steps; steps > 0; steps--) {
 		chip->read_buf(mtd, buf, eccsize);
 		buf += eccsize;
 
-		if (chip->ecc.prepad) {
-			chip->read_buf(mtd, oob, chip->ecc.prepad);
-			oob += chip->ecc.prepad;
+		if (chip->cur_ecc->prepad) {
+			chip->read_buf(mtd, oob, chip->cur_ecc->prepad);
+			oob += chip->cur_ecc->prepad;
 		}
 
 		chip->read_buf(mtd, oob, eccbytes);
 		oob += eccbytes;
 
-		if (chip->ecc.postpad) {
-			chip->read_buf(mtd, oob, chip->ecc.postpad);
-			oob += chip->ecc.postpad;
+		if (chip->cur_ecc->postpad) {
+			chip->read_buf(mtd, oob, chip->cur_ecc->postpad);
+			oob += chip->cur_ecc->postpad;
 		}
 	}
 
@@ -1072,30 +1072,31 @@ static int nand_read_page_raw_syndrome(struct mtd_info *mtd,
 static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int oob_required, int page)
 {
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
+	int i, eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
+	int eccsteps = chip->cur_ecc->steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	uint8_t *ecc_code = chip->buffers->ecccode;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint32_t *eccpos = chip->cur_ecc->layout->eccpos;
 	unsigned int max_bitflips = 0;
 
-	chip->ecc.read_page_raw(mtd, chip, buf, 1, page);
+	chip->cur_ecc->read_page_raw(mtd, chip, buf, 1, page);
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
-		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+		chip->cur_ecc->calculate(mtd, p, &ecc_calc[i]);
 
-	for (i = 0; i < chip->ecc.total; i++)
+	for (i = 0; i < chip->cur_ecc->total; i++)
 		ecc_code[i] = chip->oob_poi[eccpos[i]];
 
-	eccsteps = chip->ecc.steps;
+	eccsteps = chip->cur_ecc->steps;
 	p = buf;
 
 	for (i = 0 ; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
 		int stat;
 
-		stat = chip->ecc.correct(mtd, p, &ecc_code[i], &ecc_calc[i]);
+		stat = chip->cur_ecc->correct(mtd, p, &ecc_code[i],
+					      &ecc_calc[i]);
 		if (stat < 0) {
 			mtd->ecc_stats.failed++;
 		} else {
@@ -1118,7 +1119,7 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 			uint32_t data_offs, uint32_t readlen, uint8_t *bufpoi)
 {
 	int start_step, end_step, num_steps;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint32_t *eccpos = chip->cur_ecc->layout->eccpos;
 	uint8_t *p;
 	int data_col_addr, i, gaps = 0;
 	int datafrag_len, eccfrag_len, aligned_len, aligned_pos;
@@ -1127,15 +1128,15 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 	unsigned int max_bitflips = 0;
 
 	/* Column address within the page aligned to ECC size (256bytes) */
-	start_step = data_offs / chip->ecc.size;
-	end_step = (data_offs + readlen - 1) / chip->ecc.size;
+	start_step = data_offs / chip->cur_ecc->size;
+	end_step = (data_offs + readlen - 1) / chip->cur_ecc->size;
 	num_steps = end_step - start_step + 1;
 
 	/* Data size aligned to ECC ecc.size */
-	datafrag_len = num_steps * chip->ecc.size;
-	eccfrag_len = num_steps * chip->ecc.bytes;
+	datafrag_len = num_steps * chip->cur_ecc->size;
+	eccfrag_len = num_steps * chip->cur_ecc->bytes;
 
-	data_col_addr = start_step * chip->ecc.size;
+	data_col_addr = start_step * chip->cur_ecc->size;
 	/* If we read not a page aligned data */
 	if (data_col_addr != 0)
 		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, data_col_addr, -1);
@@ -1144,16 +1145,17 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 	chip->read_buf(mtd, p, datafrag_len);
 
 	/* Calculate ECC */
-	for (i = 0; i < eccfrag_len ; i += chip->ecc.bytes, p += chip->ecc.size)
-		chip->ecc.calculate(mtd, p, &chip->buffers->ecccalc[i]);
+	for (i = 0; i < eccfrag_len;
+	     i += chip->cur_ecc->bytes, p += chip->cur_ecc->size)
+		chip->cur_ecc->calculate(mtd, p, &chip->buffers->ecccalc[i]);
 
 	/*
 	 * The performance is faster if we position offsets according to
 	 * ecc.pos. Let's make sure that there are no gaps in ECC positions.
 	 */
 	for (i = 0; i < eccfrag_len - 1; i++) {
-		if (eccpos[i + start_step * chip->ecc.bytes] + 1 !=
-			eccpos[i + start_step * chip->ecc.bytes + 1]) {
+		if (eccpos[i + start_step * chip->cur_ecc->bytes] + 1 !=
+			eccpos[i + start_step * chip->cur_ecc->bytes + 1]) {
 			gaps = 1;
 			break;
 		}
@@ -1166,13 +1168,14 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 		 * Send the command to read the particular ECC bytes take care
 		 * about buswidth alignment in read_buf.
 		 */
-		index = start_step * chip->ecc.bytes;
+		index = start_step * chip->cur_ecc->bytes;
 
 		aligned_pos = eccpos[index] & ~(busw - 1);
 		aligned_len = eccfrag_len;
 		if (eccpos[index] & (busw - 1))
 			aligned_len++;
-		if (eccpos[index + (num_steps * chip->ecc.bytes)] & (busw - 1))
+		if (eccpos[index + (num_steps * chip->cur_ecc->bytes)] &
+		    (busw - 1))
 			aligned_len++;
 
 		chip->cmdfunc(mtd, NAND_CMD_RNDOUT,
@@ -1184,11 +1187,13 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 		chip->buffers->ecccode[i] = chip->oob_poi[eccpos[i + index]];
 
 	p = bufpoi + data_col_addr;
-	for (i = 0; i < eccfrag_len ; i += chip->ecc.bytes, p += chip->ecc.size) {
+	for (i = 0; i < eccfrag_len;
+	     i += chip->cur_ecc->bytes, p += chip->cur_ecc->size) {
 		int stat;
 
-		stat = chip->ecc.correct(mtd, p,
-			&chip->buffers->ecccode[i], &chip->buffers->ecccalc[i]);
+		stat = chip->cur_ecc->correct(mtd, p,
+					      &chip->buffers->ecccode[i],
+					      &chip->buffers->ecccalc[i]);
 		if (stat < 0) {
 			mtd->ecc_stats.failed++;
 		} else {
@@ -1212,32 +1217,33 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int oob_required, int page)
 {
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
+	int i, eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
+	int eccsteps = chip->cur_ecc->steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	uint8_t *ecc_code = chip->buffers->ecccode;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint32_t *eccpos = chip->cur_ecc->layout->eccpos;
 	unsigned int max_bitflips = 0;
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
-		chip->ecc.hwctl(mtd, NAND_ECC_READ);
+		chip->cur_ecc->hwctl(mtd, NAND_ECC_READ);
 		chip->read_buf(mtd, p, eccsize);
-		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+		chip->cur_ecc->calculate(mtd, p, &ecc_calc[i]);
 	}
 	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
 
-	for (i = 0; i < chip->ecc.total; i++)
+	for (i = 0; i < chip->cur_ecc->total; i++)
 		ecc_code[i] = chip->oob_poi[eccpos[i]];
 
-	eccsteps = chip->ecc.steps;
+	eccsteps = chip->cur_ecc->steps;
 	p = buf;
 
 	for (i = 0 ; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
 		int stat;
 
-		stat = chip->ecc.correct(mtd, p, &ecc_code[i], &ecc_calc[i]);
+		stat = chip->cur_ecc->correct(mtd, p, &ecc_code[i],
+					      &ecc_calc[i]);
 		if (stat < 0) {
 			mtd->ecc_stats.failed++;
 		} else {
@@ -1265,12 +1271,12 @@ static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
 	struct nand_chip *chip, uint8_t *buf, int oob_required, int page)
 {
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
+	int i, eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
+	int eccsteps = chip->cur_ecc->steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_code = chip->buffers->ecccode;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint32_t *eccpos = chip->cur_ecc->layout->eccpos;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	unsigned int max_bitflips = 0;
 
@@ -1279,17 +1285,17 @@ static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
 	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
 	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
 
-	for (i = 0; i < chip->ecc.total; i++)
+	for (i = 0; i < chip->cur_ecc->total; i++)
 		ecc_code[i] = chip->oob_poi[eccpos[i]];
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
 		int stat;
 
-		chip->ecc.hwctl(mtd, NAND_ECC_READ);
+		chip->cur_ecc->hwctl(mtd, NAND_ECC_READ);
 		chip->read_buf(mtd, p, eccsize);
-		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+		chip->cur_ecc->calculate(mtd, p, &ecc_calc[i]);
 
-		stat = chip->ecc.correct(mtd, p, &ecc_code[i], NULL);
+		stat = chip->cur_ecc->correct(mtd, p, &ecc_code[i], NULL);
 		if (stat < 0) {
 			mtd->ecc_stats.failed++;
 		} else {
@@ -1314,9 +1320,9 @@ static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
 static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
 				   uint8_t *buf, int oob_required, int page)
 {
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
+	int i, eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
+	int eccsteps = chip->cur_ecc->steps;
 	uint8_t *p = buf;
 	uint8_t *oob = chip->oob_poi;
 	unsigned int max_bitflips = 0;
@@ -1324,17 +1330,17 @@ static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
 		int stat;
 
-		chip->ecc.hwctl(mtd, NAND_ECC_READ);
+		chip->cur_ecc->hwctl(mtd, NAND_ECC_READ);
 		chip->read_buf(mtd, p, eccsize);
 
-		if (chip->ecc.prepad) {
-			chip->read_buf(mtd, oob, chip->ecc.prepad);
-			oob += chip->ecc.prepad;
+		if (chip->cur_ecc->prepad) {
+			chip->read_buf(mtd, oob, chip->cur_ecc->prepad);
+			oob += chip->cur_ecc->prepad;
 		}
 
-		chip->ecc.hwctl(mtd, NAND_ECC_READSYN);
+		chip->cur_ecc->hwctl(mtd, NAND_ECC_READSYN);
 		chip->read_buf(mtd, oob, eccbytes);
-		stat = chip->ecc.correct(mtd, p, oob, NULL);
+		stat = chip->cur_ecc->correct(mtd, p, oob, NULL);
 
 		if (stat < 0) {
 			mtd->ecc_stats.failed++;
@@ -1345,9 +1351,9 @@ static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
 
 		oob += eccbytes;
 
-		if (chip->ecc.postpad) {
-			chip->read_buf(mtd, oob, chip->ecc.postpad);
-			oob += chip->ecc.postpad;
+		if (chip->cur_ecc->postpad) {
+			chip->read_buf(mtd, oob, chip->cur_ecc->postpad);
+			oob += chip->cur_ecc->postpad;
 		}
 	}
 
@@ -1377,7 +1383,7 @@ static uint8_t *nand_transfer_oob(struct nand_chip *chip, uint8_t *oob,
 		return oob + len;
 
 	case MTD_OPS_AUTO_OOB: {
-		struct nand_oobfree *free = chip->ecc.layout->oobfree;
+		struct nand_oobfree *free = chip->cur_ecc->layout->oobfree;
 		uint32_t boffs = 0, roffs = ops->ooboffs;
 		size_t bytes = 0;
 
@@ -1459,16 +1465,20 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 			 * the read methods return max bitflips per ecc step.
 			 */
 			if (unlikely(ops->mode == MTD_OPS_RAW))
-				ret = chip->ecc.read_page_raw(mtd, chip, bufpoi,
-							      oob_required,
-							      page);
+				ret = chip->cur_ecc->read_page_raw(mtd, chip,
+								bufpoi,
+								oob_required,
+								page);
 			else if (!aligned && NAND_HAS_SUBPAGE_READ(chip) &&
 				 !oob)
-				ret = chip->ecc.read_subpage(mtd, chip,
-							col, bytes, bufpoi);
+				ret = chip->cur_ecc->read_subpage(mtd, chip,
+								  col, bytes,
+								  bufpoi);
 			else
-				ret = chip->ecc.read_page(mtd, chip, bufpoi,
-							  oob_required, page);
+				ret = chip->cur_ecc->read_page(mtd, chip,
+							       bufpoi,
+							       oob_required,
+							       page);
 			if (ret < 0) {
 				if (!aligned)
 					/* Invalidate page cache */
@@ -1579,6 +1589,39 @@ static int nand_read(struct mtd_info *mtd, loff_t from, size_t len,
 }
 
 /**
+ * nand_part_read - [MTD Interface] MTD compatibility function for nand_do_read_ecc
+ * @mtd: MTD device structure
+ * @from: offset to read from
+ * @len: number of bytes to read
+ * @retlen: pointer to variable to store the number of read bytes
+ * @buf: the databuffer to put data
+ *
+ * Get hold of the chip and call nand_do_read.
+ */
+static int nand_part_read(struct mtd_info *mtd, loff_t from, size_t len,
+			  size_t *retlen, uint8_t *buf)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nand_part *part = to_nand_part(mtd);
+	struct mtd_oob_ops ops;
+	int ret;
+
+	from += part->offset;
+	nand_get_device(mtd, FL_READING);
+	if (part->ecc)
+		chip->cur_ecc = part->ecc;
+	ops.len = len;
+	ops.datbuf = buf;
+	ops.oobbuf = NULL;
+	ops.mode = MTD_OPS_PLACE_OOB;
+	ret = nand_do_read_ops(mtd, from, &ops);
+	*retlen = ops.retlen;
+	chip->cur_ecc = &chip->ecc;
+	nand_release_device(mtd);
+	return ret;
+}
+
+/**
  * nand_read_oob_std - [REPLACEABLE] the most common OOB data read function
  * @mtd: mtd info structure
  * @chip: nand chip info structure
@@ -1604,13 +1647,14 @@ static int nand_read_oob_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
 {
 	uint8_t *buf = chip->oob_poi;
 	int length = mtd->oobsize;
-	int chunk = chip->ecc.bytes + chip->ecc.prepad + chip->ecc.postpad;
-	int eccsize = chip->ecc.size;
+	int chunk = chip->cur_ecc->bytes + chip->cur_ecc->prepad +
+		    chip->cur_ecc->postpad;
+	int eccsize = chip->cur_ecc->size;
 	uint8_t *bufpoi = buf;
 	int i, toread, sndrnd = 0, pos;
 
-	chip->cmdfunc(mtd, NAND_CMD_READ0, chip->ecc.size, page);
-	for (i = 0; i < chip->ecc.steps; i++) {
+	chip->cmdfunc(mtd, NAND_CMD_READ0, chip->cur_ecc->size, page);
+	for (i = 0; i < chip->cur_ecc->steps; i++) {
 		if (sndrnd) {
 			pos = eccsize + i * (eccsize + chunk);
 			if (mtd->writesize > 512)
@@ -1663,9 +1707,10 @@ static int nand_write_oob_std(struct mtd_info *mtd, struct nand_chip *chip,
 static int nand_write_oob_syndrome(struct mtd_info *mtd,
 				   struct nand_chip *chip, int page)
 {
-	int chunk = chip->ecc.bytes + chip->ecc.prepad + chip->ecc.postpad;
-	int eccsize = chip->ecc.size, length = mtd->oobsize;
-	int i, len, pos, status = 0, sndcmd = 0, steps = chip->ecc.steps;
+	int chunk = chip->cur_ecc->bytes + chip->cur_ecc->prepad +
+		    chip->cur_ecc->postpad;
+	int eccsize = chip->cur_ecc->size, length = mtd->oobsize;
+	int i, len, pos, status = 0, sndcmd = 0, steps = chip->cur_ecc->steps;
 	const uint8_t *bufpoi = chip->oob_poi;
 
 	/*
@@ -1673,7 +1718,7 @@ static int nand_write_oob_syndrome(struct mtd_info *mtd,
 	 * or
 	 * data-pad-ecc-pad-data-pad .... ecc-pad-oob
 	 */
-	if (!chip->ecc.prepad && !chip->ecc.postpad) {
+	if (!chip->cur_ecc->prepad && !chip->cur_ecc->postpad) {
 		pos = steps * (eccsize + chunk);
 		steps = 0;
 	} else
@@ -1737,7 +1782,7 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 	stats = mtd->ecc_stats;
 
 	if (ops->mode == MTD_OPS_AUTO_OOB)
-		len = chip->ecc.layout->oobavail;
+		len = chip->cur_ecc->layout->oobavail;
 	else
 		len = mtd->oobsize;
 
@@ -1765,9 +1810,9 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 
 	while (1) {
 		if (ops->mode == MTD_OPS_RAW)
-			ret = chip->ecc.read_oob_raw(mtd, chip, page);
+			ret = chip->cur_ecc->read_oob_raw(mtd, chip, page);
 		else
-			ret = chip->ecc.read_oob(mtd, chip, page);
+			ret = chip->cur_ecc->read_oob(mtd, chip, page);
 
 		if (ret < 0)
 			break;
@@ -1855,6 +1900,56 @@ out:
 	return ret;
 }
 
+/**
+ * nand_part_read_oob - [MTD Interface] NAND read data and/or out-of-band
+ * @mtd: MTD device structure
+ * @from: offset to read from
+ * @ops: oob operation description structure
+ *
+ * NAND read data and/or out-of-band data.
+ */
+static int nand_part_read_oob(struct mtd_info *mtd, loff_t from,
+			 struct mtd_oob_ops *ops)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nand_part *part = to_nand_part(mtd);
+	int ret = -ENOTSUPP;
+
+	ops->retlen = 0;
+
+	/* Do not allow reads past end of device */
+	if (ops->datbuf && (from + ops->len) > mtd->size) {
+		pr_debug("%s: attempt to read beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	from += part->offset;
+	nand_get_device(mtd, FL_READING);
+	if (part->ecc)
+		chip->cur_ecc = part->ecc;
+
+	switch (ops->mode) {
+	case MTD_OPS_PLACE_OOB:
+	case MTD_OPS_AUTO_OOB:
+	case MTD_OPS_RAW:
+		break;
+
+	default:
+		goto out;
+	}
+
+	if (!ops->datbuf)
+		ret = nand_do_read_oob(mtd, from, ops);
+	else
+		ret = nand_do_read_ops(mtd, from, ops);
+
+out:
+	chip->cur_ecc = &chip->ecc;
+	nand_release_device(mtd);
+	return ret;
+}
+
 
 /**
  * nand_write_page_raw - [INTERN] raw page write function
@@ -1888,26 +1983,26 @@ static int nand_write_page_raw_syndrome(struct mtd_info *mtd,
 					struct nand_chip *chip,
 					const uint8_t *buf, int oob_required)
 {
-	int eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
+	int eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
 	uint8_t *oob = chip->oob_poi;
 	int steps, size;
 
-	for (steps = chip->ecc.steps; steps > 0; steps--) {
+	for (steps = chip->cur_ecc->steps; steps > 0; steps--) {
 		chip->write_buf(mtd, buf, eccsize);
 		buf += eccsize;
 
-		if (chip->ecc.prepad) {
-			chip->write_buf(mtd, oob, chip->ecc.prepad);
-			oob += chip->ecc.prepad;
+		if (chip->cur_ecc->prepad) {
+			chip->write_buf(mtd, oob, chip->cur_ecc->prepad);
+			oob += chip->cur_ecc->prepad;
 		}
 
 		chip->write_buf(mtd, oob, eccbytes);
 		oob += eccbytes;
 
-		if (chip->ecc.postpad) {
-			chip->write_buf(mtd, oob, chip->ecc.postpad);
-			oob += chip->ecc.postpad;
+		if (chip->cur_ecc->postpad) {
+			chip->write_buf(mtd, oob, chip->cur_ecc->postpad);
+			oob += chip->cur_ecc->postpad;
 		}
 	}
 
@@ -1927,21 +2022,21 @@ static int nand_write_page_raw_syndrome(struct mtd_info *mtd,
 static int nand_write_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 				  const uint8_t *buf, int oob_required)
 {
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
+	int i, eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
+	int eccsteps = chip->cur_ecc->steps;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	const uint8_t *p = buf;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint32_t *eccpos = chip->cur_ecc->layout->eccpos;
 
 	/* Software ECC calculation */
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
-		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+		chip->cur_ecc->calculate(mtd, p, &ecc_calc[i]);
 
-	for (i = 0; i < chip->ecc.total; i++)
+	for (i = 0; i < chip->cur_ecc->total; i++)
 		chip->oob_poi[eccpos[i]] = ecc_calc[i];
 
-	return chip->ecc.write_page_raw(mtd, chip, buf, 1);
+	return chip->cur_ecc->write_page_raw(mtd, chip, buf, 1);
 }
 
 /**
@@ -1954,20 +2049,20 @@ static int nand_write_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 static int nand_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 				  const uint8_t *buf, int oob_required)
 {
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
+	int i, eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
+	int eccsteps = chip->cur_ecc->steps;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	const uint8_t *p = buf;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint32_t *eccpos = chip->cur_ecc->layout->eccpos;
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
-		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
+		chip->cur_ecc->hwctl(mtd, NAND_ECC_WRITE);
 		chip->write_buf(mtd, p, eccsize);
-		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+		chip->cur_ecc->calculate(mtd, p, &ecc_calc[i]);
 	}
 
-	for (i = 0; i < chip->ecc.total; i++)
+	for (i = 0; i < chip->cur_ecc->total; i++)
 		chip->oob_poi[eccpos[i]] = ecc_calc[i];
 
 	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
@@ -1992,10 +2087,10 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 {
 	uint8_t *oob_buf  = chip->oob_poi;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
-	int ecc_size      = chip->ecc.size;
-	int ecc_bytes     = chip->ecc.bytes;
-	int ecc_steps     = chip->ecc.steps;
-	uint32_t *eccpos  = chip->ecc.layout->eccpos;
+	int ecc_size      = chip->cur_ecc->size;
+	int ecc_bytes     = chip->cur_ecc->bytes;
+	int ecc_steps     = chip->cur_ecc->steps;
+	uint32_t *eccpos  = chip->cur_ecc->layout->eccpos;
 	uint32_t start_step = offset / ecc_size;
 	uint32_t end_step   = (offset + data_len - 1) / ecc_size;
 	int oob_bytes       = mtd->oobsize / ecc_steps;
@@ -2003,7 +2098,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 
 	for (step = 0; step < ecc_steps; step++) {
 		/* configure controller for WRITE access */
-		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
+		chip->cur_ecc->hwctl(mtd, NAND_ECC_WRITE);
 
 		/* write data (untouched subpages already masked by 0xFF) */
 		chip->write_buf(mtd, buf, ecc_size);
@@ -2012,7 +2107,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 		if ((step < start_step) || (step > end_step))
 			memset(ecc_calc, 0xff, ecc_bytes);
 		else
-			chip->ecc.calculate(mtd, buf, ecc_calc);
+			chip->cur_ecc->calculate(mtd, buf, ecc_calc);
 
 		/* mask OOB of un-touched subpages by padding 0xFF */
 		/* if oob_required, preserve OOB metadata of written subpage */
@@ -2027,7 +2122,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 	/* copy calculated ECC for whole page to chip->buffer->oob */
 	/* this include masked-value(0xFF) for unwritten subpages */
 	ecc_calc = chip->buffers->ecccalc;
-	for (i = 0; i < chip->ecc.total; i++)
+	for (i = 0; i < chip->cur_ecc->total; i++)
 		chip->oob_poi[eccpos[i]] = ecc_calc[i];
 
 	/* write OOB buffer to NAND device */
@@ -2051,29 +2146,29 @@ static int nand_write_page_syndrome(struct mtd_info *mtd,
 				    struct nand_chip *chip,
 				    const uint8_t *buf, int oob_required)
 {
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
+	int i, eccsize = chip->cur_ecc->size;
+	int eccbytes = chip->cur_ecc->bytes;
+	int eccsteps = chip->cur_ecc->steps;
 	const uint8_t *p = buf;
 	uint8_t *oob = chip->oob_poi;
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
 
-		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
+		chip->cur_ecc->hwctl(mtd, NAND_ECC_WRITE);
 		chip->write_buf(mtd, p, eccsize);
 
-		if (chip->ecc.prepad) {
-			chip->write_buf(mtd, oob, chip->ecc.prepad);
-			oob += chip->ecc.prepad;
+		if (chip->cur_ecc->prepad) {
+			chip->write_buf(mtd, oob, chip->cur_ecc->prepad);
+			oob += chip->cur_ecc->prepad;
 		}
 
-		chip->ecc.calculate(mtd, p, oob);
+		chip->cur_ecc->calculate(mtd, p, oob);
 		chip->write_buf(mtd, oob, eccbytes);
 		oob += eccbytes;
 
-		if (chip->ecc.postpad) {
-			chip->write_buf(mtd, oob, chip->ecc.postpad);
-			oob += chip->ecc.postpad;
+		if (chip->cur_ecc->postpad) {
+			chip->write_buf(mtd, oob, chip->cur_ecc->postpad);
+			oob += chip->cur_ecc->postpad;
 		}
 	}
 
@@ -2104,7 +2199,7 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
 	int status, subpage;
 
 	if (!(chip->options & NAND_NO_SUBPAGE_WRITE) &&
-		chip->ecc.write_subpage)
+		chip->cur_ecc->write_subpage)
 		subpage = offset || (data_len < mtd->writesize);
 	else
 		subpage = 0;
@@ -2112,13 +2207,15 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
 	chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, page);
 
 	if (unlikely(raw))
-		status = chip->ecc.write_page_raw(mtd, chip, buf,
-							oob_required);
+		status = chip->cur_ecc->write_page_raw(mtd, chip, buf,
+						       oob_required);
 	else if (subpage)
-		status = chip->ecc.write_subpage(mtd, chip, offset, data_len,
-							 buf, oob_required);
+		status = chip->cur_ecc->write_subpage(mtd, chip, offset,
+						      data_len, buf,
+						      oob_required);
 	else
-		status = chip->ecc.write_page(mtd, chip, buf, oob_required);
+		status = chip->cur_ecc->write_page(mtd, chip, buf,
+						   oob_required);
 
 	if (status < 0)
 		return status;
@@ -2177,7 +2274,7 @@ static uint8_t *nand_fill_oob(struct mtd_info *mtd, uint8_t *oob, size_t len,
 		return oob + len;
 
 	case MTD_OPS_AUTO_OOB: {
-		struct nand_oobfree *free = chip->ecc.layout->oobfree;
+		struct nand_oobfree *free = chip->cur_ecc->layout->oobfree;
 		uint32_t boffs = 0, woffs = ops->ooboffs;
 		size_t bytes = 0;
 
@@ -2361,6 +2458,46 @@ static int panic_nand_write(struct mtd_info *mtd, loff_t to, size_t len,
 }
 
 /**
+ * panic_nand_part_write - [MTD Interface] NAND write with ECC
+ * @mtd: MTD device structure
+ * @to: offset to write to
+ * @len: number of bytes to write
+ * @retlen: pointer to variable to store the number of written bytes
+ * @buf: the data to write
+ *
+ * NAND write with ECC. Used when performing writes in interrupt context, this
+ * may for example be called by mtdoops when writing an oops while in panic.
+ */
+static int panic_nand_part_write(struct mtd_info *mtd, loff_t to, size_t len,
+			    size_t *retlen, const uint8_t *buf)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nand_part *part = to_nand_part(mtd);
+	struct mtd_oob_ops ops;
+	int ret;
+
+	to += part->offset;
+	/* Wait for the device to get ready */
+	panic_nand_wait(mtd, chip, 400);
+
+	/* Grab the device */
+	panic_nand_get_device(chip, mtd, FL_WRITING);
+	if (part->ecc)
+		chip->cur_ecc = part->ecc;
+
+	ops.len = len;
+	ops.datbuf = (uint8_t *)buf;
+	ops.oobbuf = NULL;
+	ops.mode = MTD_OPS_PLACE_OOB;
+
+	ret = nand_do_write_ops(mtd, to, &ops);
+
+	chip->cur_ecc = &chip->ecc;
+	*retlen = ops.retlen;
+	return ret;
+}
+
+/**
  * nand_write - [MTD Interface] NAND write with ECC
  * @mtd: MTD device structure
  * @to: offset to write to
@@ -2388,6 +2525,39 @@ static int nand_write(struct mtd_info *mtd, loff_t to, size_t len,
 }
 
 /**
+ * nand_part_write - [MTD Interface] NAND write with ECC
+ * @mtd: MTD device structure
+ * @to: offset to write to
+ * @len: number of bytes to write
+ * @retlen: pointer to variable to store the number of written bytes
+ * @buf: the data to write
+ *
+ * NAND write with ECC.
+ */
+static int nand_part_write(struct mtd_info *mtd, loff_t to, size_t len,
+			  size_t *retlen, const uint8_t *buf)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nand_part *part = to_nand_part(mtd);
+	struct mtd_oob_ops ops;
+	int ret;
+
+	to += part->offset;
+	nand_get_device(mtd, FL_WRITING);
+	if (part->ecc)
+		chip->cur_ecc = part->ecc;
+	ops.len = len;
+	ops.datbuf = (uint8_t *)buf;
+	ops.oobbuf = NULL;
+	ops.mode = MTD_OPS_PLACE_OOB;
+	ret = nand_do_write_ops(mtd, to, &ops);
+	*retlen = ops.retlen;
+	chip->cur_ecc = &chip->ecc;
+	nand_release_device(mtd);
+	return ret;
+}
+
+/**
  * nand_do_write_oob - [MTD Interface] NAND write out-of-band
  * @mtd: MTD device structure
  * @to: offset to write to
@@ -2405,7 +2575,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 			 __func__, (unsigned int)to, (int)ops->ooblen);
 
 	if (ops->mode == MTD_OPS_AUTO_OOB)
-		len = chip->ecc.layout->oobavail;
+		len = chip->cur_ecc->layout->oobavail;
 	else
 		len = mtd->oobsize;
 
@@ -2459,9 +2629,11 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 	nand_fill_oob(mtd, ops->oobbuf, ops->ooblen, ops);
 
 	if (ops->mode == MTD_OPS_RAW)
-		status = chip->ecc.write_oob_raw(mtd, chip, page & chip->pagemask);
+		status = chip->cur_ecc->write_oob_raw(mtd, chip,
+						      page & chip->pagemask);
 	else
-		status = chip->ecc.write_oob(mtd, chip, page & chip->pagemask);
+		status = chip->cur_ecc->write_oob(mtd, chip,
+						  page & chip->pagemask);
 
 	chip->select_chip(mtd, -1);
 
@@ -2516,6 +2688,54 @@ out:
 }
 
 /**
+ * nand_write_oob - [MTD Interface] NAND write data and/or out-of-band
+ * @mtd: MTD device structure
+ * @to: offset to write to
+ * @ops: oob operation description structure
+ */
+static int nand_part_write_oob(struct mtd_info *mtd, loff_t to,
+			  struct mtd_oob_ops *ops)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nand_part *part = to_nand_part(mtd);
+	int ret = -ENOTSUPP;
+
+	ops->retlen = 0;
+
+	/* Do not allow writes past end of device */
+	if (ops->datbuf && (to + ops->len) > mtd->size) {
+		pr_debug("%s: attempt to write beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	to += part->offset;
+	nand_get_device(mtd, FL_WRITING);
+	if (part->ecc)
+		chip->cur_ecc = part->ecc;
+
+	switch (ops->mode) {
+	case MTD_OPS_PLACE_OOB:
+	case MTD_OPS_AUTO_OOB:
+	case MTD_OPS_RAW:
+		break;
+
+	default:
+		goto out;
+	}
+
+	if (!ops->datbuf)
+		ret = nand_do_write_oob(mtd, to, ops);
+	else
+		ret = nand_do_write_ops(mtd, to, ops);
+
+out:
+	chip->cur_ecc = &chip->ecc;
+	nand_release_device(mtd);
+	return ret;
+}
+
+/**
  * single_erase_cmd - [GENERIC] NAND standard block erase command function
  * @mtd: MTD device structure
  * @page: the page address of the block which will be erased
@@ -2543,6 +2763,29 @@ static int nand_erase(struct mtd_info *mtd, struct erase_info *instr)
 }
 
 /**
+ * nand_part_erase - [MTD Interface] erase partition block(s)
+ * @mtd: MTD device structure
+ * @instr: erase instruction
+ *
+ * Erase one ore more blocks.
+ */
+static int nand_part_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	struct nand_part *part = to_nand_part(mtd);
+	int ret;
+
+	instr->addr += part->offset;
+	ret = nand_erase_nand(mtd, instr, 0);
+	if (ret) {
+		if (instr->fail_addr != MTD_FAIL_ADDR_UNKNOWN)
+			instr->fail_addr -= part->offset;
+		instr->addr -= part->offset;
+	}
+
+	return ret;
+}
+
+/**
  * nand_erase_nand - [INTERN] erase block(s)
  * @mtd: MTD device structure
  * @instr: erase instruction
@@ -2686,6 +2929,18 @@ static int nand_block_isbad(struct mtd_info *mtd, loff_t offs)
 }
 
 /**
+ * nand_part_block_isbad - [MTD Interface] Check if block at offset is bad
+ * @mtd: MTD device structure
+ * @offs: offset relative to mtd start
+ */
+static int nand_part_block_isbad(struct mtd_info *mtd, loff_t offs)
+{
+	struct nand_part *part = to_nand_part(mtd);
+
+	return nand_block_checkbad(mtd, part->offset + offs, 1, 0);
+}
+
+/**
  * nand_block_markbad - [MTD Interface] Mark block at the given offset as bad
  * @mtd: MTD device structure
  * @ofs: offset relative to mtd start
@@ -2706,6 +2961,29 @@ static int nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
 }
 
 /**
+ * nand_part_block_markbad - [MTD Interface] Mark block at the given offset as
+ *			     bad
+ * @mtd: MTD device structure
+ * @ofs: offset relative to mtd start
+ */
+static int nand_part_block_markbad(struct mtd_info *mtd, loff_t ofs)
+{
+	struct nand_part *part = to_nand_part(mtd);
+	int ret;
+
+	ofs += part->offset;
+	ret = nand_block_isbad(mtd, ofs);
+	if (ret) {
+		/* If it was bad already, return success and do nothing */
+		if (ret > 0)
+			return 0;
+		return ret;
+	}
+
+	return nand_block_markbad_lowlevel(mtd, ofs);
+}
+
+/**
  * nand_onfi_set_features- [REPLACEABLE] set features for ONFI nand
  * @mtd: MTD device structure
  * @chip: nand chip info structure
@@ -3785,6 +4063,153 @@ static int nand_ecc_ctrl_init(struct mtd_info *mtd, struct nand_ecc_ctrl *ecc)
 }
 
 /**
+ * nand_add_partition - [NAND Interface] Add a NAND partition to a NAND device
+ * @master: MTD device structure representing the NAND device
+ * @part: NAND partition to add to the NAND device
+ *
+ * Adds a NAND partition to a NAND device.
+ * The NAND partition cannot overlap with another existing partition.
+ *
+ * Returns zero in case of success and a negative error code in case of failure.
+ */
+int nand_add_partition(struct mtd_info *master, struct nand_part *part)
+{
+	struct nand_chip *chip = master->priv;
+	struct mtd_info *mtd = &part->mtd;
+	struct nand_ecc_ctrl *ecc = part->ecc;
+	struct nand_part *pos;
+	bool inserted = false;
+	int ret;
+
+	/* set up the MTD object for this partition */
+	mtd->type = master->type;
+	mtd->flags = master->flags & ~mtd->flags;
+	mtd->writesize = master->writesize;
+	mtd->writebufsize = master->writebufsize;
+	mtd->oobsize = master->oobsize;
+	mtd->oobavail = master->oobavail;
+	mtd->subpage_sft = master->subpage_sft;
+	mtd->erasesize = master->erasesize;
+
+	mtd->owner = master->owner;
+	mtd->backing_dev_info = master->backing_dev_info;
+
+	mtd->dev.parent = master->dev.parent;
+
+	if (ecc) {
+		ret = nand_ecc_ctrl_init(mtd, ecc);
+		if (ret)
+			return ret;
+	} else {
+		ecc = &chip->ecc;
+	}
+
+	mtd->_erase = nand_part_erase;
+	mtd->_point = NULL;
+	mtd->_unpoint = NULL;
+	mtd->_read = nand_part_read;
+	mtd->_write = nand_part_write;
+	mtd->_panic_write = panic_nand_part_write;
+	mtd->_read_oob = nand_part_read_oob;
+	mtd->_write_oob = nand_part_write_oob;
+	mtd->_sync = nand_sync;
+	mtd->_lock = NULL;
+	mtd->_unlock = NULL;
+	mtd->_suspend = nand_suspend;
+	mtd->_resume = nand_resume;
+	mtd->_block_isbad = nand_part_block_isbad;
+	mtd->_block_markbad = nand_part_block_markbad;
+
+	/* propagate ecc info to mtd_info */
+	mtd->ecclayout = ecc->layout;
+	mtd->ecc_strength = ecc->strength;
+	mtd->ecc_step_size = ecc->size;
+	/*
+	 * Initialize bitflip_threshold to its default prior scan_bbt() call.
+	 * scan_bbt() might invoke mtd_read(), thus bitflip_threshold must be
+	 * properly set.
+	 */
+	if (!mtd->bitflip_threshold)
+		mtd->bitflip_threshold = mtd->ecc_strength;
+
+	part->master = master;
+
+	list_for_each_entry(pos, &chip->partitions, node) {
+		if (part->offset >= pos->offset + pos->mtd.size)
+			continue;
+		else if (part->offset + mtd->size > pos->offset)
+			return -EINVAL;
+
+		list_add(&part->node, pos->node.prev);
+		inserted = true;
+		break;
+	}
+
+	if (!inserted)
+		list_add_tail(&part->node, &chip->partitions);
+
+	ret = mtd_device_register(mtd, NULL, 0);
+	if (ret) {
+		list_del(&part->node);
+		goto out;
+	}
+
+out:
+	mutex_unlock(&chip->part_lock);
+	return ret;
+}
+EXPORT_SYMBOL(nand_add_partition);
+
+/**
+ * nand_del_partition - [NAND Interface] Delete a NAND part from a NAND dev
+ * @part: NAND partition to delete
+ *
+ * Deletes a NAND partition from a NAND device.
+ */
+void nand_del_partition(struct nand_part *part)
+{
+	struct nand_chip *chip = part->mtd.priv;
+
+	mutex_lock(&chip->part_lock);
+	mtd_device_unregister(&part->mtd);
+	list_del(&part->node);
+	mutex_unlock(&chip->part_lock);
+
+	if (part->ecc && part->ecc->mode == NAND_ECC_SOFT_BCH)
+		nand_bch_free((struct nand_bch_control *)part->ecc->priv);
+
+	if (part->release)
+		part->release(part);
+}
+EXPORT_SYMBOL(nand_del_partition);
+
+/*
+ * NAND part release function. Used by nandpart_alloc as its release function.
+ */
+static void nandpart_release(struct nand_part *part)
+{
+	kfree(part);
+}
+
+/**
+ * nandpart_alloc - [NAND Interface] Allocate a NAND part struct
+ *
+ * Allocate a NAND partition and assign the nandpart release function.
+ * This nand_part struct must be filled before passing it to the
+ * nand_add_partition function.
+ */
+struct nand_part *nandpart_alloc(void)
+{
+	struct nand_part *part = kzalloc(sizeof(*part), GFP_KERNEL);
+	if (!part)
+		return ERR_PTR(-ENOMEM);
+	part->release = nandpart_release;
+
+	return part;
+}
+EXPORT_SYMBOL(nandpart_alloc);
+
+/**
  * nand_scan_tail - [NAND Interface] Scan for the NAND device
  * @mtd: MTD device structure
  *
@@ -3822,6 +4247,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 		return ret;
 	}
 
+	chip->cur_ecc = &chip->ecc;
+
 	/* Allow subpage writes up to ecc.steps. Not possible for MLC flash */
 	if (!(chip->options & NAND_NO_SUBPAGE_WRITE) && nand_is_slc(chip)) {
 		switch (ecc->steps) {
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index c70e0a3..c4d271a 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -574,6 +574,7 @@ struct nand_chip {
 	struct nand_hw_control *controller;
 
 	struct nand_ecc_ctrl ecc;
+	struct nand_ecc_ctrl *cur_ecc;
 	struct nand_buffers *buffers;
 	struct nand_hw_control hwcontrol;
 
@@ -583,9 +584,40 @@ struct nand_chip {
 
 	struct nand_bbt_descr *badblock_pattern;
 
+	struct list_head partitions;
+	struct mutex part_lock;
+
 	void *priv;
 };
 
+/**
+ * struct nand_part - NAND partition structure
+ * @node:	list node used to attach the partition to its NAND dev
+ * @mtd:	MTD partiton info
+ * @master:	MTD device representing the NAND chip
+ * @offset:	partition offset
+ * @ecc:	partition specific ECC struct
+ * @release:	function used to release this nand_part struct
+ *
+ * NAND partitions work as standard MTD partitions except it can override
+ * NAND chip ECC handling.
+ * This is particularly useful for SoCs that need specific ECC configs to boot
+ * from NAND while these ECC configs do not fit the NAND chip ECC requirements.
+ */
+struct nand_part {
+	struct list_head node;
+	struct mtd_info mtd;
+	struct mtd_info *master;
+	uint64_t offset;
+	struct nand_ecc_ctrl *ecc;
+	void (*release)(struct nand_part *part);
+};
+
+static inline struct nand_part *to_nand_part(struct mtd_info *mtd)
+{
+	return container_of(mtd, struct nand_part, mtd);
+}
+
 /*
  * NAND Flash Manufacturer ID Codes
  */
@@ -806,6 +838,11 @@ static inline bool nand_is_slc(struct nand_chip *chip)
 	return chip->bits_per_cell == 1;
 }
 
+int nand_add_partition(struct mtd_info *master, struct nand_part *part);
+
+void nand_del_partition(struct nand_part *part);
+
+struct nand_part *nandpart_alloc(void);
 
 /**
  * struct nand_sdr_timings - SDR NAND chip timings
-- 
1.7.9.5

