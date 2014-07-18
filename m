Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966039AbaGRNd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:33:58 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17773 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161028AbaGRNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pekon Gupta <pekon@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/170] mtd: eLBC NAND: fix subpage write support
Date: Fri, 18 Jul 2014 14:11:21 +0200
Message-Id: <9e911a38500562935a11ab7eabf11a8e1a82cedf.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekon Gupta <pekon@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f034d87def51f026b735d1e2877e9387011b2ba3 upstream.

As subpage write is enabled by default for all drivers, nand_write_subpage_hwecc
causes a crash if the driver did not register ecc->hwctl or ecc->calculate.
This behavior was introduced in
   commit 837a6ba4f3b6d23026674e6af6b6849a4634fff9
   "mtd: nand: subpage write support for hardware based ECC schemes".

This fixes a crash by emulating subpage write support by padding sub-page data
with 0xff on either sides to make it full page compatible.

Reported-by: Helmut Schaa <helmut.schaa@googlemail.com>
Tested-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Pekon Gupta <pekon@ti.com>
Reviewed-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/nand/fsl_elbc_nand.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 20657209a472..c31d183820c5 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -725,6 +725,19 @@ static int fsl_elbc_write_page(struct mtd_info *mtd, struct nand_chip *chip,
 	return 0;
 }
 
+/* ECC will be calculated automatically, and errors will be detected in
+ * waitfunc.
+ */
+static int fsl_elbc_write_subpage(struct mtd_info *mtd, struct nand_chip *chip,
+				uint32_t offset, uint32_t data_len,
+				const uint8_t *buf, int oob_required)
+{
+	fsl_elbc_write_buf(mtd, buf, mtd->writesize);
+	fsl_elbc_write_buf(mtd, chip->oob_poi, mtd->oobsize);
+
+	return 0;
+}
+
 static int fsl_elbc_chip_init(struct fsl_elbc_mtd *priv)
 {
 	struct fsl_lbc_ctrl *ctrl = priv->ctrl;
@@ -763,6 +776,7 @@ static int fsl_elbc_chip_init(struct fsl_elbc_mtd *priv)
 
 	chip->ecc.read_page = fsl_elbc_read_page;
 	chip->ecc.write_page = fsl_elbc_write_page;
+	chip->ecc.write_subpage = fsl_elbc_write_subpage;
 
 	/* If CS Base Register selects full hardware ECC then use it */
 	if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
-- 
2.0.0

