Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaAMOgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:36:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaAMO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:27:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 91/96] vlan: Fix header ops passthru when doing TX VLAN offload.
Date: Mon, 13 Jan 2014 14:24:54 +0000
Message-Id: <1389623099-18783-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 2205369a314e12fcec4781cc73ac9c08fc2b47de upstream.

When the vlan code detects that the real device can do TX VLAN offloads
in hardware, it tries to arrange for the real device's header_ops to
be invoked directly.

But it does so illegally, by simply hooking the real device's
header_ops up to the VLAN device.

This doesn't work because we will end up invoking a set of header_ops
routines which expect a device type which matches the real device, but
will see a VLAN device instead.

Fix this by providing a pass-thru set of header_ops which will arrange
to pass the proper real device instead.

To facilitate this add a dev_rebuild_header().  There are
implementations which provide a ->cache and ->create but not a
->rebuild (f.e. PLIP).  So we need a helper function just like
dev_hard_header() to avoid crashes.

Use this helper in the one existing place where the
header_ops->rebuild was being invoked, the neighbour code.

With lots of help from Florian Westphal.

Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: used davem's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/netdevice.h |  9 +++++++++
 net/8021q/vlan_dev.c      | 19 ++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 735cb59..e80df17 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1726,6 +1726,15 @@ static inline int dev_parse_header(const struct sk_buff *skb,
 	return dev->header_ops->parse(skb, haddr);
 }
 
+static inline int dev_rebuild_header(struct sk_buff *skb)
+{
+	const struct net_device *dev = skb->dev;
+
+	if (!dev->header_ops || !dev->header_ops->rebuild)
+		return 0;
+	return dev->header_ops->rebuild(skb);
+}
+
 typedef int gifconf_func_t(struct net_device * dev, char __user * bufptr, int len);
 extern int		register_gifconf(unsigned int family, gifconf_func_t * gifconf);
 static inline int unregister_gifconf(unsigned int family)
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index b8cf84e..ce40df8 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -525,6 +525,23 @@ static const struct header_ops vlan_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
+static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev,
+				     unsigned short type,
+				     const void *daddr, const void *saddr,
+				     unsigned int len)
+{
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+	struct net_device *real_dev = vlan->real_dev;
+
+	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
+}
+
+static const struct header_ops vlan_passthru_header_ops = {
+	.create	 = vlan_passthru_hard_header,
+	.rebuild = dev_rebuild_header,
+	.parse	 = eth_header_parse,
+};
+
 static const struct net_device_ops vlan_netdev_ops;
 
 static int vlan_dev_init(struct net_device *dev)
@@ -564,7 +581,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	dev->needed_headroom = real_dev->needed_headroom;
 	if (real_dev->features & NETIF_F_HW_VLAN_TX) {
-		dev->header_ops      = real_dev->header_ops;
+		dev->header_ops      = &vlan_passthru_header_ops;
 		dev->hard_header_len = real_dev->hard_header_len;
 	} else {
 		dev->header_ops      = &vlan_header_ops;
-- 
1.8.3.2

