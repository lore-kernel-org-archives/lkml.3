Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaJTJk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:40:59 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:36211 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbaJTJk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:40:56 -0400
Message-ID: <1413798050.10246.8.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/4] mac80211: OCB mode + join and leave handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 20 Oct 2014 11:40:50 +0200
In-Reply-To: <1413477188.15416.10.camel@umadbro> (sfid-20141016_183311_325998_34050460)
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1410445822-6559-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140911_163047_025105_09D86D44) <1412843005.1828.14.camel@jlt4.sipsolutions.net>
	 <1413477188.15416.10.camel@umadbro> (sfid-20141016_183311_325998_34050460)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 18:33 +0200, Rostislav Lisovy wrote:

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

Not sure, it seems you should check "is it operating in OCB mode"? OTOH,
when it's not operating but still around it probably doesn't matter?

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

Well, the comment is wrong, since leave() can and will be done while the
interface is running.

> > This isn't safe - ocb_rx_no_sta() used GFP_KERNEL, that's clearly not
> > allowed in this context. But it does answer my previous question about
> > the function being exported - I had assumed that you wouldn't call it
> > here since it would be unsafe :)
> 
> A call to sta_info_alloc(sdata, addr, GFP_ATOMIC);
> in ieee80211_ocb_rx_no_sta() should solve this.

Yeah, I guess so, didn't check in detail now.

johannes

