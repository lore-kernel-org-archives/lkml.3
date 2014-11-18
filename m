Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbaKRPXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:23:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbaKROJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 015/206] drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
Date: Tue, 18 Nov 2014 15:06:10 +0100
Message-Id: <30ab1cf8b31dc6a680ac6443a34d02d9edb9a589.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5188cd44c55db3e92cd9e77a40b5baa7ed4340f7 ]

UFO is now disabled on all drivers that work with virtio net headers,
but userland may try to send UFO/IPv6 packets anyway.  Instead of
sending with ID=0, we should select identifiers on their behalf (as we
used to).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 916e4cf46d02 ("ipv6: reuse ip6_frag_id from ip6_ufo_append_data")
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/macvtap.c  |  3 +++
 drivers/net/tun.c      |  6 +++++-
 include/net/ipv6.h     |  2 ++
 net/ipv6/output_core.c | 38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 052d1832d3fb..4abd98efdc34 100644
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
index 10636cbd3807..495830a8ee28 100644
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
@@ -1103,6 +1104,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		break;
 	}
 
+	skb_reset_network_header(skb);
+
 	if (gso.gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
@@ -1114,6 +1117,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			tun->dev->stats.rx_frame_errors++;
@@ -1143,7 +1148,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
 	}
 
-	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb, 0);
 
 	rxhash = skb_get_rxhash(skb);
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 6b4956e4408f..ea97c94fbc7d 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -661,6 +661,8 @@ static inline int ipv6_addr_diff(const struct in6_addr *a1, const struct in6_add
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
+extern void ipv6_proxy_select_ident(struct sk_buff *skb);
+
 extern int ip6_dst_hoplimit(struct dst_entry *dst);
 
 /*
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index 798eb0f79078..4bd870af05d6 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -3,10 +3,48 @@
  * not configured or static.  These functions are needed by GSO/GRO implementation.
  */
 #include <linux/export.h>
+#include <linux/random.h>
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
+	static bool done = false;
+	u32 hash, id;
+
+	addrs = skb_header_pointer(skb,
+				   skb_network_offset(skb) +
+				   offsetof(struct ipv6hdr, saddr),
+				   sizeof(buf), buf);
+	if (!addrs)
+		return;
+
+	if (!done) {
+		get_random_bytes(&ip6_proxy_idents_hashrnd,
+				 sizeof(ip6_proxy_idents_hashrnd));
+		done = true;
+	}
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
2.1.3

