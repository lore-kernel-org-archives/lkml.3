Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab3DBTgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:36:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59312 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab3DBTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:35:13 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 02 Apr 2013 14:35:08 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        David Daney <david.daney@cavium.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4/5] net/freescale/fec: Simplify OF dependencies
Date: Tue,  2 Apr 2013 12:35:10 -0700
Message-Id: <1364931311-30603-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
References: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since of_get_mac_address() is now defined even if CONFIG_OF_NET
is not configured, the ifdef around the code calling it is no longer
necessary and can be removed.

Similar, since of_get_phy_mode() is now defined as dummy function
if OF_NET is not configured, it is no longer necessary to provide
an OF dependent function as front-end. Also, the function depends
on OF_NET, not on OF, so the conditional code was not correct anyway.
Drop the front-end function and call of_get_phy_mode() directly.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/freescale/fec.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index 911d025..d374a94 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -868,7 +868,6 @@ static void fec_get_mac(struct net_device *ndev)
 	 */
 	iap = macaddr;
 
-#ifdef CONFIG_OF
 	/*
 	 * 2) from device tree data
 	 */
@@ -880,7 +879,6 @@ static void fec_get_mac(struct net_device *ndev)
 				iap = (unsigned char *) mac;
 		}
 	}
-#endif
 
 	/*
 	 * 3) from flash or fuse (via platform data)
@@ -1666,16 +1664,6 @@ static int fec_enet_init(struct net_device *ndev)
 }
 
 #ifdef CONFIG_OF
-static int fec_get_phy_mode_dt(struct platform_device *pdev)
-{
-	struct device_node *np = pdev->dev.of_node;
-
-	if (np)
-		return of_get_phy_mode(np);
-
-	return -ENODEV;
-}
-
 static void fec_reset_phy(struct platform_device *pdev)
 {
 	int err, phy_reset;
@@ -1704,11 +1692,6 @@ static void fec_reset_phy(struct platform_device *pdev)
 	gpio_set_value(phy_reset, 1);
 }
 #else /* CONFIG_OF */
-static int fec_get_phy_mode_dt(struct platform_device *pdev)
-{
-	return -ENODEV;
-}
-
 static void fec_reset_phy(struct platform_device *pdev)
 {
 	/*
@@ -1773,7 +1756,7 @@ fec_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ndev);
 
-	ret = fec_get_phy_mode_dt(pdev);
+	ret = of_get_phy_mode(pdev->dev.of_node);
 	if (ret < 0) {
 		pdata = pdev->dev.platform_data;
 		if (pdata)
-- 
1.7.9.7

