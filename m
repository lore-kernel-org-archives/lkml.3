Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3IISpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:45:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57120 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3IISp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Marc Kleine-Budde <mkl@blackshift.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 07/24] ath9k_htc: Restore skb headroom when returning skb to mac80211
Date: Mon,  9 Sep 2013 11:44:57 -0700
Message-Id: <1378752314-2416-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helmut Schaa <helmut.schaa@googlemail.com>

commit d2e9fc141e2aa21f4b35ee27072d84e9aa6e2ba0 upstream.

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 8788621..be484b5 100644
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
1.8.1.2

