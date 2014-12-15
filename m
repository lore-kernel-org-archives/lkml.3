Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaLOTuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:50:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaLOT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 11/96] drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
Date: Mon, 15 Dec 2014 11:25:31 -0800
Message-Id: <1418671616-25482-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 5188cd44c55db3e92cd9e77a40b5baa7ed4340f7 ]

UFO is now disabled on all drivers that work with virtio net headers,
but userland may try to send UFO/IPv6 packets anyway.  Instead of
sending with ID=0, we should select identifiers on their behalf (as we
used to).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 916e4cf46d02 ("ipv6: reuse ip6_frag_id from ip6_ufo_append_data")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c  |  3 +++
 drivers/net/tun.c      |  6 +++++-
 include/net/ipv6.h     |  2 ++
 net/ipv6/output_core.c | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index ffe8fa4..5aead8c 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -17,6 +17,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
@@ -566,6 +567,8 @@ static int macvtap_skb_from_vnet_hdr(struct sk_buff *skb,
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			return -EINVAL;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d0460a3..2e3886a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -65,6 +65,7 @@
 #include <linux/nsproxy.h>
 #include <linux/virtio_net.h>
 #include <linux/rcupdate.h>
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/rtnetlink.h>
@@ -1104,6 +1105,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		break;
 	}
 
+	skb_reset_network_header(skb);
+
 	if (gso.gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
@@ -1115,6 +1118,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			tun->dev->stats.rx_frame_errors++;
@@ -1144,7 +1149,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
 	}
 
-	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb, 0);
 
 	rxhash = skb_get_rxhash(skb);
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d164d0c..e379338 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -660,6 +660,8 @@ static inline int ipv6_addr_diff(const struct in6_addr *a1, const struct in6_add
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
+void ipv6_proxy_select_ident(struct sk_buff *skb);
+
 int ip6_dst_hoplimit(struct dst_entry *dst);
 
 /*
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index 798eb0f..ae4a06b 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -3,10 +3,43 @@
  * not configured or static.  These functions are needed by GSO/GRO implementation.
  */
 #include <linux/export.h>
+#include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_fib.h>
 #include <net/addrconf.h>
 
+/* This function exists only for tap drivers that must support broken
+ * clients requesting UFO without specifying an IPv6 fragment ID.
+ *
+ * This is similar to ipv6_select_ident() but we use an independent hash
+ * seed to limit information leakage.
+ *
+ * The network header must be set before calling this.
+ */
+void ipv6_proxy_select_ident(struct sk_buff *skb)
+{
+	static u32 ip6_proxy_idents_hashrnd __read_mostly;
+	struct in6_addr buf[2];
+	struct in6_addr *addrs;
+	u32 hash, id;
+
+	addrs = skb_header_pointer(skb,
+				   skb_network_offset(skb) +
+				   offsetof(struct ipv6hdr, saddr),
+				   sizeof(buf), buf);
+	if (!addrs)
+		return;
+
+	net_get_random_once(&ip6_proxy_idents_hashrnd,
+			    sizeof(ip6_proxy_idents_hashrnd));
+
+	hash = __ipv6_addr_jhash(&addrs[1], ip6_proxy_idents_hashrnd);
+	hash = __ipv6_addr_jhash(&addrs[0], hash);
+
+	id = ip_idents_reserve(hash, 1);
+	skb_shinfo(skb)->ip6_frag_id = htonl(id);
+}
+EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
 
 int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr)
 {
-- 
1.9.1

