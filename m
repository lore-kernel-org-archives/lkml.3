Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3J1OuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:50:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab3J1Ot6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 60/64] inet: fix possible memory corruption with UDP_CORK and UFO
Date: Mon, 28 Oct 2013 14:48:19 +0000
Message-Id: <1382971703-17393-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/skbuff.h | 5 +++++
 net/ipv4/ip_output.c   | 2 +-
 net/ipv6/ip6_output.c  | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0ec4788..160f3ea 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1226,6 +1226,11 @@ static inline int skb_pagelen(const struct sk_buff *skb)
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
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 7ee32c6..ed8270f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -846,7 +846,7 @@ static int __ip_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	cork->length += length;
-	if (((length > mtu) || (skb && skb_is_gso(skb))) &&
+	if (((length > mtu) || (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->dst.dev->features & NETIF_F_UFO) && !rt->dst.header_len) {
 		err = ip_ufo_append_data(sk, queue, getfrag, from, length,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index d00f1ad..01cf1cd 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1351,7 +1351,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	skb = skb_peek_tail(&sk->sk_write_queue);
 	cork->length += length;
 	if (((length > mtu) ||
-	     (skb && skb_is_gso(skb))) &&
+	     (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->dst.dev->features & NETIF_F_UFO)) {
 		err = ip6_ufo_append_data(sk, getfrag, from, length,
-- 
1.8.3.2

