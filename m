Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaCDUDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbaCDUDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 054/172] net: add and use skb_gso_transport_seglen()
Date: Tue,  4 Mar 2014 12:02:18 -0800
Message-Id: <20140304200301.468007381@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit de960aa9ab4decc3304959f69533eef64d05d8e8 upstream.

This moves part of Eric Dumazets skb_gso_seglen helper from tbf sched to
skbuff core so it may be reused by upcoming ip forwarding path patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    1 +
 net/core/skbuff.c      |   25 +++++++++++++++++++++++++
 net/sched/sch_tbf.c    |   13 +++----------
 3 files changed, 29 insertions(+), 10 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2371,6 +2371,7 @@ void skb_copy_and_csum_dev(const struct
 void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len);
 int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen);
 void skb_scrub_packet(struct sk_buff *skb, bool xnet);
+unsigned int skb_gso_transport_seglen(const struct sk_buff *skb);
 struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features);
 
 struct skb_checksum_ops {
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -47,6 +47,8 @@
 #include <linux/in.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <linux/netdevice.h>
 #ifdef CONFIG_NET_CLS_ACT
 #include <net/pkt_sched.h>
@@ -3562,3 +3564,26 @@ void skb_scrub_packet(struct sk_buff *sk
 	nf_reset_trace(skb);
 }
 EXPORT_SYMBOL_GPL(skb_scrub_packet);
+
+/**
+ * skb_gso_transport_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_transport_seglen is used to determine the real size of the
+ * individual segments, including Layer4 headers (TCP/UDP).
+ *
+ * The MAC/L2 or network (IP, IPv6) headers are not accounted for.
+ */
+unsigned int skb_gso_transport_seglen(const struct sk_buff *skb)
+{
+	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	unsigned int hdr_len;
+
+	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
+		hdr_len = tcp_hdrlen(skb);
+	else
+		hdr_len = sizeof(struct udphdr);
+	return hdr_len + shinfo->gso_size;
+}
+EXPORT_SYMBOL_GPL(skb_gso_transport_seglen);
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -21,7 +21,6 @@
 #include <net/netlink.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
-#include <net/tcp.h>
 
 
 /*	Simple Token Bucket Filter.
@@ -148,16 +147,10 @@ static u64 psched_ns_t2l(const struct ps
  * Return length of individual segments of a gso packet,
  * including all headers (MAC, IP, TCP/UDP)
  */
-static unsigned int skb_gso_seglen(const struct sk_buff *skb)
+static unsigned int skb_gso_mac_seglen(const struct sk_buff *skb)
 {
 	unsigned int hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
-	const struct skb_shared_info *shinfo = skb_shinfo(skb);
-
-	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
-		hdr_len += tcp_hdrlen(skb);
-	else
-		hdr_len += sizeof(struct udphdr);
-	return hdr_len + shinfo->gso_size;
+	return hdr_len + skb_gso_transport_seglen(skb);
 }
 
 /* GSO packet is too big, segment it so that tbf can transmit
@@ -202,7 +195,7 @@ static int tbf_enqueue(struct sk_buff *s
 	int ret;
 
 	if (qdisc_pkt_len(skb) > q->max_size) {
-		if (skb_is_gso(skb) && skb_gso_seglen(skb) <= q->max_size)
+		if (skb_is_gso(skb) && skb_gso_mac_seglen(skb) <= q->max_size)
 			return tbf_segment(skb, sch);
 		return qdisc_reshape_fail(skb, sch);
 	}


