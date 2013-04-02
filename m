Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab3DBTfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:35:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59294 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762204Ab3DBTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:35:09 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 02 Apr 2013 14:35:07 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        David Daney <david.daney@cavium.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/5] net/cadence/macb: Simplify OF dependencies
Date: Tue,  2 Apr 2013 12:35:09 -0700
Message-Id: <1364931311-30603-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
References: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With of_get_mac_address() and of_get_phy_mode() now defined as dummy
functions if OF_NET is not configured, it is no longer necessary to
provide OF dependent functions as front-end. Also, the two functions
depend on OF_NET, not on OF, so the conditional code was not correct
anyway.

Drop the front-end functions and call of_get_mac_address() and
of_get_phy_mode() directly instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/cadence/macb.c |   43 +++++------------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 7903943..b2a9d20 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1472,41 +1472,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,gem" },
 	{ /* sentinel */ }
 };
-
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-
-static int macb_get_phy_mode_dt(struct platform_device *pdev)
-{
-	struct device_node *np = pdev->dev.of_node;
-
-	if (np)
-		return of_get_phy_mode(np);
-
-	return -ENODEV;
-}
-
-static int macb_get_hwaddr_dt(struct macb *bp)
-{
-	struct device_node *np = bp->pdev->dev.of_node;
-	if (np) {
-		const char *mac = of_get_mac_address(np);
-		if (mac) {
-			memcpy(bp->dev->dev_addr, mac, ETH_ALEN);
-			return 0;
-		}
-	}
-
-	return -ENODEV;
-}
-#else
-static int macb_get_phy_mode_dt(struct platform_device *pdev)
-{
-	return -ENODEV;
-}
-static int macb_get_hwaddr_dt(struct macb *bp)
-{
-	return -ENODEV;
-}
 #endif
 
 static int __init macb_probe(struct platform_device *pdev)
@@ -1519,6 +1485,7 @@ static int __init macb_probe(struct platform_device *pdev)
 	u32 config;
 	int err = -ENXIO;
 	struct pinctrl *pinctrl;
+	const char *mac;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
@@ -1592,11 +1559,13 @@ static int __init macb_probe(struct platform_device *pdev)
 	config |= macb_dbw(bp);
 	macb_writel(bp, NCFGR, config);
 
-	err = macb_get_hwaddr_dt(bp);
-	if (err < 0)
+	mac = of_get_mac_address(pdev->dev.of_node);
+	if (mac)
+		memcpy(bp->dev->dev_addr, mac, ETH_ALEN);
+	else
 		macb_get_hwaddr(bp);
 
-	err = macb_get_phy_mode_dt(pdev);
+	err = of_get_phy_mode(pdev->dev.of_node);
 	if (err < 0) {
 		pdata = pdev->dev.platform_data;
 		if (pdata && pdata->is_rmii)
-- 
1.7.9.7

