Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaDRARr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:17:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:53809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaDRARn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:17:43 -0400
From: Max Schwarz <max.schwarz@online.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH] arc_emac: write initial MAC address from devicetree to hw
Date: Fri, 18 Apr 2014 02:17:32 +0200
Message-ID: <1664530.jeK9vBIgft@typ>
User-Agent: KMail/4.11.5 (Linux/3.11.0-19-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:aYtv/ZR5JdEVLIoo/HBdfyDDC9FNJvCuHmTyeCGlqy5
 B+ITEpF+tJ6pP3xuqKuaAEWX8qTIBGJ07/gEoX/6ZLQBB4Meia
 K39dNtVW8E3RjeYmcJEnTb630exMe+heTgyf65QYL7PQhfMNMf
 dUHE/U8aGdAXmI3gxrIVdUKaRvGMc7YcQPTzE7nMV/QlCUJMkw
 8WuroWfKNxUm134a89S0roblDYicETILmmuA8ctIQ5kZLlcA2a
 jkvAoeeBWuB2ITBlVUzY8mzUPzR+7UQGYv312l6EKFrUggxa/S
 1jdiYp6lGCKMc41IrG+43uYRKsF3OF9xQL9DeQcglk1Lqx9fA=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAC address retrieved from dt was not actually written to the
hardware. This meant proper communication was only possible after
changing the MAC address.

Fix that by always writing the mac address during probing.

Signed-off-by: Max Schwarz <max.schwarz@online.de>
---

I recently noticed this problem on the Radxa Rock board. I'm not
sure how this has ever worked on other platforms, though. I can
only receive broadcast packets without configuring the address.

Running ifconfig eth0 hw ether XYZ or applying the patch fixes
the problem for me.

CCing Heiko Stübner because he has seen the problem as well.

 drivers/net/ethernet/arc/emac_main.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index eeecc29..9f45782 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -574,6 +574,18 @@ static int arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+static void arc_emac_set_address_internal(struct net_device *ndev)
+{
+	struct arc_emac_priv *priv = netdev_priv(ndev);
+	unsigned int addr_low, addr_hi;
+
+	addr_low = le32_to_cpu(*(__le32 *) &ndev->dev_addr[0]);
+	addr_hi = le16_to_cpu(*(__le16 *) &ndev->dev_addr[4]);
+
+	arc_reg_set(priv, R_ADDRL, addr_low);
+	arc_reg_set(priv, R_ADDRH, addr_hi);
+}
+
 /**
  * arc_emac_set_address - Set the MAC address for this device.
  * @ndev:	Pointer to net_device structure.
@@ -587,9 +599,7 @@ static int arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
  */
 static int arc_emac_set_address(struct net_device *ndev, void *p)
 {
-	struct arc_emac_priv *priv = netdev_priv(ndev);
 	struct sockaddr *addr = p;
-	unsigned int addr_low, addr_hi;
 
 	if (netif_running(ndev))
 		return -EBUSY;
@@ -599,11 +609,7 @@ static int arc_emac_set_address(struct net_device *ndev, void *p)
 
 	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
 
-	addr_low = le32_to_cpu(*(__le32 *) &ndev->dev_addr[0]);
-	addr_hi = le16_to_cpu(*(__le16 *) &ndev->dev_addr[4]);
-
-	arc_reg_set(priv, R_ADDRL, addr_low);
-	arc_reg_set(priv, R_ADDRH, addr_hi);
+	arc_emac_set_address_internal(ndev);
 
 	return 0;
 }
@@ -713,6 +719,7 @@ static int arc_emac_probe(struct platform_device *pdev)
 	else
 		eth_hw_addr_random(ndev);
 
+	arc_emac_set_address_internal(ndev);
 	dev_info(&pdev->dev, "MAC address is now %pM\n", ndev->dev_addr);
 
 	/* Do 1 allocation instead of 2 separate ones for Rx and Tx BD rings */
-- 
1.8.3.2


