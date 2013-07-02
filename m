Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3GBLTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:19:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3GBLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Bader <stefan.bader@canonical.com>,
        hayeswang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/50] r8169: fix 8168evl frame padding.
Date: Tue,  2 Jul 2013 12:06:57 +0100
Message-Id: <1372763258-20664-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit e5195c1f31f399289347e043d6abf3ffa80f0005 upstream.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: hayeswang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index f250232..5dcbbe3 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5537,6 +5537,14 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		goto err_stop_0;
 	}
 
+	/* 8168evl does not automatically pad to minimum length. */
+	if (unlikely(tp->mac_version == RTL_GIGA_MAC_VER_34 &&
+		     skb->len < ETH_ZLEN)) {
+		if (skb_padto(skb, ETH_ZLEN))
+			goto err_update_stats;
+		skb_put(skb, ETH_ZLEN - skb->len);
+	}
+
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
@@ -5608,6 +5616,7 @@ err_dma_1:
 	rtl8169_unmap_tx_skb(d, tp->tx_skb + entry, txd);
 err_dma_0:
 	dev_kfree_skb(skb);
+err_update_stats:
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 
-- 
1.8.1.2

