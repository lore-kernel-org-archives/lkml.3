Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173Ab3DCOBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:01:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50014 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758424Ab3DCOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:01:08 -0400
X-Sasl-enc: xzMiD5JA4Yi5hfguQuXFya+9EmKLUvWixnU8ShrEwh5n 1364997668
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 2/4] mac802154: Use netif flow control
Date: Wed,  3 Apr 2013 10:00:56 -0400
Message-Id: <1364997658-16498-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364997658-16498-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
 <1364997658-16498-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use netif_stop_queue() and netif_wake_queue() to control the flow of
packets to mac802154 devices.  Since many IEEE 802.15.4 devices have no
output buffer, and since the mac802154 xmit() function is designed to
block, netif_stop_queue() is called after each packet.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/mac802154/tx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 7264874..3fd3e07 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -25,6 +25,7 @@
 #include <linux/if_arp.h>
 #include <linux/crc-ccitt.h>
 
+#include <net/ieee802154_netdev.h>
 #include <net/mac802154.h>
 #include <net/wpan-phy.h>
 
@@ -44,6 +45,7 @@ struct xmit_work {
 static void mac802154_xmit_worker(struct work_struct *work)
 {
 	struct xmit_work *xw = container_of(work, struct xmit_work, work);
+	struct mac802154_sub_if_data *sdata;
 	int res;
 
 	mutex_lock(&xw->priv->phy->pib_lock);
@@ -65,6 +67,11 @@ static void mac802154_xmit_worker(struct work_struct *work)
 out:
 	mutex_unlock(&xw->priv->phy->pib_lock);
 
+	/* Restart the netif queue on each sub_if_data object. */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &xw->priv->slaves, list)
+		netif_wake_queue(sdata->dev);
+	rcu_read_unlock();
 
 	dev_kfree_skb(xw->skb);
 
@@ -75,6 +82,7 @@ netdev_tx_t mac802154_tx(struct mac802154_priv *priv, struct sk_buff *skb,
 			 u8 page, u8 chan)
 {
 	struct xmit_work *work;
+	struct mac802154_sub_if_data *sdata;
 
 	if (!(priv->phy->channels_supported[page] & (1 << chan))) {
 		WARN_ON(1);
@@ -102,6 +110,12 @@ netdev_tx_t mac802154_tx(struct mac802154_priv *priv, struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	/* Stop the netif queue on each sub_if_data object. */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &priv->slaves, list)
+		netif_stop_queue(sdata->dev);
+	rcu_read_unlock();
+
 	INIT_WORK(&work->work, mac802154_xmit_worker);
 	work->skb = skb;
 	work->priv = priv;
-- 
1.7.11.2

