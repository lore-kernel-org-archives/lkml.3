Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaKPWBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:16 -0500
Received: from 1wt.eu ([62.212.114.60]:47968 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaKPWBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:12 -0500
Message-Id: <20141116215329.732657503@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:54 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 26/48] net: Correctly set segment mac_len in skb_segment().
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit fcdfe3a7fa4cb74391d42b6a26dc07c20dab1d82 ]

When performing segmentation, the mac_len value is copied right
out of the original skb.  However, this value is not always set correctly
(like when the packet is VLAN-tagged) and we'll end up copying a bad
value.

One way to demonstrate this is to configure a VM which tags
packets internally and turn off VLAN acceleration on the forwarding
bridge port.  The packets show up corrupt like this:
16:18:24.985548 52:54:00:ab:be:25 > 52:54:00:26:ce:a3, ethertype 802.1Q
(0x8100), length 1518: vlan 100, p 0, ethertype 0x05e0,
        0x0000:  8cdb 1c7c 8cdb 0064 4006 b59d 0a00 6402 ...|...d@.....d.
        0x0010:  0a00 6401 9e0d b441 0a5e 64ec 0330 14fa ..d....A.^d..0..
        0x0020:  29e3 01c9 f871 0000 0101 080a 000a e833)....q.........3
        0x0030:  000f 8c75 6e65 7470 6572 6600 6e65 7470 ...unetperf.netp
        0x0040:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.netp
        0x0050:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.netp
        0x0060:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.netp
        ...

This also leads to awful throughput as GSO packets are dropped and
cause retransmissions.

The solution is to set the mac_len using the values already available
in then new skb.  We've already adjusted all of the header offset, so we
might as well correctly figure out the mac_len using skb_reset_mac_len().
After this change, packets are segmented correctly and performance
is restored.

CC: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[wt: open-code skb_mac_len() as 2.6.32 doesn't have it]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 72ff527..b6707b8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2573,7 +2573,6 @@ struct sk_buff *skb_segment(struct sk_buff *skb, int features)
 		tail = nskb;
 
 		__copy_skb_header(nskb, skb);
-		nskb->mac_len = skb->mac_len;
 
 		/* nskb and skb might have different headroom */
 		if (nskb->ip_summed == CHECKSUM_PARTIAL)
@@ -2583,6 +2582,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, int features)
 		skb_set_network_header(nskb, skb->mac_len);
 		nskb->transport_header = (nskb->network_header +
 					  skb_network_header_len(skb));
+		nskb->mac_len = nskb->network_header - nskb->mac_header;
 		skb_copy_from_linear_data(skb, nskb->data, doffset);
 
 		if (fskb != skb_shinfo(skb)->frag_list)
-- 
1.7.12.2.21.g234cd45.dirty



