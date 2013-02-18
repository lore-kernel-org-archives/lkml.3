Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3BRArr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:47:47 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:52620 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3BRArp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:47:45 -0500
MIME-Version: 1.0
In-Reply-To: <1360244680-10370-1-git-send-email-jslaby@suse.cz>
References: <1360244680-10370-1-git-send-email-jslaby@suse.cz>
Date: Mon, 18 Feb 2013 02:47:44 +0200
Message-ID: <CAFtRNNwUaGFejpGHydDKD1Sn4zLYbmAeyO5zkS7wsHFZ_2yRfA@mail.gmail.com>
Subject: Re: [PATCH] NET: ath5k, check ath5k_eeprom_mode_from_channel retval
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Jiri Slaby <jslaby@suse.cz>:
> It can, if invalid argument given, return a negative value. In that
> case we would access arrays out-of-bounds and such. Check the value
> and yell loudly if that happened as it would be a bug in the
> implementation. (Instead of silently corrupting memory.)
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c   | 4 ++++
>  drivers/net/wireless/ath/ath5k/reset.c | 2 ++
>  2 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index ab363f3..a78afa9 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1613,6 +1613,10 @@ ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
>         ah->ah_cal_mask |= AR5K_CALIBRATION_NF;
>
>         ee_mode = ath5k_eeprom_mode_from_channel(ah->ah_current_channel);
> +       if (WARN_ON(ee_mode < 0)) {
> +               ah->ah_cal_mask &= ~AR5K_CALIBRATION_NF;
> +               return;
> +       }
>
>         /* completed NF calibration, test threshold */
>         nf = ath5k_hw_read_measured_noise_floor(ah);
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index 4084b10..e2d8b2c 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -985,6 +985,8 @@ ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
>                 return;
>
>         ee_mode = ath5k_eeprom_mode_from_channel(channel);
> +       if (WARN_ON(ee_mode < 0))
> +               return;
>
>         /* Adjust power delta for channel 14 */
>         if (channel->center_freq == 2484)

int
ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
{
        switch (channel->hw_value) {
        case AR5K_MODE_11A:
                return AR5K_EEPROM_MODE_11A;
        case AR5K_MODE_11G:
                return AR5K_EEPROM_MODE_11G;
        case AR5K_MODE_11B:
                return AR5K_EEPROM_MODE_11B;
        default:
                return -1;
        }
}

I think we should just change that default to return 0 instead and add
an ATH5K_WARN there.



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
