Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbaGRNGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:06:33 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17178 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934154AbaGRNCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:02:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pekon gupta <pekon@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 077/170] mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page
Date: Fri, 18 Jul 2014 14:11:22 +0200
Message-Id: <62874b837dc5de00f3c8de646e80b73c52d75b01.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pekon gupta <pekon@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f306e8c3b667632952f1a4a74ffb910bbc06255f upstream.

fixes: commit 62116e5171e00f85a8d53f76e45b84423c89ff34
       mtd: nand: omap2: Support for hardware BCH error correction.

In omap_elm_correct_data(), if bitflip_count in an erased-page is within the
correctable limit (< ecc.strength), then it is not indicated back to the caller
ecc->read_page().

This mis-guides upper layers like MTD and UBIFS layer to assume erased-page as
perfectly clean and use it for writing even if actual bitflip_count was
dangerously high (bitflip_count > mtd->bitflip_threshold).

This patch fixes this above issue, by returning 'stats' to caller
ecc->read_page() under all scenarios.

Reported-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/nand/omap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 4ecf0e5fd484..0332d0b2d73a 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1463,7 +1463,7 @@ static int omap_elm_correct_data(struct mtd_info *mtd, u_char *data,
 
 	/* Check if any error reported */
 	if (!is_error_reported)
-		return 0;
+		return stat;
 
 	/* Decode BCH error using ELM module */
 	elm_decode_bch_error_page(info->elm_dev, ecc_vec, err_vec);
-- 
2.0.0

