Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbaGCJVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbaGCJVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pekon Gupta <pekon@ti.com>, Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/198] mtd: eLBC NAND: fix subpage write support
Date: Thu,  3 Jul 2014 10:17:58 +0100
Message-Id: <1404379241-8590-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekon Gupta <pekon@ti.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

