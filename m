Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaGZTK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:10:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaGZTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:10:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei-Chun Chao <weichunc@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 37/87] net: fix UDP tunnel GSO of frag_list GRO packets
Date: Sat, 26 Jul 2014 12:02:11 -0700
Message-Id: <20140726190215.717929216@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei-Chun Chao <weichunc@plumgrid.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2881,12 +2881,13 @@ struct sk_buff *skb_segment(struct sk_bu
 	int pos;
 	int dummy;
 
+	__skb_push(head_skb, doffset);
 	proto = skb_network_protocol(head_skb, &dummy);
 	if (unlikely(!proto))
 		return ERR_PTR(-EINVAL);
 
 	csum = !!can_checksum_protocol(features, proto);
-	__skb_push(head_skb, doffset);
+
 	headroom = skb_headroom(head_skb);
 	pos = skb_headlen(head_skb);
 


