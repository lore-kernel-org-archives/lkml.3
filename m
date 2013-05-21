Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3EUQmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:42:19 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43128 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3EUQmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:42:15 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/12] net: mv643xx_eth: use phy_disconnect instead of phy_detach
Date: Tue, 21 May 2013 18:41:39 +0200
Message-Id: <1369154510-4927-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a separated mdio bus driver with mvmdio, phy_detach on network device
removal will not stop the phy and finally lead to NULL pointer dereference
in mvmdio due to non-existent network device. Use phy_disconnect instead
to properly stop phy device from accessing network device prior removal of
the network device.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Note: I observed this behavior when removing a modular mv643xx_eth driver
after attaching it to a phy handled by (also modular) mvmdio. The mvmdio
conversion has been done in

commit c3a07134e6aa5b93a37f72ffa3d11fadf72bf757
 ("mv643xx_eth: convert to use the Marvell Orion MDIO driver")

and should go back any -stable version with that commit (propably only 3.9)

@David: I am not sure if the above description is sufficient for a -stable
patch, if you need more, like actual kernel failure, I am sure I can reproduce
it.

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
 drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index d0afeea..ef3454c 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2805,7 +2805,7 @@ static int mv643xx_eth_remove(struct platform_device *pdev)
 
 	unregister_netdev(mp->dev);
 	if (mp->phy != NULL)
-		phy_detach(mp->phy);
+		phy_disconnect(mp->phy);
 	cancel_work_sync(&mp->tx_timeout_task);
 
 	if (!IS_ERR(mp->clk))
-- 
1.7.10.4

