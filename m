Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967093AbaFQWvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:51:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965515AbaFQVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 018/212] net: Allow for more then a single subclass for netif_addr_lock
Date: Tue, 17 Jun 2014 14:41:52 -0700
Message-Id: <1403041506-13646-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 25175ba5c9bff9aaf0229df34bb5d54c81633ec3 ]

Currently netif_addr_lock_nested assumes that there can be only
a single nesting level between 2 devices.  However, if we
have multiple devices of the same type stacked, this fails.
For example:
 eth0 <-- vlan0.10 <-- vlan0.10.20

A more complicated configuration may stack more then one type of
device in different order.
Ex:
  eth0 <-- vlan0.10 <-- macvlan0 <-- vlan1.10.20 <-- macvlan1

This patch adds an ndo_* function that allows each stackable
device to report its nesting level.  If the device doesn't
provide this function default subclass of 1 is used.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/netdevice.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d7df837..dfc5271 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1128,6 +1128,7 @@ struct net_device_ops {
 	netdev_tx_t		(*ndo_dfwd_start_xmit) (struct sk_buff *skb,
 							struct net_device *dev,
 							void *priv);
+	int			(*ndo_get_lock_subclass)(struct net_device *dev);
 };
 
 /*
@@ -2742,7 +2743,12 @@ static inline void netif_addr_lock(struct net_device *dev)
 
 static inline void netif_addr_lock_nested(struct net_device *dev)
 {
-	spin_lock_nested(&dev->addr_list_lock, SINGLE_DEPTH_NESTING);
+	int subclass = SINGLE_DEPTH_NESTING;
+
+	if (dev->netdev_ops->ndo_get_lock_subclass)
+		subclass = dev->netdev_ops->ndo_get_lock_subclass(dev);
+
+	spin_lock_nested(&dev->addr_list_lock, subclass);
 }
 
 static inline void netif_addr_lock_bh(struct net_device *dev)
-- 
1.9.1

