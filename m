Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3EQDfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:35:55 -0400
Received: from [216.32.180.13] ([216.32.180.13]:54275 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab3EQDfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:35:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <vikram186@gmail.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v6 01/10] mtd: add datasheet's ECC information to nand_chip{}
Date: Fri, 17 May 2013 11:17:25 +0800
Message-ID: <1368760654-28754-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368760654-28754-1-git-send-email-b32955@freescale.com>
References: <1368760654-28754-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1.) Why add the ECC information to the nand_chip{} ?
   Each nand chip has its requirement for the ECC correctability, such as
   "4bit ECC for each 512Byte" or "40bit ECC for each 1024Byte".
   This ECC info is very important to the nand controller, such as gpmi.

   Take the Micron MT29F64G08CBABA for example, its geometry is
   8k page size, 744 bytes oob size and it requires 40bit ECC per 1K bytes.
   If we do not provide the ECC info to the gpmi nand driver, it has to
   calculate the ECC correctability itself. The gpmi driver will gets the 56bit
   ECC for per 1K bytes which is beyond its BCH's 40bit ecc capibility.
   The gpmi will quits in this case. But in actually, the gpmi can supports
   this nand chip if it can get the right ECC info.

2.) about the new fields.
   The @ecc_strength_ds stands for the ecc bits needed within the @ecc_step_ds.
   The two fields should be set from the nand chip's datasheets.

   For example:
	"4bit ECC for each 512Byte" could be:
		@ecc_strength_ds = 4, @ecc_step_ds = 512.
	"40bit ECC for each 1024Byte" could be:
		@ecc_strength_ds = 40, @ecc_step_ds = 1024.

3.) Why do not re-use the @strength and @size in the nand_ecc_ctrl{}?
   The @strength and @size in nand_ecc_ctrl{} is used by the nand controller
   driver, while the @ecc_strength_ds and @ecc_step_ds are get from the datasheet.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/nand.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 38535eb..ee696f1 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -434,6 +434,12 @@ struct nand_buffers {
  *			bad block marker position; i.e., BBM == 11110111b is
  *			not bad when badblockbits == 7
  * @cellinfo:		[INTERN] MLC/multichip data from chip ident
+ * @ecc_strength_ds:	[INTERN] ECC correctability from the datasheet.
+ *			Minimum amount of bit errors per @ecc_step_ds guaranteed
+ *			to be correctable. If unknown, set to zero.
+ * @ecc_step_ds:	[INTERN] ECC step required by the @ecc_strength_ds,
+ *                      also from the datasheet. It is the recommended ECC step
+ *			size, if known; if unknown, set to zero.
  * @numchips:		[INTERN] number of physical chips
  * @chipsize:		[INTERN] the size of one chip for multichip arrays
  * @pagemask:		[INTERN] page number mask = number of (pages / chip) - 1
@@ -510,6 +516,8 @@ struct nand_chip {
 	unsigned int pagebuf_bitflips;
 	int subpagesize;
 	uint8_t cellinfo;
+	uint16_t ecc_strength_ds;
+	uint16_t ecc_step_ds;
 	int badblockpos;
 	int badblockbits;
 
-- 
1.7.1


