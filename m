Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbaGOWAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:00:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54767 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541AbaGOVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pekon Gupta <pekon@ti.com>, Brian Norris <computersforpeace@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 043/198] mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page
Date: Tue, 15 Jul 2014 14:28:33 -0700
Message-Id: <1405459868-15089-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: pekon gupta <pekon@ti.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/nand/omap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 2365b5a..b594e61 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1451,7 +1451,7 @@ static int omap_elm_correct_data(struct mtd_info *mtd, u_char *data,
 
 	/* Check if any error reported */
 	if (!is_error_reported)
-		return 0;
+		return stat;
 
 	/* Decode BCH error using ELM module */
 	elm_decode_bch_error_page(info->elm_dev, ecc_vec, err_vec);
-- 
1.9.1

