Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaKLEVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:21:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbaKLBUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 024/319] drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
Date: Wed, 12 Nov 2014 10:12:42 +0900
Message-Id: <20141112010956.720109030@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c  |    3 +++
 drivers/net/tun.c      |    6 +++++-
 include/net/ipv6.h     |    2 ++
 net/ipv6/output_core.c |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
@@ -572,6 +573,8 @@ static int macvtap_skb_from_vnet_hdr(str
 			pr_warn_once("macvtap: %s: using disabled UFO feature; please fix this program\n",
 				     current->comm);
 			gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			return -EINVAL;
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
@@ -1139,6 +1140,8 @@ static ssize_t tun_get_user(struct tun_s
 		break;
 	}
 
+	skb_reset_network_header(skb);
+
 	if (gso.gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
@@ -1159,6 +1162,8 @@ static ssize_t tun_get_user(struct tun_s
 					    current->comm);
 			}
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		}
 		default:
@@ -1189,7 +1194,6 @@ static ssize_t tun_get_user(struct tun_s
 		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
 	}
 
-	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb, 0);
 
 	rxhash = skb_get_hash(skb);
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -669,6 +669,8 @@ static inline int ipv6_addr_diff(const s
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
+void ipv6_proxy_select_ident(struct sk_buff *skb);
+
 int ip6_dst_hoplimit(struct dst_entry *dst);
 
 static inline int ip6_sk_dst_hoplimit(struct ipv6_pinfo *np, struct flowi6 *fl6,
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -3,11 +3,45 @@
  * not configured or static.  These functions are needed by GSO/GRO implementation.
  */
 #include <linux/export.h>
+#include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_fib.h>
 #include <net/addrconf.h>
 #include <net/secure_seq.h>
 
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
+
 int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr)
 {
 	u16 offset = sizeof(struct ipv6hdr);


