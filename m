Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934821Ab3GWWmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:42:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259Ab3GWW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 058/103] ath9k: Fix noisefloor calibration
Date: Tue, 23 Jul 2013 15:26:09 -0700
Message-Id: <20130723220425.068125625@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.c   |    3 ++-
 drivers/net/wireless/ath/ath9k/main.c |    7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1872,7 +1872,8 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 
 	ah->caldata = caldata;
 	if (caldata && (chan->channel != caldata->channel ||
-			chan->channelFlags != caldata->channelFlags)) {
+			chan->channelFlags != caldata->channelFlags ||
+			chan->chanmode != caldata->chanmode)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1211,13 +1211,6 @@ static int ath9k_config(struct ieee80211
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
 					  curchan, channel_type);
 


