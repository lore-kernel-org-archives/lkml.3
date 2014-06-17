Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966993AbaFQWuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:50:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965516AbaFQVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 019/212] vlan: Fix lockdep warning with stacked vlan devices.
Date: Tue, 17 Jun 2014 14:41:53 -0700
Message-Id: <1403041506-13646-20-git-send-email-kamal@canonical.com>
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

[ Upstream commit d38569ab2bba6e6b3233acfc3a84cdbcfbd1f79f ]

This reverts commit dc8eaaa006350d24030502a4521542e74b5cb39f.
	vlan: Fix lockdep warning when vlan dev handle notification

Instead we use the new new API to find the lock subclass of
our vlan device.  This way we can support configurations where
vlans are interspersed with other devices:
  bond -> vlan -> macvlan -> vlan

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/if_vlan.h |  3 ++-
 net/8021q/vlan.c        |  1 +
 net/8021q/vlan_dev.c    | 53 ++++++++++---------------------------------------
 net/core/dev.c          |  1 -
 4 files changed, 13 insertions(+), 45 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index f252deb..cf64933 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -73,7 +73,7 @@ static inline struct vlan_ethhdr *vlan_eth_hdr(const struct sk_buff *skb)
 /* found in socket.c */
 extern void vlan_ioctl_set(int (*hook)(struct net *, void __user *));
 
-static inline int is_vlan_dev(struct net_device *dev)
+static inline bool is_vlan_dev(struct net_device *dev)
 {
         return dev->priv_flags & IFF_802_1Q_VLAN;
 }
@@ -158,6 +158,7 @@ struct vlan_dev_priv {
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	struct netpoll				*netpoll;
 #endif
+	unsigned int				nest_level;
 };
 
 static inline struct vlan_dev_priv *vlan_dev_priv(const struct net_device *dev)
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 9a87f5a..f0aa0a4 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -169,6 +169,7 @@ int register_vlan_dev(struct net_device *dev)
 	if (err < 0)
 		goto out_uninit_mvrp;
 
+	vlan->nest_level = dev_get_nest_level(real_dev, is_vlan_dev) + 1;
 	err = register_netdevice(dev);
 	if (err < 0)
 		goto out_uninit_mvrp;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index b21d5a6..731ede4 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -493,48 +493,10 @@ static void vlan_dev_change_rx_flags(struct net_device *dev, int change)
 	}
 }
 
-static int vlan_calculate_locking_subclass(struct net_device *real_dev)
-{
-	int subclass = 0;
-
-	while (is_vlan_dev(real_dev)) {
-		subclass++;
-		real_dev = vlan_dev_priv(real_dev)->real_dev;
-	}
-
-	return subclass;
-}
-
-static void vlan_dev_mc_sync(struct net_device *to, struct net_device *from)
-{
-	int err = 0, subclass;
-
-	subclass = vlan_calculate_locking_subclass(to);
-
-	spin_lock_nested(&to->addr_list_lock, subclass);
-	err = __hw_addr_sync(&to->mc, &from->mc, to->addr_len);
-	if (!err)
-		__dev_set_rx_mode(to);
-	spin_unlock(&to->addr_list_lock);
-}
-
-static void vlan_dev_uc_sync(struct net_device *to, struct net_device *from)
-{
-	int err = 0, subclass;
-
-	subclass = vlan_calculate_locking_subclass(to);
-
-	spin_lock_nested(&to->addr_list_lock, subclass);
-	err = __hw_addr_sync(&to->uc, &from->uc, to->addr_len);
-	if (!err)
-		__dev_set_rx_mode(to);
-	spin_unlock(&to->addr_list_lock);
-}
-
 static void vlan_dev_set_rx_mode(struct net_device *vlan_dev)
 {
-	vlan_dev_mc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
-	vlan_dev_uc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
+	dev_mc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
+	dev_uc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
 }
 
 /*
@@ -562,6 +524,11 @@ static void vlan_dev_set_lockdep_class(struct net_device *dev, int subclass)
 	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, &subclass);
 }
 
+static int vlan_dev_get_lock_subclass(struct net_device *dev)
+{
+	return vlan_dev_priv(dev)->nest_level;
+}
+
 static const struct header_ops vlan_header_ops = {
 	.create	 = vlan_dev_hard_header,
 	.rebuild = vlan_dev_rebuild_header,
@@ -597,7 +564,7 @@ static const struct net_device_ops vlan_netdev_ops;
 static int vlan_dev_init(struct net_device *dev)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	int subclass = 0, i;
+	int i;
 
 	netif_carrier_off(dev);
 
@@ -643,8 +610,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &vlan_type);
 
-	subclass = vlan_calculate_locking_subclass(dev);
-	vlan_dev_set_lockdep_class(dev, subclass);
+	vlan_dev_set_lockdep_class(dev, vlan_dev_get_lock_subclass(dev));
 
 	vlan_dev_priv(dev)->vlan_pcpu_stats = alloc_percpu(struct vlan_pcpu_stats);
 	if (!vlan_dev_priv(dev)->vlan_pcpu_stats)
@@ -824,6 +790,7 @@ static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_netpoll_cleanup	= vlan_dev_netpoll_cleanup,
 #endif
 	.ndo_fix_features	= vlan_dev_fix_features,
+	.ndo_get_lock_subclass  = vlan_dev_get_lock_subclass,
 };
 
 void vlan_setup(struct net_device *dev)
diff --git a/net/core/dev.c b/net/core/dev.c
index ff0c02e..1434116 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5214,7 +5214,6 @@ void __dev_set_rx_mode(struct net_device *dev)
 	if (ops->ndo_set_rx_mode)
 		ops->ndo_set_rx_mode(dev);
 }
-EXPORT_SYMBOL(__dev_set_rx_mode);
 
 void dev_set_rx_mode(struct net_device *dev)
 {
-- 
1.9.1

