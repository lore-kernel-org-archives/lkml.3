Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaJIIXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:23:39 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:56935 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaJIIX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:23:28 -0400
Message-ID: <1412843005.1828.14.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/4] mac80211: OCB mode + join and leave handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Thu, 09 Oct 2014 10:23:25 +0200
In-Reply-To: <1410445822-6559-2-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140911_163047_025105_09D86D44)
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1410445822-6559-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140911_163047_025105_09D86D44)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:30 +0200, Rostislav Lisovy wrote:

[...]

Nice work. Let me (finally) look in more detail ...


> +++ b/include/uapi/linux/nl80211.h
> @@ -2031,6 +2031,8 @@ enum nl80211_attrs {
>   *	and therefore can't be created in the normal ways, use the
>   *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
>   *	commands to create and destroy one
> + * @NL80211_IF_TYPE_OCB: Outside Context of a BSS
> + *	this mode corresponds to the MIB variable dot11OCBActivated=true

This change should be part of the cfg80211 patch, as a consequence that
patch must come first in the series.

> +++ b/net/mac80211/cfg.c
> @@ -229,6 +229,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
>  	case NUM_NL80211_IFTYPES:
>  	case NL80211_IFTYPE_P2P_CLIENT:
>  	case NL80211_IFTYPE_P2P_GO:
> +	case NL80211_IFTYPE_OCB:
>  		/* shouldn't happen */

There's no encryption in OCB at all?

> +++ b/net/mac80211/ieee80211_i.h
> @@ -82,6 +82,8 @@ struct ieee80211_fragment_entry {
>  	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
>  };
>  
> +/* Used in OCB mode */
> +static const u8 bssid_wildcard[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };

Please don't put data into header files, it'll be duplicated all over.
You can put an extern definition here, or just static const
definition(s) where needed.
 
> +struct ieee80211_if_ocb {
> +	struct timer_list housekeeping_timer;
> +	unsigned long wrkq_flags;
> +
> +	spinlock_t incomplete_lock;
> +	struct list_head incomplete_stations;
> +};

Please add some comments explaining the purpose of the fields.

> +void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
> +			     const u8 *bssid, const u8 *addr,
> +			     u32 supp_rates)

Does this have to be visible outside the file? I may have missed the
reference(s) but it seems maybe it doesn't have to.

> +/* TODO: Almost the same as ieee80211_ibss_finish_sta()
> + *       Maybe use the same function for both?
> + */
> +static struct sta_info *ieee80211_ocb_finish_sta(struct sta_info *sta)
> +	__acquires(RCU)
> +{
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	u8 addr[ETH_ALEN];
> +
> +	ether_addr_copy(addr, sta->sta.addr);

for ether_addr_copy() you need alignment on addr:

u8 addr[ETH_ALEN] __aligned(2);

> +int ieee80211_ocb_join(struct ieee80211_sub_if_data *sdata,
> +		       struct ocb_setup *setup)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
> +	u32 changed = BSS_CHANGED_OCB;
> +	int err;
> +
> +	sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
> +	sdata->smps_mode = IEEE80211_SMPS_OFF;
> +	sdata->needed_rx_chains = sdata->local->rx_chains;
> +
> +	mutex_lock(&sdata->local->mtx);
> +	err = ieee80211_vif_use_channel(sdata, &setup->chandef,
> +					IEEE80211_CHANCTX_EXCLUSIVE);

Do you really need to use the channel context exclusively? I see no
reason for that since the channel is fixed, and doesn't change like in
IBSS, afaict? IBSS needs this, but only because it might change the
channel on the fly.

> +#if 0 /* TODO */
> +	drv_leave_ocb(local, sdata);
> +#endif

I'd just remove that for now - probably no current driver needs it?

> +	mutex_lock(&sdata->local->mtx);
> +	ieee80211_vif_release_channel(sdata);
> +	mutex_unlock(&sdata->local->mtx);
> +
> +	skb_queue_purge(&sdata->skb_queue);
> +
> +	del_timer_sync(&sdata->u.ocb.housekeeping_timer);

That might call the timer - is it safe if that happens here? Looks like
maybe the housekeeping would still get triggered or so.

> +	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
> +		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
> +						NL80211_IFTYPE_OCB);
> +		if (ieee80211_bssid_match(bssid, bssid_wildcard))
> +			sta->last_rx = jiffies;

Calling ieee80211_bssid_match() here is rather pointless - see what it
does. You really just want is_broadcast_ether_addr(bssid) instead of the
ether_addr_equal() that does exactly the same thing.

> @@ -3130,6 +3137,32 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
>  						 BIT(rate_idx));
>  		}
>  		break;
> +	case NL80211_IFTYPE_OCB:
> +		if (!bssid)
> +			return false;
> +		if (ieee80211_is_beacon(hdr->frame_control)) {
> +			return false;
> +		} else if (!ieee80211_bssid_match(bssid, bssid_wildcard)) {
> +			ocb_dbg(sdata, "BSSID mismatch in OCB mode!\n");
> +			return false;

same here.

And then I guess you don't need bssid_wildcard at all any more (see
previous comments)

> +		} else if (!multicast &&
> +			   !ether_addr_equal(sdata->dev->dev_addr, hdr->addr1)) {
> +			/* if we are in promisc mode we also accept
> +			 * packets not destined for us
> +			 */
> +			if (!(sdata->dev->flags & IFF_PROMISC))
> +				return false;
> +			rx->flags &= ~IEEE80211_RX_RA_MATCH;
> +		} else if (!rx->sta) {
> +			int rate_idx;
> +			if (status->flag & RX_FLAG_HT)
> +				rate_idx = 0; /* TODO: HT rates */
> +			else
> +				rate_idx = status->rate_idx;
> +			ieee80211_ocb_rx_no_sta(sdata, bssid, hdr->addr2,
> +						BIT(rate_idx));
> +		}

This isn't safe - ocb_rx_no_sta() used GFP_KERNEL, that's clearly not
allowed in this context. But it does answer my previous question about
the function being exported - I had assumed that you wouldn't call it
here since it would be unsafe :)

> +	case NL80211_IFTYPE_OCB:
> +		/* DA SA BSSID */
> +		memcpy(hdr.addr1, skb->data, ETH_ALEN);
> +		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
> +		memset(hdr.addr3, 0xff, ETH_ALEN);

Use eth_broadcast_addr(), which really is the same but more expressive.

johannes

