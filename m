Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3LSL7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:59:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45295 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3LSL7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 179/208] net: allwinner: emac: Add missing free_irq
Date: Thu, 19 Dec 2013 11:54:37 +0000
Message-Id: <1387454106-19326-180-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit e9c56f8d2f851fb6d6ce6794c0f5463b862a878e upstream.

The sun4i-emac driver uses devm_request_irq at .ndo_open time, but relies on
the managed device mechanism to actually free it. This causes an issue whenever
someone wants to restart the interface, the interrupt still being held, and not
yet released.

Fall back to using the regular request_irq at .ndo_open time, and introduce a
free_irq during .ndo_stop.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 50b853a..46dfb13 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -717,8 +717,7 @@ static int emac_open(struct net_device *dev)
 	if (netif_msg_ifup(db))
 		dev_dbg(db->dev, "enabling %s\n", dev->name);
 
-	if (devm_request_irq(db->dev, dev->irq, &emac_interrupt,
-			     0, dev->name, dev))
+	if (request_irq(dev->irq, &emac_interrupt, 0, dev->name, dev))
 		return -EAGAIN;
 
 	/* Initialize EMAC board */
@@ -774,6 +773,8 @@ static int emac_stop(struct net_device *ndev)
 
 	emac_shutdown(ndev);
 
+	free_irq(ndev->irq, ndev);
+
 	return 0;
 }
 
-- 
1.8.3.2

