Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3GKOga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:36:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab3GKO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 72/98] ath9k: Fix noisefloor calibration
Date: Thu, 11 Jul 2013 15:24:42 +0100
Message-Id: <1373552708-15235-73-git-send-email-luis.henriques@canonical.com>
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

commit 696df78509d1f81b651dd98ecdc1aecab616db6b upstream.

The commits,

"ath9k: Fix regression in channelwidth switch at the same channel"
"ath9k: Fix invalid noisefloor reading due to channel update"

attempted to fix noisefloor calibration when a channel switch
happens due to HT20/HT40 bandwidth change. This is causing invalid
readings resulting in messages like:

"ath: phy16: NF[0] (-45) > MAX (-95), correcting to MAX".

This results in an incorrect noise being used initially for reporting
the signal level of received packets, until NF calibration is done
and the history buffer is updated via the ANI timer, which happens
much later.

When a bandwidth change happens, it is appropriate to reset
the internal history data for the channel. Do this correctly in the
reset() routine by checking the "chanmode" variable.

Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c24402b..a1ef2c9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1774,7 +1774,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ah->caldata = caldata;
 	if (caldata && (chan->channel != caldata->channel ||
-			chan->channelFlags != caldata->channelFlags)) {
+			chan->channelFlags != caldata->channelFlags ||
+			chan->chanmode != caldata->chanmode)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e8da084..278ce3d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1624,13 +1624,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_update_survey_stats(sc);
 		spin_unlock_irqrestore(&common->cc_lock, flags);
 
-		/*
-		 * Preserve the current channel values, before updating
-		 * the same channel
-		 */
-		if (ah->curchan && (old_pos == pos))
-			ath9k_hw_getnf(ah, ah->curchan);
-
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
 					  curchan, conf->channel_type);
 
-- 
1.8.1.2

