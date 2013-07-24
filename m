Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3GXOKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45726 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963Ab3GXOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>,
        "Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.422638669@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [19/85] ath9k: Fix noisefloor calibration
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1540,7 +1540,8 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	if (caldata &&
 	    (chan->channel != caldata->channel ||
 	     (chan->channelFlags & ~CHANNEL_CW_INT) !=
-	     (caldata->channelFlags & ~CHANNEL_CW_INT))) {
+	     (caldata->channelFlags & ~CHANNEL_CW_INT) ||
+	     chan->chanmode != caldata->chanmode)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1688,13 +1688,6 @@ static int ath9k_config(struct ieee80211
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
 

