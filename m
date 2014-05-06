Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbaEFJPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:15:12 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36144 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544AbaEFJPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:15:09 -0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru, Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH] mtd: fsl_elbc_nand: set NAND_NO_SUBPAGE_WRITE flag if using hardware ECC
Date: Tue,  6 May 2014 13:14:38 +0400
Message-Id: <1399367678-31878-1-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per MPC8572E manual, sec 14.4.3.1.3: "Transfers shorter than a full page,
however, require software to prepare the appropriate ECC in the spare
region"

Need to set NAND_NO_SUBPAGE_WRITE flag. If this is not done, then
generic nand_write_subpage_hwecc() is called instead of driver's
write routine, which results into OOPS dereferencing NULL chip->ecc.hwctl
pointer.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/mtd/nand/fsl_elbc_nand.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index ec549cd..bb146a0 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -766,6 +766,8 @@ static int fsl_elbc_chip_init(struct fsl_elbc_mtd *priv)
 	if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
 	    BR_DECC_CHK_GEN) {
 		chip->ecc.mode = NAND_ECC_HW;
+		/* hardware can't calculate ECC for subpages */
+		chip->options |= NAND_NO_SUBPAGE_WRITE;
 		/* put in small page settings and adjust later if needed */
 		chip->ecc.layout = (priv->fmr & FMR_ECCM) ?
 				&fsl_elbc_oob_sp_eccm1 : &fsl_elbc_oob_sp_eccm0;
-- 
1.7.10.4

