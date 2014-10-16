Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaJPRUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:20:11 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43145 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaJPRUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:20:08 -0400
Message-ID: <1413480005.16330.15.camel@umadbro>
Subject: Re: [PATCH 1/4] mac80211: OCB mode + join and leave handling
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Thu, 16 Oct 2014 19:20:05 +0200
In-Reply-To: <1413477188.15416.10.camel@umadbro>
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1410445822-6559-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140911_163047_025105_09D86D44) <1412843005.1828.14.camel@jlt4.sipsolutions.net>
	 <1413477188.15416.10.camel@umadbro>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 18:33 +0200, Rostislav Lisovy wrote:
> > > +   mutex_lock(&sdata->local->mtx);
> > > +   ieee80211_vif_release_channel(sdata);
> > > +   mutex_unlock(&sdata->local->mtx);
> > > +
> > > +   skb_queue_purge(&sdata->skb_queue);
> > > +
> > > +   del_timer_sync(&sdata->u.ocb.housekeeping_timer);
> > 
> > That might call the timer - is it safe if that happens here? Looks like
> > maybe the housekeeping would still get triggered or so.
> 
> You are right. I hope the following is a reasonable solution (in form of
> a patch to my previous patch; comment stolen from some prehistoric
> version of mesh.c):
> 
> @@ -127,6 +127,9 @@ void ieee80211_ocb_work(struct ieee80211_sub_if_data *sdata)
>         struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
>         struct sta_info *sta;
>  
> +       if (!netif_running(sdata->dev))
> +               return;
> +
>         sdata_lock(sdata);
>  
>         spin_lock_bh(&ifocb->incomplete_lock);
> @@ -229,6 +232,13 @@ int ieee80211_ocb_leave(struct ieee80211_sub_if_data *sdata)
>         skb_queue_purge(&sdata->skb_queue);
>  
>         del_timer_sync(&sdata->u.ocb.housekeeping_timer);
> +       /*
> +        * If the timer fired while we waited for it, it will have
> +        * requeued the work. Now the work will be running again
> +        * but will not rearm the timer again because it checks
> +        * whether the interface is running, which, at this point,
> +        * it no longer is.
> +        */
>  
>         return 0;
>  }

Now I realized it is not that easy (and I confused "interface running"
and being "connected to the network"). There seems not to be a solid
indication that we are no longer "connected" to the network.
I think a field
	enum {
		IEEE80211_OCB_STOPPED,
		IEEE80211_OCB_JOINED,
	} state;
in struct ieee80211_if_ocb seems to be appropriate.

Best regards;
Rostislav

