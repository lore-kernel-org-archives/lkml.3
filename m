Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaJMCfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:35:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaJMCaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 02/25] net: systemport: fix bcm_sysport_insert_tsb()
Date: Mon, 13 Oct 2014 04:24:55 +0200
Message-Id: <20141013022454.385617705@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit e87474a6e697857df21cff0707a2472abceca8b3 ]

Similar to commit bc23333ba11fb7f959b7e87e121122f5a0fbbca8 ("net:
bcmgenet: fix bcmgenet_put_tx_csum()"), we need to return the skb
pointer in case we had to reallocate the SKB headroom.

Fixes: 80105befdb4b8 ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -848,7 +848,8 @@ static irqreturn_t bcm_sysport_wol_isr(i
 	return IRQ_HANDLED;
 }
 
-static int bcm_sysport_insert_tsb(struct sk_buff *skb, struct net_device *dev)
+static struct sk_buff *bcm_sysport_insert_tsb(struct sk_buff *skb,
+					      struct net_device *dev)
 {
 	struct sk_buff *nskb;
 	struct bcm_tsb *tsb;
@@ -864,7 +865,7 @@ static int bcm_sysport_insert_tsb(struct
 		if (!nskb) {
 			dev->stats.tx_errors++;
 			dev->stats.tx_dropped++;
-			return -ENOMEM;
+			return NULL;
 		}
 		skb = nskb;
 	}
@@ -883,7 +884,7 @@ static int bcm_sysport_insert_tsb(struct
 			ip_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return 0;
+			return skb;
 		}
 
 		/* Get the checksum offset and the L4 (transport) offset */
@@ -902,7 +903,7 @@ static int bcm_sysport_insert_tsb(struct
 		tsb->l4_ptr_dest_map = csum_info;
 	}
 
-	return 0;
+	return skb;
 }
 
 static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
@@ -936,8 +937,8 @@ static netdev_tx_t bcm_sysport_xmit(stru
 
 	/* Insert TSB and checksum infos */
 	if (priv->tsb_en) {
-		ret = bcm_sysport_insert_tsb(skb, dev);
-		if (ret) {
+		skb = bcm_sysport_insert_tsb(skb, dev);
+		if (!skb) {
 			ret = NETDEV_TX_OK;
 			goto out;
 		}


