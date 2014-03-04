Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaCDU0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:26:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaCDUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 34/97] net: add and use skb_gso_transport_seglen()
Date: Tue,  4 Mar 2014 12:03:47 -0800
Message-Id: <20140304200347.175110941@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit de960aa9ab4decc3304959f69533eef64d05d8e8 upstream.

[ no skb_gso_seglen helper in 3.10, leave tbf alone ]

This moves part of Eric Dumazets skb_gso_seglen helper from tbf sched to
skbuff core so it may be reused by upcoming ip forwarding path patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    2 ++
 net/core/skbuff.c      |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2488,6 +2488,8 @@ extern int	       skb_shift(struct sk_bu
 extern struct sk_buff *skb_segment(struct sk_buff *skb,
 				   netdev_features_t features);
 
+unsigned int skb_gso_transport_seglen(const struct sk_buff *skb);
+
 static inline void *skb_header_pointer(const struct sk_buff *skb, int offset,
 				       int len, void *buffer)
 {
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
@@ -3471,3 +3473,26 @@ bool skb_try_coalesce(struct sk_buff *to
 	return true;
 }
 EXPORT_SYMBOL(skb_try_coalesce);
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


