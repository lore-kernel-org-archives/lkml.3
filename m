Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaCDJJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:09:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53787 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbaCDJJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:09:11 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 3/5] drivers: bus: omap_l3: Convert to use devm_request_irq()
Date: Tue, 4 Mar 2014 11:08:28 +0200
Message-ID: <1393924110-11132-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393924110-11132-1-git-send-email-peter.ujfalusi@ti.com>
References: <1393924110-11132-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this we can remove the free_irq() calls from probe and remove.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/bus/omap_l3_noc.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index ca95d3db5055..2bbc87bdea2b 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -159,9 +159,8 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	 * Setup interrupt Handlers
 	 */
 	l3->debug_irq = platform_get_irq(pdev, 0);
-	ret = request_irq(l3->debug_irq,
-			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-dbg-irq", l3);
+	ret = devm_request_irq(&pdev->dev, l3->debug_irq, l3_interrupt_handler,
+			       IRQF_DISABLED, "l3-dbg-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->debug_irq);
@@ -169,29 +168,17 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
-	ret = request_irq(l3->app_irq,
-			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-app-irq", l3);
-	if (ret) {
+	ret = devm_request_irq(&pdev->dev, l3->app_irq, l3_interrupt_handler,
+			       IRQF_DISABLED, "l3-app-irq", l3);
+	if (ret)
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->app_irq);
-		goto err4;
-	}
-
-	return 0;
 
-err4:
-	free_irq(l3->debug_irq, l3);
 	return ret;
 }
 
 static int omap4_l3_remove(struct platform_device *pdev)
 {
-	struct omap4_l3 *l3 = platform_get_drvdata(pdev);
-
-	free_irq(l3->app_irq, l3);
-	free_irq(l3->debug_irq, l3);
-
 	return 0;
 }
 
-- 
1.9.0

