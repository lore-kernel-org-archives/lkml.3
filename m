Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaHCKRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 06:17:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53658 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaHCKRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 06:17:11 -0400
Date: Sun, 3 Aug 2014 15:47:07 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Aaron Sierra <asierra@xes-inc.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Joe Schultz <jschultz@xes-inc.com>, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] mtd: fsl_ifc_nand: use devm_ functions consistently
Message-ID: <20140803101707.GA8018@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc for all calls to kzalloc and not just the first.  Use
devm functions for other allocations as well. The calls to free the
allocated memory in the remove function are done away with.

The semantic match that finds the inconsistency is as follows:

// <smpl>
@@
@@

*devm_kzalloc(...)
...
*kzalloc(...)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested.
 drivers/mtd/nand/fsl_ifc_nand.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 2338124..b403a77 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -995,11 +995,6 @@ static int fsl_ifc_chip_remove(struct fsl_ifc_mtd *priv)
 {
 	nand_release(&priv->mtd);
 
-	kfree(priv->mtd.name);
-
-	if (priv->vbase)
-		iounmap(priv->vbase);
-
 	ifc_nand_ctrl->chips[priv->bank] = NULL;
 
 	return 0;
@@ -1062,7 +1057,8 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
 
 	mutex_lock(&fsl_ifc_nand_mutex);
 	if (!fsl_ifc_ctrl_dev->nand) {
-		ifc_nand_ctrl = kzalloc(sizeof(*ifc_nand_ctrl), GFP_KERNEL);
+		ifc_nand_ctrl = devm_kzalloc(&dev->dev, sizeof(*ifc_nand_ctrl),
+					     GFP_KERNEL);
 		if (!ifc_nand_ctrl) {
 			mutex_unlock(&fsl_ifc_nand_mutex);
 			return -ENOMEM;
@@ -1085,7 +1081,7 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
 	priv->ctrl = fsl_ifc_ctrl_dev;
 	priv->dev = &dev->dev;
 
-	priv->vbase = ioremap(res.start, resource_size(&res));
+	priv->vbase = devm_ioremap(&dev->dev, res.start, resource_size(&res));
 	if (!priv->vbase) {
 		dev_err(priv->dev, "%s: failed to map chip region\n", __func__);
 		ret = -ENOMEM;
@@ -1104,7 +1100,8 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
 		    IFC_NAND_EVTER_INTR_FTOERIR_EN |
 		    IFC_NAND_EVTER_INTR_WPERIR_EN,
 		    &ifc->ifc_nand.nand_evter_intr_en);
-	priv->mtd.name = kasprintf(GFP_KERNEL, "%llx.flash", (u64)res.start);
+	priv->mtd.name = devm_kasprintf(&dev->dev, GFP_KERNEL, "%llx.flash",
+					(u64)res.start);
 	if (!priv->mtd.name) {
 		ret = -ENOMEM;
 		goto err;
@@ -1148,10 +1145,8 @@ static int fsl_ifc_nand_remove(struct platform_device *dev)
 
 	mutex_lock(&fsl_ifc_nand_mutex);
 	ifc_nand_ctrl->counter--;
-	if (!ifc_nand_ctrl->counter) {
+	if (!ifc_nand_ctrl->counter)
 		fsl_ifc_ctrl_dev->nand = NULL;
-		kfree(ifc_nand_ctrl);
-	}
 	mutex_unlock(&fsl_ifc_nand_mutex);
 
 	return 0;
-- 
1.9.1

