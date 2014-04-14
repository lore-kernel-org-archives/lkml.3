Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaDNQrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:47:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48056 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaDNQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:53 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/15] bus: omap_l3_noc: populate l3->dev and use it
Date: Mon, 14 Apr 2014 11:25:18 -0500
Message-ID: <1397492726-17203-9-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

l3->dev is not populated, so populate it and use it to print information
relevant to the device instead of using a generic pr_*.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/bus/omap_l3_noc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 0f0417a..da4e27c 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -118,7 +118,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 
 			if (std_err) {
 				WARN(true,
-				     "L3 %s Error: MASTER %s TARGET %s %s\n",
+				     "%s:L3 %s Error: MASTER %s TARGET %s %s\n",
+				     dev_name(l3->dev),
 				     err_description,
 				     master_name, target_name,
 				     err_string);
@@ -143,6 +144,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	if (!l3)
 		return -ENOMEM;
 
+	l3->dev = &pdev->dev;
 	platform_set_drvdata(pdev, l3);
 
 	/* Get mem resources */
@@ -152,7 +154,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 
 		l3->l3_base[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(l3->l3_base[i])) {
-			dev_err(&pdev->dev, "ioremap %d failed\n", i);
+			dev_err(l3->dev, "ioremap %d failed\n", i);
 			return PTR_ERR(l3->l3_base[i]);
 		}
 	}
@@ -161,19 +163,19 @@ static int omap4_l3_probe(struct platform_device *pdev)
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

