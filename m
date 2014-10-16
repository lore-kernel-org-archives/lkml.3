Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaJPQdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:33:13 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50433 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaJPQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:33:12 -0400
Message-ID: <1413477188.15416.10.camel@umadbro>
Subject: Re: [PATCH 1/4] mac80211: OCB mode + join and leave handling
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Thu, 16 Oct 2014 18:33:08 +0200
In-Reply-To: <1412843005.1828.14.camel@jlt4.sipsolutions.net>
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1410445822-6559-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140911_163047_025105_09D86D44) <1412843005.1828.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Johannes;
Thanks for the thorough review.

On Thu, 2014-10-09 at 10:23 +0200, Johannes Berg wrote:
> On Thu, 2014-09-11 at 16:30 +0200, Rostislav Lisovy wrote:
> > +++ b/net/mac80211/cfg.c
> > @@ -229,6 +229,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
> >  	case NUM_NL80211_IFTYPES:
> >  	case NL80211_IFTYPE_P2P_CLIENT:
> >  	case NL80211_IFTYPE_P2P_GO:
> > +	case NL80211_IFTYPE_OCB:
> >  		/* shouldn't happen */
> 
> There's no encryption in OCB at all?

As far as I know the standard 802.11* encryption is not used. The IEEE
1609 (WAVE protocol stack used in US) does define some encryption but it
is not part of the 802.11p.

> > +void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
> > +			     const u8 *bssid, const u8 *addr,
> > +			     u32 supp_rates)
> 
> Does this have to be visible outside the file? I may have missed the
> reference(s) but it seems maybe it doesn't have to.
> 

Please see below.

> > +	mutex_lock(&sdata->local->mtx);
> > +	ieee80211_vif_release_channel(sdata);
> > +	mutex_unlock(&sdata->local->mtx);
> > +
> > +	skb_queue_purge(&sdata->skb_queue);
> > +
> > +	del_timer_sync(&sdata->u.ocb.housekeeping_timer);
> 
> That might call the timer - is it safe if that happens here? Looks like
> maybe the housekeeping would still get triggered or so.

You are right. I hope the following is a reasonable solution (in form of
a patch to my previous patch; comment stolen from some prehistoric
version of mesh.c):

@@ -127,6 +127,9 @@ void ieee80211_ocb_work(struct ieee80211_sub_if_data *sdata)
        struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
        struct sta_info *sta;
 
+       if (!netif_running(sdata->dev))
+               return;
+
        sdata_lock(sdata);
 
        spin_lock_bh(&ifocb->incomplete_lock);
@@ -229,6 +232,13 @@ int ieee80211_ocb_leave(struct ieee80211_sub_if_data *sdata)
        skb_queue_purge(&sdata->skb_queue);
 
        del_timer_sync(&sdata->u.ocb.housekeeping_timer);
+       /*
+        * If the timer fired while we waited for it, it will have
+        * requeued the work. Now the work will be running again
+        * but will not rearm the timer again because it checks
+        * whether the interface is running, which, at this point,
+        * it no longer is.
+        */
 
        return 0;
 }


> > +		} else if (!multicast &&
> > +			   !ether_addr_equal(sdata->dev->dev_addr, hdr->addr1)) {
> > +			/* if we are in promisc mode we also accept
> > +			 * packets not destined for us
> > +			 */
> > +			if (!(sdata->dev->flags & IFF_PROMISC))
> > +				return false;
> > +			rx->flags &= ~IEEE80211_RX_RA_MATCH;
> > +		} else if (!rx->sta) {
> > +			int rate_idx;
> > +			if (status->flag & RX_FLAG_HT)
> > +				rate_idx = 0; /* TODO: HT rates */
> > +			else
> > +				rate_idx = status->rate_idx;
> > +			ieee80211_ocb_rx_no_sta(sdata, bssid, hdr->addr2,
> > +						BIT(rate_idx));
> > +		}
> 
> This isn't safe - ocb_rx_no_sta() used GFP_KERNEL, that's clearly not
> allowed in this context. But it does answer my previous question about
> the function being exported - I had assumed that you wouldn't call it
> here since it would be unsafe :)

A call to sta_info_alloc(sdata, addr, GFP_ATOMIC);
in ieee80211_ocb_rx_no_sta() should solve this.


I agree with all the other comments and will fix them.

Best regards;
Rostislav;

