Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaELPkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:40:51 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33277 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaELPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:40:49 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: berthe.ab@gmail.com, m@bues.ch, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: use devm function for memory allocation
Date: Mon, 12 May 2014 17:40:42 +0200
Message-Id: <1399909242-21264-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/gpio/gpio-bt8xx.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index ecb3ca2d..6557147 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -178,7 +178,7 @@ static int bt8xxgpio_probe(struct pci_dev *dev,
 	struct bt8xxgpio *bg;
 	int err;
 
-	bg = kzalloc(sizeof(*bg), GFP_KERNEL);
+	bg = devm_kzalloc(&dev->dev, sizeof(struct bt8xxgpio), GFP_KERNEL);
 	if (!bg)
 		return -ENOMEM;
 
@@ -188,9 +188,9 @@ static int bt8xxgpio_probe(struct pci_dev *dev,
 	err = pci_enable_device(dev);
 	if (err) {
 		printk(KERN_ERR "bt8xxgpio: Can't enable device.\n");
-		goto err_freebg;
+		return err;
 	}
-	if (!request_mem_region(pci_resource_start(dev, 0),
+	if (!devm_request_mem_region(&dev->dev, pci_resource_start(dev, 0),
 				pci_resource_len(dev, 0),
 				"bt8xxgpio")) {
 		printk(KERN_WARNING "bt8xxgpio: Can't request iomem (0x%llx).\n",
@@ -201,11 +201,11 @@ static int bt8xxgpio_probe(struct pci_dev *dev,
 	pci_set_master(dev);
 	pci_set_drvdata(dev, bg);
 
-	bg->mmio = ioremap(pci_resource_start(dev, 0), 0x1000);
+	bg->mmio = devm_ioremap(&dev->dev, pci_resource_start(dev, 0), 0x1000);
 	if (!bg->mmio) {
 		printk(KERN_ERR "bt8xxgpio: ioremap() failed\n");
 		err = -EIO;
-		goto err_release_mem;
+		goto err_disable;
 	}
 
 	/* Disable interrupts */
@@ -220,18 +220,13 @@ static int bt8xxgpio_probe(struct pci_dev *dev,
 	err = gpiochip_add(&bg->gpio);
 	if (err) {
 		printk(KERN_ERR "bt8xxgpio: Failed to register GPIOs\n");
-		goto err_release_mem;
+		goto err_disable;
 	}
 
 	return 0;
 
-err_release_mem:
-	release_mem_region(pci_resource_start(dev, 0),
-			   pci_resource_len(dev, 0));
 err_disable:
 	pci_disable_device(dev);
-err_freebg:
-	kfree(bg);
 
 	return err;
 }
@@ -250,8 +245,6 @@ static void bt8xxgpio_remove(struct pci_dev *pdev)
 	release_mem_region(pci_resource_start(pdev, 0),
 			   pci_resource_len(pdev, 0));
 	pci_disable_device(pdev);
-
-	kfree(bg);
 }
 
 #ifdef CONFIG_PM
-- 
1.8.3.2

