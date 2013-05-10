Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3EJOT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:19:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56899 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823Ab3EJOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hayes Wang" <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "=?UTF-8?q?fran=C3=A7ois=20romieu?=" <romieu@fr.zoreil.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.15393931@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [117/118] r8169: fix vlan tag read ordering.
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: françois romieu <romieu@fr.zoreil.com>

commit ce11ff5e5963e441feb591e76278528f876c332d upstream.

Control of receive descriptor must not be returned to ethernet chipset
before vlan tag processing is done.

VLAN tag receive word is now reset both in normal and error path.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Spotted-by: Timo Teras <timo.teras@iki.fi>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1629,8 +1629,6 @@ static void rtl8169_rx_vlan_tag(struct R
 
 	if (opts2 & RxVlanTag)
 		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
-
-	desc->opts2 = 0;
 }
 
 static int rtl8169_gset_tbi(struct net_device *dev, struct ethtool_cmd *cmd)
@@ -5823,7 +5821,6 @@ static int rtl8169_rx_interrupt(struct n
 				rtl8169_schedule_work(dev, rtl8169_reset_task);
 				dev->stats.rx_fifo_errors++;
 			}
-			rtl8169_mark_to_asic(desc, rx_buf_sz);
 		} else {
 			struct sk_buff *skb;
 			dma_addr_t addr = le64_to_cpu(desc->addr);
@@ -5837,16 +5834,14 @@ static int rtl8169_rx_interrupt(struct n
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
@@ -5860,6 +5855,10 @@ static int rtl8169_rx_interrupt(struct n
 			dev->stats.rx_bytes += pkt_size;
 			dev->stats.rx_packets++;
 		}
+release_descriptor:
+		desc->opts2 = 0;
+		wmb();
+		rtl8169_mark_to_asic(desc, rx_buf_sz);
 	}
 
 	count = cur_rx - tp->cur_rx;

