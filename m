Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbbAYTEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:04:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbbAYSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Huaibin Wang <huaibin.wang@6wind.com>,
        Eric Dumazet <edumazet@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 015/183] tcp6: dont move IP6CB before xfrm6_policy_check()
Date: Sun, 25 Jan 2015 10:05:37 -0800
Message-Id: <20150125180810.844138589@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 2dc49d1680b534877fd20cce52557ea542bb06b6 ]

When xfrm6_policy_check() is used, _decode_session6() is called after some
intermediate functions. This function uses IP6CB(), thus TCP_SKB_CB() must be
prepared after the call of xfrm6_policy_check().

Before this patch, scenarii with IPv6 + TCP + IPsec Transport are broken.

Fixes: 971f10eca186 ("tcp: better TCP_SKB_CB layout to reduce cache line misses")
Reported-by: Huaibin Wang <huaibin.wang@6wind.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/tcp_ipv6.c |   45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1385,6 +1385,28 @@ ipv6_pktoptions:
 	return 0;
 }
 
+static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
+			   const struct tcphdr *th)
+{
+	/* This is tricky: we move IP6CB at its correct location into
+	 * TCP_SKB_CB(). It must be done after xfrm6_policy_check(), because
+	 * _decode_session6() uses IP6CB().
+	 * barrier() makes sure compiler won't play aliasing games.
+	 */
+	memmove(&TCP_SKB_CB(skb)->header.h6, IP6CB(skb),
+		sizeof(struct inet6_skb_parm));
+	barrier();
+
+	TCP_SKB_CB(skb)->seq = ntohl(th->seq);
+	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
+				    skb->len - th->doff*4);
+	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
+	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
+	TCP_SKB_CB(skb)->tcp_tw_isn = 0;
+	TCP_SKB_CB(skb)->ip_dsfield = ipv6_get_dsfield(hdr);
+	TCP_SKB_CB(skb)->sacked = 0;
+}
+
 static int tcp_v6_rcv(struct sk_buff *skb)
 {
 	const struct tcphdr *th;
@@ -1416,24 +1438,9 @@ static int tcp_v6_rcv(struct sk_buff *sk
 
 	th = tcp_hdr(skb);
 	hdr = ipv6_hdr(skb);
-	/* This is tricky : We move IPCB at its correct location into TCP_SKB_CB()
-	 * barrier() makes sure compiler wont play fool^Waliasing games.
-	 */
-	memmove(&TCP_SKB_CB(skb)->header.h6, IP6CB(skb),
-		sizeof(struct inet6_skb_parm));
-	barrier();
-
-	TCP_SKB_CB(skb)->seq = ntohl(th->seq);
-	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
-				    skb->len - th->doff*4);
-	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
-	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
-	TCP_SKB_CB(skb)->tcp_tw_isn = 0;
-	TCP_SKB_CB(skb)->ip_dsfield = ipv6_get_dsfield(hdr);
-	TCP_SKB_CB(skb)->sacked = 0;
 
 	sk = __inet6_lookup_skb(&tcp_hashinfo, skb, th->source, th->dest,
-				tcp_v6_iif(skb));
+				inet6_iif(skb));
 	if (!sk)
 		goto no_tcp_socket;
 
@@ -1449,6 +1456,8 @@ process:
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
+	tcp_v6_fill_cb(skb, hdr, th);
+
 #ifdef CONFIG_TCP_MD5SIG
 	if (tcp_v6_inbound_md5_hash(sk, skb))
 		goto discard_and_relse;
@@ -1480,6 +1489,8 @@ no_tcp_socket:
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
+	tcp_v6_fill_cb(skb, hdr, th);
+
 	if (skb->len < (th->doff<<2) || tcp_checksum_complete(skb)) {
 csum_error:
 		TCP_INC_STATS_BH(net, TCP_MIB_CSUMERRORS);
@@ -1503,6 +1514,8 @@ do_time_wait:
 		goto discard_it;
 	}
 
+	tcp_v6_fill_cb(skb, hdr, th);
+
 	if (skb->len < (th->doff<<2)) {
 		inet_twsk_put(inet_twsk(sk));
 		goto bad_packet;


