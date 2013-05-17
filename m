Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3EQVsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:48:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3EQVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:48:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 42/50] r8169: fix vlan tag read ordering.
Date: Fri, 17 May 2013 14:47:17 -0700
Message-Id: <20130517213847.091375166@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit ce11ff5e5963e441feb591e76278528f876c332d upstream.

Control of receive descriptor must not be returned to ethernet chipset
before vlan tag processing is done.

VLAN tag receive word is now reset both in normal and error path.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Spotted-by: Timo Teras <timo.teras@iki.fi>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/r8169.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1690,8 +1690,6 @@ static void rtl8169_rx_vlan_tag(struct R
 
 	if (opts2 & RxVlanTag)
 		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
-
-	desc->opts2 = 0;
 }
 
 static int rtl8169_gset_tbi(struct net_device *dev, struct ethtool_cmd *cmd)
@@ -5434,8 +5432,6 @@ static int rtl_rx(struct net_device *dev
 			    !(status & (RxRWT | RxFOVF)) &&
 			    (dev->features & NETIF_F_RXALL))
 				goto process_pkt;
-
-			rtl8169_mark_to_asic(desc, rx_buf_sz);
 		} else {
 			struct sk_buff *skb;
 			dma_addr_t addr;
@@ -5456,16 +5452,14 @@ process_pkt:
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
@@ -5481,6 +5475,10 @@ process_pkt:
 			tp->rx_stats.bytes += pkt_size;
 			u64_stats_update_end(&tp->rx_stats.syncp);
 		}
+release_descriptor:
+		desc->opts2 = 0;
+		wmb();
+		rtl8169_mark_to_asic(desc, rx_buf_sz);
 	}
 
 	count = cur_rx - tp->cur_rx;


