Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163049Ab3DEXD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:03:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39583 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162833Ab3DEXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:03:26 -0400
X-Sasl-enc: N7iSl4JisUyiDB+yM5DVuZ+d+WdQjKk9Cu99i4jYu7xQ 1365203005
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2] mac802154: Keep track of the channel when changed
Date: Fri,  5 Apr 2013 19:03:10 -0400
Message-Id: <1365202990-9006-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <515F4017.6060404@signal11.us>
References: <515F4017.6060404@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two sections checked whether the current channel != the new channel
without ever setting the current channel variables.

1. net/mac802154/tx.c: Prevent set_channel() from getting called every
time a packet is sent.

2. net/mac802154/mib.c: Lock (pib_lock) accesses to current_channel and
current_page and make sure they are updated when the channel has been
changed.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/mac802154/mib.c | 12 +++++++++++-
 net/mac802154/tx.c  |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/mac802154/mib.c b/net/mac802154/mib.c
index f03e55f..8ded97c 100644
--- a/net/mac802154/mib.c
+++ b/net/mac802154/mib.c
@@ -176,9 +176,15 @@ static void phy_chan_notify(struct work_struct *work)
 	struct mac802154_sub_if_data *priv = netdev_priv(nw->dev);
 	int res;
 
+	mutex_lock(&priv->hw->phy->pib_lock);
 	res = hw->ops->set_channel(&hw->hw, priv->page, priv->chan);
 	if (res)
 		pr_debug("set_channel failed\n");
+	else {
+		priv->hw->phy->current_channel = priv->chan;
+		priv->hw->phy->current_page = priv->page;
+	}
+	mutex_unlock(&priv->hw->phy->pib_lock);
 
 	kfree(nw);
 }
@@ -195,8 +201,11 @@ void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan)
 	priv->chan = chan;
 	spin_unlock_bh(&priv->mib_lock);
 
+	mutex_lock(&priv->hw->phy->pib_lock);
 	if (priv->hw->phy->current_channel != priv->chan ||
 	    priv->hw->phy->current_page != priv->page) {
+		mutex_unlock(&priv->hw->phy->pib_lock);
+
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
 		if (!work)
 			return;
@@ -204,5 +213,6 @@ void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan)
 		INIT_WORK(&work->work, phy_chan_notify);
 		work->dev = dev;
 		queue_work(priv->hw->dev_workqueue, &work->work);
-	}
+	} else
+		mutex_unlock(&priv->hw->phy->pib_lock);
 }
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 3fd3e07..6d16473 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -58,6 +58,9 @@ static void mac802154_xmit_worker(struct work_struct *work)
 			pr_debug("set_channel failed\n");
 			goto out;
 		}
+
+		xw->priv->phy->current_channel = xw->chan;
+		xw->priv->phy->current_page = xw->page;
 	}
 
 	res = xw->priv->ops->xmit(&xw->priv->hw, xw->skb);
-- 
1.7.11.2

