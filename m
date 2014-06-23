Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaFWUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:50:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51340 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756647AbaFWUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:50:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] net: allwinner: emac: Add missing free_irq
Date: Mon, 23 Jun 2014 22:49:40 +0200
Message-Id: <1403556580-21818-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the mdio probe function fails in emac_open, the interrupt we just requested
isn't freed. If emac_open is called again, for example because we try to set up
the interface again, the kernel will oops because the interrupt wasn't properly
released.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: <stable@vger.kernel.org> # 3.11+
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 28460676b8ca..d81e7167a8b5 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -736,6 +736,7 @@ static int emac_open(struct net_device *dev)
 
 	ret = emac_mdio_probe(dev);
 	if (ret < 0) {
+		free_irq(dev->irq, dev);
 		netdev_err(dev, "cannot probe MDIO bus\n");
 		return ret;
 	}
-- 
2.0.0

