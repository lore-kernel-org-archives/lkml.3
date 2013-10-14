Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab3JNX7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:59:31 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43742 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab3JNX72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:59:28 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 3/5] net: macb: Use devm_ioremap()
Date: Mon, 14 Oct 2013 16:58:58 -0700
Message-Id: <1381795140-10792-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the device managed version of ioremap to remap IO memory,
simplifying error paths.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/net/ethernet/cadence/macb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 62aa136889a4..436aecc31732 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -17,6 +17,7 @@
 #include <linux/circ_buf.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
@@ -1816,7 +1817,7 @@ static int __init macb_probe(struct platform_device *pdev)
 		goto err_out_disable_pclk;
 	}
 
-	bp->regs = ioremap(regs->start, resource_size(regs));
+	bp->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!bp->regs) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		err = -ENOMEM;
@@ -1828,7 +1829,7 @@ static int __init macb_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "Unable to request IRQ %d (error %d)\n",
 			dev->irq, err);
-		goto err_out_iounmap;
+		goto err_out_disable_clocks;
 	}
 
 	dev->netdev_ops = &macb_netdev_ops;
@@ -1916,8 +1917,6 @@ err_out_unregister_netdev:
 	unregister_netdev(dev);
 err_out_free_irq:
 	free_irq(dev->irq, dev);
-err_out_iounmap:
-	iounmap(bp->regs);
 err_out_disable_clocks:
 	clk_disable_unprepare(bp->hclk);
 err_out_disable_pclk:
@@ -1944,7 +1943,6 @@ static int __exit macb_remove(struct platform_device *pdev)
 		mdiobus_free(bp->mii_bus);
 		unregister_netdev(dev);
 		free_irq(dev->irq, dev);
-		iounmap(bp->regs);
 		clk_disable_unprepare(bp->hclk);
 		clk_disable_unprepare(bp->pclk);
 		free_netdev(dev);
-- 
1.8.4

