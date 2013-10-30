Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3J3Lql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:46:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34785 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3J3Lq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:46:29 -0400
Date: Wed, 30 Oct 2013 12:46:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 09/16] wl1251: disable power saving in monitor mode
Message-ID: <20131030114627.GC8763@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1382819655-30430-10-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382819655-30430-10-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-10-26 22:34:08, Pali Rohár wrote:
> From: David Gnedt <david.gnedt@davizone.at>
> 
> Force power saving off while monitor interface is present.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> ---
>  drivers/net/wireless/ti/wl1251/main.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
> index 727f2ee..62cb374 100644
> --- a/drivers/net/wireless/ti/wl1251/main.c
> +++ b/drivers/net/wireless/ti/wl1251/main.c
> @@ -617,7 +617,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
>  			goto out_sleep;
>  	}
>  
> -	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
> +	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested &&
> +	    !wl->monitor_present) {
>  		wl1251_debug(DEBUG_PSM, "psm enabled");
>  
>  		wl->psm_requested = true;
> @@ -633,8 +634,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
>  		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
>  		if (ret < 0)
>  			goto out_sleep;
> -	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
> -		   wl->psm_requested) {
> +	} else if ((!(conf->flags & IEEE80211_CONF_PS) || wl->monitor_present)
> +		   && wl->psm_requested) {
>  		wl1251_debug(DEBUG_PSM, "psm disabled");
>  

These boolean expressions make my head spin. Introduce helper function 

can_do_pm()... return (conf->flags & IEEE80211_CONF_PS) &&
!wl->monitor_present

?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
