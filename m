Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaHRJiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:38:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaHRJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 135/137] net: Correctly set segment mac_len in skb_segment().
Date: Mon, 18 Aug 2014 10:33:16 +0100
Message-Id: <1408354398-10226-136-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

commit fcdfe3a7fa4cb74391d42b6a26dc07c20dab1d82 upstream.

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
[ luis: backported to 3.11: used davem's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 39766e4077d6..a8976de2e1a0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2804,7 +2804,6 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 		tail = nskb;
 
 		__copy_skb_header(nskb, skb);
-		nskb->mac_len = skb->mac_len;
 
 		/* nskb and skb might have different headroom */
 		if (nskb->ip_summed == CHECKSUM_PARTIAL)
@@ -2814,6 +2813,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 		skb_set_network_header(nskb, skb->mac_len);
 		nskb->transport_header = (nskb->network_header +
 					  skb_network_header_len(skb));
+		skb_reset_mac_len(nskb);
 
 		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
-- 
1.9.1

