Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3FYSeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3FYSd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
	<holger.hoffstaette@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 50/95] r8169: fix offloaded tx checksum for small packets.
Date: Tue, 25 Jun 2013 11:32:37 -0700
Message-Id: <20130625182159.286123367@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

[ Upstream commit b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 ]

8168evl offloaded checksums are wrong since commit
e5195c1f31f399289347e043d6abf3ffa80f0005 ("r8169: fix 8168evl frame padding.")
pads small packets to 60 bytes (without ethernet checksum). Typical symptoms
appear as UDP checksums which are wrong by the count of added bytes.

It isn't worth compensating. Let the driver checksum.

Due to the skb length changes, TSO code is moved before the Tx descriptor gets
written.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |   41 +++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5747,7 +5747,20 @@ err_out:
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
@@ -5760,13 +5773,20 @@ static inline void rtl8169_tso_csum(stru
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
@@ -5787,17 +5807,15 @@ static netdev_tx_t rtl8169_start_xmit(st
 		goto err_stop_0;
 	}
 
-	/* 8168evl does not automatically pad to minimum length. */
-	if (unlikely(tp->mac_version == RTL_GIGA_MAC_VER_34 &&
-		     skb->len < ETH_ZLEN)) {
-		if (skb_padto(skb, ETH_ZLEN))
-			goto err_update_stats;
-		skb_put(skb, ETH_ZLEN - skb->len);
-	}
-
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
+	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(skb));
+	opts[0] = DescOwn;
+
+	if (!rtl8169_tso_csum(tp, skb, opts))
+		goto err_update_stats;
+
 	len = skb_headlen(skb);
 	mapping = dma_map_single(d, skb->data, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(d, mapping))) {
@@ -5809,11 +5827,6 @@ static netdev_tx_t rtl8169_start_xmit(st
 	tp->tx_skb[entry].len = len;
 	txd->addr = cpu_to_le64(mapping);
 
-	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(skb));
-	opts[0] = DescOwn;
-
-	rtl8169_tso_csum(tp, skb, opts);
-
 	frags = rtl8169_xmit_frags(tp, skb, opts);
 	if (frags < 0)
 		goto err_dma_1;


