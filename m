Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3BSNgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:36:19 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56946 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3BSNgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:36:17 -0500
Message-ID: <51237FC7.3070509@suse.cz>
Date: Tue, 19 Feb 2013 14:36:07 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>, Jiri Slaby <jirislaby@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [PATCH] NET: ath5k, check ath5k_eeprom_mode_from_channel retval
References: <1360244680-10370-1-git-send-email-jslaby@suse.cz> <CAFtRNNwUaGFejpGHydDKD1Sn4zLYbmAeyO5zkS7wsHFZ_2yRfA@mail.gmail.com>
In-Reply-To: <CAFtRNNwUaGFejpGHydDKD1Sn4zLYbmAeyO5zkS7wsHFZ_2yRfA@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/mixed;
 boundary="------------040609090703070509000205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040609090703070509000205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/18/2013 01:47 AM, Nick Kossifidis wrote:
> int
> ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
> {
>         switch (channel->hw_value) {
>         case AR5K_MODE_11A:
>                 return AR5K_EEPROM_MODE_11A;
>         case AR5K_MODE_11G:
>                 return AR5K_EEPROM_MODE_11G;
>         case AR5K_MODE_11B:
>                 return AR5K_EEPROM_MODE_11B;
>         default:
>                 return -1;
>         }
> }
> 
> I think we should just change that default to return 0 instead and add
> an ATH5K_WARN there.

Something like the attached patch? It needs ah to be propagated to
eeprom. If you are fine with that, I'll send it as patch...

thanks,
-- 
js
suse labs

--------------040609090703070509000205
Content-Type: text/x-patch;
 name="0001-ath5k-cleanup-channel-to-eprom_mode-function.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-ath5k-cleanup-channel-to-eprom_mode-function.patch"

>From 0e75c33da1f8b35ff1d25f08650e95fc97c01528 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Tue, 19 Feb 2013 14:31:13 +0100
Subject: [PATCH] ath5k: cleanup channel to eprom_mode function

Stop returning negative values from ath5k_eeprom_mode_from_channel.
Warn about that case instead and return the default/0/A. This cleans
up the callers, but needs to pass ah down to
ath5k_eeprom_mode_from_channel for ATH5K_WARN.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |  6 ++++--
 drivers/net/wireless/ath/ath5k/eeprom.h |  5 ++++-
 drivers/net/wireless/ath/ath5k/phy.c    | 20 +++-----------------
 drivers/net/wireless/ath/ath5k/reset.c  |  4 +---
 4 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index b7e0258..94d34ee 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1779,7 +1779,8 @@ ath5k_eeprom_detach(struct ath5k_hw *ah)
 }
 
 int
-ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
+ath5k_eeprom_mode_from_channel(struct ath5k_hw *ah,
+		struct ieee80211_channel *channel)
 {
 	switch (channel->hw_value) {
 	case AR5K_MODE_11A:
@@ -1789,6 +1790,7 @@ ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
 	case AR5K_MODE_11B:
 		return AR5K_EEPROM_MODE_11B;
 	default:
-		return -1;
+		ATH5K_WARN(ah, "channel is not A/B/G!");
+		return AR5K_EEPROM_MODE_11A;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 94a9bbe..dcc3e40 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -494,5 +494,8 @@ struct ath5k_eeprom_info {
 	u32	ee_antenna[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
 };
 
+struct ath5k_hw;
+
 int
-ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel);
+ath5k_eeprom_mode_from_channel(struct ath5k_hw *ah,
+		struct ieee80211_channel *channel);
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index a78afa9..d6bc7cb 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1612,11 +1612,7 @@ ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 
 	ah->ah_cal_mask |= AR5K_CALIBRATION_NF;
 
-	ee_mode = ath5k_eeprom_mode_from_channel(ah->ah_current_channel);
-	if (WARN_ON(ee_mode < 0)) {
-		ah->ah_cal_mask &= ~AR5K_CALIBRATION_NF;
-		return;
-	}
+	ee_mode = ath5k_eeprom_mode_from_channel(ah, ah->ah_current_channel);
 
 	/* completed NF calibration, test threshold */
 	nf = ath5k_hw_read_measured_noise_floor(ah);
@@ -2317,12 +2313,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 
 	def_ant = ah->ah_def_ant;
 
-	ee_mode = ath5k_eeprom_mode_from_channel(channel);
-	if (ee_mode < 0) {
-		ATH5K_ERR(ah,
-			"invalid channel: %d\n", channel->center_freq);
-		return;
-	}
+	ee_mode = ath5k_eeprom_mode_from_channel(ah, channel);
 
 	switch (ant_mode) {
 	case AR5K_ANTMODE_DEFAULT:
@@ -3622,12 +3613,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		return -EINVAL;
 	}
 
-	ee_mode = ath5k_eeprom_mode_from_channel(channel);
-	if (ee_mode < 0) {
-		ATH5K_ERR(ah,
-			"invalid channel: %d\n", channel->center_freq);
-		return -EINVAL;
-	}
+	ee_mode = ath5k_eeprom_mode_from_channel(ah, channel);
 
 	/* Initialize TX power table */
 	switch (ah->ah_radio) {
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index e2d8b2c..a3399c4 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -984,9 +984,7 @@ ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 	if (ah->ah_version == AR5K_AR5210)
 		return;
 
-	ee_mode = ath5k_eeprom_mode_from_channel(channel);
-	if (WARN_ON(ee_mode < 0))
-		return;
+	ee_mode = ath5k_eeprom_mode_from_channel(ah, channel);
 
 	/* Adjust power delta for channel 14 */
 	if (channel->center_freq == 2484)
-- 
1.8.1.2


--------------040609090703070509000205--
