Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaIOUNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:13:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbaIOTrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 107/114] mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()
Date: Mon, 15 Sep 2014 12:26:47 -0700
Message-Id: <20140915192644.766988172@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/omap2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -933,7 +933,7 @@ static int omap_calculate_ecc(struct mtd
 	u32 val;
 
 	val = readl(info->reg.gpmc_ecc_config);
-	if (((val >> ECC_CONFIG_CS_SHIFT)  & ~CS_MASK) != info->gpmc_cs)
+	if (((val >> ECC_CONFIG_CS_SHIFT) & CS_MASK) != info->gpmc_cs)
 		return -EINVAL;
 
 	/* read ecc result */


