Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3L0NFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 08:05:25 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58922 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3L0NFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 08:05:24 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Huang Shijie <b32955@freescale.com>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "Gupta, Pekon" <pekon@ti.com>,
        "Rashika Kheria" <rashika.kheria@gmail.com>
Subject: [PATCH] mtd: nand: remove NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE
Thread-Topic: [PATCH] mtd: nand: remove NAND_MAX_OOBSIZE and
 NAND_MAX_PAGESIZE
Thread-Index: Ac8DBArv16K0d+s0Sfag04LtsfgfKQ==
Date: Fri, 27 Dec 2013 13:03:32 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E480C3@SZXEMA512-MBX.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>
Date: Fri, 27 Dec 2013 20:23:09 +0800
Subject: [PATCH] mtd: nand: remove NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE

remove NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE, dynamic allocate
NAND buffer after detecting NAND writesize and oobsize.

 - save memory. when use MACRO allocate static buffer, use a small
   page size NAND chip, the buffer is still 8k, the memory is wasted.

 - reduce maintenance. NAND chip pagesize and oobsize update frequently,
   allocate buffer according to the detecting size will reduce maintenance.

 - this fix was suggested by Brian Norris [computersforpeace@gmail.com]
                         and Huang Shijie [b32955@freescale.com]

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 drivers/mtd/nand/cafe_nand.c           | 15 +++++++--
 drivers/mtd/nand/denali.c              |  9 -----
 drivers/mtd/nand/denali.h              |  2 +-
 drivers/mtd/nand/fsmc_nand.c           |  4 +--
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |  4 +--
 drivers/mtd/nand/mxc_nand.c            |  5 ++-
 drivers/mtd/nand/nand_base.c           | 60 ++++++++++++++++++++--------------
 drivers/mtd/nand/nand_bbt.c            |  2 +-
 drivers/mtd/nand/omap2.c               |  6 ++--
 include/linux/mtd/nand.h               | 17 +++-------
 10 files changed, 66 insertions(+), 58 deletions(-)

diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index c34985a..c784621 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -53,6 +53,9 @@
 #define CAFE_GLOBAL_IRQ_MASK	0x300c
 #define CAFE_NAND_RESET		0x3034
 
+#define CAFE_MAX_OOBSIZE	744
+#define CAFE_MAX_PAGESIZE	8192
+
 /* Missing from the datasheet: bit 19 of CTRL1 sets CE0 vs. CE1 */
 #define CTRL1_CHIPSELECT	(1<<19)
 
@@ -657,13 +660,21 @@ static int cafe_nand_probe(struct pci_dev *pdev,
 		err = -ENOMEM;
 		goto out_free_mtd;
 	}
-	cafe->dmabuf = dma_alloc_coherent(&cafe->pdev->dev, 2112 + sizeof(struct nand_buffers),
+	cafe->dmabuf = dma_alloc_coherent(&cafe->pdev->dev,
+					  (2112 + CAFE_MAX_OOBSIZE * 3
+					   + CAFE_MAX_PAGESIZE),
 					  &cafe->dmaaddr, GFP_KERNEL);
 	if (!cafe->dmabuf) {
 		err = -ENOMEM;
 		goto out_ior;
 	}
-	cafe->nand.buffers = (void *)cafe->dmabuf + 2112;
+
+	cafe->nand.buffers.buffer = (void *)cafe->dmabuf + 2112;
+	cafe->nand.buffers.ecccalc = cafe->nand.buffers.buffer;
+	cafe->nand.buffers.ecccode = cafe->nand.buffers.ecccalc
+		+ CAFE_MAX_OOBSIZE;
+	cafe->nand.buffers.databuf = cafe->nand.buffers.ecccode
+		+ CAFE_MAX_OOBSIZE;
 
 	cafe->rs = init_rs_non_canonical(12, &cafe_mul, 0, 1, 8);
 	if (!cafe->rs) {
diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 3a3a47f..e86c995 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1475,15 +1475,6 @@ int denali_init(struct denali_nand_info *denali)
 		goto failed_req_irq;
 	}
 
-	/* MTD supported page sizes vary by kernel. We validate our
-	 * kernel supports the device here.
-	 */
-	if (denali->mtd.writesize > NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE) {
-		ret = -ENODEV;
-		pr_err("Spectra: device size not supported by this version of MTD.");
-		goto failed_req_irq;
-	}
-
 	/* support for multi nand
 	 * MTD known nothing about multi nand,
 	 * so we should tell it the real pagesize
diff --git a/drivers/mtd/nand/denali.h b/drivers/mtd/nand/denali.h
index cec5712..5feb466 100644
--- a/drivers/mtd/nand/denali.h
+++ b/drivers/mtd/nand/denali.h
@@ -455,7 +455,7 @@
 
 #define ECC_SECTOR_SIZE     512
 
-#define DENALI_BUF_SIZE		(NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE)
+#define DENALI_BUF_SIZE		(8192 + 744)
 
 struct nand_buf {
 	int head;
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 8b27522..082c880 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -719,8 +719,8 @@ static int fsmc_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
-	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
+	uint8_t *ecc_code = chip->buffers.ecccode;
 	int off, len, group = 0;
 	/*
 	 * ecc_oob is intentionally taken as uint16_t. In 16bit devices, we
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index e2f5820..7618e71 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1298,7 +1298,7 @@ static int mx23_check_transcription_stamp(struct gpmi_nand_data *this)
 	unsigned int search_area_size_in_strides;
 	unsigned int stride;
 	unsigned int page;
-	uint8_t *buffer = chip->buffers->databuf;
+	uint8_t *buffer = chip->buffers.databuf;
 	int saved_chip_number;
 	int found_an_ncb_fingerprint = false;
 
@@ -1357,7 +1357,7 @@ static int mx23_write_transcription_stamp(struct gpmi_nand_data *this)
 	unsigned int block;
 	unsigned int stride;
 	unsigned int page;
-	uint8_t      *buffer = chip->buffers->databuf;
+	uint8_t      *buffer = chip->buffers.databuf;
 	int saved_chip_number;
 	int status;
 
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 567a5e5..5343c4f 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -137,6 +137,9 @@
 
 #define NFC_V3_DELAY_LINE		(host->regs_ip + 0x34)
 
+#define MXC_MAX_OOBSIZE			744
+#define MXC_MAX_PAGESIZE		8192
+
 struct mxc_nand_host;
 
 struct mxc_nand_devtype_data {
@@ -1400,7 +1403,7 @@ static int mxcnd_probe(struct platform_device *pdev)
 
 	/* Allocate memory for MTD device structure and private data */
 	host = devm_kzalloc(&pdev->dev, sizeof(struct mxc_nand_host) +
-			NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE, GFP_KERNEL);
+			    MXC_MAX_PAGESIZE + MXC_MAX_OOBSIZE, GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
 
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 9b3bb3c..57c1b57a 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1078,8 +1078,8 @@ static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
-	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
+	uint8_t *ecc_code = chip->buffers.ecccode;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	unsigned int max_bitflips = 0;
 
@@ -1147,7 +1147,7 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 
 	/* Calculate ECC */
 	for (i = 0; i < eccfrag_len ; i += chip->ecc.bytes, p += chip->ecc.size)
-		chip->ecc.calculate(mtd, p, &chip->buffers->ecccalc[i]);
+		chip->ecc.calculate(mtd, p, &chip->buffers.ecccalc[i]);
 
 	/*
 	 * The performance is faster if we position offsets according to
@@ -1183,14 +1183,14 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 	}
 
 	for (i = 0; i < eccfrag_len; i++)
-		chip->buffers->ecccode[i] = chip->oob_poi[eccpos[i + index]];
+		chip->buffers.ecccode[i] = chip->oob_poi[eccpos[i + index]];
 
 	p = bufpoi + data_col_addr;
 	for (i = 0; i < eccfrag_len ; i += chip->ecc.bytes, p += chip->ecc.size) {
 		int stat;
 
 		stat = chip->ecc.correct(mtd, p,
-			&chip->buffers->ecccode[i], &chip->buffers->ecccalc[i]);
+			&chip->buffers.ecccode[i], &chip->buffers.ecccalc[i]);
 		if (stat < 0) {
 			mtd->ecc_stats.failed++;
 		} else {
@@ -1218,8 +1218,8 @@ static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
-	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
+	uint8_t *ecc_code = chip->buffers.ecccode;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	unsigned int max_bitflips = 0;
 
@@ -1271,9 +1271,9 @@ static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
-	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint8_t *ecc_code = chip->buffers.ecccode;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
 	unsigned int max_bitflips = 0;
 
 	/* Read the OOB area first */
@@ -1452,7 +1452,7 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 
 		/* Is the current page in the buffer? */
 		if (realpage != chip->pagebuf || oob) {
-			bufpoi = aligned ? buf : chip->buffers->databuf;
+			bufpoi = aligned ? buf : chip->buffers.databuf;
 
 			chip->cmdfunc(mtd, NAND_CMD_READ0, 0x00, page);
 
@@ -1491,7 +1491,7 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 					/* Invalidate page cache */
 					chip->pagebuf = -1;
 				}
-				memcpy(buf, chip->buffers->databuf + col, bytes);
+				memcpy(buf, chip->buffers.databuf + col, bytes);
 			}
 
 			buf += bytes;
@@ -1514,7 +1514,7 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 					nand_wait_ready(mtd);
 			}
 		} else {
-			memcpy(buf, chip->buffers->databuf + col, bytes);
+			memcpy(buf, chip->buffers.databuf + col, bytes);
 			buf += bytes;
 			max_bitflips = max_t(unsigned int, max_bitflips,
 					     chip->pagebuf_bitflips);
@@ -1932,7 +1932,7 @@ static int nand_write_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 	int i, eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
 	const uint8_t *p = buf;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
 
@@ -1959,7 +1959,7 @@ static int nand_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 	int i, eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
 	const uint8_t *p = buf;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
 
@@ -1993,7 +1993,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 				int oob_required)
 {
 	uint8_t *oob_buf  = chip->oob_poi;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
 	int ecc_size      = chip->ecc.size;
 	int ecc_bytes     = chip->ecc.bytes;
 	int ecc_steps     = chip->ecc.steps;
@@ -2028,7 +2028,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 
 	/* copy calculated ECC for whole page to chip->buffer->oob */
 	/* this include masked-value(0xFF) for unwritten subpages */
-	ecc_calc = chip->buffers->ecccalc;
+	ecc_calc = chip->buffers.ecccalc;
 	for (i = 0; i < chip->ecc.total; i++)
 		chip->oob_poi[eccpos[i]] = ecc_calc[i];
 
@@ -2282,9 +2282,9 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
 			cached = 0;
 			bytes = min_t(int, bytes - column, (int) writelen);
 			chip->pagebuf = -1;
-			memset(chip->buffers->databuf, 0xff, mtd->writesize);
-			memcpy(&chip->buffers->databuf[column], buf, bytes);
-			wbuf = chip->buffers->databuf;
+			memset(chip->buffers.databuf, 0xff, mtd->writesize);
+			memcpy(&chip->buffers.databuf[column], buf, bytes);
+			wbuf = chip->buffers.databuf;
 		}
 
 		if (unlikely(oob)) {
@@ -3564,13 +3564,21 @@ int nand_scan_tail(struct mtd_info *mtd)
 	BUG_ON((chip->bbt_options & NAND_BBT_NO_OOB_BBM) &&
 			!(chip->bbt_options & NAND_BBT_USE_FLASH));
 
-	if (!(chip->options & NAND_OWN_BUFFERS))
-		chip->buffers = kmalloc(sizeof(*chip->buffers), GFP_KERNEL);
-	if (!chip->buffers)
+	if (!(chip->options & NAND_OWN_BUFFERS)) {
+		chip->buffers.buffer =
+			kmalloc(mtd->oobsize * 3 + mtd->writesize, GFP_KERNEL);
+		if (!chip->buffers.buffer)
+			return -ENOMEM;
+
+		chip->buffers.ecccalc = chip->buffers.buffer;
+		chip->buffers.ecccode = chip->buffers.ecccalc + mtd->oobsize;
+		chip->buffers.databuf = chip->buffers.ecccode + mtd->oobsize;
+	}
+	if (!chip->buffers.buffer)
 		return -ENOMEM;
 
 	/* Set the internal oob buffer location, just after the page data */
-	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
+	chip->oob_poi = chip->buffers.databuf + mtd->writesize;
 
 	/*
 	 * If no default placement scheme is given, select an appropriate one.
@@ -3886,8 +3894,10 @@ void nand_release(struct mtd_info *mtd)
 
 	/* Free bad block table memory */
 	kfree(chip->bbt);
-	if (!(chip->options & NAND_OWN_BUFFERS))
-		kfree(chip->buffers);
+	if (!(chip->options & NAND_OWN_BUFFERS)) {
+		kfree(chip->buffers.buffer);
+		chip->buffers.buffer = NULL;
+	}
 
 	/* Free bad block descriptor memory */
 	if (chip->badblock_pattern && chip->badblock_pattern->options
diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index c0615d1..5cc4253 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -829,7 +829,7 @@ static inline int nand_memory_bbt(struct mtd_info *mtd, struct nand_bbt_descr *b
 {
 	struct nand_chip *this = mtd->priv;
 
-	return create_bbt(mtd, this->buffers->databuf, bd, -1);
+	return create_bbt(mtd, this->buffers.databuf, bd, -1);
 }
 
 /**
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index f777250..c67986d 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1519,7 +1519,7 @@ static int omap_write_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
 				  const uint8_t *buf, int oob_required)
 {
 	int i;
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
 
 	/* Enable GPMC ecc engine */
@@ -1557,8 +1557,8 @@ static int omap_write_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
 static int omap_read_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int oob_required, int page)
 {
-	uint8_t *ecc_calc = chip->buffers->ecccalc;
-	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint8_t *ecc_calc = chip->buffers.ecccalc;
+	uint8_t *ecc_code = chip->buffers.ecccode;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	uint8_t *oob = &chip->oob_poi[eccpos[0]];
 	uint32_t oob_pos = mtd->writesize + chip->ecc.layout->eccpos[0];
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index f3ea8da..ce9466f 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -52,14 +52,6 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
 #define NAND_MAX_CHIPS		8
 
 /*
- * This constant declares the max. oobsize / page, which
- * is supported now. If you add a chip with bigger oobsize/page
- * adjust this accordingly.
- */
-#define NAND_MAX_OOBSIZE	744
-#define NAND_MAX_PAGESIZE	8192
-
-/*
  * Constants for hardware specific CLE/ALE/NCE function
  *
  * These are bits which can be or'ed to set/clear multiple
@@ -419,9 +411,10 @@ struct nand_ecc_ctrl {
  * consecutive order.
  */
 struct nand_buffers {
-	uint8_t	ecccalc[NAND_MAX_OOBSIZE];
-	uint8_t	ecccode[NAND_MAX_OOBSIZE];
-	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];
+	uint8_t *buffer;
+	uint8_t *ecccalc;
+	uint8_t *ecccode;
+	uint8_t *databuf;
 };
 
 /**
@@ -574,7 +567,7 @@ struct nand_chip {
 	struct nand_hw_control *controller;
 
 	struct nand_ecc_ctrl ecc;
-	struct nand_buffers *buffers;
+	struct nand_buffers buffers;
 	struct nand_hw_control hwcontrol;
 
 	uint8_t *bbt;
-- 
1.8.1.5

