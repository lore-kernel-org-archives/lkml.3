Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaCYIV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63463 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaCYIVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 34/47] mtd: nand: stm_nand_bch: load flash-resident BBT
Date: Tue, 25 Mar 2014 08:19:51 +0000
Message-Id: <1395735604-26706-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If load of existing BBT fails (first run), scan device for factory-set
BBMs (Bad-Block Markers) and create a new flash-resident.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index d1d84c1..6698b1f 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1834,6 +1834,21 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
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
 	return 0;
 }
 
-- 
1.8.3.2

