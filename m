Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3KAVqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:46:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3KAVoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:44:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [ 24/32] inet: fix possible memory corruption with UDP_CORK and UFO
Date: Fri,  1 Nov 2013 14:43:35 -0700
Message-Id: <20131101214319.498703632@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
---
 include/linux/skbuff.h |    5 +++++
 net/ipv4/ip_output.c   |    2 +-
 net/ipv6/ip6_output.c  |    2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1208,6 +1208,11 @@ static inline int skb_pagelen(const stru
 	return len + skb_headlen(skb);
 }
 
+static inline bool skb_has_frags(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->nr_frags;
+}
+
 /**
  * __skb_fill_page_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -846,7 +846,7 @@ static int __ip_append_data(struct sock
 		csummode = CHECKSUM_PARTIAL;
 
 	cork->length += length;
-	if (((length > mtu) || (skb && skb_is_gso(skb))) &&
+	if (((length > mtu) || (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->dst.dev->features & NETIF_F_UFO) && !rt->dst.header_len) {
 		err = ip_ufo_append_data(sk, queue, getfrag, from, length,
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1345,7 +1345,7 @@ int ip6_append_data(struct sock *sk, int
 	skb = skb_peek_tail(&sk->sk_write_queue);
 	cork->length += length;
 	if (((length > mtu) ||
-	     (skb && skb_is_gso(skb))) &&
+	     (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->dst.dev->features & NETIF_F_UFO)) {
 		err = ip6_ufo_append_data(sk, getfrag, from, length,


