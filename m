Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab3IHDVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56187 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab3IHDS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Helmut Schaa" <helmut.schaa@googlemail.com>,
        "Marc Kleine-Budde" <mkl@blackshift.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.265516554@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [100/121] ath9k_htc: Restore skb headroom when returning skb to
 mac80211
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -448,6 +448,7 @@ static void ath9k_htc_tx_process(struct
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

