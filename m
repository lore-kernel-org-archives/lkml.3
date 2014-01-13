Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaAMQMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:12:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53766 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaAMQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 188/208] vlan: Fix header ops passthru when doing TX VLAN offload.
Date: Mon, 13 Jan 2014 16:00:29 +0000
Message-Id: <1389628849-1614-189-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/netdevice.h |  9 +++++++++
 net/8021q/vlan_dev.c      | 19 ++++++++++++++++++-
 net/core/neighbour.c      |  2 +-
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9a41568..1ffe7d7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1836,6 +1836,15 @@ static inline int dev_parse_header(const struct sk_buff *skb,
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
index 1cd3d2a..4af64af 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -549,6 +549,23 @@ static const struct header_ops vlan_header_ops = {
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
 static struct device_type vlan_type = {
 	.name	= "vlan",
 };
@@ -592,7 +609,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	dev->needed_headroom = real_dev->needed_headroom;
 	if (real_dev->features & NETIF_F_HW_VLAN_CTAG_TX) {
-		dev->header_ops      = real_dev->header_ops;
+		dev->header_ops      = &vlan_passthru_header_ops;
 		dev->hard_header_len = real_dev->hard_header_len;
 	} else {
 		dev->header_ops      = &vlan_header_ops;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 60533db..72d71c9 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1274,7 +1274,7 @@ int neigh_compat_output(struct neighbour *neigh, struct sk_buff *skb)
 
 	if (dev_hard_header(skb, dev, ntohs(skb->protocol), NULL, NULL,
 			    skb->len) < 0 &&
-	    dev->header_ops->rebuild(skb))
+	    dev_rebuild_header(skb))
 		return 0;
 
 	return dev_queue_xmit(skb);
-- 
1.8.3.2

