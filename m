Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaI3VhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbaI3VhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 063/103] mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()
Date: Tue, 30 Sep 2014 14:31:08 -0700
Message-Id: <1412112708-27356-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 40ddbf5069bd4e11447c0088fc75318e0aac53f0 upstream.

commit 65b97cf6b8de introduced in v3.7 caused a regression
by using a reversed CS_MASK thus causing omap_calculate_ecc to
always fail. As the NAND base driver never checks for .calculate()'s
return value, the zeroed ECC values are used as is without showing
any error to the user. However, this won't work and the NAND device
won't be guarded by any error code.

Fix the issue by using the correct mask.

Code was tested on omap3beagle using the following procedure
- flash the primary bootloader (MLO) from the kernel to the first
NAND partition using nandwrite.
- boot the board from NAND. This utilizes OMAP ROM loader that
relies on 1-bit Hamming code ECC.

Fixes: 65b97cf6b8de (mtd: nand: omap2: handle nand on gpmc)

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/nand/omap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index b594e61..a858904 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -933,7 +933,7 @@ static int omap_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
 	u32 val;
 
 	val = readl(info->reg.gpmc_ecc_config);
-	if (((val >> ECC_CONFIG_CS_SHIFT)  & ~CS_MASK) != info->gpmc_cs)
+	if (((val >> ECC_CONFIG_CS_SHIFT) & CS_MASK) != info->gpmc_cs)
 		return -EINVAL;
 
 	/* read ecc result */
-- 
1.9.1

