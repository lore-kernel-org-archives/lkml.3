Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3J3Lvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:51:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34979 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3J3Lvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:51:50 -0400
Date: Wed, 30 Oct 2013 12:51:48 +0100
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
Subject: Re: [PATCH 11/16] wl1251: enable tx path in monitor mode if
 necessary for packet injection
Message-ID: <20131030115148.GE8763@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1382819655-30430-12-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382819655-30430-12-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> If necessary enable the tx path in monitor mode for packet injection using
> the JOIN command with BSS_TYPE_STA_BSS and zero BSSID.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> ---
>  drivers/net/wireless/ti/wl1251/main.c   |    5 +++++
>  drivers/net/wireless/ti/wl1251/tx.c     |   17 +++++++++++++++++
>  drivers/net/wireless/ti/wl1251/wl1251.h |    1 +
>  3 files changed, 23 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
> diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
> index 3cc82fd..1de4ccb 100644
> --- a/drivers/net/wireless/ti/wl1251/tx.c
> +++ b/drivers/net/wireless/ti/wl1251/tx.c
> @@ -28,6 +28,7 @@
>  #include "tx.h"
>  #include "ps.h"
>  #include "io.h"
> +#include "event.h"
>  
>  static bool wl1251_tx_double_buffer_busy(struct wl1251 *wl, u32 data_out_count)
>  {
> @@ -298,6 +299,22 @@ static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff *skb)
>  		}
>  	}
>  
> +	/* Enable tx path in monitor mode for packet injection */
> +	if ((wl->vif == NULL) && !wl->joined) {
> +		ret = wl1251_cmd_join(wl, BSS_TYPE_STA_BSS, wl->channel,
> +				      wl->beacon_int, wl->dtim_period);
> +		if (ret < 0)
> +			wl1251_warning("join failed");
> +		else {
> +			ret = wl1251_event_wait(wl, JOIN_EVENT_COMPLETE_ID,
> +						100);
> +			if (ret < 0)
> +				wl1251_warning("join timeout");
> +			else
> +				wl->joined = true;
> +		}
> +	}

Create function enable_tx_for_packet_injection() and then just return
so that you don't have to nest ifs?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
