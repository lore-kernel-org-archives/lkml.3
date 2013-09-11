Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3IKXLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:11:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3IKXKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:10:46 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=d9hS-i982MoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=s4Z7wkT3hRoA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=ahAPg7YLhdxFjBaGidcA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=DHJNRD0nMRSrFHD5:21 a=V-bNNCtMoUQWLnRr:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042902.161548139@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [058/251] vlan: mask vlan prio bits
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0058-vlan-mask-vlan-prio-bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d4b812dea4a236f729526facf97df1a9d18e191c ]

In commit 48cc32d38a52d0b68f91a171a8d00531edc6a46e
("vlan: don't deliver frames for unknown vlans to protocols")
Florian made sure we set pkt_type to PACKET_OTHERHOST
if the vlan id is set and we could find a vlan device for this
particular id.

But we also have a problem if prio bits are set.

Steinar reported an issue on a router receiving IPv6 frames with a
vlan tag of 4000 (id 0, prio 2), and tunneled into a sit device,
because skb->vlan_tci is set.

Forwarded frame is completely corrupted : We can see (8100:4000)
being inserted in the middle of IPv6 source address :

16:48:00.780413 IP6 2001:16d8:8100:4000:ee1c:0:9d9:bc87 >
9f94:4d95:2001:67c:29f4::: ICMP6, unknown icmp6 type (0), length 64
       0x0000:  0000 0029 8000 c7c3 7103 0001 a0ae e651
       0x0010:  0000 0000 ccce 0b00 0000 0000 1011 1213
       0x0020:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
       0x0030:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233

It seems we are not really ready to properly cope with this right now.

We can probably do better in future kernels :
vlan_get_ingress_priority() should be a netdev property instead of
a per vlan_dev one.

For stable kernels, lets clear vlan_tci to fix the bugs.

Reported-by: Steinar H. Gunderson <sesse@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/if_vlan.h |    3 +--
 net/8021q/vlan_core.c   |    2 +-
 net/core/dev.c          |   11 +++++++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 9b0c614..fef94f5 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -82,9 +82,8 @@ static inline int is_vlan_dev(struct net_device *dev)
 }
 
 #define vlan_tx_tag_present(__skb)	((__skb)->vlan_tci & VLAN_TAG_PRESENT)
-#define vlan_tx_nonzero_tag_present(__skb) \
-	(vlan_tx_tag_present(__skb) && ((__skb)->vlan_tci & VLAN_VID_MASK))
 #define vlan_tx_tag_get(__skb)		((__skb)->vlan_tci & ~VLAN_TAG_PRESENT)
+#define vlan_tx_tag_get_id(__skb)	((__skb)->vlan_tci & VLAN_VID_MASK)
 
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index fe29a64..d5f07cb 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -8,7 +8,7 @@
 bool vlan_do_receive(struct sk_buff **skbp)
 {
 	struct sk_buff *skb = *skbp;
-	u16 vlan_id = skb->vlan_tci & VLAN_VID_MASK;
+	u16 vlan_id = vlan_tx_tag_get_id(skb);
 	struct net_device *vlan_dev;
 	struct vlan_pcpu_stats *rx_stats;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 9b5e388..1012a02 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3317,8 +3317,15 @@ ncls:
 		}
 	}
 
-	if (vlan_tx_nonzero_tag_present(skb))
-		skb->pkt_type = PACKET_OTHERHOST;
+	if (unlikely(vlan_tx_tag_present(skb))) {
+		if (vlan_tx_tag_get_id(skb))
+			skb->pkt_type = PACKET_OTHERHOST;
+		/* Note: we might in the future use prio bits
+		 * and set skb->priority like in vlan_do_receive()
+		 * For the time being, just ignore Priority Code Point
+		 */
+		skb->vlan_tci = 0;
+	}
 
 	/* deliver only exact match when indicated */
 	null_or_dev = deliver_exact ? skb->dev : NULL;
-- 
1.7.10.4


