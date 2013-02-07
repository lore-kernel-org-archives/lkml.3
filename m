Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab3BGNJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:09:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758369Ab3BGNJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:09:00 -0500
Date: Thu, 7 Feb 2013 15:13:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, linux-driver@qlogic.com,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, bhutchings@solarflare.com,
        eric.dumazet@gmail.com
Subject: [PATCHv2-net-3.8 1/3] ixgbe: fix gso type
Message-ID: <e1e4fe6d356c2766cd6a962a3ef6439bfd94a985.1360236441.git.mst@redhat.com>
References: <cover.1360236441.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360236441.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ixgbe set gso_size but not gso_type. This leads to
crashes in macvtap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 20a5af6..e1b2d22 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1401,6 +1401,10 @@ static void ixgbe_set_rsc_gso_size(struct ixgbe_ring *ring,
 	/* set gso_size to avoid messing up TCP MSS */
 	skb_shinfo(skb)->gso_size = DIV_ROUND_UP((skb->len - hdr_len),
 						 IXGBE_CB(skb)->append_cnt);
+	if (skb->protocol == __constant_htons(ETH_P_IPV6))
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
+	else
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
 }
 
 static void ixgbe_update_rsc_stats(struct ixgbe_ring *rx_ring,
@@ -1435,6 +1439,8 @@ static void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 {
 	struct net_device *dev = rx_ring->netdev;
 
+	skb->protocol = eth_type_trans(skb, dev);
+
 	ixgbe_update_rsc_stats(rx_ring, skb);
 
 	ixgbe_rx_hash(rx_ring, rx_desc, skb);
@@ -1450,8 +1456,6 @@ static void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 	}
 
 	skb_record_rx_queue(skb, rx_ring->queue_index);
-
-	skb->protocol = eth_type_trans(skb, dev);
 }
 
 static void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
-- 
MST

