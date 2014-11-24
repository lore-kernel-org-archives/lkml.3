Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaKXS6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:58:34 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:43222 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaKXS6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:58:32 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net/smsc911x: Add minimal runtime PM support
Date: Mon, 24 Nov 2014 19:58:17 +0100
Message-Id: <1416855497-6479-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add minimal runtime PM support (enable on probe, disable on remove), to
ensure proper operation with a parent device that uses runtime PM.

This is needed on systems where the external bus controller module of
the SoC is contained in a PM domain and/or has a gateable functional
clock. In such cases, before accessing any device connected to the
external bus, the PM domain must be powered up, and/or the functional
clock must be enabled, which is typically handled through runtime PM by
the bus controller driver.

An example of this is the kzm9g development board, where an smsc9220
Ethernet controller is connected to the Bus State Controller (BSC) of a
Renesas sh73a0 SoC.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/smsc/smsc911x.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 77ed74561e5fe815..f9c87624a0afb08b 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -59,6 +59,8 @@
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 #include <linux/of_net.h>
+#include <linux/pm_runtime.h>
+
 #include "smsc911x.h"
 
 #define SMSC_CHIPNAME		"smsc911x"
@@ -2338,6 +2340,9 @@ static int smsc911x_drv_remove(struct platform_device *pdev)
 
 	free_netdev(dev);
 
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
@@ -2491,6 +2496,9 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
 	if (pdata->config.shift)
 		pdata->ops = &shifted_smsc911x_ops;
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	retval = smsc911x_init(dev);
 	if (retval < 0)
 		goto out_disable_resources;
@@ -2572,6 +2580,8 @@ out_unregister_netdev_5:
 out_free_irq:
 	free_irq(dev->irq, dev);
 out_disable_resources:
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	(void)smsc911x_disable_resources(pdev);
 out_enable_resources_fail:
 	smsc911x_free_resources(pdev);
-- 
1.9.1

