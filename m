Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaG1Pb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:31:59 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:18254
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751946AbaG1Pby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:31:54 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>,
        <arnd@arndb.de>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <artem.bityutskiy@linux.intel.com>, <pekon@ti.com>,
        <jussi.kivilinna@iki.fi>, <acourbot@nvidia.com>,
        <ivan.khoronzhuk@ti.com>, <joern@logfs.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        <anirudh@xilinx.com>, <svemula@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH RFC v4 2/4] nand: pl353: Add software ecc support
Date: Mon, 28 Jul 2014 21:01:38 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1406561500-18264-1-git-send-email-punnaia@xilinx.com>
References: <1406561500-18264-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <1ed93a4e-8a0e-4caa-a1e8-d39cf9c8e8e2@BN1BFFO11FD037.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(77982001)(104016003)(86362001)(4396001)(229853001)(93916002)(21056001)(6806004)(85852003)(70736001)(77096002)(83072002)(92566001)(31696002)(92726001)(74502001)(99396002)(79102001)(20776003)(81342001)(50226001)(33646002)(47776003)(107046002)(64706001)(1496007)(2201001)(95666004)(76176999)(46102001)(106466001)(85306003)(48376002)(74662001)(76482001)(87936001)(104166001)(80022001)(53416004)(89996001)(74316001)(62966002)(77156001)(88136002)(44976005)(83322001)(50466002)(81542001)(50986999)(87286001)(19580405001)(19580395003)(31966008)(102836001)(921003)(1121002)(107986001)(2101003)(217873001)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB060;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added software ecc support.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v4:
- Updated the driver to sync with pl353_smc driver APIs
---
 drivers/mtd/nand/pl353_nand.c |  164 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 164 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/pl353_nand.c b/drivers/mtd/nand/pl353_nand.c
index f97f428..93dc4ca 100644
--- a/drivers/mtd/nand/pl353_nand.c
+++ b/drivers/mtd/nand/pl353_nand.c
@@ -319,6 +319,71 @@ static int pl353_nand_write_oob(struct mtd_info *mtd, struct nand_chip *chip,
 }
 
 /**
+ * pl353_nand_read_page_raw - [Intern] read raw page data without ecc
+ * @mtd:		Pointer to the mtd info structure
+ * @chip:		Pointer to the NAND chip info structure
+ * @buf:		Pointer to the data buffer
+ * @oob_required:	Caller requires OOB data read to chip->oob_poi
+ * @page:		Page number to read
+ *
+ * Return:	Always return zero
+ */
+static int pl353_nand_read_page_raw(struct mtd_info *mtd,
+				struct nand_chip *chip,
+				uint8_t *buf, int oob_required, int page)
+{
+	unsigned long data_phase_addr;
+	uint8_t *p;
+
+	chip->read_buf(mtd, buf, mtd->writesize);
+
+	p = chip->oob_poi;
+	chip->read_buf(mtd, p,
+			(mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+	p += (mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_R;
+	data_phase_addr |= PL353_NAND_CLEAR_CS;
+	chip->IO_ADDR_R = (void __iomem * __force)data_phase_addr;
+
+	chip->read_buf(mtd, p, PL353_NAND_LAST_TRANSFER_LENGTH);
+	return 0;
+}
+
+/**
+ * pl353_nand_write_page_raw - [Intern] raw page write function
+ * @mtd:		Pointer to the mtd info structure
+ * @chip:		Pointer to the NAND chip info structure
+ * @buf:		Pointer to the data buffer
+ * @oob_required:	Caller requires OOB data read to chip->oob_poi
+ *
+ * Return:	Always return zero
+ */
+static int pl353_nand_write_page_raw(struct mtd_info *mtd,
+				    struct nand_chip *chip,
+				    const uint8_t *buf, int oob_required)
+{
+	unsigned long data_phase_addr;
+	uint8_t *p;
+
+	chip->write_buf(mtd, buf, mtd->writesize);
+
+	p = chip->oob_poi;
+	chip->write_buf(mtd, p,
+			(mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+	p += (mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_W;
+	data_phase_addr |= PL353_NAND_CLEAR_CS;
+	data_phase_addr |= (1 << END_CMD_VALID_SHIFT);
+	chip->IO_ADDR_W = (void __iomem * __force)data_phase_addr;
+
+	chip->write_buf(mtd, p, PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	return 0;
+}
+
+/**
  * nand_write_page_hwecc - Hardware ECC based page write function
  * @mtd:		Pointer to the mtd info structure
  * @chip:		Pointer to the NAND chip info structure
@@ -384,6 +449,39 @@ static int pl353_nand_write_page_hwecc(struct mtd_info *mtd,
 }
 
 /**
+ * pl353_nand_write_page_swecc - [REPLACABLE] software ecc based page write
+ * function
+ * @mtd:		Pointer to the mtd info structure
+ * @chip:		Pointer to the NAND chip info structure
+ * @buf:		Pointer to the data buffer
+ * @oob_required:	Caller requires OOB data read to chip->oob_poi
+ *
+ * Return:	Always return zero
+ */
+static int pl353_nand_write_page_swecc(struct mtd_info *mtd,
+				    struct nand_chip *chip, const uint8_t *buf,
+				    int oob_required)
+{
+	int i, eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	int eccsteps = chip->ecc.steps;
+	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	const uint8_t *p = buf;
+	uint32_t *eccpos = chip->ecc.layout->eccpos;
+
+	/* Software ecc calculation */
+	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
+		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+
+	for (i = 0; i < chip->ecc.total; i++)
+		chip->oob_poi[eccpos[i]] = ecc_calc[i];
+
+	chip->ecc.write_page_raw(mtd, chip, buf, 1);
+
+	return 0;
+}
+
+/**
  * pl353_nand_read_page_hwecc - Hardware ECC based page read function
  * @mtd:		Pointer to the mtd info structure
  * @chip:		Pointer to the NAND chip info structure
@@ -465,6 +563,52 @@ static int pl353_nand_read_page_hwecc(struct mtd_info *mtd,
 }
 
 /**
+ * pl353_nand_read_page_swecc - [REPLACABLE] software ecc based page read
+ * function
+ * @mtd:		Pointer to the mtd info structure
+ * @chip:		Pointer to the NAND chip info structure
+ * @buf:		Pointer to the buffer to store read data
+ * @oob_required:	Caller requires OOB data read to chip->oob_poi
+ * @page:		Page number to read
+ *
+ * Return:	Always return zero
+ */
+static int pl353_nand_read_page_swecc(struct mtd_info *mtd,
+				     struct nand_chip *chip,
+				     uint8_t *buf,  int oob_required, int page)
+{
+	int i, eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	int eccsteps = chip->ecc.steps;
+	uint8_t *p = buf;
+	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint32_t *eccpos = chip->ecc.layout->eccpos;
+
+	chip->ecc.read_page_raw(mtd, chip, buf, page, 1);
+
+	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
+		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+
+	for (i = 0; i < chip->ecc.total; i++)
+		ecc_code[i] = chip->oob_poi[eccpos[i]];
+
+	eccsteps = chip->ecc.steps;
+	p = buf;
+
+	for (i = 0 ; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
+		int stat;
+
+		stat = chip->ecc.correct(mtd, p, &ecc_code[i], &ecc_calc[i]);
+		if (stat < 0)
+			mtd->ecc_stats.failed++;
+		else
+			mtd->ecc_stats.corrected += stat;
+	}
+	return 0;
+}
+
+/**
  * pl353_nand_select_chip - Select the flash device
  * @mtd:	Pointer to the mtd info structure
  * @chip:	Pointer to the NAND chip info structure
@@ -689,6 +833,8 @@ static int pl353_nand_ecc_init(struct mtd_info *mtd)
 	nand_chip->ecc.read_oob = pl353_nand_read_oob;
 	nand_chip->ecc.write_oob = pl353_nand_write_oob;
 	nand_chip->ecc.strength = 1;
+	nand_chip->ecc.read_page_raw = pl353_nand_read_page_raw;
+	nand_chip->ecc.write_page_raw = pl353_nand_write_page_raw;
 
 	switch (xnand->ecc_mode) {
 	case NAND_ECC_HW:
@@ -715,6 +861,24 @@ static int pl353_nand_ecc_init(struct mtd_info *mtd)
 			nand_chip->ecc.layout = &nand_oob_64;
 
 		break;
+	case NAND_ECC_SOFT:
+		/*
+		 * The software ECC routines won't work with the
+		 * SMC controller
+		 */
+		nand_chip->ecc.mode = NAND_ECC_HW;
+		nand_chip->ecc.calculate = nand_calculate_ecc;
+		nand_chip->ecc.correct = nand_correct_data;
+		nand_chip->ecc.read_page = pl353_nand_read_page_swecc;
+		nand_chip->ecc.write_page = pl353_nand_write_page_swecc;
+		nand_chip->ecc.size = 256;
+		nand_chip->ecc.bytes = 3;
+		/* Bypass the controller ECC block */
+		pl353_smc_set_ecc_pg_size(mtd->dev.parent, mtd->writesize);
+		pl353_smc_set_ecc_mode(mtd->dev.parent,
+					PL353_SMC_ECCMODE_BYPASS);
+
+		break;
 	default:
 		return -ENOTSUPP;
 	}
-- 
1.7.4


