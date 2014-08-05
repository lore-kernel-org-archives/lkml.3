Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaHEKNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:13:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59621 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbaHEKMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:12:43 -0400
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <pekon.gupta@gmail.com>, <artem.bityutskiy@linux.intel.com>,
        <dwmw2@infradead.org>, <jg1.han@samsung.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/3] mtd: nand: omap: Revert to using software ECC by default
Date: Tue, 5 Aug 2014 13:11:20 +0300
Message-ID: <1407233482-11642-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407233482-11642-1-git-send-email-rogerq@ti.com>
References: <1407233482-11642-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For v3.12 and prior, 1-bit Hamming code ECC via software was the
default choice. Commit c66d039197e4 in v3.13 changed the behaviour
to use 1-bit Hamming code via Hardware using a different ECC layout
i.e. (ROM code layout) than what is used by software ECC.

This ECC layout change causes NAND filesystems created in v3.12
and prior to be unusable in v3.13 and later. So revert back to
using software ECC by default if an ECC scheme is not explicitely
specified.

This defect can be observed on the following boards during legacy boot

-omap3beagle
-omap3touchbook
-overo
-am3517crane
-devkit8000
-ldp
-3430sdp

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-flash.c            |  2 +-
 arch/arm/mach-omap2/gpmc-nand.c              |  3 ++-
 drivers/mtd/nand/omap2.c                     | 14 +++++++++++---
 include/linux/platform_data/mtd-nand-omap2.h | 13 +++++++++++--
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index e87f2a8..2d245c2 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -142,7 +142,7 @@ __init board_nand_init(struct mtd_partition *nand_parts, u8 nr_parts, u8 cs,
 	board_nand_data.nr_parts	= nr_parts;
 	board_nand_data.devsize		= nand_type;
 
-	board_nand_data.ecc_opt = OMAP_ECC_HAM1_CODE_HW;
+	board_nand_data.ecc_opt = OMAP_ECC_HAM1_CODE_SW;
 	gpmc_nand_init(&board_nand_data, gpmc_t);
 }
 #endif /* CONFIG_MTD_NAND_OMAP2 || CONFIG_MTD_NAND_OMAP2_MODULE */
diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 93914d2..03b6f95 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -68,7 +68,8 @@ static bool gpmc_hwecc_bch_capable(enum omap_ecc ecc_opt)
 		return 0;
 
 	/* legacy platforms support only HAM1 (1-bit Hamming) ECC scheme */
-	if (ecc_opt == OMAP_ECC_HAM1_CODE_HW)
+	if (ecc_opt == OMAP_ECC_HAM1_CODE_HW ||
+	    ecc_opt == OMAP_ECC_HAM1_CODE_SW)
 		return 1;
 	else
 		return 0;
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index f0ed92e..4dd6178 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1794,9 +1794,12 @@ static int omap_nand_probe(struct platform_device *pdev)
 	}
 
 	/* populate MTD interface based on ECC scheme */
-	nand_chip->ecc.layout	= &omap_oobinfo;
 	ecclayout		= &omap_oobinfo;
 	switch (info->ecc_opt) {
+	case OMAP_ECC_HAM1_CODE_SW:
+		nand_chip->ecc.mode = NAND_ECC_SOFT;
+		break;
+
 	case OMAP_ECC_HAM1_CODE_HW:
 		pr_info("nand: using OMAP_ECC_HAM1_CODE_HW\n");
 		nand_chip->ecc.mode             = NAND_ECC_HW;
@@ -1848,7 +1851,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 		nand_chip->ecc.priv		= nand_bch_init(mtd,
 							nand_chip->ecc.size,
 							nand_chip->ecc.bytes,
-							&nand_chip->ecc.layout);
+							&ecclayout);
 		if (!nand_chip->ecc.priv) {
 			pr_err("nand: error: unable to use s/w BCH library\n");
 			err = -EINVAL;
@@ -1923,7 +1926,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 		nand_chip->ecc.priv		= nand_bch_init(mtd,
 							nand_chip->ecc.size,
 							nand_chip->ecc.bytes,
-							&nand_chip->ecc.layout);
+							&ecclayout);
 		if (!nand_chip->ecc.priv) {
 			pr_err("nand: error: unable to use s/w BCH library\n");
 			err = -EINVAL;
@@ -2012,6 +2015,9 @@ static int omap_nand_probe(struct platform_device *pdev)
 		goto return_error;
 	}
 
+	if (info->ecc_opt == OMAP_ECC_HAM1_CODE_SW)
+		goto scan_tail;
+
 	/* all OOB bytes from oobfree->offset till end off OOB are free */
 	ecclayout->oobfree->length = mtd->oobsize - ecclayout->oobfree->offset;
 	/* check if NAND device's OOB is enough to store ECC signatures */
@@ -2021,7 +2027,9 @@ static int omap_nand_probe(struct platform_device *pdev)
 		err = -EINVAL;
 		goto return_error;
 	}
+	nand_chip->ecc.layout = ecclayout;
 
+scan_tail:
 	/* second phase scan */
 	if (nand_scan_tail(mtd)) {
 		err = -ENXIO;
diff --git a/include/linux/platform_data/mtd-nand-omap2.h b/include/linux/platform_data/mtd-nand-omap2.h
index 660c029..16ec262 100644
--- a/include/linux/platform_data/mtd-nand-omap2.h
+++ b/include/linux/platform_data/mtd-nand-omap2.h
@@ -21,8 +21,17 @@ enum nand_io {
 };
 
 enum omap_ecc {
-	/* 1-bit  ECC calculation by GPMC, Error detection by Software */
-	OMAP_ECC_HAM1_CODE_HW = 0,
+	/*
+	 * 1-bit ECC: calculation and correction by SW
+	 * ECC stored at end of spare area
+	 */
+	OMAP_ECC_HAM1_CODE_SW = 0,
+
+	/*
+	 * 1-bit ECC: calculation by GPMC, Error detection by Software
+	 * ECC layout compatible with ROM code layout
+	 */
+	OMAP_ECC_HAM1_CODE_HW,
 	/* 4-bit  ECC calculation by GPMC, Error detection by Software */
 	OMAP_ECC_BCH4_CODE_HW_DETECTION_SW,
 	/* 4-bit  ECC calculation by GPMC, Error detection by ELM */
-- 
1.8.3.2

