Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3BFW6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:58:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab3BFW6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:58:46 -0500
Date: Thu, 7 Feb 2013 01:02:50 +0200
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
Subject: [PATCH 1/2] ixgbe: fix gso type
Message-ID: <76c44c70077f42302d7b079b29fd414205747af5.1360191528.git.mst@redhat.com>
References: <cover.1360191528.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360191528.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ixgbe set gso_size but not gso_type. This leads to
crashes in macvtap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I tested that this fixes the crash for me.  I am told on ixgbe LRO only
triggers with TCP so checking protocol should be enough?

 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 396e280..9d01673 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1399,6 +1399,10 @@ static void ixgbe_set_rsc_gso_size(struct ixgbe_ring *ring,
 	/* set gso_size to avoid messing up TCP MSS */
 	skb_shinfo(skb)->gso_size = DIV_ROUND_UP((skb->len - hdr_len),
 						 IXGBE_CB(skb)->append_cnt);
+	if (skb->protocol == ETH_P_IPV6)
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
+	else
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
 }
 
 static void ixgbe_update_rsc_stats(struct ixgbe_ring *rx_ring,
@@ -1433,6 +1437,8 @@ static void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 {
 	struct net_device *dev = rx_ring->netdev;
 
+	skb->protocol = eth_type_trans(skb, dev);
+
 	ixgbe_update_rsc_stats(rx_ring, skb);
 
 	ixgbe_rx_hash(rx_ring, rx_desc, skb);
@@ -1448,8 +1454,6 @@ static void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 	}
 
 	skb_record_rx_queue(skb, rx_ring->queue_index);
-
-	skb->protocol = eth_type_trans(skb, dev);
 }
 
 static void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
-- 
MST

