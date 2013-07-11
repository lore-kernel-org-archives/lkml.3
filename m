Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab3GKOhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:37:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43173 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab3GKO0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 71/98] ath9k_hw: Remove CHANNEL_CW_INT
Date: Thu, 11 Jul 2013 15:24:41 +0100
Message-Id: <1373552708-15235-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit fcb9a3de1e72cb271343aa9484a20c066b6c4eee upstream.

This flag is used for indicating channel interference and
we currently do nothing with it, so remove it.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 4 +---
 drivers/net/wireless/ath/ath9k/hw.c    | 6 ++----
 drivers/net/wireless/ath/ath9k/hw.h    | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 1e85085..7bdd726 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -369,7 +369,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	struct ieee80211_channel *c = chan->chan;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
-	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
 		ath_dbg(common, CALIBRATE,
 			"NF did not complete in calibration window\n");
@@ -384,7 +383,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		ath_dbg(common, CALIBRATE,
 			"noise floor failed detected; detected %d, threshold %d\n",
 			nf, nfThresh);
-		chan->channelFlags |= CHANNEL_CW_INT;
 	}
 
 	if (!caldata) {
@@ -410,7 +408,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 	int i, j;
 
 	ah->caldata->channel = chan->channel;
-	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
+	ah->caldata->channelFlags = chan->channelFlags;
 	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6333166..c24402b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1773,10 +1773,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		ath9k_hw_getnf(ah, ah->curchan);
 
 	ah->caldata = caldata;
-	if (caldata &&
-	    (chan->channel != caldata->channel ||
-	     (chan->channelFlags & ~CHANNEL_CW_INT) !=
-	     (caldata->channelFlags & ~CHANNEL_CW_INT))) {
+	if (caldata && (chan->channel != caldata->channel ||
+			chan->channelFlags != caldata->channelFlags)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 88295a1..d2fc9f1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -317,7 +317,6 @@ enum ath9k_int {
 	ATH9K_INT_NOCARD = 0xffffffff
 };
 
-#define CHANNEL_CW_INT    0x00002
 #define CHANNEL_CCK       0x00020
 #define CHANNEL_OFDM      0x00040
 #define CHANNEL_2GHZ      0x00080
-- 
1.8.1.2

