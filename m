Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbaFUOto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 10:49:44 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:54653 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaFUOsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 10:48:13 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] tlan: Fix MAC address byte order on OC-2325/OC-2326
Date: Sat, 21 Jun 2014 16:47:49 +0200
Message-Id: <1403362076-7777-5-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403362076-7777-1-git-send-email-linux@rainbow-software.org>
References: <1403362076-7777-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olicom OC-2325 and OC-2326 cards have the MAC address byte-swapped in EEPROM.
Byte-swap the MAC address if it's located at offset 0xF8.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/ti/tlan.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index ae9fece..31d4a96 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -864,7 +864,7 @@ static int tlan_init(struct net_device *dev)
 		priv->rx_list_dma + sizeof(struct tlan_list)*TLAN_NUM_RX_LISTS;
 
 	err = 0;
-	for (i = 0;  i < 6 ; i++)
+	for (i = 0; i < ETH_ALEN; i++)
 		err |= tlan_ee_read_byte(dev,
 					 (u8) priv->adapter->addr_ofs + i,
 					 (u8 *) &dev->dev_addr[i]);
@@ -872,7 +872,14 @@ static int tlan_init(struct net_device *dev)
 		pr_err("%s: Error reading MAC from eeprom: %d\n",
 		       dev->name, err);
 	}
-	dev->addr_len = 6;
+	/* Olicom OC-2325/OC-2326 have the address byte-swapped */
+	if (priv->adapter->addr_ofs == 0xf8) {
+		for (i = 0; i < ETH_ALEN; i += 2) {
+			char tmp = dev->dev_addr[i];
+			dev->dev_addr[i] = dev->dev_addr[i + 1];
+			dev->dev_addr[i + 1] = tmp;
+		}
+	}
 
 	netif_carrier_off(dev);
 
-- 
Ondrej Zary

