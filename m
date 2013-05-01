Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3EAXxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:53:30 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:36020 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3EAXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:53:28 -0400
X-rim-org-msg-ref-id: 813455215
Message-ID: <813455215-1367452406-cardhu_decombobulator_blackberry.rim.net-461706736-@b4.c4.bise6.blackberry>
Reply-To: paul.ferrari@gmail.com
X-Priority: Normal
References: <20130501212450.B7F13660E0A@gitolite.kernel.org>
In-Reply-To: <20130501212450.B7F13660E0A@gitolite.kernel.org>
Sensitivity: Normal
Importance: Normal
Subject: Re: ath9k: merge ath_tx_start_dma into ath_tx_start
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
From: paul.ferrari@gmail.com
Date: Wed, 1 May 2013 23:53:24 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r41Nrx2L000476

       
Sent from my Verizon Wireless BlackBerry

-----Original Message-----
From:	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Sender:	git-commits-head-owner@vger.kernel.org
Date:	Wed,  1 May 2013 21:24:50 
To: <git-commits-head@vger.kernel.org>
Subject: ath9k: merge ath_tx_start_dma into ath_tx_start

Gitweb:     http://git.kernel.org/linus/;a=commit;h=bdc21457ac2bb75b59e774303edbb623830284ae
Commit:     bdc21457ac2bb75b59e774303edbb623830284ae
Parent:     7c8f0db0d024efda38976fc2acf7743f458e1d96
Author:     Felix Fietkau <nbd@openwrt.org>
AuthorDate: Mon Apr 22 23:11:43 2013 +0200
Committer:  John W. Linville <linville@tuxdriver.com>
CommitDate: Tue Apr 23 14:14:52 2013 -0400

    ath9k: merge ath_tx_start_dma into ath_tx_start
    
    The split makes no sense and merging the functions makes further changes
    easier to implement
    
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   80 +++++++++++++++------------------
 1 files changed, 36 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5bc5802..108fe5f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1892,49 +1892,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	return bf;
 }
 
-/* FIXME: tx power */
-static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
-			     struct ath_tx_control *txctl)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ath_atx_tid *tid = NULL;
-	struct ath_buf *bf;
-	u8 tidno;
-
-	if (txctl->an && ieee80211_is_data_qos(hdr->frame_control)) {
-		tidno = ieee80211_get_qos_ctl(hdr)[0] &
-			IEEE80211_QOS_CTL_TID_MASK;
-		tid = ATH_AN_2_TID(txctl->an, tidno);
-
-		WARN_ON(tid->ac->txq != txctl->txq);
-	}
-
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
-		/*
-		 * Try aggregation if it's a unicast data frame
-		 * and the destination is HT capable.
-		 */
-		ath_tx_send_ampdu(sc, tid, skb, txctl);
-	} else {
-		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
-		if (!bf) {
-			if (txctl->paprd)
-				dev_kfree_skb_any(skb);
-			else
-				ieee80211_free_txskb(sc->hw, skb);
-			return;
-		}
-
-		bf->bf_state.bfs_paprd = txctl->paprd;
-
-		if (txctl->paprd)
-			bf->bf_state.bfs_paprd_timestamp = jiffies;
-
-		ath_tx_send_normal(sc, txctl->txq, tid, skb);
-	}
-}
-
 /* Upon failure caller should free skb */
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
@@ -1945,8 +1902,11 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
+	struct ath_atx_tid *tid = NULL;
+	struct ath_buf *bf;
 	int padpos, padsize;
 	int frmlen = skb->len + FCS_LEN;
+	u8 tidno;
 	int q;
 
 	/* NOTE:  sta can be NULL according to net/mac80211.h */
@@ -2002,8 +1962,40 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
-	ath_tx_start_dma(sc, skb, txctl);
+	if (txctl->an && ieee80211_is_data_qos(hdr->frame_control)) {
+		tidno = ieee80211_get_qos_ctl(hdr)[0] &
+			IEEE80211_QOS_CTL_TID_MASK;
+		tid = ATH_AN_2_TID(txctl->an, tidno);
+
+		WARN_ON(tid->ac->txq != txctl->txq);
+	}
+
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
+		/*
+		 * Try aggregation if it's a unicast data frame
+		 * and the destination is HT capable.
+		 */
+		ath_tx_send_ampdu(sc, tid, skb, txctl);
+		goto out;
+	}
+
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	if (!bf) {
+		if (txctl->paprd)
+			dev_kfree_skb_any(skb);
+		else
+			ieee80211_free_txskb(sc->hw, skb);
+		goto out;
+	}
+
+	bf->bf_state.bfs_paprd = txctl->paprd;
+
+	if (txctl->paprd)
+		bf->bf_state.bfs_paprd_timestamp = jiffies;
+
+	ath_tx_send_normal(sc, txctl->txq, tid, skb);
 
+out:
 	ath_txq_unlock(sc, txq);
 
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
