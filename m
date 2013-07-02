Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3GBLTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:19:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36179 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3GBLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 10/50] r8169: fix offloaded tx checksum for small packets.
Date: Tue,  2 Jul 2013 12:06:58 +0100
Message-Id: <1372763258-20664-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

commit b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 upstream.

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
[ luis: backported to 3.5:
  - adjust context
  - extra parameter to function rtl8169_tx_vlan_tag ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c | 41 ++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 5dcbbe3..915e104 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5497,7 +5497,20 @@ err_out:
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
@@ -5510,13 +5523,20 @@ static inline void rtl8169_tso_csum(struct rtl8169_private *tp,
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
@@ -5537,17 +5557,15 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
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
 
+	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(tp, skb));
+	opts[0] = DescOwn;
+
+	if (!rtl8169_tso_csum(tp, skb, opts))
+		goto err_update_stats;
+
 	len = skb_headlen(skb);
 	mapping = dma_map_single(d, skb->data, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(d, mapping))) {
@@ -5559,11 +5577,6 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
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
-- 
1.8.1.2

