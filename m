Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaCZWiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:38:01 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33593 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbaCZWh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:37:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,738,1389744000"; 
   d="scan'208";a="115264735"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Jesse Gross <jesse@nicira.com>, <pshelar@nicira.com>, <tgraf@redhat.com>,
        <dev@openvswitch.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Tom Herbert <therbert@google.com>, Jason Wang <jasowang@redhat.com>,
        Florian Westphal <fw@strlen.de>, Joe Perches <joe@perches.com>,
        Simon Horman <horms@verge.net.au>, Jiri Pirko <jiri@resnulli.us>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Miklos Szeredi <mszeredi@suse.cz>, <netfilter-devel@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH v5] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy and handle errors
Date: Wed, 26 Mar 2014 22:37:45 +0000
Message-ID: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
orphan them. Also, it doesn't handle errors, so this patch takes care of that
as well, and modify the callers accordingly. skb_tx_error() is also added to
the callers so they will signal the failed delivery towards the creator of the
skb.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
v2: orphan the frags right before touching the frags

v3:
- orphan 'from' instead of 'to'
- call skb_tx_error() in the callers if something went wrong

v4: correctly use error path in queue_userspace_packet

v5: remove const qualifier of "from" in skb_zerocopy parameters

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 03db95a..0db91fa 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2508,8 +2508,8 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
 		    unsigned int flags);
 void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to);
 unsigned int skb_zerocopy_headlen(const struct sk_buff *from);
-void skb_zerocopy(struct sk_buff *to, const struct sk_buff *from,
-		  int len, int hlen);
+int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
+		 int len, int hlen);
 void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len);
 int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen);
 void skb_scrub_packet(struct sk_buff *skb, bool xnet);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3f14c63..908ad98 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2127,25 +2127,31 @@ EXPORT_SYMBOL_GPL(skb_zerocopy_headlen);
  *
  *	The `hlen` as calculated by skb_zerocopy_headlen() specifies the
  *	headroom in the `to` buffer.
+ *
+ *	Return value:
+ *	0: everything is OK
+ *	-ENOMEM: couldn't orphan frags of @from due to lack of memory
+ *	-EFAULT: skb_copy_bits() found some problem with skb geometry
  */
-void
-skb_zerocopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
+int
+skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 {
 	int i, j = 0;
 	int plen = 0; /* length of skb->head fragment */
+	int ret;
 	struct page *page;
 	unsigned int offset;
 
 	BUG_ON(!from->head_frag && !hlen);
 
 	/* dont bother with small payloads */
-	if (len <= skb_tailroom(to)) {
-		skb_copy_bits(from, 0, skb_put(to, len), len);
-		return;
-	}
+	if (len <= skb_tailroom(to))
+		return skb_copy_bits(from, 0, skb_put(to, len), len);
 
 	if (hlen) {
-		skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
+		ret = skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
+		if (unlikely(ret))
+			return ret;
 		len -= hlen;
 	} else {
 		plen = min_t(int, skb_headlen(from), len);
@@ -2163,6 +2169,11 @@ skb_zerocopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
 	to->len += len + plen;
 	to->data_len += len + plen;
 
+	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
+		skb_tx_error(from);
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
 		if (!len)
 			break;
@@ -2173,6 +2184,8 @@ skb_zerocopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
 		j++;
 	}
 	skb_shinfo(to)->nr_frags = j;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy);
 
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index f072fe8..108120f 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -354,13 +354,16 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 	skb = nfnetlink_alloc_skb(net, size, queue->peer_portid,
 				  GFP_ATOMIC);
-	if (!skb)
+	if (!skb) {
+		skb_tx_error(entskb);
 		return NULL;
+	}
 
 	nlh = nlmsg_put(skb, 0, 0,
 			NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET,
 			sizeof(struct nfgenmsg), 0);
 	if (!nlh) {
+		skb_tx_error(entskb);
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -488,13 +491,15 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		nla->nla_type = NFQA_PAYLOAD;
 		nla->nla_len = nla_attr_size(data_len);
 
-		skb_zerocopy(skb, entskb, data_len, hlen);
+		if (skb_zerocopy(skb, entskb, data_len, hlen))
+			goto nla_put_failure;
 	}
 
 	nlh->nlmsg_len = skb->len;
 	return skb;
 
 nla_put_failure:
+	skb_tx_error(entskb);
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 	return NULL;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c53fe0c..9230223 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -464,7 +464,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	}
 	nla->nla_len = nla_attr_size(skb->len);
 
-	skb_zerocopy(user_skb, skb, skb->len, hlen);
+	err = skb_zerocopy(user_skb, skb, skb->len, hlen);
+	if (err)
+		goto out;
 
 	/* Pad OVS_PACKET_ATTR_PACKET if linear copy was performed */
 	if (!(dp->user_features & OVS_DP_F_UNALIGNED)) {
@@ -478,6 +480,8 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 
 	err = genlmsg_unicast(ovs_dp_get_net(dp), user_skb, upcall_info->portid);
 out:
+	if (err)
+		skb_tx_error(skb);
 	kfree_skb(nskb);
 	return err;
 }
