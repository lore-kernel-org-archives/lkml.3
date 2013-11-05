Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3KEBLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:11:46 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:49279 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KEBLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:11:45 -0500
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: mv643xx_eth: Add missing phy_addr_set in DT mode
Date: Mon,  4 Nov 2013 17:27:19 -0700
Message-Id: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cc9d4598 'net: mv643xx_eth: use of_phy_connect if phy_node
present' made the call to phy_scan optional, if the DT has a link to
the phy node.

However phy_scan has the side effect of calling phy_addr_set, which
writes the phy MDIO address to the ethernet controller. If phy_addr_set
is not called, and the bootloader has not set the correct address then
the driver will fail to function.

Tested on Kirkwood.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
Cc: David Miller <davem@davemloft.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 2c210ec..00e43b5 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2890,6 +2890,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 					 PHY_INTERFACE_MODE_GMII);
 		if (!mp->phy)
 			err = -ENODEV;
+		phy_addr_set(mp, mp->phy->addr);
 	} else if (pd->phy_addr != MV643XX_ETH_PHY_NONE) {
 		mp->phy = phy_scan(mp, pd->phy_addr);
 
-- 
1.8.1.2

