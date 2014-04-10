Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965AbaDJDXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934662AbaDJDVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 039/134] ath9k: Fix noisefloor calibration
Date: Wed,  9 Apr 2014 20:22:35 -0700
Message-Id: <20140410032305.028081840@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.c   |    3 ++-
 drivers/net/wireless/ath/ath9k/main.c |    7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1628,7 +1628,8 @@ int ath9k_hw_reset(struct ath_hw *ah, st
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
@@ -1614,13 +1614,6 @@ static int ath9k_config(struct ieee80211
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
 


