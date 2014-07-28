Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaG1PcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:32:18 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:54962
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752909AbaG1PcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:32:12 -0400
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
Subject: [PATCH RFC v4 3/4] nand: pl353: Add ONDIE ECC support
Date: Mon, 28 Jul 2014 21:01:39 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1406561500-18264-1-git-send-email-punnaia@xilinx.com>
References: <1406561500-18264-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <27fce982-6598-44a0-ad80-c13d02a952ee@BN1AFFO11FD042.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(102836001)(104166001)(77982001)(80022001)(81542001)(46102001)(76482001)(20776003)(4396001)(19580395003)(50226001)(31966008)(44976005)(87286001)(77156001)(6806004)(88136002)(74662001)(21056001)(74316001)(47776003)(2201001)(79102001)(70736001)(64706001)(83322001)(85852003)(81342001)(229853001)(83072002)(107046002)(77096002)(85306003)(106466001)(95666004)(50466002)(33646002)(1496007)(74502001)(31696002)(76176999)(62966002)(87936001)(92566001)(99396002)(89996001)(104016003)(48376002)(86362001)(93916002)(53416004)(92726001)(50986999)(19580405001)(1121002)(107986001)(921003)(217873001)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB005;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
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

Added ONDIE ECC support. Currently this ecc mode is supported for
specific micron parts with oob size 64 bytes.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v4:
- Updated the driver to sync with pl353_smc driver APIs
---
 drivers/mtd/nand/pl353_nand.c |  162 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 144 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/nand/pl353_nand.c b/drivers/mtd/nand/pl353_nand.c
index 93dc4ca..5c9b60d 100644
--- a/drivers/mtd/nand/pl353_nand.c
+++ b/drivers/mtd/nand/pl353_nand.c
@@ -140,6 +140,48 @@ static struct nand_ecclayout nand_oob_64 = {
 		 .length = 50} }
 };
 
+static struct nand_ecclayout ondie_nand_oob_64 = {
+	.eccbytes = 32,
+
+	.eccpos = {
+		8, 9, 10, 11, 12, 13, 14, 15,
+		24, 25, 26, 27, 28, 29, 30, 31,
+		40, 41, 42, 43, 44, 45, 46, 47,
+		56, 57, 58, 59, 60, 61, 62, 63
+	},
+
+	.oobfree = {
+		{ .offset = 4, .length = 4 },
+		{ .offset = 20, .length = 4 },
+		{ .offset = 36, .length = 4 },
+		{ .offset = 52, .length = 4 }
+	}
+};
+
+/* Generic flash bbt decriptors */
+static uint8_t bbt_pattern[] = { 'B', 'b', 't', '0' };
+static uint8_t mirror_pattern[] = { '1', 't', 'b', 'B' };
+
+static struct nand_bbt_descr bbt_main_descr = {
+	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
+		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_PERCHIP,
+	.offs = 4,
+	.len = 4,
+	.veroffs = 20,
+	.maxblocks = 4,
+	.pattern = bbt_pattern
+};
+
+static struct nand_bbt_descr bbt_mirror_descr = {
+	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
+		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_PERCHIP,
+	.offs = 4,
+	.len = 4,
+	.veroffs = 20,
+	.maxblocks = 4,
+	.pattern = mirror_pattern
+};
+
 /**
  * pl353_nand_calculate_hwecc - Calculate Hardware ECC
  * @mtd:	Pointer to the mtd_info structure
@@ -816,15 +858,74 @@ static int pl353_nand_device_ready(struct mtd_info *mtd)
 }
 
 /**
+ * pl353_nand_detect_ondie_ecc - Get the flash ondie ecc state
+ * @mtd:	Pointer to the mtd_info structure
+ *
+ * This function enables the ondie ecc for the Micron ondie ecc capable devices
+ *
+ * Return:	1 on detect, 0 if fail to detect
+ */
+static int pl353_nand_detect_ondie_ecc(struct mtd_info *mtd)
+{
+	struct nand_chip *nand_chip = mtd->priv;
+	u8 maf_id, dev_id, i, get_feature;
+	u8 set_feature[4] = { 0x08, 0x00, 0x00, 0x00 };
+
+	/* Check if On-Die ECC flash */
+	nand_chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
+	nand_chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);
+
+	/* Read manufacturer and device IDs */
+	maf_id = readb(nand_chip->IO_ADDR_R);
+	dev_id = readb(nand_chip->IO_ADDR_R);
+
+	if ((maf_id == NAND_MFR_MICRON) &&
+	    ((dev_id == 0xf1) || (dev_id == 0xa1) ||
+	     (dev_id == 0xb1) || (dev_id == 0xaa) ||
+	     (dev_id == 0xba) || (dev_id == 0xda) ||
+	     (dev_id == 0xca) || (dev_id == 0xac) ||
+	     (dev_id == 0xbc) || (dev_id == 0xdc) ||
+	     (dev_id == 0xcc) || (dev_id == 0xa3) ||
+	     (dev_id == 0xb3) ||
+	     (dev_id == 0xd3) || (dev_id == 0xc3))) {
+
+		nand_chip->cmdfunc(mtd, NAND_CMD_GET_FEATURES,
+				   ONDIE_ECC_FEATURE_ADDR, -1);
+		get_feature = readb(nand_chip->IO_ADDR_R);
+
+		if (get_feature & 0x08) {
+			return 1;
+		} else {
+			nand_chip->cmdfunc(mtd, NAND_CMD_SET_FEATURES,
+					   ONDIE_ECC_FEATURE_ADDR, -1);
+			for (i = 0; i < 4; i++)
+				writeb(set_feature[i], nand_chip->IO_ADDR_W);
+
+			ndelay(1000);
+
+			nand_chip->cmdfunc(mtd, NAND_CMD_GET_FEATURES,
+					   ONDIE_ECC_FEATURE_ADDR, -1);
+			get_feature = readb(nand_chip->IO_ADDR_R);
+
+			if (get_feature & 0x08)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
  * pl353_nand_ecc_init - Initialize the ecc information as per the ecc mode
  * @mtd:	Pointer to the mtd_info structure
+ * @ondie_ecc_state:	ondie ecc status
  *
  * This function initializes the ecc block and functional pointers as per the
  * ecc mode
  *
  * Return:	Zero on success and error on failure.
  */
-static int pl353_nand_ecc_init(struct mtd_info *mtd)
+static int pl353_nand_ecc_init(struct mtd_info *mtd, int ondie_ecc_state)
 {
 	struct nand_chip *nand_chip = mtd->priv;
 	struct pl353_nand_info *xnand =
@@ -838,27 +939,50 @@ static int pl353_nand_ecc_init(struct mtd_info *mtd)
 
 	switch (xnand->ecc_mode) {
 	case NAND_ECC_HW:
-		if (mtd->writesize > 2048) {
+		if ((mtd->writesize > 2048) || ((ondie_ecc_state) &&
+						(mtd->oobsize != 64))) {
 			pr_warn("hardware ECC not possible\n");
 			return -ENOTSUPP;
 		}
 
 		nand_chip->ecc.mode = NAND_ECC_HW;
-		nand_chip->ecc.calculate = pl353_nand_calculate_hwecc;
-		nand_chip->ecc.correct = pl353_nand_correct_data;
-		nand_chip->ecc.hwctl = NULL;
-		nand_chip->ecc.read_page = pl353_nand_read_page_hwecc;
-		nand_chip->ecc.size = PL353_NAND_ECC_SIZE;
-		nand_chip->ecc.write_page = pl353_nand_write_page_hwecc;
-		pl353_smc_set_ecc_pg_size(mtd->dev.parent, mtd->writesize);
-		pl353_smc_set_ecc_mode(mtd->dev.parent, PL353_SMC_ECCMODE_APB);
-		/* Hardware ECC generates 3 bytes ECC code for each 512 bytes */
-		nand_chip->ecc.bytes = 3;
-
-		if (mtd->oobsize == 16)
-			nand_chip->ecc.layout = &nand_oob_16;
-		else
-			nand_chip->ecc.layout = &nand_oob_64;
+		if (ondie_ecc_state) {
+			/* Bypass the controller ECC block */
+			pl353_smc_set_ecc_mode(mtd->dev.parent,
+						PL353_SMC_ECCMODE_BYPASS);
+			nand_chip->ecc.bytes = 0;
+			nand_chip->ecc.layout = &ondie_nand_oob_64;
+			nand_chip->ecc.read_page = pl353_nand_read_page_raw;
+			nand_chip->ecc.write_page = pl353_nand_write_page_raw;
+			nand_chip->ecc.size = mtd->writesize;
+			/*
+			 * On-Die ECC spare bytes offset 8 is used for ECC codes
+			 * Use the BBT pattern descriptors
+			 */
+			nand_chip->bbt_td = &bbt_main_descr;
+			nand_chip->bbt_md = &bbt_mirror_descr;
+		} else {
+			nand_chip->ecc.calculate = pl353_nand_calculate_hwecc;
+			nand_chip->ecc.correct = pl353_nand_correct_data;
+			nand_chip->ecc.hwctl = NULL;
+			nand_chip->ecc.read_page = pl353_nand_read_page_hwecc;
+			nand_chip->ecc.size = PL353_NAND_ECC_SIZE;
+			nand_chip->ecc.write_page = pl353_nand_write_page_hwecc;
+			pl353_smc_set_ecc_pg_size(mtd->dev.parent,
+							mtd->writesize);
+			pl353_smc_set_ecc_mode(mtd->dev.parent,
+							PL353_SMC_ECCMODE_APB);
+			/*
+			 * Hardware ECC generates 3 bytes ECC code for each
+			 * 512 bytes
+			 */
+			nand_chip->ecc.bytes = 3;
+
+			if (mtd->oobsize == 16)
+				nand_chip->ecc.layout = &nand_oob_16;
+			else
+				nand_chip->ecc.layout = &nand_oob_64;
+		}
 
 		break;
 	case NAND_ECC_SOFT:
@@ -901,6 +1025,7 @@ static int pl353_nand_probe(struct platform_device *pdev)
 	struct nand_chip *nand_chip;
 	struct resource *res;
 	struct mtd_part_parser_data ppdata;
+	int ondie_ecc_state;
 
 	xnand = devm_kzalloc(&pdev->dev, sizeof(*xnand), GFP_KERNEL);
 	if (!xnand)
@@ -944,6 +1069,7 @@ static int pl353_nand_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, xnand);
 
+	ondie_ecc_state = pl353_nand_detect_ondie_ecc(mtd);
 	/* first scan to find the device and get the page size */
 	if (nand_scan_ident(mtd, 1, NULL)) {
 		dev_err(&pdev->dev, "nand_scan_ident for NAND failed\n");
@@ -954,7 +1080,7 @@ static int pl353_nand_probe(struct platform_device *pdev)
 	if (xnand->ecc_mode < 0)
 		xnand->ecc_mode = NAND_ECC_HW;
 
-	if (pl353_nand_ecc_init(mtd))
+	if (pl353_nand_ecc_init(mtd, ondie_ecc_state))
 		return -ENOTSUPP;
 
 	if (nand_chip->options & NAND_BUSWIDTH_16)
-- 
1.7.4


