Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaCDUEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbaCDUER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Stefan Roese <sr@denx.de>, Pekon Gupta <pekon@ti.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.13 131/172] mtd: nand: omap: fix ecclayout->oobfree->offset
Date: Tue,  4 Mar 2014 12:03:35 -0800
Message-Id: <20140304200303.901237106@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekon Gupta <pekon@ti.com>

commit aa6092f9835893290e77c3e24649def49dac1583 upstream.

1) In current implementation, ecclayout->oobfree->offset is calculated with
 respect to ecclayout->eccpos[0] which is incorrect because ECC bytes may not
 be stored contiguously in OOB.
 So, this patch calculates ecclayout->oobfree->offset with respect to last
 ECC byte-position 'eccpos[ecclayout->eccbytes-1]'.

2) ECC layout of some ecc-schemes expects reserved-markers at specific eccpos[]
 which should not be over-written by any file-system metadata.
 So this patch aligns oobfree->offset taking into account of such markers.

Tested-by: Enric Balletbo i Serra <eballetbo@gmail.com>
Tested-by: Stefan Roese <sr@denx.de>
Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/omap2.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1838,8 +1838,9 @@ static int omap_nand_probe(struct platfo
 			oob_index		= 1;
 		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++)
 			ecclayout->eccpos[i]	= oob_index;
-		ecclayout->oobfree->offset	= ecclayout->eccpos[0] +
-							ecclayout->eccbytes;
+		/* no reserved-marker in ecclayout for this ecc-scheme */
+		ecclayout->oobfree->offset	=
+				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		break;
 
 	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
@@ -1862,8 +1863,9 @@ static int omap_nand_probe(struct platfo
 			if (((i + 1) % nand_chip->ecc.bytes) == 0)
 				oob_index++;
 		}
-		ecclayout->oobfree->offset	= ecclayout->eccpos[0] +
-							ecclayout->eccbytes;
+		/* include reserved-marker in ecclayout->oobfree calculation */
+		ecclayout->oobfree->offset	= 1 +
+				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		/* software bch library is used for locating errors */
 		nand_chip->ecc.priv		= nand_bch_init(mtd,
 							nand_chip->ecc.size,
@@ -1900,8 +1902,9 @@ static int omap_nand_probe(struct platfo
 		oob_index			= BADBLOCK_MARKER_LENGTH;
 		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++)
 			ecclayout->eccpos[i]	= oob_index;
-		ecclayout->oobfree->offset	= ecclayout->eccpos[0] +
-							ecclayout->eccbytes;
+		/* reserved marker already included in ecclayout->eccbytes */
+		ecclayout->oobfree->offset	=
+				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		/* This ECC scheme requires ELM H/W block */
 		if (is_elm_present(info, pdata->elm_of_node, BCH4_ECC) < 0) {
 			pr_err("nand: error: could not initialize ELM\n");
@@ -1935,8 +1938,9 @@ static int omap_nand_probe(struct platfo
 			if (((i + 1) % nand_chip->ecc.bytes) == 0)
 				oob_index++;
 		}
-		ecclayout->oobfree->offset	= ecclayout->eccpos[0] +
-							ecclayout->eccbytes;
+		/* include reserved-marker in ecclayout->oobfree calculation */
+		ecclayout->oobfree->offset	= 1 +
+				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		/* software bch library is used for locating errors */
 		nand_chip->ecc.priv		= nand_bch_init(mtd,
 							nand_chip->ecc.size,
@@ -1980,8 +1984,9 @@ static int omap_nand_probe(struct platfo
 		oob_index			= BADBLOCK_MARKER_LENGTH;
 		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++)
 			ecclayout->eccpos[i]	= oob_index;
-		ecclayout->oobfree->offset	= ecclayout->eccpos[0] +
-							ecclayout->eccbytes;
+		/* reserved marker already included in ecclayout->eccbytes */
+		ecclayout->oobfree->offset	=
+				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		break;
 #else
 		pr_err("nand: error: CONFIG_MTD_NAND_OMAP_BCH not enabled\n");


