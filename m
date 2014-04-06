Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaDFXjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:39:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59439 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Florian Westphal" <fw@strlen.de>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.427414191@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 07/18] net: add and use skb_gso_transport_seglen()
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit de960aa9ab4decc3304959f69533eef64d05d8e8 upstream.

[ no skb_gso_seglen helper in 3.4, leave tbf alone ]

This moves part of Eric Dumazets skb_gso_seglen helper from tbf sched to
skbuff core so it may be reused by upcoming ip forwarding path patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2143,6 +2143,8 @@ extern int	       skb_shift(struct sk_bu
 
 extern struct sk_buff *skb_segment(struct sk_buff *skb, u32 features);
 
+unsigned int skb_gso_transport_seglen(const struct sk_buff *skb);
+
 static inline void *skb_header_pointer(const struct sk_buff *skb, int offset,
 				       int len, void *buffer)
 {
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -45,6 +45,8 @@
 #include <linux/in.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <linux/netdevice.h>
 #ifdef CONFIG_NET_CLS_ACT
 #include <net/pkt_sched.h>
@@ -3181,3 +3183,26 @@ void __skb_warn_lro_forwarding(const str
 			   " while LRO is enabled\n", skb->dev->name);
 }
 EXPORT_SYMBOL(__skb_warn_lro_forwarding);
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

