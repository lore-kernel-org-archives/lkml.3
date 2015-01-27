Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbbA0MTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580AbbA0MSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Benc <jbenc@redhat.com>, Stefan Assmann <sassmann@redhat.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 071/126] enic: fix rx skb checksum
Date: Tue, 27 Jan 2015 12:16:16 +0000
Message-Id: <1422361031-19364-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Govindarajulu Varadarajan <_govind@gmx.com>

commit 17e96834fd35997ca7cdfbf15413bcd5a36ad448 upstream.

Hardware always provides compliment of IP pseudo checksum. Stack expects
whole packet checksum without pseudo checksum if CHECKSUM_COMPLETE is set.

This causes checksum error in nf & ovs.

kernel: qg-19546f09-f2: hw csum failure
kernel: CPU: 9 PID: 0 Comm: swapper/9 Tainted: GF          O--------------   3.10.0-123.8.1.el7.x86_64 #1
kernel: Hardware name: Cisco Systems Inc UCSB-B200-M3/UCSB-B200-M3, BIOS B200M3.2.2.3.0.080820141339 08/08/2014
kernel: ffff881218f40000 df68243feb35e3a8 ffff881237a43ab8 ffffffff815e237b
kernel: ffff881237a43ad0 ffffffff814cd4ca ffff8829ec71eb00 ffff881237a43af0
kernel: ffffffff814c6232 0000000000000286 ffff8829ec71eb00 ffff881237a43b00
kernel: Call Trace:
kernel: <IRQ>  [<ffffffff815e237b>] dump_stack+0x19/0x1b
kernel: [<ffffffff814cd4ca>] netdev_rx_csum_fault+0x3a/0x40
kernel: [<ffffffff814c6232>] __skb_checksum_complete_head+0x62/0x70
kernel: [<ffffffff814c6251>] __skb_checksum_complete+0x11/0x20
kernel: [<ffffffff8155a20c>] nf_ip_checksum+0xcc/0x100
kernel: [<ffffffffa049edc7>] icmp_error+0x1f7/0x35c [nf_conntrack_ipv4]
kernel: [<ffffffff814cf419>] ? netif_rx+0xb9/0x1d0
kernel: [<ffffffffa040eb7b>] ? internal_dev_recv+0xdb/0x130 [openvswitch]
kernel: [<ffffffffa04c8330>] nf_conntrack_in+0xf0/0xa80 [nf_conntrack]
kernel: [<ffffffff81509380>] ? inet_del_offload+0x40/0x40
kernel: [<ffffffffa049e302>] ipv4_conntrack_in+0x22/0x30 [nf_conntrack_ipv4]
kernel: [<ffffffff815005ca>] nf_iterate+0xaa/0xc0
kernel: [<ffffffff81509380>] ? inet_del_offload+0x40/0x40
kernel: [<ffffffff81500664>] nf_hook_slow+0x84/0x140
kernel: [<ffffffff81509380>] ? inet_del_offload+0x40/0x40
kernel: [<ffffffff81509dd4>] ip_rcv+0x344/0x380

Hardware verifies IP & tcp/udp header checksum but does not provide payload
checksum, use CHECKSUM_UNNECESSARY. Set it only if its valid IP tcp/udp packet.

Cc: Jiri Benc <jbenc@redhat.com>
Cc: Stefan Assmann <sassmann@redhat.com>
Reported-by: Sunil Choudhary <schoudha@redhat.com>
Signed-off-by: Govindarajulu Varadarajan <_govind@gmx.com>
Reviewed-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index f32f828b7f3d..fb9708d4b8b5 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1041,10 +1041,14 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 				     PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);
 		}
 
-		if ((netdev->features & NETIF_F_RXCSUM) && !csum_not_calc) {
-			skb->csum = htons(checksum);
-			skb->ip_summed = CHECKSUM_COMPLETE;
-		}
+		/* Hardware does not provide whole packet checksum. It only
+		 * provides pseudo checksum. Since hw validates the packet
+		 * checksum but not provide us the checksum value. use
+		 * CHECSUM_UNNECESSARY.
+		 */
+		if ((netdev->features & NETIF_F_RXCSUM) && tcp_udp_csum_ok &&
+		    ipv4_csum_ok)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 		if (vlan_stripped)
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
-- 
2.1.4

