Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbaFCUK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:10:58 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:60298 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933840AbaFCUK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:10:57 -0400
Message-ID: <1401826244.4157.49.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC 2/4] cfg80211: Add new interface type for OCB mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 03 Jun 2014 22:10:44 +0200
In-Reply-To: <1401468984-24575-3-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140530_185637_255661_DD2CB60E)
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1401468984-24575-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140530_185637_255661_DD2CB60E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 18:56 +0200, Rostislav Lisovy wrote:
> Add new OCB mode (outside the context of the BSS) interface
> type as well as functions necessary to configure the interface
> when 'joining' such network.

I think you also want some API to leave (stop operating in) the network
again, and call that appropriately (e.g. on ifdown) and allow userspace
to call it.

> +struct ocb_setup {
> +	struct cfg80211_chan_def chandef;
> +	u32 basic_rates;
> +};

The channel seems obvious - but basic rates? Wouldn't OCB always just
use a single rate, basically? Certainly not *basic* rates (which are
required to be implemented for joining the BSS) since there is no BSS?


> +	if (!setup->chandef.chan)
> +		WARN_ON(!setup->chandef.chan);

That makes very little sense to me?


> @@ -892,6 +893,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
>                                 *radar_detect |=
> BIT(wdev->chandef.width);
>                 }
>                 return;
> +       case NL80211_IFTYPE_OCB:
>         case NL80211_IFTYPE_MONITOR:
>         case NL80211_IFTYPE_AP_VLAN:
>         case NL80211_IFTYPE_WDS:

That certainly doesn't seem correct, in particular if you consider the
comment that's two lines down.

        case NL80211_IFTYPE_P2P_DEVICE:
                /* these interface types don't really have a channel
*/   

It seems for OCB you need some indication that it's joined (maybe the
channel being non-NULL could do?) and then treat it here correctly has
having an exclusive lock on the channel.

johannes

