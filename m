Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3IKE6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3IKE4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:46 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ZWWUZoMTopAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Emd8KNXAJSkA:10 a=mK_AVkanAAAA:8 a=WJ_HdPNrAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=9xyTavCNlvEA:10 a=faxmgylBHEMA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042934.060120249@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marc Kleine-Budde <mkl@blackshift.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [249/251] ath9k_htc: Restore skb headroom when returning skb to mac80211
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0249-ath9k_htc-Restore-skb-headroom-when-returning-skb-to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Helmut Schaa <helmut.schaa@googlemail.com>

[ Upstream commit d2e9fc141e2aa21f4b35ee27072d84e9aa6e2ba0 ]

ath9k_htc adds padding between the 802.11 header and the payload during
TX by moving the header. When handing the frame back to mac80211 for TX
status handling the header is not moved back into its original position.
This can result in a too small skb headroom when entering ath9k_htc
again (due to a soft retransmission for example) causing an
skb_under_panic oops.

Fix this by moving the 802.11 header back into its original position
before returning the frame to mac80211 as other drivers like rt2x00
or ath5k do.

Reported-by: Marc Kleine-Budde <mkl@blackshift.org>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Tested-by: Marc Kleine-Budde <mkl@blackshift.org>
Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
Cc: stable@vger.kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 47e61d0..c1289b6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -448,6 +448,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	struct ieee80211_conf *cur_conf = &priv->hw->conf;
 	bool txok;
 	int slot;
+	int hdrlen, padsize;
 
 	slot = strip_drv_header(priv, skb);
 	if (slot < 0) {
@@ -504,6 +505,15 @@ send_mac80211:
 
 	ath9k_htc_tx_clear_slot(priv, slot);
 
+	/* Remove padding before handing frame back to mac80211 */
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+
+	padsize = hdrlen & 3;
+	if (padsize && skb->len > hdrlen + padsize) {
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
 	/* Send status to mac80211 */
 	ieee80211_tx_status(priv->hw, skb);
 }
-- 
1.7.10.4


