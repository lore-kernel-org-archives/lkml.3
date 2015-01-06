Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbbAFRvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:51:32 -0500
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:4545
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752047AbbAFRv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:51:29 -0500
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
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH v5 2/3] nand: pl353: Add software ecc support
Date: Tue, 6 Jan 2015 23:21:11 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1420566672-6870-1-git-send-email-punnaia@xilinx.com>
References: <1420566672-6870-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21228.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <90461bcb47ac434a9ef9ef9968879825@BN1AFFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(87936001)(92566001)(64706001)(47776003)(2201001)(20776003)(62966003)(86362001)(76176999)(2950100001)(92726002)(6806004)(89996001)(50986999)(19580405001)(19580395003)(50466002)(74316001)(48376002)(120916001)(21056001)(99396003)(46102003)(53416004)(106466001)(33646002)(107046002)(229853001)(77156002)(31966008)(50226001)(4396001)(921003)(107986001)(24736002)(83996005)(1121003)(2101003)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB014;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB014;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1AFFO11HUB014;
X-Forefront-PRVS: 0448A97BF2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB014;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 17:51:26.9968
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1AFFO11HUB014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added software ecc support.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v5:
- None
Changes in v4:
- Updated the driver to sync with pl353_smc driver APIs
---
 drivers/mtd/nand/pl353_nand.c |  164 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 164 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/pl353_nand.c b/drivers/mtd/nand/pl353_nand.c
index 622d94f..ef5f6d2 100644
--- a/drivers/mtd/nand/pl353_nand.c
+++ b/drivers/mtd/nand/pl353_nand.c
@@ -327,6 +327,71 @@ static int pl353_nand_write_oob(struct mtd_info *mtd, struct nand_chip *chip,
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
@@ -392,6 +457,39 @@ static int pl353_nand_write_page_hwecc(struct mtd_info *mtd,
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
@@ -473,6 +571,52 @@ static int pl353_nand_read_page_hwecc(struct mtd_info *mtd,
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
@@ -697,6 +841,8 @@ static int pl353_nand_ecc_init(struct mtd_info *mtd)
 	nand_chip->ecc.read_oob = pl353_nand_read_oob;
 	nand_chip->ecc.write_oob = pl353_nand_write_oob;
 	nand_chip->ecc.strength = 1;
+	nand_chip->ecc.read_page_raw = pl353_nand_read_page_raw;
+	nand_chip->ecc.write_page_raw = pl353_nand_write_page_raw;
 
 	switch (xnand->ecc_mode) {
 	case NAND_ECC_HW:
@@ -723,6 +869,24 @@ static int pl353_nand_ecc_init(struct mtd_info *mtd)
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

