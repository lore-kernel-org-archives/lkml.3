Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3BCPXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:23:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34110 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670Ab3BCOzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:02 -0500
Message-Id: <20130203144645.292616915@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Avinash Patil <patila@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 014/128] mwifiex: wakeup and stop multiple tx queues in net_device
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit bbea3bc432dc5c08d09ca5c80afdd82515470688 upstream.

replace single queue function calls with equivalent multiple queue
functions. Wakeup queue and stop queue calls are guarded by spin lock.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/init.c      |   40 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.c      |   11 ++++----
 drivers/net/wireless/mwifiex/main.h      |    9 +++++++
 drivers/net/wireless/mwifiex/sta_event.c |    6 ++---
 drivers/net/wireless/mwifiex/sta_ioctl.c |    4 +--
 drivers/net/wireless/mwifiex/txrx.c      |    5 ++--
 6 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 2694045..244c728 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -283,6 +283,45 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 }
 
 /*
+ * This function sets trans_start per tx_queue
+ */
+void mwifiex_set_trans_start(struct net_device *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++)
+		netdev_get_tx_queue(dev, i)->trans_start = jiffies;
+
+	dev->trans_start = jiffies;
+}
+
+/*
+ * This function wakes up all queues in net_device
+ */
+void mwifiex_wake_up_net_dev_queue(struct net_device *netdev,
+					struct mwifiex_adapter *adapter)
+{
+	unsigned long dev_queue_flags;
+
+	spin_lock_irqsave(&adapter->queue_lock, dev_queue_flags);
+	netif_tx_wake_all_queues(netdev);
+	spin_unlock_irqrestore(&adapter->queue_lock, dev_queue_flags);
+}
+
+/*
+ * This function stops all queues in net_device
+ */
+void mwifiex_stop_net_dev_queue(struct net_device *netdev,
+					struct mwifiex_adapter *adapter)
+{
+	unsigned long dev_queue_flags;
+
+	spin_lock_irqsave(&adapter->queue_lock, dev_queue_flags);
+	netif_tx_stop_all_queues(netdev);
+	spin_unlock_irqrestore(&adapter->queue_lock, dev_queue_flags);
+}
+
+/*
  *  This function releases the lock variables and frees the locks and
  *  associated locks.
  */
@@ -359,6 +398,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	spin_lock_init(&adapter->int_lock);
 	spin_lock_init(&adapter->main_proc_lock);
 	spin_lock_init(&adapter->mwifiex_cmd_lock);
+	spin_lock_init(&adapter->queue_lock);
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			priv = adapter->priv[i];
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 67e6db7..d21cd47 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -401,7 +401,7 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 static int
 mwifiex_open(struct net_device *dev)
 {
-	netif_start_queue(dev);
+	netif_tx_start_all_queues(dev);
 	return 0;
 }
 
@@ -465,8 +465,8 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	atomic_inc(&priv->adapter->tx_pending);
 
 	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
-		netif_stop_queue(priv->netdev);
-		dev->trans_start = jiffies;
+		mwifiex_set_trans_start(dev);
+		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
 	}
 
 	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
@@ -533,7 +533,7 @@ mwifiex_tx_timeout(struct net_device *dev)
 
 	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_index=%d\n",
 				jiffies, priv->bss_index);
-	dev->trans_start = jiffies;
+	mwifiex_set_trans_start(dev);
 	priv->num_tx_timeout++;
 }
 
@@ -793,7 +793,8 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		priv = adapter->priv[i];
 		if (priv && priv->netdev) {
 			if (!netif_queue_stopped(priv->netdev))
-				netif_stop_queue(priv->netdev);
+				mwifiex_stop_net_dev_queue(priv->netdev,
+								adapter);
 			if (netif_carrier_ok(priv->netdev))
 				netif_carrier_off(priv->netdev);
 		}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3861a61..41f8863 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -655,10 +655,19 @@ struct mwifiex_adapter {
 	struct mwifiex_wait_queue cmd_wait_q;
 	u8 scan_wait_q_woken;
 	struct cmd_ctrl_node *cmd_queued;
+	spinlock_t queue_lock;		/* lock for tx queues */
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
 
+void mwifiex_set_trans_start(struct net_device *dev);
+
+void mwifiex_stop_net_dev_queue(struct net_device *netdev,
+		struct mwifiex_adapter *adapter);
+
+void mwifiex_wake_up_net_dev_queue(struct net_device *netdev,
+		struct mwifiex_adapter *adapter);
+
 int mwifiex_init_fw(struct mwifiex_adapter *adapter);
 
 int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index f204810..40205f6 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -126,7 +126,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 		queue_work(priv->workqueue, &priv->cfg_workqueue);
 	}
 	if (!netif_queue_stopped(priv->netdev))
-		netif_stop_queue(priv->netdev);
+		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
 	/* Reset wireless stats signal info */
@@ -201,7 +201,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		if (!netif_carrier_ok(priv->netdev))
 			netif_carrier_on(priv->netdev);
 		if (netif_queue_stopped(priv->netdev))
-			netif_wake_queue(priv->netdev);
+			mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 		break;
 
 	case EVENT_DEAUTHENTICATED:
@@ -292,7 +292,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		priv->adhoc_is_link_sensed = false;
 		mwifiex_clean_txrx(priv);
 		if (!netif_queue_stopped(priv->netdev))
-			netif_stop_queue(priv->netdev);
+			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 		if (netif_carrier_ok(priv->netdev))
 			netif_carrier_off(priv->netdev);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 4b6f553..6d990c7 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -234,7 +234,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 				      "associating...\n");
 
 		if (!netif_queue_stopped(priv->netdev))
-			netif_stop_queue(priv->netdev);
+			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 
 		/* Clear any past association response stored for
 		 * application retrieval */
@@ -265,7 +265,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		ret = mwifiex_check_network_compatibility(priv, bss_desc);
 
 		if (!netif_queue_stopped(priv->netdev))
-			netif_stop_queue(priv->netdev);
+			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 
 		if (!ret) {
 			dev_dbg(adapter->dev, "info: network found in scan"
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index a206f41..d9274a1 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -134,7 +134,7 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 	if (!priv)
 		goto done;
 
-	priv->netdev->trans_start = jiffies;
+	mwifiex_set_trans_start(priv->netdev);
 	if (!status) {
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += skb->len;
@@ -152,7 +152,8 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		if ((GET_BSS_ROLE(tpriv) == MWIFIEX_BSS_ROLE_STA)
 				&& (tpriv->media_connected)) {
 			if (netif_queue_stopped(tpriv->netdev))
-				netif_wake_queue(tpriv->netdev);
+				mwifiex_wake_up_net_dev_queue(tpriv->netdev,
+								adapter);
 		}
 	}
 done:


