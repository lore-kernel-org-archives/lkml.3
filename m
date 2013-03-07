Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3CGKwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:52:39 -0500
Received: from [216.32.181.184] ([216.32.181.184]:44967 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932618Ab3CGKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:52:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH V4 3/3] mtd: add the support to parse out the full-id nand type
Date: Thu, 7 Mar 2013 18:49:24 +0800
Message-ID: <1362653364-29993-4-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1362653364-29993-1-git-send-email-b32955@freescale.com>
References: <1362653364-29993-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we meet a full-id nand type which @mfr_id is true, we can use
the find_full_id_nand() to parse out the neccessary information for a
nand chip.

If we meet a non full-id nand type, we can handle it in the lagacy way.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |   36 +++++++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 29c0378..b9a24ff 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3074,6 +3074,30 @@ static void nand_decode_bbm_options(struct mtd_info *mtd,
 		chip->bbt_options |= NAND_BBT_SCAN2NDPAGE;
 }
 
+static inline bool is_full_id_nand(struct nand_flash_dev *type)
+{
+	return type->mfr_id;
+}
+
+static bool find_full_id_nand(struct mtd_info *mtd, struct nand_chip *chip,
+		   struct nand_flash_dev *type, u8 *id_data, int *busw)
+{
+	if (!strncmp(type->id, id_data, type->id_len)) {
+		mtd->writesize = type->pagesize;
+		mtd->erasesize = type->erasesize;
+		mtd->oobsize = type->oobsize;
+
+		chip->cellinfo = id_data[2];
+		chip->chipsize = (uint64_t)type->chipsize << 20;
+		chip->options |= type->options;
+
+		*busw = type->options & NAND_BUSWIDTH_16;
+
+		return true;
+	}
+	return false;
+}
+
 /*
  * Get the flash and manufacturer id and lookup if the type is supported.
  */
@@ -3125,9 +3149,15 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 	if (!type)
 		type = nand_flash_ids;
 
-	for (; type->name != NULL; type++)
-		if (*dev_id == type->dev_id)
-			break;
+	for (; type->name != NULL; type++) {
+		if (is_full_id_nand(type)) {
+			if (find_full_id_nand(mtd, chip, type, id_data, &busw))
+				goto ident_done;
+		} else {
+			if (*dev_id == type->dev_id)
+				break;
+		}
+	}
 
 	chip->onfi_version = 0;
 	if (!type->name || !type->pagesize) {
-- 
1.7.1


