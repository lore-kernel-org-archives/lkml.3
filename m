Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397AbaGCKPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:15:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51572 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaGCJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pekon Gupta <pekon@ti.com>, Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 034/198] mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page
Date: Thu,  3 Jul 2014 10:17:57 +0100
Message-Id: <1404379241-8590-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/nand/omap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 81b80af55872..8c4eb287bbdb 100644
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
1.9.1

