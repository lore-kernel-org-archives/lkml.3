Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3FZCqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:46:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54144 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086Ab3FZCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "hayeswang" <hayeswang@realtek.com>,
        "Francois Romieu" <romieu@fr.zoreil.com>,
        "Stefan Bader" <stefan.bader@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.437609827@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [16/26] r8169: fix 8168evl frame padding.
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

[ Upstream commits e5195c1f31f399289347e043d6abf3ffa80f0005 and
  b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 ]

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: hayeswang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index f698183..ed7a5a6 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5524,7 +5524,20 @@ err_out:
 	return -EIO;
 }
 
-static inline void rtl8169_tso_csum(struct rtl8169_private *tp,
+static bool rtl_skb_pad(struct sk_buff *skb)
+{
+	if (skb_padto(skb, ETH_ZLEN))
+		return false;
+	skb_put(skb, ETH_ZLEN - skb->len);
+	return true;
+}
+
+static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
+{
+	return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
+}
+
+static inline bool rtl8169_tso_csum(struct rtl8169_private *tp,
 				    struct sk_buff *skb, u32 *opts)
 {
 	const struct rtl_tx_desc_info *info = tx_desc_info + tp->txd_version;
@@ -5537,13 +5550,20 @@ static inline void rtl8169_tso_csum(struct rtl8169_private *tp,
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		const struct iphdr *ip = ip_hdr(skb);
 
+		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
+			return skb_checksum_help(skb) == 0 && rtl_skb_pad(skb);
+
 		if (ip->protocol == IPPROTO_TCP)
 			opts[offset] |= info->checksum.tcp;
 		else if (ip->protocol == IPPROTO_UDP)
 			opts[offset] |= info->checksum.udp;
 		else
 			WARN_ON_ONCE(1);
+	} else {
+		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
+			return rtl_skb_pad(skb);
 	}
+	return true;
 }
 
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
@@ -5575,6 +5595,12 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
+	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(tp, skb));
+	opts[0] = DescOwn;
+
+	if (!rtl8169_tso_csum(tp, skb, opts))
+		goto err_update_stats;
+
 	len = skb_headlen(skb);
 	mapping = dma_map_single(d, skb->data, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(d, mapping))) {
@@ -5586,11 +5612,6 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	tp->tx_skb[entry].len = len;
 	txd->addr = cpu_to_le64(mapping);
 
-	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(tp, skb));
-	opts[0] = DescOwn;
-
-	rtl8169_tso_csum(tp, skb, opts);
-
 	frags = rtl8169_xmit_frags(tp, skb, opts);
 	if (frags < 0)
 		goto err_dma_1;

