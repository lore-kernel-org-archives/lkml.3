Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaDPKsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:48:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbaDPKch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xin Long <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 21/46] ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment properly
Date: Wed, 16 Apr 2014 11:31:37 +0100
Message-Id: <1397644322-13905-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: lucien <lucien.xin@gmail.com>

commit e367c2d03dba4c9bcafad24688fadb79dd95b218 upstream.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_output.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 554eb0d..b878dd6 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1110,21 +1110,19 @@ static void ip6_append_data_mtu(unsigned int *mtu,
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
@@ -1141,7 +1139,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_cork *cork;
 	struct sk_buff *skb, *skb_prev = NULL;
-	unsigned int maxfraglen, fragheaderlen, mtu;
+	unsigned int maxfraglen, fragheaderlen, mtu, orig_mtu;
 	int exthdrlen;
 	int dst_exthdrlen;
 	int hh_len;
@@ -1223,6 +1221,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 		dst_exthdrlen = 0;
 		mtu = cork->fragsize;
 	}
+	orig_mtu = mtu;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
@@ -1302,8 +1301,7 @@ alloc_new_skb:
 			if (skb == NULL || skb_prev == NULL)
 				ip6_append_data_mtu(&mtu, &maxfraglen,
 						    fragheaderlen, skb, rt,
-						    np->pmtudisc ==
-						    IPV6_PMTUDISC_PROBE);
+						    orig_mtu);
 
 			skb_prev = skb;
 
-- 
1.9.1

