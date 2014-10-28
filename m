Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaJ1SNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:13:20 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40791 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaJ1SNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:13:18 -0400
Date: Tue, 28 Oct 2014 11:13:11 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>
Subject: Re: [PATCH v7 1/2] mtd: nand: add sunxi NAND flash controller support
Message-ID: <20141028181310.GA23619@ld-irv-0074>
References: <1413896922-11680-1-git-send-email-boris.brezillon@free-electrons.com>
 <1413896922-11680-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413896922-11680-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Tue, Oct 21, 2014 at 03:08:41PM +0200, Boris Brezillon wrote:
> +static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
> +				       struct nand_ecc_ctrl *ecc,
> +				       struct device_node *np)
> +{
> +	struct nand_ecclayout *layout;
> +	int i, j;
> +	int ret;
> +
> +	ret = sunxi_nand_hw_common_ecc_ctrl_init(mtd, ecc, np);
> +	if (ret)
> +		return ret;
> +
> +	ecc->read_page = sunxi_nfc_hw_ecc_read_page;
> +	ecc->write_page = sunxi_nfc_hw_ecc_write_page;
> +	layout = ecc->layout;
> +
> +	for (i = 0; i < ecc->steps; i++) {

Hmm, did you retest this since changing this to ecc->steps? I think this
won't work, since ecc->steps is only initialized in nand_scan_tail(),
which comes after this. I only recommended the change for the
{read,write}_page() type of functions, not the initialization functions.

[snip the rest]

So I'd suggest the following additional patch, and otherwise, the series
is fine with me. If you give your ack, I can just squash this in and
apply it to my tree:

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index ea615dc442a4..ccaa8e283388 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -931,6 +931,7 @@ static int sunxi_nand_hw_common_ecc_ctrl_init(struct mtd_info *mtd,
 	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
 	struct sunxi_nand_hw_ecc *data;
 	struct nand_ecclayout *layout;
+	int nsectors;
 	int ret;
 	int i;
 
@@ -959,13 +960,14 @@ static int sunxi_nand_hw_common_ecc_ctrl_init(struct mtd_info *mtd,
 	ecc->bytes = ALIGN(ecc->bytes, 2);
 
 	layout = &data->layout;
+	nsectors = mtd->writesize / ecc->size;
 
-	if (mtd->oobsize < ((ecc->bytes + 4) * ecc->steps)) {
+	if (mtd->oobsize < ((ecc->bytes + 4) * nsectors)) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	layout->eccbytes = (ecc->bytes * ecc->steps);
+	layout->eccbytes = (ecc->bytes * nsectors);
 
 	ecc->layout = layout;
 	ecc->priv = data;
@@ -988,6 +990,7 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
 				       struct device_node *np)
 {
 	struct nand_ecclayout *layout;
+	int nsectors;
 	int i, j;
 	int ret;
 
@@ -998,8 +1001,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
 	ecc->read_page = sunxi_nfc_hw_ecc_read_page;
 	ecc->write_page = sunxi_nfc_hw_ecc_write_page;
 	layout = ecc->layout;
+	nsectors = mtd->writesize / ecc->size;
 
-	for (i = 0; i < ecc->steps; i++) {
+	for (i = 0; i < nsectors; i++) {
 		if (i) {
 			layout->oobfree[i].offset =
 				layout->oobfree[i - 1].offset +
@@ -1022,13 +1026,13 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
 					layout->oobfree[i].length + j;
 	}
 
-	if (mtd->oobsize > (ecc->bytes + 4) * ecc->steps) {
-		layout->oobfree[ecc->steps].offset =
-				layout->oobfree[ecc->steps - 1].offset +
-				layout->oobfree[ecc->steps - 1].length +
+	if (mtd->oobsize > (ecc->bytes + 4) * nsectors) {
+		layout->oobfree[nsectors].offset =
+				layout->oobfree[nsectors - 1].offset +
+				layout->oobfree[nsectors - 1].length +
 				ecc->bytes;
-		layout->oobfree[ecc->steps].length = mtd->oobsize -
-				((ecc->bytes + 4) * ecc->steps);
+		layout->oobfree[nsectors].length = mtd->oobsize -
+				((ecc->bytes + 4) * nsectors);
 	}
 
 	return 0;
@@ -1039,6 +1043,7 @@ static int sunxi_nand_hw_syndrome_ecc_ctrl_init(struct mtd_info *mtd,
 						struct device_node *np)
 {
 	struct nand_ecclayout *layout;
+	int nsectors;
 	int i;
 	int ret;
 
@@ -1051,8 +1056,9 @@ static int sunxi_nand_hw_syndrome_ecc_ctrl_init(struct mtd_info *mtd,
 	ecc->write_page = sunxi_nfc_hw_syndrome_ecc_write_page;
 
 	layout = ecc->layout;
+	nsectors = mtd->writesize / ecc->size;
 
-	for (i = 0; i < (ecc->bytes * ecc->steps); i++)
+	for (i = 0; i < (ecc->bytes * nsectors); i++)
 		layout->eccpos[i] = i;
 
 	layout->oobfree[0].length = mtd->oobsize - i;
