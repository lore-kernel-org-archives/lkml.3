Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaFCLmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaFCLmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Gibson <david@gibson.dropbear.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 112/138] rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set
Date: Tue,  3 Jun 2014 12:39:18 +0100
Message-Id: <1401795584-22664-113-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gibson <david@gibson.dropbear.id.au>

commit c53864fd60227de025cb79e05493b13f69843971 upstream.

Since 115c9b81928360d769a76c632bae62d15206a94a (rtnetlink: Fix problem with
buffer allocation), RTM_NEWLINK messages only contain the IFLA_VFINFO_LIST
attribute if they were solicited by a GETLINK message containing an
IFLA_EXT_MASK attribute with the RTEXT_FILTER_VF flag.

That was done because some user programs broke when they received more data
than expected - because IFLA_VFINFO_LIST contains information for each VF
it can become large if there are many VFs.

However, the IFLA_VF_PORTS attribute, supplied for devices which implement
ndo_get_vf_port (currently the 'enic' driver only), has the same problem.
It supplies per-VF information and can therefore become large, but it is
not currently conditional on the IFLA_EXT_MASK value.

Worse, it interacts badly with the existing EXT_MASK handling.  When
IFLA_EXT_MASK is not supplied, the buffer for netlink replies is fixed at
NLMSG_GOODSIZE.  If the information for IFLA_VF_PORTS exceeds this, then
rtnl_fill_ifinfo() returns -EMSGSIZE on the first message in a packet.
netlink_dump() will misinterpret this as having finished the listing and
omit data for this interface and all subsequent ones.  That can cause
getifaddrs(3) to enter an infinite loop.

This patch addresses the problem by only supplying IFLA_VF_PORTS when
IFLA_EXT_MASK is supplied with the RTEXT_FILTER_VF flag set.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/rtnetlink.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 415e33ecd503..e05052210103 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -714,7 +714,8 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 		return 0;
 }
 
-static size_t rtnl_port_size(const struct net_device *dev)
+static size_t rtnl_port_size(const struct net_device *dev,
+			     u32 ext_filter_mask)
 {
 	size_t port_size = nla_total_size(4)		/* PORT_VF */
 		+ nla_total_size(PORT_PROFILE_MAX)	/* PORT_PROFILE */
@@ -730,7 +731,8 @@ static size_t rtnl_port_size(const struct net_device *dev)
 	size_t port_self_size = nla_total_size(sizeof(struct nlattr))
 		+ port_size;
 
-	if (!dev->netdev_ops->ndo_get_vf_port || !dev->dev.parent)
+	if (!dev->netdev_ops->ndo_get_vf_port || !dev->dev.parent ||
+	    !(ext_filter_mask & RTEXT_FILTER_VF))
 		return 0;
 	if (dev_num_vf(dev->dev.parent))
 		return port_self_size + vf_ports_size +
@@ -765,7 +767,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(ext_filter_mask
 			        & RTEXT_FILTER_VF ? 4 : 0) /* IFLA_NUM_VF */
 	       + rtnl_vfinfo_size(dev, ext_filter_mask) /* IFLA_VFINFO_LIST */
-	       + rtnl_port_size(dev) /* IFLA_VF_PORTS + IFLA_PORT_SELF */
+	       + rtnl_port_size(dev, ext_filter_mask) /* IFLA_VF_PORTS + IFLA_PORT_SELF */
 	       + rtnl_link_get_size(dev) /* IFLA_LINKINFO */
 	       + rtnl_link_get_af_size(dev); /* IFLA_AF_SPEC */
 }
@@ -826,11 +828,13 @@ static int rtnl_port_self_fill(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
-static int rtnl_port_fill(struct sk_buff *skb, struct net_device *dev)
+static int rtnl_port_fill(struct sk_buff *skb, struct net_device *dev,
+			  u32 ext_filter_mask)
 {
 	int err;
 
-	if (!dev->netdev_ops->ndo_get_vf_port || !dev->dev.parent)
+	if (!dev->netdev_ops->ndo_get_vf_port || !dev->dev.parent ||
+	    !(ext_filter_mask & RTEXT_FILTER_VF))
 		return 0;
 
 	err = rtnl_port_self_fill(skb, dev);
@@ -994,7 +998,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb, struct net_device *dev,
 		nla_nest_end(skb, vfinfo);
 	}
 
-	if (rtnl_port_fill(skb, dev))
+	if (rtnl_port_fill(skb, dev, ext_filter_mask))
 		goto nla_put_failure;
 
 	if (dev->rtnl_link_ops) {
-- 
1.9.1

