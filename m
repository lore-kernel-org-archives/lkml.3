Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3FLMk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:40:26 -0400
Received: from mout.gmx.net ([212.227.17.22]:65017 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab3FLMkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:40:25 -0400
From: Dave Wiltshire <david.wiltshire@gmx.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, nsujir@broadcom.com,
        mchan@broadcom.com, rmody@brocade.com, jcliburn@gmail.com,
        chris.snook@gmail.com, jeffrey.t.kirsher@intel.com,
        bruce.w.allan@intel.com, alexander.h.duyck@intel.com,
        cooldavid@cooldavid.org, linux-driver@qlogic.com,
        linux-wimax@intel.com, wimax@linuxwimax.org,
        linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, edumazet@google.com, dev@openvswitch.org,
        jhs@mojatatu.com, Dave Wiltshire <david.wiltshire@gmx.com>
Subject: [PATCH 3/3] skbuff: Added new helper function skb_cow_clone_head.
Date: Wed, 12 Jun 2013 22:40:11 +1000
Message-Id: <1371040811-8319-2-git-send-email-david.wiltshire@gmx.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371040811-8319-1-git-send-email-david.wiltshire@gmx.com>
References: <1371030906-2396-1-git-send-email-david.wiltshire@gmx.com>
 <1371040811-8319-1-git-send-email-david.wiltshire@gmx.com>
X-Provags-ID: V03:K0:vNiH3ngp0ZdQJPDTUnr7yyav8/6JegwKazrrbVP+piQNwQWnuQJ
 wHkoPJtlW5BoC9R2p8QwdelqljqjYiaIIX/zI1V1FCGINfmDg5+x0fS1MC809h7v+ywonFH
 4R+Yxn/cBL1zJRxEMyxRGIAAdzfPlEGCLz6t7RehIdlFY/GzZM81P931HjriPuQ1haCzmWB
 jEj7YCtK+XOoFYCphK7Sg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a few different drivers there is a check of (skb_cloned &&
!skb_clone_writable) before then using pskb_expand_head to copy the skb
if that is required. There are already some skb_cow_* functions for
other conditions, so added this one and changed the call sites.

Signed-off-by: Dave Wiltshire <david.wiltshire@gmx.com>
---
 include/linux/skbuff.h    |   14 ++++++++++++++
 net/core/dev.c            |    8 ++------
 net/openvswitch/actions.c |   22 +++++++---------------
 net/sched/act_csum.c      |    8 ++------
 net/sched/act_nat.c       |   18 +++++-------------
 5 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a7393ad..7d18541 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2154,6 +2154,20 @@ static inline int skb_cow_head(struct sk_buff *skb, unsigned int headroom)
 }
 
 /**
+ * skb_cow_clone_head
+ * @skb: buffer to cow
+ * @len: length up to which to write
+ *
+ * This function is identical to skb_cow and sb_cow_head except that we
+ * replace the skb_cloned check by skb_cloned && !skb_clone_writable.
+ *
+ */
+static inline int skb_cow_clone_head(struct sk_buff *skb, unsigned int len)
+{
+	return __skb_cow(skb, 0, skb_cloned(skb) && !skb_clone_writable(skb, len));
+}
+
+/**
  *	skb_padto	- pad an skbuff up to a minimal size
  *	@skb: buffer to pad
  *	@len: minimal length
diff --git a/net/core/dev.c b/net/core/dev.c
index fa007db..1fb1cf5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2222,12 +2222,8 @@ int skb_checksum_help(struct sk_buff *skb)
 	offset += skb->csum_offset;
 	BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
 
-	if (skb_cloned(skb) &&
-	    !skb_clone_writable(skb, offset + sizeof(__sum16))) {
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		if (ret)
-			goto out;
-	}
+	if (skb_cow_clone_head(skb, offset + sizeof(__sum16)))
+		goto out;
 
 	*(__sum16 *)(skb->data + offset) = csum_fold(csum);
 out_set_summed:
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 894b6cb..3d3a9d0 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -38,21 +38,13 @@
 static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			const struct nlattr *attr, int len, bool keep_skb);
 
-static int make_writable(struct sk_buff *skb, int write_len)
-{
-	if (!skb_cloned(skb) || skb_clone_writable(skb, write_len))
-		return 0;
-
-	return pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-}
-
 /* remove VLAN header from packet and update csum accordingly. */
 static int __pop_vlan_tci(struct sk_buff *skb, __be16 *current_tci)
 {
 	struct vlan_hdr *vhdr;
 	int err;
 
-	err = make_writable(skb, VLAN_ETH_HLEN);
+	err = skb_cow_clone_head(skb, VLAN_ETH_HLEN);
 	if (unlikely(err))
 		return err;
 
@@ -126,7 +118,7 @@ static int set_eth_addr(struct sk_buff *skb,
 			const struct ovs_key_ethernet *eth_key)
 {
 	int err;
-	err = make_writable(skb, ETH_HLEN);
+	err = skb_cow_clone_head(skb, ETH_HLEN);
 	if (unlikely(err))
 		return err;
 
@@ -221,7 +213,7 @@ static int set_ipv4(struct sk_buff *skb, const struct ovs_key_ipv4 *ipv4_key)
 	struct iphdr *nh;
 	int err;
 
-	err = make_writable(skb, skb_network_offset(skb) +
+	err = skb_cow_clone_head(skb, skb_network_offset(skb) +
 				 sizeof(struct iphdr));
 	if (unlikely(err))
 		return err;
@@ -250,7 +242,7 @@ static int set_ipv6(struct sk_buff *skb, const struct ovs_key_ipv6 *ipv6_key)
 	__be32 *saddr;
 	__be32 *daddr;
 
-	err = make_writable(skb, skb_network_offset(skb) +
+	err = skb_cow_clone_head(skb, skb_network_offset(skb) +
 			    sizeof(struct ipv6hdr));
 	if (unlikely(err))
 		return err;
@@ -284,7 +276,7 @@ static int set_ipv6(struct sk_buff *skb, const struct ovs_key_ipv6 *ipv6_key)
 	return 0;
 }
 
-/* Must follow make_writable() since that can move the skb data. */
+/* Must follow skb_cow_clone_head() since that can move the skb data. */
 static void set_tp_port(struct sk_buff *skb, __be16 *port,
 			 __be16 new_port, __sum16 *check)
 {
@@ -313,7 +305,7 @@ static int set_udp(struct sk_buff *skb, const struct ovs_key_udp *udp_port_key)
 	struct udphdr *uh;
 	int err;
 
-	err = make_writable(skb, skb_transport_offset(skb) +
+	err = skb_cow_clone_head(skb, skb_transport_offset(skb) +
 				 sizeof(struct udphdr));
 	if (unlikely(err))
 		return err;
@@ -333,7 +325,7 @@ static int set_tcp(struct sk_buff *skb, const struct ovs_key_tcp *tcp_port_key)
 	struct tcphdr *th;
 	int err;
 
-	err = make_writable(skb, skb_transport_offset(skb) +
+	err = skb_cow_clone_head(skb, skb_transport_offset(skb) +
 				 sizeof(struct tcphdr));
 	if (unlikely(err))
 		return err;
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 3a4c0ca..e7ff098 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -122,9 +122,7 @@ static void *tcf_csum_skb_nextlayer(struct sk_buff *skb,
 	int hl = ihl + jhl;
 
 	if (!pskb_may_pull(skb, ipl + ntkoff) || (ipl < hl) ||
-	    (skb_cloned(skb) &&
-	     !skb_clone_writable(skb, hl + ntkoff) &&
-	     pskb_expand_head(skb, 0, 0, GFP_ATOMIC)))
+	    skb_cow_clone_head(skb, hl + ntkoff))
 		return NULL;
 	else
 		return (void *)(skb_network_header(skb) + ihl);
@@ -382,9 +380,7 @@ static int tcf_csum_ipv4(struct sk_buff *skb, u32 update_flags)
 	}
 
 	if (update_flags & TCA_CSUM_UPDATE_FLAG_IPV4HDR) {
-		if (skb_cloned(skb) &&
-		    !skb_clone_writable(skb, sizeof(*iph) + ntkoff) &&
-		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+		if (skb_cow_clone_head(skb, sizeof(*iph) + ntkoff))
 			goto fail;
 
 		ip_send_check(ip_hdr(skb));
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 876f0ef..2b5b89c 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -144,9 +144,7 @@ static int tcf_nat(struct sk_buff *skb, const struct tc_action *a,
 		addr = iph->daddr;
 
 	if (!((old_addr ^ addr) & mask)) {
-		if (skb_cloned(skb) &&
-		    !skb_clone_writable(skb, sizeof(*iph) + noff) &&
-		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+		if (skb_cow_clone_head(skb, sizeof(*iph) + noff))
 			goto drop;
 
 		new_addr &= mask;
@@ -174,9 +172,7 @@ static int tcf_nat(struct sk_buff *skb, const struct tc_action *a,
 		struct tcphdr *tcph;
 
 		if (!pskb_may_pull(skb, ihl + sizeof(*tcph) + noff) ||
-		    (skb_cloned(skb) &&
-		     !skb_clone_writable(skb, ihl + sizeof(*tcph) + noff) &&
-		     pskb_expand_head(skb, 0, 0, GFP_ATOMIC)))
+		    skb_cow_clone_head(skb, ihl + sizeof(*tcph) + noff))
 			goto drop;
 
 		tcph = (void *)(skb_network_header(skb) + ihl);
@@ -188,9 +184,7 @@ static int tcf_nat(struct sk_buff *skb, const struct tc_action *a,
 		struct udphdr *udph;
 
 		if (!pskb_may_pull(skb, ihl + sizeof(*udph) + noff) ||
-		    (skb_cloned(skb) &&
-		     !skb_clone_writable(skb, ihl + sizeof(*udph) + noff) &&
-		     pskb_expand_head(skb, 0, 0, GFP_ATOMIC)))
+		    skb_cow_clone_head(skb, ihl + sizeof(*udph) + noff))
 			goto drop;
 
 		udph = (void *)(skb_network_header(skb) + ihl);
@@ -230,10 +224,8 @@ static int tcf_nat(struct sk_buff *skb, const struct tc_action *a,
 		if ((old_addr ^ addr) & mask)
 			break;
 
-		if (skb_cloned(skb) &&
-		    !skb_clone_writable(skb, ihl + sizeof(*icmph) +
-					     sizeof(*iph) + noff) &&
-		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+		if (skb_cow_clone_head(skb, ihl + sizeof(*icmph) +
+					    sizeof(*iph) + noff))
 			goto drop;
 
 		icmph = (void *)(skb_network_header(skb) + ihl);
-- 
1.7.10.4

