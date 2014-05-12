Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaELBmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34630 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbaELBms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:48 -0400
Message-Id: <20140512003205.430154009@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 115/143] inet: fix possible memory corruption with UDP_CORK and UFO
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ This is a simplified -stable version of a set of upstream commits. ]

This is a replacement patch only for stable which does fix the problems
handled by the following two commits in -net:

"ip_output: do skb ufo init for peeked non ufo skb as well" (e93b7d748be887cd7639b113ba7d7ef792a7efb9)
"ip6_output: do skb ufo init for peeked non ufo skb as well" (c547dbf55d5f8cf615ccc0e7265e98db27d3fb8b)

Three frames are written on a corked udp socket for which the output
netdevice has UFO enabled.  If the first and third frame are smaller than
the mtu and the second one is bigger, we enqueue the second frame with
skb_append_datato_frags without initializing the gso fields. This leads
to the third frame appended regulary and thus constructing an invalid skb.

This fixes the problem by always using skb_append_datato_frags as soon
as the first frag got enqueued to the skb without marking the packet
as SKB_GSO_UDP.

The problem with only two frames for ipv6 was fixed by "ipv6: udp
packets following an UFO enqueued packet need also be handled by UFO"
(2811ebac2521ceac84f2bdae402455baa6a7fb47).

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
(cherry picked from commit 5124ae99ac8a8f63d0fca9b75adaef40b20678ff)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/ip_output.c  | 2 +-
 net/ipv6/ip6_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 2cd69e3..faa6623 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -875,7 +875,7 @@ int ip_append_data(struct sock *sk,
 	skb = skb_peek_tail(&sk->sk_write_queue);
 
 	inet->cork.length += length;
-	if (((length > mtu) || (skb && skb_is_gso(skb))) &&
+	if (((length > mtu) || (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
 		err = ip_ufo_append_data(sk, getfrag, from, length, hh_len,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 5a1b5bc..6dff3d7 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1257,7 +1257,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	inet->cork.length += length;
 	skb = skb_peek_tail(&sk->sk_write_queue);
 	if (((length > mtu) ||
-	     (skb && skb_is_gso(skb))) &&
+	     (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
 		err = ip6_ufo_append_data(sk, getfrag, from, length,
-- 
1.7.12.2.21.g234cd45.dirty



