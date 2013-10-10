Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3JJQKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:10:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3JJPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 015/104] ipv6: Store Router Alert option in IP6CB directly.
Date: Thu, 10 Oct 2013 08:41:03 -0700
Message-Id: <1381419752-29733-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?YOSHIFUJI=20Hideaki=20/=20=E5=90=89=E8=97=A4=E8=8B=B1=E6?=

commit dd3332bfcb2223458f553f341d3388cb84040e6a upstream.

Router Alert option is very small and we can store the value
itself in the skb.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: 3.8.y-stable prereq for f46078cfcd77fa5165bf849f5e568a7ac5fa569c
  "ipv6: drop packets with multiple fragmentation headers" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/ipv6.h      | 3 ++-
 include/uapi/linux/ipv6.h | 2 ++
 net/ipv6/exthdrs.c        | 3 ++-
 net/ipv6/ip6_input.c      | 5 ++---
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index faed1e3..8d766c2 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -89,7 +89,7 @@ static inline __u8 ipv6_tclass(const struct ipv6hdr *iph)
 
 struct inet6_skb_parm {
 	int			iif;
-	__u16			ra;
+	__be16			ra;
 	__u16			hop;
 	__u16			dst0;
 	__u16			srcrt;
@@ -105,6 +105,7 @@ struct inet6_skb_parm {
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
 #define IP6SKB_REROUTED		4
+#define IP6SKB_ROUTERALERT	8
 };
 
 #define IP6CB(skb)	((struct inet6_skb_parm*)((skb)->cb))
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 5a2991c..4bda4cf 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -63,6 +63,8 @@ struct ipv6_opt_hdr {
 #define ipv6_destopt_hdr ipv6_opt_hdr
 #define ipv6_hopopt_hdr  ipv6_opt_hdr
 
+/* Router Alert option values (RFC2711) */
+#define IPV6_OPT_ROUTERALERT_MLD	0x0000	/* MLD(RFC2710) */
 
 /*
  *	routing header type 0 (used in cmsghdr struct)
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 473f628..07a7d65 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -553,7 +553,8 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
 	const unsigned char *nh = skb_network_header(skb);
 
 	if (nh[optoff + 1] == 2) {
-		IP6CB(skb)->ra = optoff;
+		IP6CB(skb)->flags |= IP6SKB_ROUTERALERT;
+		memcpy(&IP6CB(skb)->ra, nh + optoff + 2, sizeof(IP6CB(skb)->ra));
 		return true;
 	}
 	LIMIT_NETDEBUG(KERN_DEBUG "ipv6_hop_ra: wrong RA length %d\n",
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index dee9964..5345300 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -302,9 +302,8 @@ int ip6_mc_input(struct sk_buff *skb)
 		struct inet6_skb_parm *opt = IP6CB(skb);
 
 		/* Check for MLD */
-		if (unlikely(opt->ra)) {
+		if (unlikely(opt->flags & IP6SKB_ROUTERALERT)) {
 			/* Check if this is a mld message */
-			u8 *ptr = skb_network_header(skb) + opt->ra;
 			struct icmp6hdr *icmp6;
 			u8 nexthdr = hdr->nexthdr;
 			__be16 frag_off;
@@ -313,7 +312,7 @@ int ip6_mc_input(struct sk_buff *skb)
 			/* Check if the value of Router Alert
 			 * is for MLD (0x0000).
 			 */
-			if ((ptr[2] | ptr[3]) == 0) {
+			if (opt->ra == htons(IPV6_OPT_ROUTERALERT_MLD)) {
 				deliver = false;
 
 				if (!ipv6_ext_hdr(nexthdr)) {
-- 
1.8.1.2

