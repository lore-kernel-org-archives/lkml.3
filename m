Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaJII1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:27:04 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:56950 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaJII0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:26:54 -0400
Message-ID: <1412843212.1828.17.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 3/4] cfg80211: Join and Leave handling for OCB mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Thu, 09 Oct 2014 10:26:52 +0200
In-Reply-To: <1410445822-6559-4-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140911_163049_091317_F9C6D45E)
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1410445822-6559-4-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140911_163049_091317_F9C6D45E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:30 +0200, Rostislav Lisovy wrote:
> Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>

A bit more commit log would be good :)

> +++ b/include/net/cfg80211.h
> @@ -375,6 +375,8 @@ static inline enum nl80211_channel_type
>  cfg80211_get_chandef_type(const struct cfg80211_chan_def *chandef)
>  {
>  	switch (chandef->width) {
> +	case NL80211_CHAN_WIDTH_5:
> +	case NL80211_CHAN_WIDTH_10:
>  	case NL80211_CHAN_WIDTH_20_NOHT:
>  		return NL80211_CHAN_NO_HT;

This is wrong, the old nl80211_channel_type simply cannot express a 5 or
10 MHz width - so this case should WARN() or something and really never
ever be called here.

Also, it doesn't really belong into this patch?

> +struct ocb_setup {
> +	struct cfg80211_chan_def chandef;
> +};

kernel-doc would be appreciated.

> @@ -892,6 +893,13 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
>  				*radar_detect |= BIT(wdev->chandef.width);
>  		}
>  		return;
> +	case NL80211_IFTYPE_OCB:
> +		if (wdev->chandef.chan) {
> +			*chan = wdev->chandef.chan;
> +			*chanmode = CHAN_MODE_EXCLUSIVE;
> +			return;
> +		}

same as in the mac80211 patch - I don't see why this should be
exclusive.

> +	WARN_ON(!setup->chandef.chan);

if (WARN_ON(...))
	return -EINVAL;

would be better

johannes

