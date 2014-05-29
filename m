Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956AbaE2FU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:20:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaE2Ef1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 081/140] net: Find the nesting level of a given device by type.
Date: Wed, 28 May 2014 21:33:40 -0700
Message-Id: <20140529043100.027388398@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 4085ebe8c31face855fd01ee40372cb4aab1df3a ]

Multiple devices in the kernel can be stacked/nested and they
need to know their nesting level for the purposes of lockdep.
This patch provides a generic function that determines a nesting
level of a particular device by its type (ex: vlan, macvlan, etc).
We only care about nesting of the same type of devices.

For example:
  eth0 <- vlan0.10 <- macvlan0 <- vlan1.20

The nesting level of vlan1.20 would be 1, since there is another vlan
in the stack under it.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |   10 +++++++++
 net/core/dev.c            |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2988,6 +2988,14 @@ void *netdev_lower_get_next_private_rcu(
 	     priv; \
 	     priv = netdev_lower_get_next_private_rcu(dev, &(iter)))
 
+void *netdev_lower_get_next(struct net_device *dev,
+				struct list_head **iter);
+#define netdev_for_each_lower_dev(dev, ldev, iter) \
+	for (iter = &(dev)->adj_list.lower, \
+	     ldev = netdev_lower_get_next(dev, &(iter)); \
+	     ldev; \
+	     ldev = netdev_lower_get_next(dev, &(iter)))
+
 void *netdev_adjacent_get_private(struct list_head *adj_list);
 void *netdev_lower_get_first_private_rcu(struct net_device *dev);
 struct net_device *netdev_master_upper_dev_get(struct net_device *dev);
@@ -3003,6 +3011,8 @@ void netdev_upper_dev_unlink(struct net_
 void netdev_adjacent_rename_links(struct net_device *dev, char *oldname);
 void *netdev_lower_dev_get_private(struct net_device *dev,
 				   struct net_device *lower_dev);
+int dev_get_nest_level(struct net_device *dev,
+		       bool (*type_check)(struct net_device *dev));
 int skb_checksum_help(struct sk_buff *skb);
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				  netdev_features_t features, bool tx_path);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4605,6 +4605,32 @@ void *netdev_lower_get_next_private_rcu(
 EXPORT_SYMBOL(netdev_lower_get_next_private_rcu);
 
 /**
+ * netdev_lower_get_next - Get the next device from the lower neighbour
+ *                         list
+ * @dev: device
+ * @iter: list_head ** of the current position
+ *
+ * Gets the next netdev_adjacent from the dev's lower neighbour
+ * list, starting from iter position. The caller must hold RTNL lock or
+ * its own locking that guarantees that the neighbour lower
+ * list will remain unchainged.
+ */
+void *netdev_lower_get_next(struct net_device *dev, struct list_head **iter)
+{
+	struct netdev_adjacent *lower;
+
+	lower = list_entry((*iter)->next, struct netdev_adjacent, list);
+
+	if (&lower->list == &dev->adj_list.lower)
+		return NULL;
+
+	*iter = &lower->list;
+
+	return lower->dev;
+}
+EXPORT_SYMBOL(netdev_lower_get_next);
+
+/**
  * netdev_lower_get_first_private_rcu - Get the first ->private from the
  *				       lower neighbour list, RCU
  *				       variant
@@ -5054,6 +5080,30 @@ void *netdev_lower_dev_get_private(struc
 }
 EXPORT_SYMBOL(netdev_lower_dev_get_private);
 
+
+int dev_get_nest_level(struct net_device *dev,
+		       bool (*type_check)(struct net_device *dev))
+{
+	struct net_device *lower = NULL;
+	struct list_head *iter;
+	int max_nest = -1;
+	int nest;
+
+	ASSERT_RTNL();
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		nest = dev_get_nest_level(lower, type_check);
+		if (max_nest < nest)
+			max_nest = nest;
+	}
+
+	if (type_check(dev))
+		max_nest++;
+
+	return max_nest;
+}
+EXPORT_SYMBOL(dev_get_nest_level);
+
 static void dev_change_rx_flags(struct net_device *dev, int flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;


