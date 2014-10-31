Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaJaNOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:14:06 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:51816 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667AbaJaNOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:03 -0400
Message-ID: <1414761237.3014.27.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/2] cfg80211: 802.11p OCB mode handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Fri, 31 Oct 2014 14:13:57 +0100
In-Reply-To: <1414665771-8371-2-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20141030_114322_295525_C7C629F8)
References: <1414665771-8371-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1414665771-8371-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141030_114322_295525_C7C629F8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 11:42 +0100, Rostislav Lisovy wrote:

> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -263,6 +263,7 @@ struct ieee80211_vif_chanctx_switch {
>   * @BSS_CHANGED_BANDWIDTH: The bandwidth used by this interface changed,
>   *	note that this is only called when it changes after the channel
>   *	context had been assigned.
> + * @BSS_CHANGED_OCB: OCB join status changed
>   */
>  enum ieee80211_bss_change {
>  	BSS_CHANGED_ASSOC		= 1<<0,
> @@ -287,6 +288,7 @@ enum ieee80211_bss_change {
>  	BSS_CHANGED_P2P_PS		= 1<<19,
>  	BSS_CHANGED_BEACON_INFO		= 1<<20,
>  	BSS_CHANGED_BANDWIDTH		= 1<<21,
> +	BSS_CHANGED_OCB			= 1<<22,

This should be in the mac80211 patch.
 
> +	NL80211_CMD_JOIN_OCB,
> +	NL80211_CMD_LEAVE_OCB,
>  	/* add new commands above here */

please leave a blank line before the comment

> @@ -2093,6 +2102,7 @@ enum nl80211_iftype {
>  	NL80211_IFTYPE_P2P_CLIENT,
>  	NL80211_IFTYPE_P2P_GO,
>  	NL80211_IFTYPE_P2P_DEVICE,
> +	NL80211_IFTYPE_OCB,

This is causing a bunch of compiler warnings (warning: enumeration value
‘NL80211_IFTYPE_OCB’ not handled in switch, e.g. in mac80211/iface.c)
which I think you should address in this patch. That'll mean that you
modify even mac80211 and potentially some drivers, but I think that's
the right thing to do in this patch since it's the one changing the API
to introduce the new value.

The later patch can then add functionality to those new case labels in
mac80211 (this one of course adds it in cfg80211). For this patch they
should be with the error case that will typically exist.

> +static int nl80211_join_ocb(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	struct ocb_setup setup = {};
> +	int err;
> +
> +	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
> +		return -EINVAL;

This check isn't necessary,

> +	err = nl80211_parse_chandef(rdev, info, &setup.chandef);
> +	if (err)
> +		return err;

it's also done in this function.

I think there's one thing you forgot in this patch, namely
__cfg80211_leave() which you also need to make the __ version of the
leave function non-static for due to locking.

I noticed that the switch statement there has a default case - I'll
remove that, so be sure to rebase on mac80211-next.

johannes

