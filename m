Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaD1PRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:17:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50734 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbaD1PP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:15:58 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>
Subject: [PATCH V3 04/20] bus: omap_l3_noc: populate l3->dev and use it
Date: Mon, 28 Apr 2014 10:14:44 -0500
Message-ID: <1398698101-25513-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

l3->dev is not populated, so populate it and use it to print information
relevant to the device instead of using a generic pr_*.

Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Darren Etheridge <detheridge@ti.com>
---
change in V3: none
 drivers/bus/omap_l3_noc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 800486c..37d71b7 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -131,6 +131,7 @@ static int omap_l3_probe(struct platform_device *pdev)
 	if (!l3)
 		return -ENOMEM;
 
+	l3->dev = &pdev->dev;
 	platform_set_drvdata(pdev, l3);
 
 	/* Get mem resources */
@@ -140,7 +141,7 @@ static int omap_l3_probe(struct platform_device *pdev)
 
 		l3->l3_base[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(l3->l3_base[i])) {
-			dev_err(&pdev->dev, "ioremap %d failed\n", i);
+			dev_err(l3->dev, "ioremap %d failed\n", i);
 			return PTR_ERR(l3->l3_base[i]);
 		}
 	}
@@ -149,19 +150,19 @@ static int omap_l3_probe(struct platform_device *pdev)
 	 * Setup interrupt Handlers
 	 */
 	l3->debug_irq = platform_get_irq(pdev, 0);
-	ret = devm_request_irq(&pdev->dev, l3->debug_irq, l3_interrupt_handler,
+	ret = devm_request_irq(l3->dev, l3->debug_irq, l3_interrupt_handler,
 			       IRQF_DISABLED, "l3-dbg-irq", l3);
 	if (ret) {
-		dev_err(&pdev->dev, "request_irq failed for %d\n",
+		dev_err(l3->dev, "request_irq failed for %d\n",
 			l3->debug_irq);
 		return ret;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
-	ret = devm_request_irq(&pdev->dev, l3->app_irq, l3_interrupt_handler,
+	ret = devm_request_irq(l3->dev, l3->app_irq, l3_interrupt_handler,
 			       IRQF_DISABLED, "l3-app-irq", l3);
 	if (ret)
-		dev_err(&pdev->dev, "request_irq failed for %d\n", l3->app_irq);
+		dev_err(l3->dev, "request_irq failed for %d\n", l3->app_irq);
 
 	return ret;
 }
-- 
1.7.9.5

