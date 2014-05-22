Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaEVS66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:58:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54964 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaEVS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:58:57 -0400
Date: Fri, 23 May 2014 00:28:48 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] mtd: Introduce the use of the managed version of kzalloc
Message-ID: <20140522185848.GA15125@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, the now unnecessary label out_err_hw_init is done away
with and the label out_err_kzalloc is renamed to out_err.

The following Coccinelle semantic patch was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

@rem depends on prb@
identifier platform.removefn;
expression e;
@@
removefn(...) {
  <...
- kfree(e);
  ...>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 drivers/mtd/nand/bf5xx_nand.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index b7a2494..722898a 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -679,9 +679,6 @@ static int bf5xx_nand_remove(struct platform_device *pdev)
 	peripheral_free_list(bfin_nfc_pin_req);
 	bf5xx_nand_dma_remove(info);
 
-	/* free the common resources */
-	kfree(info);
-
 	return 0;
 }
 
@@ -742,10 +739,10 @@ static int bf5xx_nand_probe(struct platform_device *pdev)
 		return -EFAULT;
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (info == NULL) {
 		err = -ENOMEM;
-		goto out_err_kzalloc;
+		goto out_err;
 	}
 
 	platform_set_drvdata(pdev, info);
@@ -790,7 +787,7 @@ static int bf5xx_nand_probe(struct platform_device *pdev)
 	/* initialise the hardware */
 	err = bf5xx_nand_hw_init(info);
 	if (err)
-		goto out_err_hw_init;
+		goto out_err;
 
 	/* setup hardware ECC data struct */
 	if (hardware_ecc) {
@@ -827,9 +824,7 @@ static int bf5xx_nand_probe(struct platform_device *pdev)
 
 out_err_nand_scan:
 	bf5xx_nand_dma_remove(info);
-out_err_hw_init:
-	kfree(info);
-out_err_kzalloc:
+out_err:
 	peripheral_free_list(bfin_nfc_pin_req);
 
 	return err;
-- 
1.9.1

