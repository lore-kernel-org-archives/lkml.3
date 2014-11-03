Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaKCQQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:16:13 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:41392 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaKCQQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:16:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: db8500-prcmu: Provide sane error path values
Date: Mon,  3 Nov 2014 16:15:56 +0000
Message-Id: <1415031356-11664-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also rid superfluous gotos and label.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 89ae8bf..a820473 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3150,27 +3150,27 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcmu");
 	if (!res) {
 		dev_err(&pdev->dev, "no prcmu memory region provided\n");
-		return -ENOENT;
+		return -EINVAL;
 	}
 	prcmu_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!prcmu_base) {
 		dev_err(&pdev->dev,
 			"failed to ioremap prcmu register memory\n");
-		return -ENOENT;
+		return -ENOMEM;
 	}
 	init_prcm_registers();
 	dbx500_fw_version_init(pdev, pdata->version_offset);
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "prcmu-tcdm");
 	if (!res) {
 		dev_err(&pdev->dev, "no prcmu tcdm region provided\n");
-		return -ENOENT;
+		return -EINVAL;
 	}
 	tcdm_base = devm_ioremap(&pdev->dev, res->start,
 			resource_size(res));
 	if (!tcdm_base) {
 		dev_err(&pdev->dev,
 			"failed to ioremap prcmu-tcdm register memory\n");
-		return -ENOENT;
+		return -ENOMEM;
 	}
 
 	/* Clean up the mailbox interrupts after pre-kernel code. */
@@ -3179,15 +3179,14 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_err(&pdev->dev, "no prcmu irq provided\n");
-		return -ENOENT;
+		return irq;
 	}
 
 	err = request_threaded_irq(irq, prcmu_irq_handler,
 	        prcmu_irq_thread_fn, IRQF_NO_SUSPEND, "prcmu", NULL);
 	if (err < 0) {
 		pr_err("prcmu: Failed to allocate IRQ_DB8500_PRCMU1.\n");
-		err = -EBUSY;
-		goto no_irq_return;
+		return err;
 	}
 
 	db8500_irq_init(np);
@@ -3211,7 +3210,7 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 		if (err) {
 			mfd_remove_devices(&pdev->dev);
 			pr_err("prcmu: Failed to add subdevices\n");
-			goto no_irq_return;
+			return err;
 		}
 	}
 
@@ -3219,12 +3218,10 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 	if (err) {
 		mfd_remove_devices(&pdev->dev);
 		pr_err("prcmu: Failed to add ab8500 subdevice\n");
-		goto no_irq_return;
+		return err;
 	}
 
 	pr_info("DB8500 PRCMU initialized\n");
-
-no_irq_return:
 	return err;
 }
 static const struct of_device_id db8500_prcmu_match[] = {
-- 
1.9.1

