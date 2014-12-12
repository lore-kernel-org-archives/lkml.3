Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967370AbaLLG7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:59:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51724 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758603AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Wilmer van der Gaast" <wilmer@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Perry Lorier" <perryl@google.com>,
        "Dave =?UTF-8?Q?T=C3=A4ht?=" <dave.taht@bufferbloat.net>,
        "Matt Mathis" <mattmathis@google.com>,
        "Tom Herbert" <therbert@google.com>, "Ankur Jain" <jankur@google.com>,
        "Yuchung Cheng" <ycheng@google.com>, "Florian Westphal" <fw@strlen.de>
Date: Fri, 12 Dec 2014 06:14:26 +0000
Message-ID: <lsq.1418364866.226415394@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 160/164] tcp: be more strict before accepting ECN
 negociation
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit bd14b1b2e29bd6812597f896dde06eaf7c6d2f24 upstream.

It appears some networks play bad games with the two bits reserved for
ECN. This can trigger false congestion notifications and very slow
transferts.

Since RFC 3168 (6.1.1) forbids SYN packets to carry CT bits, we can
disable TCP ECN negociation if it happens we receive mangled CT bits in
the SYN packet.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Perry Lorier <perryl@google.com>
Cc: Matt Mathis <mattmathis@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Wilmer van der Gaast <wilmer@google.com>
Cc: Ankur Jain <jankur@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Dave Täht <dave.taht@bufferbloat.net>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Florian Westphal <fw@strlen.de>
---
 include/net/tcp.h   | 23 ++++++++++++++++-------
 net/ipv4/tcp_ipv4.c |  2 +-
 net/ipv6/tcp_ipv6.c |  2 +-
 3 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -358,13 +358,6 @@ static inline void tcp_dec_quickack_mode
 #define	TCP_ECN_DEMAND_CWR	4
 #define	TCP_ECN_SEEN		8
 
-static __inline__ void
-TCP_ECN_create_request(struct request_sock *req, struct tcphdr *th)
-{
-	if (sysctl_tcp_ecn && th->ece && th->cwr)
-		inet_rsk(req)->ecn_ok = 1;
-}
-
 enum tcp_tw_status {
 	TCP_TW_SUCCESS = 0,
 	TCP_TW_RST = 1,
@@ -652,6 +645,22 @@ struct tcp_skb_cb {
 
 #define TCP_SKB_CB(__skb)	((struct tcp_skb_cb *)&((__skb)->cb[0]))
 
+/* RFC3168 : 6.1.1 SYN packets must not have ECT/ECN bits set
+ *
+ * If we receive a SYN packet with these bits set, it means a network is
+ * playing bad games with TOS bits. In order to avoid possible false congestion
+ * notifications, we disable TCP ECN negociation.
+ */
+static inline void
+TCP_ECN_create_request(struct request_sock *req, const struct sk_buff *skb)
+{
+	const struct tcphdr *th = tcp_hdr(skb);
+
+	if (sysctl_tcp_ecn && th->ece && th->cwr &&
+	    INET_ECN_is_not_ect(TCP_SKB_CB(skb)->ip_dsfield))
+		inet_rsk(req)->ecn_ok = 1;
+}
+
 /* Due to TSO, an SKB can be composed of multiple actual
  * packets.  To keep these tracked properly, we use this.
  */
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1352,7 +1352,7 @@ int tcp_v4_conn_request(struct sock *sk,
 		goto drop_and_free;
 
 	if (!want_cookie || tmp_opt.tstamp_ok)
-		TCP_ECN_create_request(req, tcp_hdr(skb));
+		TCP_ECN_create_request(req, skb);
 
 	if (want_cookie) {
 		isn = cookie_v4_init_sequence(sk, skb, &req->mss);
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1254,7 +1254,7 @@ static int tcp_v6_conn_request(struct so
 	ipv6_addr_copy(&treq->rmt_addr, &ipv6_hdr(skb)->saddr);
 	ipv6_addr_copy(&treq->loc_addr, &ipv6_hdr(skb)->daddr);
 	if (!want_cookie || tmp_opt.tstamp_ok)
-		TCP_ECN_create_request(req, tcp_hdr(skb));
+		TCP_ECN_create_request(req, skb);
 
 	treq->iif = sk->sk_bound_dev_if;
 

