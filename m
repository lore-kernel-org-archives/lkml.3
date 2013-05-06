Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab3EFXJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:09:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:13382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636Ab3EFXI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="298534603"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: mika.westerberg@linux.intel.com, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH] gpio-langwell: fix irq conflicts when DT is not used
Date: Mon,  6 May 2013 16:11:03 -0700
Message-Id: <1367881863-6025-1-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DT is not used IOAPIC does not register irq domain. As result
IOAPIC won't care about gpio-langwell's virq and may cause conflict if
an irq number is equal to gpio-langwell's virq mapped beforehand.

This patch tells gpio_langwell to not ignore irq_base if != 0 and
preferably use it to avoid the conflict.

If DT is used, irq_base can safely be 0.

Signed-off-by: David Cohen <david.a.cohen@intel.com>
---
 drivers/gpio/gpio-langwell.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index c48901a..88644db 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -362,6 +362,7 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	resource_size_t start, len;
 	struct lnw_gpio *lnw;
 	u32 gpio_base;
+	u32 irq_base;
 	int retval;
 	int ngpio = id->driver_data;
 
@@ -383,6 +384,7 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 		retval = -EFAULT;
 		goto err_ioremap;
 	}
+	irq_base = *(u32 *)base;
 	gpio_base = *((u32 *)base + 1);
 	/* release the IO mapping, since we already get the info from bar1 */
 	iounmap(base);
@@ -403,13 +405,6 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 		goto err_ioremap;
 	}
 
-	lnw->domain = irq_domain_add_linear(pdev->dev.of_node, ngpio,
-					    &lnw_gpio_irq_ops, lnw);
-	if (!lnw->domain) {
-		retval = -ENOMEM;
-		goto err_ioremap;
-	}
-
 	lnw->reg_base = base;
 	lnw->chip.label = dev_name(&pdev->dev);
 	lnw->chip.request = lnw_gpio_request;
@@ -422,6 +417,14 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	lnw->chip.ngpio = ngpio;
 	lnw->chip.can_sleep = 0;
 	lnw->pdev = pdev;
+
+	lnw->domain = irq_domain_add_simple(pdev->dev.of_node, ngpio, irq_base,
+					    &lnw_gpio_irq_ops, lnw);
+	if (!lnw->domain) {
+		retval = -ENOMEM;
+		goto err_ioremap;
+	}
+
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
-- 
1.7.10.4

