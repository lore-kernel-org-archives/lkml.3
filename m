Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaFDLNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:13:41 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58647 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaFDLNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:13:38 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 02/21] ata: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:02 +0400
Message-Id: <1401880402-30091-3-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

pata_mpc52xx's task_irq is special case since it is managed by betstcomm
DMA driver. Do not use devres for it.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/ata/pata_mpc52xx.c |   24 ++++++++++--------------
 drivers/ata/sata_mv.c      |    5 ++++-
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 0024ced..fc14d7f 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -729,18 +729,17 @@ static int mpc52xx_ata_probe(struct platform_device *op)
 	if ((prop) && (proplen >= 4))
 		udma_mask = ATA_UDMA2 & ((1 << (*prop + 1)) - 1);
 
-	ata_irq = irq_of_parse_and_map(op->dev.of_node, 0);
-	if (ata_irq == NO_IRQ) {
+	ata_irq = devm_irq_of_parse_and_map(&op->dev, op->dev.of_node, 0);
+	if (ata_irq <= 0) {
 		dev_err(&op->dev, "error mapping irq\n");
-		return -EINVAL;
+		return ata_irq ? ata_irq : -EINVAL;
 	}
 
 	/* Prepare our private structure */
 	priv = devm_kzalloc(&op->dev, sizeof(*priv), GFP_ATOMIC);
 	if (!priv) {
 		dev_err(&op->dev, "error allocating private structure\n");
-		rv = -ENOMEM;
-		goto err1;
+		return -ENOMEM;
 	}
 
 	priv->ipb_period = 1000000000 / (ipb_freq / 1000);
@@ -762,16 +761,14 @@ static int mpc52xx_ata_probe(struct platform_device *op)
 	dmatsk = bcom_ata_init(MAX_DMA_BUFFERS, MAX_DMA_BUFFER_SIZE);
 	if (!dmatsk) {
 		dev_err(&op->dev, "bestcomm initialization failed\n");
-		rv = -ENOMEM;
-		goto err1;
+		return -ENOMEM;
 	}
 
 	task_irq = bcom_get_task_irq(dmatsk);
-	rv = devm_request_irq(&op->dev, task_irq, &mpc52xx_ata_task_irq, 0,
-				"ATA task", priv);
+	rv = request_irq(task_irq, &mpc52xx_ata_task_irq, 0, "ATA task", priv);
 	if (rv) {
 		dev_err(&op->dev, "error requesting DMA IRQ\n");
-		goto err2;
+		goto err1;
 	}
 	priv->dmatsk = dmatsk;
 
@@ -793,10 +790,10 @@ static int mpc52xx_ata_probe(struct platform_device *op)
 	return 0;
 
  err2:
-	irq_dispose_mapping(task_irq);
+	free_irq(task_irq, priv);
+ err1:
 	bcom_ata_release(dmatsk);
  err1:
-	irq_dispose_mapping(ata_irq);
 	return rv;
 }
 
@@ -812,9 +809,8 @@ mpc52xx_ata_remove(struct platform_device *op)
 
 	/* Clean up DMA */
 	task_irq = bcom_get_task_irq(priv->dmatsk);
-	irq_dispose_mapping(task_irq);
+	free_irq(task_irq, priv);
 	bcom_ata_release(priv->dmatsk);
-	irq_dispose_mapping(priv->ata_irq);
 
 	return 0;
 }
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 05c8a44..9b48e91 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4081,7 +4081,10 @@ static int mv_platform_probe(struct platform_device *pdev)
 	/* allocate host */
 	if (pdev->dev.of_node) {
 		of_property_read_u32(pdev->dev.of_node, "nr-ports", &n_ports);
-		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+		irq = devm_irq_of_parse_and_map(&pdev->dev,
+				pdev->dev.of_node, 0);
+		if (irq <= 0)
+			return -EINVAL;
 	} else {
 		mv_platform_data = dev_get_platdata(&pdev->dev);
 		n_ports = mv_platform_data->n_ports;
-- 
1.7.10.4

