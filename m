Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaGHAVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:21:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaGGXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>, Pekon Gupta <pekon@ti.com>,
        Scott Wood <scottwood@freescale.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.10 13/53] mtd: eLBC NAND: fix subpage write support
Date: Mon,  7 Jul 2014 16:57:58 -0700
Message-Id: <20140707235829.694197476@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/fsl_elbc_nand.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -725,6 +725,19 @@ static int fsl_elbc_write_page(struct mt
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
@@ -763,6 +776,7 @@ static int fsl_elbc_chip_init(struct fsl
 
 	chip->ecc.read_page = fsl_elbc_read_page;
 	chip->ecc.write_page = fsl_elbc_write_page;
+	chip->ecc.write_subpage = fsl_elbc_write_subpage;
 
 	/* If CS Base Register selects full hardware ECC then use it */
 	if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==


