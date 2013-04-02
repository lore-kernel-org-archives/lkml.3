Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab3DBSvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:51:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59247 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933010Ab3DBSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:12 -0400
X-Sasl-enc: S1sXl5sHIp0flVU3XBDnjBCKCYYgrhwDjwo5lTF13Pny 1364928492
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 3/6] mac802154: Use netif flow control
Date: Tue,  2 Apr 2013 14:47:58 -0400
Message-Id: <1364928481-1813-4-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364928481-1813-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use netif_stop_queue() and netif_wake_queue() to control the flow of
packets to mac802154 devices.  Since many IEEE 802.15.4 devices have no
output buffer, and since the mac802154 xmit() function is designed to
block, netif_stop_queue() is called after each packet.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/mac802154/tx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index a248246..fe3e02c 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -25,6 +25,7 @@
 #include <linux/if_arp.h>
 #include <linux/crc-ccitt.h>
 
+#include <net/ieee802154_netdev.h>
 #include <net/mac802154.h>
 #include <net/wpan-phy.h>
 
@@ -45,6 +46,7 @@ static void mac802154_xmit_worker(struct work_struct *work)
 {
 	struct xmit_work *xw = container_of(work, struct xmit_work, work);
 	u8 xmit_attempts = 0;
+	struct mac802154_sub_if_data *sdata;
 	int res;
 
 	mutex_lock(&xw->priv->phy->pib_lock);
@@ -71,6 +73,12 @@ static void mac802154_xmit_worker(struct work_struct *work)
 out:
 	mutex_unlock(&xw->priv->phy->pib_lock);
 
+	/* Restart the netif queue on each sub_if_data object. */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &xw->priv->slaves, list) {
+		netif_wake_queue(sdata->dev);
+	}
+	rcu_read_unlock();
 
 	dev_kfree_skb(xw->skb);
 
@@ -81,6 +89,7 @@ netdev_tx_t mac802154_tx(struct mac802154_priv *priv, struct sk_buff *skb,
 			 u8 page, u8 chan)
 {
 	struct xmit_work *work;
+	struct mac802154_sub_if_data *sdata;
 
 	if (!(priv->phy->channels_supported[page] & (1 << chan))) {
 		WARN_ON(1);
@@ -108,6 +117,13 @@ netdev_tx_t mac802154_tx(struct mac802154_priv *priv, struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	/* Stop the netif queue on each sub_if_data object. */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &priv->slaves, list) {
+		netif_stop_queue(sdata->dev);
+	}
+	rcu_read_unlock();
+
 	INIT_WORK(&work->work, mac802154_xmit_worker);
 	work->skb = skb;
 	work->priv = priv;
-- 
1.7.11.2

