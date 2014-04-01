Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaDANYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:24:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38372 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaDANY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:24:26 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <arnd@arndb.de>,
        <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 2/5] drivers: bus: omap_l3: Convert to use devm_ioremap_resource()
Date: Tue, 1 Apr 2014 16:23:47 +0300
Message-ID: <1396358630-32340-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396358630-32340-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396358630-32340-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can then remove the iounmap() calls from probe and remove.
Since the driver requests the resources via index we can do the mem resource
request within a for loop.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/bus/omap_l3_noc.c | 59 +++++++++--------------------------------------
 1 file changed, 11 insertions(+), 48 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index d25d727e7cfb..6f58be3c2f76 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -131,52 +131,24 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 static int omap4_l3_probe(struct platform_device *pdev)
 {
 	static struct omap4_l3 *l3;
-	struct resource	*res;
-	int ret;
+	int ret, i;
 
 	l3 = devm_kzalloc(&pdev->dev, sizeof(*l3), GFP_KERNEL);
 	if (!l3)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, l3);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "couldn't find resource 0\n");
-		return -ENODEV;
-	}
-
-	l3->l3_base[0] = ioremap(res->start, resource_size(res));
-	if (!l3->l3_base[0]) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		return -ENOMEM;
-	}
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!res) {
-		dev_err(&pdev->dev, "couldn't find resource 1\n");
-		ret = -ENODEV;
-		goto err1;
-	}
 
-	l3->l3_base[1] = ioremap(res->start, resource_size(res));
-	if (!l3->l3_base[1]) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err1;
-	}
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	if (!res) {
-		dev_err(&pdev->dev, "couldn't find resource 2\n");
-		ret = -ENODEV;
-		goto err2;
-	}
+	/* Get mem resources */
+	for (i = 0; i < L3_MODULES; i++) {
+		struct resource	*res = platform_get_resource(pdev,
+							     IORESOURCE_MEM, i);
 
-	l3->l3_base[2] = ioremap(res->start, resource_size(res));
-	if (!l3->l3_base[2]) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err2;
+		l3->l3_base[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(l3->l3_base[i])) {
+			dev_err(&pdev->dev, "ioremap %d failed\n", i);
+			return PTR_ERR(l3->l3_base[i]);
+		}
 	}
 
 	/*
@@ -189,7 +161,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->debug_irq);
-		goto err3;
+		return ret;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
@@ -206,12 +178,6 @@ static int omap4_l3_probe(struct platform_device *pdev)
 
 err4:
 	free_irq(l3->debug_irq, l3);
-err3:
-	iounmap(l3->l3_base[2]);
-err2:
-	iounmap(l3->l3_base[1]);
-err1:
-	iounmap(l3->l3_base[0]);
 	return ret;
 }
 
@@ -221,9 +187,6 @@ static int omap4_l3_remove(struct platform_device *pdev)
 
 	free_irq(l3->app_irq, l3);
 	free_irq(l3->debug_irq, l3);
-	iounmap(l3->l3_base[0]);
-	iounmap(l3->l3_base[1]);
-	iounmap(l3->l3_base[2]);
 
 	return 0;
 }
-- 
1.9.1

