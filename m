Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbaIZJ6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:58:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbaIZJqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 114/142] mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()
Date: Fri, 26 Sep 2014 11:45:25 +0200
Message-Id: <20223b44368a373892a5b730cef6765720de77c5.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/nand/omap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 0332d0b2d73a..854662826272 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -948,7 +948,7 @@ static int omap_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
 	u32 val;
 
 	val = readl(info->reg.gpmc_ecc_config);
-	if (((val >> ECC_CONFIG_CS_SHIFT)  & ~CS_MASK) != info->gpmc_cs)
+	if (((val >> ECC_CONFIG_CS_SHIFT) & CS_MASK) != info->gpmc_cs)
 		return -EINVAL;
 
 	/* read ecc result */
-- 
2.1.0

