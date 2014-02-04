Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791AbaBDVpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:45:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934433AbaBDVLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.13 048/140] ath9k: Use correct channel for RX packets
Date: Tue,  4 Feb 2014 13:10:35 -0800
Message-Id: <20140204211038.330975926@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit ff9a93f2ebb88ac7aab9568de80b64b92078e96d upstream.

Accessing the current channel definition in mac80211
when processing RX packets is problematic because it
could have been updated when a scan is issued. Since a
channel change involves flushing the existing packets
in the RX queue before a chip-reset is done, they would
be processed using the wrong band/channel information.

To avoid this, use the current channel information
maintained in the driver.

Reported-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/recv.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -851,20 +851,15 @@ static int ath9k_process_rate(struct ath
 	enum ieee80211_band band;
 	unsigned int i = 0;
 	struct ath_softc __maybe_unused *sc = common->priv;
+	struct ath_hw *ah = sc->sc_ah;
 
-	band = hw->conf.chandef.chan->band;
+	band = ah->curchan->chan->band;
 	sband = hw->wiphy->bands[band];
 
-	switch (hw->conf.chandef.width) {
-	case NL80211_CHAN_WIDTH_5:
+	if (IS_CHAN_QUARTER_RATE(ah->curchan))
 		rxs->flag |= RX_FLAG_5MHZ;
-		break;
-	case NL80211_CHAN_WIDTH_10:
+	else if (IS_CHAN_HALF_RATE(ah->curchan))
 		rxs->flag |= RX_FLAG_10MHZ;
-		break;
-	default:
-		break;
-	}
 
 	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
@@ -1248,6 +1243,14 @@ static int ath9k_rx_skb_preprocess(struc
 		ath_start_rx_poll(sc, 3);
 	}
 
+	/*
+	 * This shouldn't happen, but have a safety check anyway.
+	 */
+	if (WARN_ON(!ah->curchan)) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status)) {
 		ret =-EINVAL;
 		goto exit;
@@ -1255,8 +1258,8 @@ static int ath9k_rx_skb_preprocess(struc
 
 	ath9k_process_rssi(common, hw, rx_stats, rx_status);
 
-	rx_status->band = hw->conf.chandef.chan->band;
-	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = ah->curchan->chan->band;
+	rx_status->freq = ah->curchan->chan->center_freq;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
 


