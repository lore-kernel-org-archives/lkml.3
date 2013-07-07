Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3GGWpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 18:45:32 -0400
Received: from mail.nanl.de ([217.115.11.12]:41095 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab3GGWpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 18:45:30 -0400
From: Jonas Gorski <jogo@openwrt.org>
To: netdev@vger.kernel.org
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mv643xx_eth: do not use port number as platform device id
Date: Mon,  8 Jul 2013 00:44:55 +0200
Message-Id: <1373237095-28989-1-git-send-email-jogo@openwrt.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <51D9E499.5000801@gmail.com>
References: <51D9E499.5000801@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port number is only local to the ethernet block, not global, so
there can be two ethernet blocks both using the same port, like
kirkwood with both using port 0.

Fix this by using the array index offset for the allocated platform
devices as the id.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 6495bea..c35db73 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2483,6 +2483,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	struct resource res;
 	const char *mac_addr;
 	int ret;
+	int dev_num = 0;
 
 	memset(&ppd, 0, sizeof(ppd));
 	ppd.shared = pdev;
@@ -2503,6 +2504,14 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
+	while (dev_num < 3 && port_platdev[dev_num])
+		dev_num++;
+
+	if (dev_num == 3) {
+		dev_err(&pdev->dev, "too many ports registered\n");
+		return -EINVAL;
+	}
+
 	mac_addr = of_get_mac_address(pnp);
 	if (mac_addr)
 		memcpy(ppd.mac_addr, mac_addr, 6);
@@ -2521,7 +2530,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 		of_property_read_u32(pnp, "duplex", &ppd.duplex);
 	}
 
-	ppdev = platform_device_alloc(MV643XX_ETH_NAME, ppd.port_number);
+	ppdev = platform_device_alloc(MV643XX_ETH_NAME, dev_num);
 	if (!ppdev)
 		return -ENOMEM;
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
@@ -2538,7 +2547,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	if (ret)
 		goto port_err;
 
-	port_platdev[ppd.port_number] = ppdev;
+	port_platdev[dev_num] = ppdev;
 
 	return 0;
 
-- 
1.8.3.2

