Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaL2BPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:15:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33140 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbaL2BMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:14 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.99031734@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 19/27] drivers/net, ipv6: Select IPv6 fragment idents
 for virtio UFO packets
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: For 3.2, net/ipv6/output_core.c is a completely new file]
---
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -15,6 +15,7 @@
 #include <linux/cdev.h>
 #include <linux/fs.h>
 
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
@@ -577,6 +578,8 @@ static int macvtap_skb_from_vnet_hdr(str
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			return -EINVAL;
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -64,6 +64,7 @@
 #include <linux/nsproxy.h>
 #include <linux/virtio_net.h>
 #include <linux/rcupdate.h>
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/rtnetlink.h>
@@ -695,6 +696,8 @@ static ssize_t tun_get_user(struct tun_s
 		break;
 	}
 
+	skb_reset_network_header(skb);
+
 	if (gso.gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
@@ -706,6 +709,8 @@ static ssize_t tun_get_user(struct tun_s
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			tun->dev->stats.rx_frame_errors++;
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -481,6 +481,7 @@ static inline int ipv6_addr_diff(const s
 }
 
 extern void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
+void ipv6_proxy_select_ident(struct sk_buff *skb);
 
 /*
  *	Prototypes exported by ipv6
--- /dev/null
+++ b/net/ipv6/output_core.c
@@ -0,0 +1,38 @@
+#include <linux/export.h>
+#include <linux/skbuff.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+
+/* This function exists only for tap drivers that must support broken
+ * clients requesting UFO without specifying an IPv6 fragment ID.
+ *
+ * This is similar to ipv6_select_ident() but we use an independent hash
+ * seed to limit information leakage.
+ */
+void ipv6_proxy_select_ident(struct sk_buff *skb)
+{
+	static u32 ip6_proxy_idents_hashrnd __read_mostly;
+	static bool hashrnd_initialized = false;
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
+	if (unlikely(!hashrnd_initialized)) {
+		hashrnd_initialized = true;
+		get_random_bytes(&ip6_proxy_idents_hashrnd,
+				 sizeof(ip6_proxy_idents_hashrnd));
+	}
+	hash = __ipv6_addr_jhash(&addrs[1], ip6_proxy_idents_hashrnd);
+	hash = __ipv6_addr_jhash(&addrs[0], hash);
+
+	id = ip_idents_reserve(hash, 1);
+	skb_shinfo(skb)->ip6_frag_id = htonl(id);
+}
+EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -37,6 +37,6 @@ obj-$(CONFIG_NETFILTER)	+= netfilter/
 obj-$(CONFIG_IPV6_SIT) += sit.o
 obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
 
-obj-y += addrconf_core.o exthdrs_core.o
+obj-y += addrconf_core.o exthdrs_core.o output_core.o
 
 obj-$(subst m,y,$(CONFIG_IPV6)) += inet6_hashtables.o

