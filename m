Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaFEFN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:13:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaFEEUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 025/214] rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set
Date: Wed,  4 Jun 2014 21:16:28 -0700
Message-Id: <20140605041643.174447157@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gibson <david@gibson.dropbear.id.au>

[ Upstream commit c53864fd60227de025cb79e05493b13f69843971 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -746,7 +746,8 @@ static inline int rtnl_vfinfo_size(const
 		return 0;
 }
 
-static size_t rtnl_port_size(const struct net_device *dev)
+static size_t rtnl_port_size(const struct net_device *dev,
+			     u32 ext_filter_mask)
 {
 	size_t port_size = nla_total_size(4)		/* PORT_VF */
 		+ nla_total_size(PORT_PROFILE_MAX)	/* PORT_PROFILE */
@@ -762,7 +763,8 @@ static size_t rtnl_port_size(const struc
 	size_t port_self_size = nla_total_size(sizeof(struct nlattr))
 		+ port_size;
 
-	if (!dev->netdev_ops->ndo_get_vf_port || !dev->dev.parent)
+	if (!dev->netdev_ops->ndo_get_vf_port || !dev->dev.parent ||
+	    !(ext_filter_mask & RTEXT_FILTER_VF))
 		return 0;
 	if (dev_num_vf(dev->dev.parent))
 		return port_self_size + vf_ports_size +
@@ -793,7 +795,7 @@ static noinline size_t if_nlmsg_size(con
 	       + nla_total_size(ext_filter_mask
 			        & RTEXT_FILTER_VF ? 4 : 0) /* IFLA_NUM_VF */
 	       + rtnl_vfinfo_size(dev, ext_filter_mask) /* IFLA_VFINFO_LIST */
-	       + rtnl_port_size(dev) /* IFLA_VF_PORTS + IFLA_PORT_SELF */
+	       + rtnl_port_size(dev, ext_filter_mask) /* IFLA_VF_PORTS + IFLA_PORT_SELF */
 	       + rtnl_link_get_size(dev) /* IFLA_LINKINFO */
 	       + rtnl_link_get_af_size(dev); /* IFLA_AF_SPEC */
 }
@@ -853,11 +855,13 @@ static int rtnl_port_self_fill(struct sk
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
@@ -1004,7 +1008,7 @@ static int rtnl_fill_ifinfo(struct sk_bu
 		nla_nest_end(skb, vfinfo);
 	}
 
-	if (rtnl_port_fill(skb, dev))
+	if (rtnl_port_fill(skb, dev, ext_filter_mask))
 		goto nla_put_failure;
 
 	if (dev->rtnl_link_ops) {


