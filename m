Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbaELCGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:06:22 -0400
Received: from 1wt.eu ([62.212.114.60]:34556 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaELBmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:31 -0400
Message-Id: <20140512003205.381435779@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 114/143] ipv6: udp packets following an UFO enqueued packet need also be
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 handled by UFO

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

In the following scenario the socket is corked:
If the first UDP packet is larger then the mtu we try to append it to the
write queue via ip6_ufo_append_data. A following packet, which is smaller
than the mtu would be appended to the already queued up gso-skb via
plain ip6_append_data. This causes random memory corruptions.

In ip6_ufo_append_data we also have to be careful to not queue up the
same skb multiple times. So setup the gso frame only when no first skb
is available.

This also fixes a shortcoming where we add the current packet's length to
cork->length but return early because of a packet > mtu with dontfrag set
(instead of sutracting it again).

Found with trinity.

Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 2811ebac2521ceac84f2bdae402455baa6a7fb47)
[wt: 2.6.32 doesn't have dontfrag so remove the optimization]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/ip6_output.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6ff4d07..5a1b5bc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1086,6 +1086,8 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 	 * udp datagram
 	 */
 	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL) {
+		struct frag_hdr fhdr;
+
 		skb = sock_alloc_send_skb(sk,
 			hh_len + fragheaderlen + transhdrlen + 20,
 			(flags & MSG_DONTWAIT), &err);
@@ -1107,12 +1109,6 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum = 0;
 		sk->sk_sndmsg_off = 0;
-	}
-
-	err = skb_append_datato_frags(sk,skb, getfrag, from,
-				      (length - transhdrlen));
-	if (!err) {
-		struct frag_hdr fhdr;
 
 		/* Specify the length of each IPv6 datagram fragment.
 		 * It has to be a multiple of 8.
@@ -1123,15 +1119,10 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 		ipv6_select_ident(&fhdr, rt);
 		skb_shinfo(skb)->ip6_frag_id = fhdr.identification;
 		__skb_queue_tail(&sk->sk_write_queue, skb);
-
-		return 0;
 	}
-	/* There is not enough support do UPD LSO,
-	 * so follow normal path
-	 */
-	kfree_skb(skb);
 
-	return err;
+	return skb_append_datato_frags(sk, skb, getfrag, from,
+				       (length - transhdrlen));
 }
 
 static inline struct ipv6_opt_hdr *ip6_opt_dup(struct ipv6_opt_hdr *src,
@@ -1264,18 +1255,20 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	 */
 
 	inet->cork.length += length;
-	if (((length > mtu) && (sk->sk_protocol == IPPROTO_UDP)) &&
+	skb = skb_peek_tail(&sk->sk_write_queue);
+	if (((length > mtu) ||
+	     (skb && skb_is_gso(skb))) &&
+	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
-
-		err = ip6_ufo_append_data(sk, getfrag, from, length, hh_len,
-					  fragheaderlen, transhdrlen, mtu,
-					  flags, rt);
+		err = ip6_ufo_append_data(sk, getfrag, from, length,
+					  hh_len, fragheaderlen,
+					  transhdrlen, mtu, flags, rt);
 		if (err)
 			goto error;
 		return 0;
 	}
 
-	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL)
+	if (!skb)
 		goto alloc_new_skb;
 
 	while (length > 0) {
-- 
1.7.12.2.21.g234cd45.dirty



