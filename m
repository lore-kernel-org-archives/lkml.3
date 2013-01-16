Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab3APQty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:49:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36106 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab3APQDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 095/222] b43: fix tx path skb leaks
Date: Wed, 16 Jan 2013 13:54:55 -0200
Message-Id: <1358351822-7675-96-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 78f18df4b323d2ac14d6c82e2fc3c8dc4556bccc upstream.

ieee80211_free_txskb() needs to be used instead of dev_kfree_skb_any for
tx packets passed to the driver from mac80211

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/b43/dma.c  |    7 +++++--
 drivers/net/wireless/b43/main.c |   12 ++++++++----
 drivers/net/wireless/b43/pio.c  |    4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 777cd74..38bc5a7 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -409,7 +409,10 @@ static inline
 				struct b43_dmadesc_meta *meta)
 {
 	if (meta->skb) {
-		dev_kfree_skb_any(meta->skb);
+		if (ring->tx)
+			ieee80211_free_txskb(ring->dev->wl->hw, meta->skb);
+		else
+			dev_kfree_skb_any(meta->skb);
 		meta->skb = NULL;
 	}
 }
@@ -1454,7 +1457,7 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(dev->wl->hw, skb);
 		err = 0;
 		goto out;
 	}
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c04d7b6..a4e020a 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3392,7 +3392,7 @@ static void b43_tx_work(struct work_struct *work)
 				break;
 			}
 			if (unlikely(err))
-				dev_kfree_skb(skb); /* Drop it */
+				ieee80211_free_txskb(wl->hw, skb);
 			err = 0;
 		}
 
@@ -3413,7 +3413,7 @@ static void b43_op_tx(struct ieee80211_hw *hw,
 
 	if (unlikely(skb->len < 2 + 2 + 6)) {
 		/* Too short, this can't be a valid frame. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
@@ -4223,8 +4223,12 @@ redo:
 
 	/* Drain all TX queues. */
 	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
-		while (skb_queue_len(&wl->tx_queue[queue_num]))
-			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
+		while (skb_queue_len(&wl->tx_queue[queue_num])) {
+			struct sk_buff *skb;
+
+			skb = skb_dequeue(&wl->tx_queue[queue_num]);
+			ieee80211_free_txskb(wl->hw, skb);
+		}
 	}
 
 	b43_mac_suspend(dev);
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 3533ab8..a73ff8c 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -196,7 +196,7 @@ static void b43_pio_cancel_tx_packets(struct b43_pio_txqueue *q)
 	for (i = 0; i < ARRAY_SIZE(q->packets); i++) {
 		pack = &(q->packets[i]);
 		if (pack->skb) {
-			dev_kfree_skb_any(pack->skb);
+			ieee80211_free_txskb(q->dev->wl->hw, pack->skb);
 			pack->skb = NULL;
 		}
 	}
@@ -552,7 +552,7 @@ int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb)
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(dev->wl->hw, skb);
 		err = 0;
 		goto out;
 	}
-- 
1.7.9.5

