Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab3BZLOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:14:02 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37488 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3BZLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:14:00 -0500
Message-ID: <512C98E9.3040304@gmail.com>
Date: Tue, 26 Feb 2013 13:13:45 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130222 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        mcgrof@qca.qualcomm.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath5k: cleanup channel to eprom_mode function
References: <1361803008-18494-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1361803008-18494-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Feb 25 16:36:48 2013, Jiri Slaby wrote:
> Stop returning negative values from ath5k_eeprom_mode_from_channel.
> Yell loudly about that case in that function instead and return the
> default/zero/mode A. This cleans up the callers, but needs to pass ah
> down to ath5k_eeprom_mode_from_channel for ATH5K_WARN. For that
> purpose we also need the declaration to be moved to ath5k.h.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h  |  3 ++-
>  drivers/net/wireless/ath/ath5k/eeprom.c |  6 ++++--
>  drivers/net/wireless/ath/ath5k/eeprom.h |  3 ---
>  drivers/net/wireless/ath/ath5k/phy.c    | 20 +++-----------------
>  drivers/net/wireless/ath/ath5k/reset.c  |  4 +---
>  5 files changed, 10 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index 3150def..2d691b8 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1523,7 +1523,8 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah);
>  /* EEPROM access functions */
>  int ath5k_eeprom_init(struct ath5k_hw *ah);
>  void ath5k_eeprom_detach(struct ath5k_hw *ah);
> -
> +int ath5k_eeprom_mode_from_channel(struct ath5k_hw *ah,
> +		struct ieee80211_channel *channel);
>
>  /* Protocol Control Unit Functions */
>  /* Helpers */
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
> index b7e0258..94d34ee 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.c
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.c
> @@ -1779,7 +1779,8 @@ ath5k_eeprom_detach(struct ath5k_hw *ah)
>  }
>
>  int
> -ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
> +ath5k_eeprom_mode_from_channel(struct ath5k_hw *ah,
> +		struct ieee80211_channel *channel)
>  {
>  	switch (channel->hw_value) {
>  	case AR5K_MODE_11A:
> @@ -1789,6 +1790,7 @@ ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
>  	case AR5K_MODE_11B:
>  		return AR5K_EEPROM_MODE_11B;
>  	default:
> -		return -1;
> +		ATH5K_WARN(ah, "channel is not A/B/G!");
> +		return AR5K_EEPROM_MODE_11A;
>  	}
>  }
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
> index 94a9bbe..693296e 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.h
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.h
> @@ -493,6 +493,3 @@ struct ath5k_eeprom_info {
>  	/* Antenna raw switch tables */
>  	u32	ee_antenna[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
>  };
> -
> -int
> -ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel);
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index a78afa9..d6bc7cb 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1612,11 +1612,7 @@ ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
>
>  	ah->ah_cal_mask |= AR5K_CALIBRATION_NF;
>
> -	ee_mode = ath5k_eeprom_mode_from_channel(ah->ah_current_channel);
> -	if (WARN_ON(ee_mode < 0)) {
> -		ah->ah_cal_mask &= ~AR5K_CALIBRATION_NF;
> -		return;
> -	}
> +	ee_mode = ath5k_eeprom_mode_from_channel(ah, ah->ah_current_channel);
>
>  	/* completed NF calibration, test threshold */
>  	nf = ath5k_hw_read_measured_noise_floor(ah);
> @@ -2317,12 +2313,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
>
>  	def_ant = ah->ah_def_ant;
>
> -	ee_mode = ath5k_eeprom_mode_from_channel(channel);
> -	if (ee_mode < 0) {
> -		ATH5K_ERR(ah,
> -			"invalid channel: %d\n", channel->center_freq);
> -		return;
> -	}
> +	ee_mode = ath5k_eeprom_mode_from_channel(ah, channel);
>
>  	switch (ant_mode) {
>  	case AR5K_ANTMODE_DEFAULT:
> @@ -3622,12 +3613,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>  		return -EINVAL;
>  	}
>
> -	ee_mode = ath5k_eeprom_mode_from_channel(channel);
> -	if (ee_mode < 0) {
> -		ATH5K_ERR(ah,
> -			"invalid channel: %d\n", channel->center_freq);
> -		return -EINVAL;
> -	}
> +	ee_mode = ath5k_eeprom_mode_from_channel(ah, channel);
>
>  	/* Initialize TX power table */
>  	switch (ah->ah_radio) {
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index e2d8b2c..a3399c4 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -984,9 +984,7 @@ ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
>  	if (ah->ah_version == AR5K_AR5210)
>  		return;
>
> -	ee_mode = ath5k_eeprom_mode_from_channel(channel);
> -	if (WARN_ON(ee_mode < 0))
> -		return;
> +	ee_mode = ath5k_eeprom_mode_from_channel(ah, channel);
>
>  	/* Adjust power delta for channel 14 */
>  	if (channel->center_freq == 2484)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>
