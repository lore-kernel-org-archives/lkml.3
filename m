Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab3JWFpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:45:47 -0400
Received: from services.gouders.net ([141.101.32.176]:48638 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3JWFpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:45:46 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3.12] cfg80211: fix ibss wext chandef creation
In-Reply-To: <1382472166-19563-1-git-send-email-sw@simonwunderlich.de> (Simon
	Wunderlich's message of "Tue, 22 Oct 2013 22:02:46 +0200")
References: <1382472166-19563-1-git-send-email-sw@simonwunderlich.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Wed, 23 Oct 2013 07:46:04 +0200
Message-ID: <ghr4bcpmjn.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Wunderlich <sw@simonwunderlich.de> writes:

> The wext internal chandefs for ibss should be created using the
> cfg80211_chandef_create() functions. Otherwise the center_freq1 field
> will not be set and cfg80211_chandef_valid() will spit a warning and
> report the chandef as invalid when it should be used.

Thanks a lot, Simon, I don't see anymore traces here.

Tested-by: Dirk Gouders <dirk@gouders.net>

> Reported-by: Dirk Gouders <dirk@gouders.net>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Cc: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/ibss.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
> index 39bff7d..a710019 100644
> --- a/net/wireless/ibss.c
> +++ b/net/wireless/ibss.c
> @@ -246,7 +246,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
>  
>  	/* try to find an IBSS channel if none requested ... */
>  	if (!wdev->wext.ibss.chandef.chan) {
> -		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
> +		struct ieee80211_channel *new_chan = NULL;
>  
>  		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
>  			struct ieee80211_supported_band *sband;
> @@ -262,16 +262,19 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
>  					continue;
>  				if (chan->flags & IEEE80211_CHAN_DISABLED)
>  					continue;
> -				wdev->wext.ibss.chandef.chan = chan;
> +				new_chan = chan;
>  				break;
>  			}
>  
> -			if (wdev->wext.ibss.chandef.chan)
> +			if (new_chan)
>  				break;
>  		}
>  
> -		if (!wdev->wext.ibss.chandef.chan)
> +		if (!new_chan)
>  			return -EINVAL;
> +
> +		cfg80211_chandef_create(&wdev->wext.ibss.chandef, new_chan,
> +					NL80211_CHAN_NO_HT);
>  	}
>  
>  	/* don't join -- SSID is not there */
> @@ -345,8 +348,8 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
>  		return err;
>  
>  	if (chan) {
> -		wdev->wext.ibss.chandef.chan = chan;
> -		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
> +		cfg80211_chandef_create(&wdev->wext.ibss.chandef, chan,
> +					NL80211_CHAN_NO_HT);
>  		wdev->wext.ibss.channel_fixed = true;
>  	} else {
>  		/* cfg80211_ibss_wext_join will pick one if needed */
