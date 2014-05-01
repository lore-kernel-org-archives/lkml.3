Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbaEAKBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:01:19 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:51615 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbaEAJ6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 37/47] mtd: nand: stm_nand_bch: load flash-resident BBT
Date: Thu,  1 May 2014 10:56:44 +0100
Message-Id: <1398938214-17847-38-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If load of existing BBT fails (first run), scan device for factory-set
BBMs (Bad-Block Markers) and create a new flash-resident.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 2df452b..a06dca8 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1235,6 +1235,30 @@ static int bch_load_bbt(struct nandi_controller *nandi,
 	return 0;
 }
 
+static int bch_scan_bbt(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	struct nandi_bbt_info *bbt_info = &nandi->info.bbt_info;
+	int err;
+	/* Load Flash-resident BBT */
+	err = bch_load_bbt(nandi, bbt_info);
+	if (err) {
+		dev_warn(nandi->dev,
+			"failed to find BBTs:"
+			"  scanning device for bad-block markers\n");
+
+		/* Scan, build, and write BBT */
+		nandi_scan_build_bbt(nandi, bbt_info);
+		err = bch_update_bbts(nandi, bbt_info, NAND_IBBT_UPDATE_BOTH,
+				      bbt_info->bbt_vers[0] + 1);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 /*
  * Initialisation
  */
@@ -1318,6 +1342,8 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 
 	chip->ecc.read_page = bch_read;
 	chip->write_page = bch_write;
+
+	chip->scan_bbt = bch_scan_bbt;
 }
 
 /*
-- 
1.8.3.2

