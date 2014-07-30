Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaG3Mf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:35:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36713 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbaG3MPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wei-Chun Chao <weichunc@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 37/94] net: fix UDP tunnel GSO of frag_list GRO packets
Date: Wed, 30 Jul 2014 14:14:26 +0200
Message-Id: <1ea464333aa10210b8b285a8a64ce17211569156.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei-Chun Chao <weichunc@plumgrid.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5882a07c72093dc3a18e2d2b129fb200686bb6ee ]

This patch fixes a kernel BUG_ON in skb_segment. It is hit when
testing two VMs on openvswitch with one VM acting as VXLAN gateway.

During VXLAN packet GSO, skb_segment is called with skb->data
pointing to inner TCP payload. skb_segment calls skb_network_protocol
to retrieve the inner protocol. skb_network_protocol actually expects
skb->data to point to MAC and it calls pskb_may_pull with ETH_HLEN.
This ends up pulling in ETH_HLEN data from header tail. As a result,
pskb_trim logic is skipped and BUG_ON is hit later.

Move skb_push in front of skb_network_protocol so that skb->data
lines up properly.

kernel BUG at net/core/skbuff.c:2999!
Call Trace:
[<ffffffff816ac412>] tcp_gso_segment+0x122/0x410
[<ffffffff816bc74c>] inet_gso_segment+0x13c/0x390
[<ffffffff8164b39b>] skb_mac_gso_segment+0x9b/0x170
[<ffffffff816b3658>] skb_udp_tunnel_segment+0xd8/0x390
[<ffffffff816b3c00>] udp4_ufo_fragment+0x120/0x140
[<ffffffff816bc74c>] inet_gso_segment+0x13c/0x390
[<ffffffff8109d742>] ? default_wake_function+0x12/0x20
[<ffffffff8164b39b>] skb_mac_gso_segment+0x9b/0x170
[<ffffffff8164b4d0>] __skb_gso_segment+0x60/0xc0
[<ffffffff8164b6b3>] dev_hard_start_xmit+0x183/0x550
[<ffffffff8166c91e>] sch_direct_xmit+0xfe/0x1d0
[<ffffffff8164bc94>] __dev_queue_xmit+0x214/0x4f0
[<ffffffff8164bf90>] dev_queue_xmit+0x10/0x20
[<ffffffff81687edb>] ip_finish_output+0x66b/0x890
[<ffffffff81688a58>] ip_output+0x58/0x90
[<ffffffff816c628f>] ? fib_table_lookup+0x29f/0x350
[<ffffffff816881c9>] ip_local_out_sk+0x39/0x50
[<ffffffff816cbfad>] iptunnel_xmit+0x10d/0x130
[<ffffffffa0212200>] vxlan_xmit_skb+0x1d0/0x330 [vxlan]
[<ffffffffa02a3919>] vxlan_tnl_send+0x129/0x1a0 [openvswitch]
[<ffffffffa02a2cd6>] ovs_vport_send+0x26/0xa0 [openvswitch]
[<ffffffffa029931e>] do_output+0x2e/0x50 [openvswitch]

Signed-off-by: Wei-Chun Chao <weichunc@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5a60953e6f39..aeb870c5c134 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2744,12 +2744,13 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	int i = 0;
 	int pos;
 
+	__skb_push(head_skb, doffset);
 	proto = skb_network_protocol(head_skb);
 	if (unlikely(!proto))
 		return ERR_PTR(-EINVAL);
 
 	csum = !!can_checksum_protocol(features, proto);
-	__skb_push(head_skb, doffset);
+
 	headroom = skb_headroom(head_skb);
 	pos = skb_headlen(head_skb);
 
-- 
2.0.1

