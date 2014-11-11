Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaKKLqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:46:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaKKLKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 084/170] drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
Date: Tue, 11 Nov 2014 11:07:23 +0000
Message-Id: <1415704129-12709-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 5188cd44c55db3e92cd9e77a40b5baa7ed4340f7 upstream.

UFO is now disabled on all drivers that work with virtio net headers,
but userland may try to send UFO/IPv6 packets anyway.  Instead of
sending with ID=0, we should select identifiers on their behalf (as we
used to).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 916e4cf46d02 ("ipv6: reuse ip6_frag_id from ip6_ufo_append_data")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvtap.c  |  3 +++
 drivers/net/tun.c      |  6 +++++-
 include/net/ipv6.h     |  2 ++
 net/ipv6/output_core.c | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 1f8ca1e4c46c..f30ceb17d5fc 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
@@ -572,6 +573,8 @@ static int macvtap_skb_from_vnet_hdr(struct sk_buff *skb,
 			pr_warn_once("macvtap: %s: using disabled UFO feature; please fix this program\n",
 				     current->comm);
 			gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			return -EINVAL;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 5716e63d5be1..9ec6c8b5bf99 100644
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
@@ -1139,6 +1140,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		break;
 	}
 
+	skb_reset_network_header(skb);
+
 	if (gso.gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
@@ -1159,6 +1162,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					    current->comm);
 			}
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		}
 		default:
@@ -1189,7 +1194,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
 	}
 
-	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb, 0);
 
 	rxhash = skb_get_hash(skb);
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 574337fe72dd..9b442a8d68ba 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -668,6 +668,8 @@ static inline int ipv6_addr_diff(const struct in6_addr *a1, const struct in6_add
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
+void ipv6_proxy_select_ident(struct sk_buff *skb);
+
 int ip6_dst_hoplimit(struct dst_entry *dst);
 
 static inline int ip6_sk_dst_hoplimit(struct ipv6_pinfo *np, struct flowi6 *fl6,
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index 5ec867e4a8b7..1d4156ddf355 100644
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
-- 
2.1.0

