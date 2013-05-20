Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3ETKxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3ETKxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Francois Romieu <romieu@fr.zoreil.com>, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 052/115] r8169: fix vlan tag read ordering.
Date: Mon, 20 May 2013 11:50:52 +0100
Message-Id: <1369047116-9378-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

commit ce11ff5e5963e441feb591e76278528f876c332d upstream.

Control of receive descriptor must not be returned to ethernet chipset
before vlan tag processing is done.

VLAN tag receive word is now reset both in normal and error path.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Spotted-by: Timo Teras <timo.teras@iki.fi>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index a32d221..6c595f9 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1687,8 +1687,6 @@ static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
 
 	if (opts2 & RxVlanTag)
 		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
-
-	desc->opts2 = 0;
 }
 
 static int rtl8169_gset_tbi(struct net_device *dev, struct ethtool_cmd *cmd)
@@ -5787,8 +5785,6 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 			    !(status & (RxRWT | RxFOVF)) &&
 			    (dev->features & NETIF_F_RXALL))
 				goto process_pkt;
-
-			rtl8169_mark_to_asic(desc, rx_buf_sz);
 		} else {
 			struct sk_buff *skb;
 			dma_addr_t addr;
@@ -5809,16 +5805,14 @@ process_pkt:
 			if (unlikely(rtl8169_fragmented_frame(status))) {
 				dev->stats.rx_dropped++;
 				dev->stats.rx_length_errors++;
-				rtl8169_mark_to_asic(desc, rx_buf_sz);
-				continue;
+				goto release_descriptor;
 			}
 
 			skb = rtl8169_try_rx_copy(tp->Rx_databuff[entry],
 						  tp, pkt_size, addr);
-			rtl8169_mark_to_asic(desc, rx_buf_sz);
 			if (!skb) {
 				dev->stats.rx_dropped++;
-				continue;
+				goto release_descriptor;
 			}
 
 			rtl8169_rx_csum(skb, status);
@@ -5834,6 +5828,10 @@ process_pkt:
 			tp->rx_stats.bytes += pkt_size;
 			u64_stats_update_end(&tp->rx_stats.syncp);
 		}
+release_descriptor:
+		desc->opts2 = 0;
+		wmb();
+		rtl8169_mark_to_asic(desc, rx_buf_sz);
 	}
 
 	count = cur_rx - tp->cur_rx;
-- 
1.8.1.2

