Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab3GCSo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:44:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab3GCSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:10 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=zhwIW6rwBxgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=d858u21KyysA:10 a=tHz9FfFoAAAA:8 a=J1Y8HTJGAAAA:8 a=e0gVtgZ23HrhdBXb4dMA:9 a=6O0IECtVFhoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184055.250981234@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [064/141] xen-netfront: reduce gso_max_size to account for max TCP header
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0064-xen-netfront-reduce-gso_max_size-to-account-for-max-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit 9ecd1a75d977e2e8c48139c7d3efed183f898d94 ]

The maximum packet including header that can be handled by netfront / netback
wire format is 65535. Reduce gso_max_size accordingly.

Drop skb and print warning when skb->len > 65535. This can 1) save the effort
to send malformed packet to netback, 2) help spotting misconfiguration of
netfront in the future.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/xen-netfront.c       |   17 +++++++++++++++--
 include/xen/interface/io/netif.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 650f79a..ecac034 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -36,7 +36,7 @@
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
-#include <linux/tcp.h>
+#include <net/tcp.h>
 #include <linux/udp.h>
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
@@ -491,6 +491,16 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned int len = skb_headlen(skb);
 	unsigned long flags;
 
+	/* If skb->len is too big for wire format, drop skb and alert
+	 * user about misconfiguration.
+	 */
+	if (unlikely(skb->len > XEN_NETIF_MAX_TX_SIZE)) {
+		net_alert_ratelimited(
+			"xennet: skb->len = %u, too big for wire format\n",
+			skb->len);
+		goto drop;
+	}
+
 	frags += DIV_ROUND_UP(offset + len, PAGE_SIZE);
 	if (unlikely(frags > MAX_SKB_FRAGS + 1)) {
 		printk(KERN_ALERT "xennet: skb rides the rocket: %d frags\n",
@@ -1026,7 +1036,8 @@ err:
 
 static int xennet_change_mtu(struct net_device *dev, int mtu)
 {
-	int max = xennet_can_sg(dev) ? 65535 - ETH_HLEN : ETH_DATA_LEN;
+	int max = xennet_can_sg(dev) ?
+		XEN_NETIF_MAX_TX_SIZE - MAX_TCP_HEADER : ETH_DATA_LEN;
 
 	if (mtu > max)
 		return -EINVAL;
@@ -1330,6 +1341,8 @@ static struct net_device * __devinit xennet_create_dev(struct xenbus_device *dev
 	SET_ETHTOOL_OPS(netdev, &xennet_ethtool_ops);
 	SET_NETDEV_DEV(netdev, &dev->dev);
 
+	netif_set_gso_max_size(netdev, XEN_NETIF_MAX_TX_SIZE - MAX_TCP_HEADER);
+
 	np->netdev = netdev;
 
 	netif_carrier_off(netdev);
diff --git a/include/xen/interface/io/netif.h b/include/xen/interface/io/netif.h
index a36c87a..d4635cd 100644
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -65,6 +65,7 @@
 #define _XEN_NETTXF_extra_info		(3)
 #define  XEN_NETTXF_extra_info		(1U<<_XEN_NETTXF_extra_info)
 
+#define XEN_NETIF_MAX_TX_SIZE 0xFFFF
 struct xen_netif_tx_request {
     grant_ref_t gref;      /* Reference to buffer page */
     uint16_t offset;       /* Offset within buffer page */
-- 
1.7.10.4


