Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3KTUWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:22:23 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58942 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3KTUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:22:04 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 5/7] net: mv643xx_eth: resume/suspend PHY on port start/stop
Date: Wed, 20 Nov 2013 21:21:51 +0100
Message-Id: <1384978913-8052-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network PHYs consume a noticable amount of power. This adds phy_resume
on port start and phy_suspend on port stop to save this power if the
port is down anyway. While at it, also properly start/stop the phy.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 00cd36e..55805b2 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2097,6 +2097,8 @@ static void port_start(struct mv643xx_eth_private *mp)
 
 		mv643xx_eth_get_settings(mp->dev, &cmd);
 		phy_reset(mp);
+		phy_resume(mp->phy);
+		phy_start(mp->phy);
 		mv643xx_eth_set_settings(mp->dev, &cmd);
 	}
 
@@ -2306,6 +2308,11 @@ static int mv643xx_eth_stop(struct net_device *dev)
 	for (i = 0; i < mp->txq_count; i++)
 		txq_deinit(mp->txq + i);
 
+	if (mp->phy) {
+		phy_stop(mp->phy);
+		phy_suspend(mp->phy);
+	}
+
 	return 0;
 }
 
-- 
1.7.2.5

