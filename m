Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaF3Lx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:53:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51913 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbaF3LxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 017/181] vlan: more careful checksum features handling
Date: Mon, 30 Jun 2014 13:50:38 +0200
Message-Id: <306ba5b24eab33ed30f13ff2005e021881b3d2bf.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubeček <mkubecek@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit da08143b85203b581f4a6461b149186b0e9592df upstream.

When combining real_dev's features and vlan_features, simple
bitwise AND is used. This doesn't work well for checksum
offloading features as if one set has NETIF_F_HW_CSUM and the
other NETIF_F_IP_CSUM and/or NETIF_F_IPV6_CSUM, we end up with
no checksum offloading. However, from the logical point of view
(how can_checksum_protocol() works), NETIF_F_HW_CSUM contains
the functionality of NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM so
that the result should be IP/IPV6.

Add helper function netdev_intersect_features() implementing
this logic and use it in vlan_dev_fix_features().

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/netdevice.h | 14 ++++++++++++++
 net/8021q/vlan_dev.c      |  4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f2a0cbc7d06..51bfd7a68272 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2892,6 +2892,20 @@ extern const char *netdev_drivername(const struct net_device *dev);
 
 extern void linkwatch_run_queue(void);
 
+static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
+							  netdev_features_t f2)
+{
+	if (f1 & NETIF_F_GEN_CSUM)
+		f1 |= (NETIF_F_ALL_CSUM & ~NETIF_F_GEN_CSUM);
+	if (f2 & NETIF_F_GEN_CSUM)
+		f2 |= (NETIF_F_ALL_CSUM & ~NETIF_F_GEN_CSUM);
+	f1 &= f2;
+	if (f1 & NETIF_F_GEN_CSUM)
+		f1 &= ~(NETIF_F_ALL_CSUM & ~NETIF_F_GEN_CSUM);
+
+	return f1;
+}
+
 static inline netdev_features_t netdev_get_wanted_features(
 	struct net_device *dev)
 {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 1b89bc7468de..0c21361fab30 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -694,9 +694,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
 	netdev_features_t old_features = features;
 
-	features &= real_dev->vlan_features;
+	features = netdev_intersect_features(features, real_dev->vlan_features);
 	features |= NETIF_F_RXCSUM;
-	features &= real_dev->features;
+	features = netdev_intersect_features(features, real_dev->features);
 
 	features |= old_features & NETIF_F_SOFT_FEATURES;
 	features |= NETIF_F_LLTX;
-- 
2.0.0

