Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3HMQMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:12:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab3HMP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:26 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=7Me1z757Bz4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bS3IfHRTbSsA:10 a=mK_AVkanAAAA:8 a=vmLDa1wCAAAA:8 a=eWccYnK8uHW2A70HafAA:9 a=9xyTavCNlvEA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155824.466423327@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:56:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [05/88] carl9170: fix frame drop and WARN due to minstrel_ht change
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0005-carl9170-fix-frame-drop-and-WARN-due-to-minstrel_ht-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

[ Upstream commit 5f34608fa2acbfef5a06d0072a978c9943c28a2d ]

With "mac80211/minstrel_ht: add support for using CCK rates"
minstrel_ht selects legacy CCK rates as viable rates for
outgoing frames which might be sent as part of an A-MPDU
[IEEE80211_TX_CTL_AMPDU is set].

This behavior triggered the following WARN_ON in the driver:
> WARNING: at carl9170/tx.c:995 carl9170_op_tx+0x1dd/0x6fd
The driver assumed that the rate control algorithm made a
mistake and dropped the frame.

This patch removes the noisy warning altogether and allows
said A-MPDU frames with CCK sample and/or fallback rates to
be transmitted seamlessly.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/carl9170/tx.c |   69 +++++++++++++-------------------
 1 file changed, 28 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 6a86814..745e9dd 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -387,8 +387,7 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 	u8 tid;
 
 	if (!(txinfo->flags & IEEE80211_TX_CTL_AMPDU) ||
-	    txinfo->flags & IEEE80211_TX_CTL_INJECTED ||
-	   (!(super->f.mac_control & cpu_to_le16(AR9170_TX_MAC_AGGR))))
+	    txinfo->flags & IEEE80211_TX_CTL_INJECTED)
 		return;
 
 	rcu_read_lock();
@@ -982,30 +981,6 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 		SET_VAL(CARL9170_TX_SUPER_AMPDU_FACTOR,
 			txc->s.ampdu_settings, factor);
-
-		for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
-			txrate = &info->control.rates[i];
-			if (txrate->idx >= 0) {
-				txc->s.ri[i] =
-					CARL9170_TX_SUPER_RI_AMPDU;
-
-				if (WARN_ON(!(txrate->flags &
-					      IEEE80211_TX_RC_MCS))) {
-					/*
-					 * Not sure if it's even possible
-					 * to aggregate non-ht rates with
-					 * this HW.
-					 */
-					goto err_out;
-				}
-				continue;
-			}
-
-			txrate->idx = 0;
-			txrate->count = ar->hw->max_rate_tries;
-		}
-
-		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_AGGR);
 	}
 
 	/*
@@ -1013,11 +988,31 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 	 * taken from mac_control. For all fallback rate, the firmware
 	 * updates the mac_control flags from the rate info field.
 	 */
-	for (i = 1; i < CARL9170_TX_MAX_RATES; i++) {
+	for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
+		__le32 phy_set;
 		txrate = &info->control.rates[i];
 		if (txrate->idx < 0)
 			break;
 
+		phy_set = carl9170_tx_physet(ar, info, txrate);
+		if (i == 0) {
+			/* first rate - part of the hw's frame header */
+			txc->f.phy_control = phy_set;
+
+			if (ampdu && txrate->flags & IEEE80211_TX_RC_MCS)
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_AGGR);
+			if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
+			else if (carl9170_tx_cts_check(ar, txrate))
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
+
+		} else {
+			/* fallback rates are stored in the firmware's
+			 * retry rate set array.
+			 */
+			txc->s.rr[i - 1] = phy_set;
+		}
+
 		SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[i],
 			txrate->count);
 
@@ -1028,21 +1023,13 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 			txc->s.ri[i] |= (AR9170_TX_MAC_PROT_CTS <<
 				CARL9170_TX_SUPER_RI_ERP_PROT_S);
 
-		txc->s.rr[i - 1] = carl9170_tx_physet(ar, info, txrate);
+		if (ampdu && (txrate->flags & IEEE80211_TX_RC_MCS))
+			txc->s.ri[i] |= CARL9170_TX_SUPER_RI_AMPDU;
 	}
 
-	txrate = &info->control.rates[0];
-	SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[0], txrate->count);
-
-	if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
-		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
-	else if (carl9170_tx_cts_check(ar, txrate))
-		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
-
 	txc->s.len = cpu_to_le16(skb->len);
 	txc->f.length = cpu_to_le16(len + FCS_LEN);
 	txc->f.mac_control = mac_tmp;
-	txc->f.phy_control = carl9170_tx_physet(ar, info, txrate);
 
 	arinfo = (void *)info->rate_driver_data;
 	arinfo->timeout = jiffies;
@@ -1382,9 +1369,9 @@ static void carl9170_tx(struct ar9170 *ar)
 }
 
 static bool carl9170_tx_ampdu_queue(struct ar9170 *ar,
-	struct ieee80211_sta *sta, struct sk_buff *skb)
+	struct ieee80211_sta *sta, struct sk_buff *skb,
+	struct ieee80211_tx_info *txinfo)
 {
-	struct _carl9170_tx_superframe *super = (void *) skb->data;
 	struct carl9170_sta_info *sta_info;
 	struct carl9170_sta_tid *agg;
 	struct sk_buff *iter;
@@ -1451,7 +1438,7 @@ err_unlock:
 
 err_unlock_rcu:
 	rcu_read_unlock();
-	super->f.mac_control &= ~cpu_to_le16(AR9170_TX_MAC_AGGR);
+	txinfo->flags &= ~IEEE80211_TX_CTL_AMPDU;
 	carl9170_tx_status(ar, skb, false);
 	ar->tx_dropped++;
 	return false;
@@ -1485,7 +1472,7 @@ void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		run = carl9170_tx_ampdu_queue(ar, sta, skb);
+		run = carl9170_tx_ampdu_queue(ar, sta, skb, info);
 		if (run)
 			carl9170_tx_ampdu(ar);
 
-- 
1.7.10.4


