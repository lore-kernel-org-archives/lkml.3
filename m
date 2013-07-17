Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768Ab3GQXEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:04:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3GQW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grzegorz Lyczba <grzegorz.lyczba@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 074/145] ipvs: Fix reuse connection if real server is dead
Date: Wed, 17 Jul 2013 15:46:46 -0700
Message-Id: <1374101277-7915-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Lyczba <grzegorz.lyczba@gmail.com>

commit dc7b3eb900aab02e5cafbca3948d005be13fb4a5 upstream.

Expire cached connection for new TCP/SCTP connection if real
server is down. Otherwise, IPVS uses the dead server for the
reused connection, instead of a new working one.

Signed-off-by: Grzegorz Lyczba <grzegorz.lyczba@gmail.com>
Acked-by: Hans Schillstrom <hans@schillstrom.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 47edf5a..85972e4 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1002,6 +1002,32 @@ static inline int is_tcp_reset(const struct sk_buff *skb, int nh_len)
 	return th->rst;
 }
 
+static inline bool is_new_conn(const struct sk_buff *skb,
+			       struct ip_vs_iphdr *iph)
+{
+	switch (iph->protocol) {
+	case IPPROTO_TCP: {
+		struct tcphdr _tcph, *th;
+
+		th = skb_header_pointer(skb, iph->len, sizeof(_tcph), &_tcph);
+		if (th == NULL)
+			return false;
+		return th->syn;
+	}
+	case IPPROTO_SCTP: {
+		sctp_chunkhdr_t *sch, schunk;
+
+		sch = skb_header_pointer(skb, iph->len + sizeof(sctp_sctphdr_t),
+					 sizeof(schunk), &schunk);
+		if (sch == NULL)
+			return false;
+		return sch->type == SCTP_CID_INIT;
+	}
+	default:
+		return false;
+	}
+}
+
 /* Handle response packets: rewrite addresses and send away...
  */
 static unsigned int
@@ -1627,6 +1653,15 @@ ip_vs_in(unsigned int hooknum, struct sk_buff *skb, int af)
 	 * Check if the packet belongs to an existing connection entry
 	 */
 	cp = pp->conn_in_get(af, skb, &iph, 0);
+
+	if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp && cp->dest &&
+	    unlikely(!atomic_read(&cp->dest->weight)) && !iph.fragoffs &&
+	    is_new_conn(skb, &iph)) {
+		ip_vs_conn_expire_now(cp);
+		__ip_vs_conn_put(cp);
+		cp = NULL;
+	}
+
 	if (unlikely(!cp) && !iph.fragoffs) {
 		/* No (second) fragments need to enter here, as nf_defrag_ipv6
 		 * replayed fragment zero will already have created the cp
-- 
1.8.1.2

