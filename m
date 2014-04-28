Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaD1Bdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42846 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "lucien" <lucien.xin@gmail.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.405090313@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 07/94] ipv6: ip6_append_data_mtu do not handle the mtu
 of the  second fragment properly
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: lucien <lucien.xin@gmail.com>

[ Upstream commit e367c2d03dba4c9bcafad24688fadb79dd95b218 ]

In ip6_append_data_mtu(), when the xfrm mode is not tunnel(such as
transport),the ipsec header need to be added in the first fragment, so the mtu
will decrease to reserve space for it, then the second fragment come, the mtu
should be turn back, as the commit 0c1833797a5a6ec23ea9261d979aa18078720b74
said.  however, in the commit a493e60ac4bbe2e977e7129d6d8cbb0dd236be, it use
*mtu = min(*mtu, ...) to change the mtu, which lead to the new mtu is alway
equal with the first fragment's. and cannot turn back.

when I test through  ping6 -c1 -s5000 $ip (mtu=1280):
...frag (0|1232) ESP(spi=0x00002000,seq=0xb), length 1232
...frag (1232|1216)
...frag (2448|1216)
...frag (3664|1216)
...frag (4880|164)

which should be:
...frag (0|1232) ESP(spi=0x00001000,seq=0x1), length 1232
...frag (1232|1232)
...frag (2464|1232)
...frag (3696|1232)
...frag (4928|116)

so delete the min() when change back the mtu.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Fixes: 75a493e60ac4bb ("ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size")
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ip6_output.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1191,21 +1191,19 @@ static void ip6_append_data_mtu(unsigned
 				unsigned int fragheaderlen,
 				struct sk_buff *skb,
 				struct rt6_info *rt,
-				bool pmtuprobe)
+				unsigned int orig_mtu)
 {
 	if (!(rt->dst.flags & DST_XFRM_TUNNEL)) {
 		if (skb == NULL) {
 			/* first fragment, reserve header_len */
-			*mtu = *mtu - rt->dst.header_len;
+			*mtu = orig_mtu - rt->dst.header_len;
 
 		} else {
 			/*
 			 * this fragment is not first, the headers
 			 * space is regarded as data space.
 			 */
-			*mtu = min(*mtu, pmtuprobe ?
-				   rt->dst.dev->mtu :
-				   dst_mtu(rt->dst.path));
+			*mtu = orig_mtu;
 		}
 		*maxfraglen = ((*mtu - fragheaderlen) & ~7)
 			      + fragheaderlen - sizeof(struct frag_hdr);
@@ -1222,7 +1220,7 @@ int ip6_append_data(struct sock *sk, int
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_cork *cork;
 	struct sk_buff *skb, *skb_prev = NULL;
-	unsigned int maxfraglen, fragheaderlen, mtu;
+	unsigned int maxfraglen, fragheaderlen, mtu, orig_mtu;
 	int exthdrlen;
 	int dst_exthdrlen;
 	int hh_len;
@@ -1307,6 +1305,7 @@ int ip6_append_data(struct sock *sk, int
 		dst_exthdrlen = 0;
 		mtu = cork->fragsize;
 	}
+	orig_mtu = mtu;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
@@ -1389,8 +1388,7 @@ alloc_new_skb:
 			if (skb == NULL || skb_prev == NULL)
 				ip6_append_data_mtu(&mtu, &maxfraglen,
 						    fragheaderlen, skb, rt,
-						    np->pmtudisc ==
-						    IPV6_PMTUDISC_PROBE);
+						    orig_mtu);
 
 			skb_prev = skb;
 

