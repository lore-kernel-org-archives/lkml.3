Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab3APQDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3APQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 094/222] ath5k: fix tx path skb leaks
Date: Wed, 16 Jan 2013 13:54:54 -0200
Message-Id: <1358351822-7675-95-git-send-email-herton.krzesinski@canonical.com>
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

commit 596ab5ec3bf10a22be30d7cb1d903a4b83fd607c upstream.

ieee80211_free_txskb() needs to be used instead of dev_kfree_skb_any for
tx packets passed to the driver from mac80211

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath5k/base.c         |    4 ++--
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 44ad6fe..10a9985 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -845,7 +845,7 @@ ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf)
 		return;
 	dma_unmap_single(ah->dev, bf->skbaddr, bf->skb->len,
 			DMA_TO_DEVICE);
-	dev_kfree_skb_any(bf->skb);
+	ieee80211_free_txskb(ah->hw, bf->skb);
 	bf->skb = NULL;
 	bf->skbaddr = 0;
 	bf->desc->ds_data = 0;
@@ -1572,7 +1572,7 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	return;
 
 drop_packet:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 
 static void
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 22b80af..4c8ba4d 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -61,7 +61,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	u16 qnum = skb_get_queue_mapping(skb);
 
 	if (WARN_ON(qnum >= ah->ah_capabilities.cap_queues.q_tx_num)) {
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 
-- 
1.7.9.5

