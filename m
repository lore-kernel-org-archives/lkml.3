Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaESO5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:57:40 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:33753 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaESO5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:57:38 -0400
Message-ID: <1400511443.4273.16.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC 2/2] mac80211: Add new interface type for OCB mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 19 May 2014 16:57:23 +0200
In-Reply-To: <1400510945-24868-3-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140519_164915_803287_21439779)
References: <1400510945-24868-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1400510945-24868-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140519_164915_803287_21439779)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 16:49 +0200, Rostislav Lisovy wrote:

>  include/uapi/linux/nl80211.h |   3 ++
>  net/mac80211/Makefile        |   3 +-
>  net/mac80211/cfg.c           |   1 +
>  net/mac80211/chan.c          |   2 +
>  net/mac80211/driver-ops.h    |   3 +-
>  net/mac80211/ieee80211_i.h   |  38 ++++++++++++++
>  net/mac80211/iface.c         |  28 +++++++++++
>  net/mac80211/ocb.c           | 115 +++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/util.c          |   5 ++
>  net/wireless/util.c          |   1 +

please avoid patches that modify both cfg80211 and mac80211 unless
they're really small.

> +/**
> + * struct ieee80211_if_ocb - the specific struct for ocb-mode
> + *
> + * In this struct all ocb-specific information of an interface is stored.
> + *
> + * @timer: the timer used for all tasks in the ocb-code

Why do you need your own timer?

> + * @work: holds the workqueue

and work struct (not a workqueue - that's something entirely different)?
we have a general interface work struct.

> + * @skb_queue: holds all queued skb to be processed

Why do you need to queue SKBs?

> + * @wrkq_flags: bitmask telling what work is pending
> + * @timer_running: tells if the timer is running
> + * @bssid: holds the BSSID (IEEE802.11p defines this to be
> + *         ff:ff:ff:ff:ff:ff but this is more flexible)

Why would you ever need this flexibility? It seems pointless to prepare
for it - I'm guessing you're never going to implement it?

> @@ -622,6 +632,17 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
>  
>  		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
>  			changed |= ieee80211_reset_erp_info(sdata);
> +
> +		if (sdata->vif.type == NL80211_IFTYPE_OCB) {
> +			/* Disable beacons */
> +			sdata->vif.bss_conf.enable_beacon = false;
> +			changed |= BSS_CHANGED_BEACON;
> +
> +			/* Receive all data frames */
> +			local->fif_other_bss++;
> +			ieee80211_configure_filter(local);
> +		}

NACK. Please make a proper "join OCB" operation etc. In the wireless
stack, "ifup" shouldn't be used to start real operation.

> +/**
> + * ieee80211_ocb_housekeeping - Housekeeping function (expires stations)
> + *
> + * @sdata:
> + * @ifocb:

yes?

> + * This function is used for all periodical clean up work.
> + * It expires all stations that have not shown up for a given period of time.
> + * After all cleanups have been done it schedules the next run.
> + */
> +static void ieee80211_ocb_housekeeping(struct ieee80211_sub_if_data *sdata,
> +			   struct ieee80211_if_ocb *ifocb)
> +{
> +	ieee80211_sta_expire(sdata, IEEE80211_OCB_PEER_INACTIVITY_LIMIT);

> +	mod_timer(&ifocb->timer,
> +		  round_jiffies(jiffies + IEEE80211_OCB_HOUSEKEEPING_INTERVAL));
> +}

use a delayed work struct?

I don't even see a call to turn on the carrier?

Anyway I think you should have some OCB join method in the cfg80211 API
even if there's nothing really to do... at minimum, you need to specify
a channel somehow!

johannes

