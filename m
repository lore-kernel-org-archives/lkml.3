Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3AXHJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:09:04 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:11714
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab3AXHIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:08:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <shmulik.ladkani@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 3/3] mtd: add the new detection method for the unparsable nand chips
Date: Thu, 24 Jan 2013 14:11:41 +0800
Message-ID: <1359007901-26464-4-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359007901-26464-1-git-send-email-b32955@freescale.com>
References: <1359007901-26464-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new detection method find_nand_type_by_fullid() for the
unparsable nand chips. The new detection method is called firstly
before all the other detection methods.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 0e80ec4..7f0431d 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3152,6 +3152,29 @@ static void nand_decode_bbm_options(struct mtd_info *mtd,
 		chip->bbt_options |= NAND_BBT_SCAN2NDPAGE;
 }
 
+static struct nand_flash_dev *find_nand_type_by_fullid(struct mtd_info *mtd,
+				struct nand_chip *chip, u8 *id_data, int *busw)
+{
+	struct nand_flash_dev *type = nand_flash_full_ids;
+
+	for (; type->name != NULL; type++) {
+		if (!strncmp(type->id, id_data, type->id_len)) {
+			mtd->writesize = type->pagesize;
+			mtd->erasesize = type->erasesize;
+			mtd->oobsize = type->oobsize;
+
+			chip->cellinfo = id_data[2];
+			chip->chipsize = (uint64_t)type->chipsize << 20;
+			chip->options |= type->options;
+
+			*busw = type->options & NAND_BUSWIDTH_16;
+
+			break;
+		}
+	}
+	return type;
+}
+
 /*
  * Get the flash and manufacturer id and lookup if the type is supported.
  */
@@ -3200,8 +3223,16 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 		return ERR_PTR(-ENODEV);
 	}
 
-	if (!type)
+	if (!type) {
+		/*
+		 * Some nand chips's information can not be paresed out
+		 * from the id data. So, try your luck in the full-id table.
+		 */
+		type = find_nand_type_by_fullid(mtd, chip, id_data, &busw);
+		if (type->name != NULL)
+			goto ident_done;
 		type = nand_flash_ids;
+	}
 
 	for (; type->name != NULL; type++)
 		if (*dev_id == type->id[1])
-- 
1.7.0.4


