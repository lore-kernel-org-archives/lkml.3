Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbaIOXVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:21:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50489 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbaIOWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 009/187] net: Correctly set segment mac_len in skb_segment().
Date: Mon, 15 Sep 2014 15:06:59 -0700
Message-Id: <1410818997-9432-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f7eca05..808a270 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2872,9 +2872,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		tail = nskb;
 
 		__copy_skb_header(nskb, head_skb);
-		nskb->mac_len = head_skb->mac_len;
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - headroom);
+		skb_reset_mac_len(nskb);
 
 		skb_copy_from_linear_data_offset(head_skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
-- 
1.9.1

