Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbaGXNww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:52:52 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35030 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbaGXNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:52:50 -0400
From: pramod.gurav.etc@gmail.com
X-Google-Original-From: pramod.gurav@smartplayin.com
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: atmel-sha: Switch to managed version of kzalloc
Date: Thu, 24 Jul 2014 19:26:20 +0530
Message-Id: <1406210180-17313-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav@smartplayin.com>

This patch switches data allocation from kzalloc to devm_kzalloc.
It also removed some kfree() on data that was earlier allocated
using devm_kzalloc().

CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/crypto/atmel-sha.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 0618be0..9a4f69e 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1353,7 +1353,6 @@ static struct crypto_platform_data *atmel_sha_of_init(struct platform_device *pd
 					GFP_KERNEL);
 	if (!pdata->dma_slave) {
 		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
-		devm_kfree(&pdev->dev, pdata);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1375,7 +1374,8 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	unsigned long sha_phys_size;
 	int err;
 
-	sha_dd = kzalloc(sizeof(struct atmel_sha_dev), GFP_KERNEL);
+	sha_dd = devm_kzalloc(&pdev->dev, sizeof(struct atmel_sha_dev),
+				GFP_KERNEL);
 	if (sha_dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
@@ -1490,8 +1490,6 @@ clk_err:
 	free_irq(sha_dd->irq, sha_dd);
 res_err:
 	tasklet_kill(&sha_dd->done_task);
-	kfree(sha_dd);
-	sha_dd = NULL;
 sha_dd_err:
 	dev_err(dev, "initialization failed.\n");
 
@@ -1523,9 +1521,6 @@ static int atmel_sha_remove(struct platform_device *pdev)
 	if (sha_dd->irq >= 0)
 		free_irq(sha_dd->irq, sha_dd);
 
-	kfree(sha_dd);
-	sha_dd = NULL;
-
 	return 0;
 }
 
-- 
1.7.9.5

