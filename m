Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3LKAHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:07:46 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65466 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3LKAHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:07:41 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v2 1/5] net: macb: Migrate to dev_pm_ops
Date: Tue, 10 Dec 2013 16:07:19 -0800
Message-Id: <1386720443-24100-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386720443-24100-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1386720443-24100-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate the suspend/resume functions to use the dev_pm_ops PM interface.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/net/ethernet/cadence/macb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 92578690f6de..389ccf1362d5 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1946,8 +1946,9 @@ static int __exit macb_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int macb_suspend(struct platform_device *pdev, pm_message_t state)
+static int macb_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct net_device *netdev = platform_get_drvdata(pdev);
 	struct macb *bp = netdev_priv(netdev);
 
@@ -1960,8 +1961,9 @@ static int macb_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int macb_resume(struct platform_device *pdev)
+static int macb_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct net_device *netdev = platform_get_drvdata(pdev);
 	struct macb *bp = netdev_priv(netdev);
 
@@ -1972,19 +1974,17 @@ static int macb_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#else
-#define macb_suspend	NULL
-#define macb_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(macb_pm_ops, macb_suspend, macb_resume);
+
 static struct platform_driver macb_driver = {
 	.remove		= __exit_p(macb_remove),
-	.suspend	= macb_suspend,
-	.resume		= macb_resume,
 	.driver		= {
 		.name		= "macb",
 		.owner	= THIS_MODULE,
 		.of_match_table	= of_match_ptr(macb_dt_ids),
+		.pm	= &macb_pm_ops,
 	},
 };
 
-- 
1.8.5.1

