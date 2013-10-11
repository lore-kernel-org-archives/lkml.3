Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab3JKK5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:57:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab3JKKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 058/100] ipv6: udp packets following an UFO enqueued packet need also be handled by UFO
Date: Fri, 11 Oct 2013 11:41:28 +0100
Message-Id: <1381488130-30235-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 2811ebac2521ceac84f2bdae402455baa6a7fb47 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_output.c | 53 +++++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8fa50aa..d00f1ad 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1135,6 +1135,8 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 	 * udp datagram
 	 */
 	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL) {
+		struct frag_hdr fhdr;
+
 		skb = sock_alloc_send_skb(sk,
 			hh_len + fragheaderlen + transhdrlen + 20,
 			(flags & MSG_DONTWAIT), &err);
@@ -1155,12 +1157,6 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum = 0;
-	}
-
-	err = skb_append_datato_frags(sk,skb, getfrag, from,
-				      (length - transhdrlen));
-	if (!err) {
-		struct frag_hdr fhdr;
 
 		/* Specify the length of each IPv6 datagram fragment.
 		 * It has to be a multiple of 8.
@@ -1171,15 +1167,10 @@ static inline int ip6_ufo_append_data(struct sock *sk,
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
@@ -1351,27 +1342,27 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	 * --yoshfuji
 	 */
 
-	cork->length += length;
-	if (length > mtu) {
-		int proto = sk->sk_protocol;
-		if (dontfrag && (proto == IPPROTO_UDP || proto == IPPROTO_RAW)){
-			ipv6_local_rxpmtu(sk, fl6, mtu-exthdrlen);
-			return -EMSGSIZE;
-		}
-
-		if (proto == IPPROTO_UDP &&
-		    (rt->dst.dev->features & NETIF_F_UFO)) {
+	if ((length > mtu) && dontfrag && (sk->sk_protocol == IPPROTO_UDP ||
+					   sk->sk_protocol == IPPROTO_RAW)) {
+		ipv6_local_rxpmtu(sk, fl6, mtu-exthdrlen);
+		return -EMSGSIZE;
+	}
 
-			err = ip6_ufo_append_data(sk, getfrag, from, length,
-						  hh_len, fragheaderlen,
-						  transhdrlen, mtu, flags, rt);
-			if (err)
-				goto error;
-			return 0;
-		}
+	skb = skb_peek_tail(&sk->sk_write_queue);
+	cork->length += length;
+	if (((length > mtu) ||
+	     (skb && skb_is_gso(skb))) &&
+	    (sk->sk_protocol == IPPROTO_UDP) &&
+	    (rt->dst.dev->features & NETIF_F_UFO)) {
+		err = ip6_ufo_append_data(sk, getfrag, from, length,
+					  hh_len, fragheaderlen,
+					  transhdrlen, mtu, flags, rt);
+		if (err)
+			goto error;
+		return 0;
 	}
 
-	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL)
+	if (!skb)
 		goto alloc_new_skb;
 
 	while (length > 0) {
-- 
1.8.3.2

