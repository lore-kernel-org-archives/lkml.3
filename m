Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaJAO7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:59:40 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39187 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaJAO7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:59:36 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <lisovy@merica.cz>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>, pekon gupta <pekon@ti.com>,
        Tony Lindgren <tony@atomide.com>, Roger Quadros <rogerq@ti.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lisovy@gmail.com, michal.vokac@comap.cz, sojkam1@fel.cvut.cz,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: [PATCH 1/2] mtd: nand: omap: Do not use global variables
Date: Wed,  1 Oct 2014 16:59:13 +0200
Message-Id: <1412175554-19391-1-git-send-email-lisovy@merica.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the commit 97a288ba2cfa ("ARM: omap2+: gpmc-nand: Use
dynamic platform_device_alloc()") gpmc-nand driver supports
multiple NAND flash devices connected to the single controller.
Remove global variable to make the code thread-safe.

Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
---
 drivers/mtd/nand/omap2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 5967b38..24d5c6a 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -146,8 +146,6 @@ static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
 static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
 #endif
 
-/* oob info generated runtime depending on ecc algorithm and layout selected */
-static struct nand_ecclayout omap_oobinfo;
 
 struct omap_nand_info {
 	struct nand_hw_control		controller;
@@ -1794,7 +1792,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 	}
 
 	/* populate MTD interface based on ECC scheme */
-	ecclayout		= &omap_oobinfo;
+	ecclayout		= kzalloc(sizeof(*ecclayout), GFP_KERNEL);
 	switch (info->ecc_opt) {
 	case OMAP_ECC_HAM1_CODE_SW:
 		nand_chip->ecc.mode = NAND_ECC_SOFT;
-- 
1.9.1

