Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaCDJLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:11:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43522 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbaCDJJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:09:06 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 2/5] drivers: bus: omap_l3: Convert to use devm_request_and_ioremap()
Date: Tue, 4 Mar 2014 11:08:27 +0200
Message-ID: <1393924110-11132-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393924110-11132-1-git-send-email-peter.ujfalusi@ti.com>
References: <1393924110-11132-1-git-send-email-peter.ujfalusi@ti.com>
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
---
 drivers/bus/omap_l3_noc.c | 63 +++++++++++------------------------------------
 1 file changed, 15 insertions(+), 48 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index d25d727e7cfb..ca95d3db5055 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -131,52 +131,28 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
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
+	for (i = 0; i < 3; i++) {
+		struct resource	*res = platform_get_resource(pdev,
+							     IORESOURCE_MEM, i);
+		if (!res) {
+			dev_err(&pdev->dev, "couldn't find resource %d\n", i);
+			return -ENODEV;
+		}
 
-	l3->l3_base[2] = ioremap(res->start, resource_size(res));
-	if (!l3->l3_base[2]) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err2;
+		l3->l3_base[i] = devm_request_and_ioremap(&pdev->dev, res);
+		if (!l3->l3_base[i]) {
+			dev_err(&pdev->dev, "ioremap %d failed\n", i);
+			return -ENOMEM;
+		}
 	}
 
 	/*
@@ -189,7 +165,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->debug_irq);
-		goto err3;
+		return ret;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
@@ -206,12 +182,6 @@ static int omap4_l3_probe(struct platform_device *pdev)
 
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
 
@@ -221,9 +191,6 @@ static int omap4_l3_remove(struct platform_device *pdev)
 
 	free_irq(l3->app_irq, l3);
 	free_irq(l3->debug_irq, l3);
-	iounmap(l3->l3_base[0]);
-	iounmap(l3->l3_base[1]);
-	iounmap(l3->l3_base[2]);
 
 	return 0;
 }
-- 
1.9.0

