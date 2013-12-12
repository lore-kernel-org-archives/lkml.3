Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3LLXtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:49:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:46743 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3LLXs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:48:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,475,1384300800"; 
   d="scan'208";a="81618597"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next v2 8/9] xen-netback: Timeout packets in RX path
Date: Thu, 12 Dec 2013 23:48:16 +0000
Message-ID: <1386892097-15502-9-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com>
References: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A malicious or buggy guest can leave its queue filled indefinitely, in which
case qdisc start to queue packets for that VIF. If those packets came from an
another guest, it can block its slots and prevent shutdown. To avoid that, we
make sure the queue is drained in every 10 seconds

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/net/xen-netback/common.h    |    5 +++++
 drivers/net/xen-netback/interface.c |   21 ++++++++++++++++++++-
 drivers/net/xen-netback/netback.c   |   10 ++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index e022812..a834818 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -128,6 +128,8 @@ struct xenvif {
 	 */
 	bool rx_event;
 
+	struct timer_list wake_queue;
+
 	/* Given MAX_BUFFER_OFFSET of 4096 the worst case is that each
 	 * head/fragment page uses 2 copy operations because it
 	 * straddles two buffers in the frontend.
@@ -223,4 +225,7 @@ void xenvif_idx_unmap(struct xenvif *vif, u16 pending_idx);
 
 extern bool separate_tx_rx_irq;
 
+extern unsigned int rx_drain_timeout_msecs;
+extern unsigned int rx_drain_timeout_jiffies;
+
 #endif /* __XEN_NETBACK__COMMON_H__ */
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 7aa3535..eaf406f 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -114,6 +114,17 @@ static irqreturn_t xenvif_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void xenvif_wake_queue(unsigned long data)
+{
+	struct xenvif *vif = (struct xenvif *)data;
+
+	netdev_err(vif->dev, "timer fires\n");
+	if (netif_queue_stopped(vif->dev)) {
+		netdev_err(vif->dev, "draining TX queue\n");
+		netif_wake_queue(vif->dev);
+	}
+}
+
 static int xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xenvif *vif = netdev_priv(dev);
@@ -141,8 +152,13 @@ static int xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * then turn off the queue to give the ring a chance to
 	 * drain.
 	 */
-	if (!xenvif_rx_ring_slots_available(vif, min_slots_needed))
+	if (!xenvif_rx_ring_slots_available(vif, min_slots_needed)) {
+		vif->wake_queue.function = xenvif_wake_queue;
+		vif->wake_queue.data = (unsigned long)vif;
 		xenvif_stop_queue(vif);
+		mod_timer(&vif->wake_queue,
+			jiffies + rx_drain_timeout_jiffies);
+	}
 
 	skb_queue_tail(&vif->rx_queue, skb);
 	xenvif_kick_thread(vif);
@@ -341,6 +357,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	init_timer(&vif->credit_timeout);
 	vif->credit_window_start = get_jiffies_64();
 
+	init_timer(&vif->wake_queue);
+
 	dev->netdev_ops	= &xenvif_netdev_ops;
 	dev->hw_features = NETIF_F_SG |
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
@@ -515,6 +533,7 @@ void xenvif_disconnect(struct xenvif *vif)
 		xenvif_carrier_off(vif);
 
 	if (vif->task) {
+		del_timer_sync(&vif->wake_queue);
 		kthread_stop(vif->task);
 		vif->task = NULL;
 	}
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1078ae8..e6c56b5 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -64,6 +64,14 @@ static unsigned int fatal_skb_slots = FATAL_SKB_SLOTS_DEFAULT;
 module_param(fatal_skb_slots, uint, 0444);
 
 /*
+ * When guest ring is filled up, qdisc queues the packets for us, but we have
+ * to timeout them, otherwise other guests' packets can get stucked there
+ */
+unsigned int rx_drain_timeout_msecs = 10000;
+module_param(rx_drain_timeout_msecs, uint, 0444);
+unsigned int rx_drain_timeout_jiffies;
+
+/*
  * To avoid confusion, we define XEN_NETBK_LEGACY_SLOTS_MAX indicating
  * the maximum slots a valid packet can use. Now this value is defined
  * to be XEN_NETIF_NR_SLOTS_MIN, which is supposed to be supported by
@@ -2051,6 +2059,8 @@ static int __init netback_init(void)
 	if (rc)
 		goto failed_init;
 
+	rx_drain_timeout_jiffies = msecs_to_jiffies(rx_drain_timeout_msecs);
+
 	return 0;
 
 failed_init:
