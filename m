Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbaGYGQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:16:46 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58629 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaGYGQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:16:45 -0400
From: pramod.gurav.etc@gmail.com
X-Google-Original-From: pramod.gurav@smartplayin.com
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH] crypto: atmel-tdes: Switch to managed version of kzalloc
Date: Fri, 25 Jul 2014 11:50:21 +0530
Message-Id: <1406269221-20087-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav@smartplayin.com>

This patch switches data allocation from kzalloc to devm_kzalloc.
It also removes some kfree() on data that was earlier allocated
using devm_kzalloc() from probe as well as remove funtions.

CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/crypto/atmel-tdes.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 6cde5b5..d3a9041 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1337,7 +1337,6 @@ static struct crypto_platform_data *atmel_tdes_of_init(struct platform_device *p
 					GFP_KERNEL);
 	if (!pdata->dma_slave) {
 		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
-		devm_kfree(&pdev->dev, pdata);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1359,7 +1358,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	unsigned long tdes_phys_size;
 	int err;
 
-	tdes_dd = kzalloc(sizeof(struct atmel_tdes_dev), GFP_KERNEL);
+	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (tdes_dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
@@ -1483,8 +1482,6 @@ tdes_irq_err:
 res_err:
 	tasklet_kill(&tdes_dd->done_task);
 	tasklet_kill(&tdes_dd->queue_task);
-	kfree(tdes_dd);
-	tdes_dd = NULL;
 tdes_dd_err:
 	dev_err(dev, "initialization failed.\n");
 
@@ -1519,9 +1516,6 @@ static int atmel_tdes_remove(struct platform_device *pdev)
 	if (tdes_dd->irq >= 0)
 		free_irq(tdes_dd->irq, tdes_dd);
 
-	kfree(tdes_dd);
-	tdes_dd = NULL;
-
 	return 0;
 }
 
-- 
1.7.9.5

