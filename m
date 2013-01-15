Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3AOSwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:52:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:33948 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581Ab3AOSv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:51:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 002/221] ath5k: fix tx path skb leaks
Date: Tue, 15 Jan 2013 10:48:49 -0800
Message-Id: <20130115184958.219962054@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 596ab5ec3bf10a22be30d7cb1d903a4b83fd607c upstream.

ieee80211_free_txskb() needs to be used instead of dev_kfree_skb_any for
tx packets passed to the driver from mac80211

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath5k/base.c         |    4 ++--
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -848,7 +848,7 @@ ath5k_txbuf_free_skb(struct ath5k_hw *ah
 		return;
 	dma_unmap_single(ah->dev, bf->skbaddr, bf->skb->len,
 			DMA_TO_DEVICE);
-	dev_kfree_skb_any(bf->skb);
+	ieee80211_free_txskb(ah->hw, bf->skb);
 	bf->skb = NULL;
 	bf->skbaddr = 0;
 	bf->desc->ds_data = 0;
@@ -1575,7 +1575,7 @@ ath5k_tx_queue(struct ieee80211_hw *hw,
 	return;
 
 drop_packet:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 
 static void
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -62,7 +62,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 	u16 qnum = skb_get_queue_mapping(skb);
 
 	if (WARN_ON(qnum >= ah->ah_capabilities.cap_queues.q_tx_num)) {
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 


