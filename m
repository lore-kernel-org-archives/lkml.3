Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3JKVBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:01:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab3JKThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/48] ipv6: udp packets following an UFO enqueued packet need also be handled by UFO
Date: Fri, 11 Oct 2013 12:36:20 -0700
Message-Id: <20131011193638.702652817@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 2811ebac2521ceac84f2bdae402455baa6a7fb47 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   53 ++++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1128,6 +1128,8 @@ static inline int ip6_ufo_append_data(st
 	 * udp datagram
 	 */
 	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL) {
+		struct frag_hdr fhdr;
+
 		skb = sock_alloc_send_skb(sk,
 			hh_len + fragheaderlen + transhdrlen + 20,
 			(flags & MSG_DONTWAIT), &err);
@@ -1148,12 +1150,6 @@ static inline int ip6_ufo_append_data(st
 
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
@@ -1164,15 +1160,10 @@ static inline int ip6_ufo_append_data(st
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
@@ -1345,27 +1336,27 @@ int ip6_append_data(struct sock *sk, int
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


