Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3EXU2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:28:49 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:40700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3EXU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:28:48 -0400
Message-ID: <1369427323.8290.37.camel@jlt4.sipsolutions.net>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 24 May 2013 22:28:43 +0200
In-Reply-To: <20130522115908.GA22547@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	 <20130506123805.GA1602@redhat.com>
	 <20130506083759.556dac76@chukar.edge2.net>
	 <20130506153044.GB1602@redhat.com>
	 <1367854279.8434.13.camel@jlt4.sipsolutions.net>
	 <1367855046.8434.16.camel@jlt4.sipsolutions.net>
	 <20130507084241.GA1581@redhat.com>
	 <1367934810.8328.30.camel@jlt4.sipsolutions.net>
	 <20130507153525.GB1576@redhat.com> <20130522115908.GA22547@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 13:59 +0200, Stanislaw Gruszka wrote:

> > AFICT, we wake queues only if beacon arrives or mac80211 call drv_config
> > with BSS_CHANGED_IDLE. I'm not sure if the latter prevent stuck. 
> 
> It should prevent stuck. When we fail to auth, drv_config() with BSS_CHANGED_IDLE
> is called via:
> 
> ieee80211_destroy_auth_data ->
> ieee80211_vif_release_channel ->
> __ieee80211_vif_release_channel ->
> ieee80211_unassign_vif_chanctx ->
> ieee80211_bss_info_change_notify
> 
> But there is need to have ->vif.chanctx_conf valid in 
> __ieee80211_vif_release_channel(), where is below condition:
> 
>         conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
>                                          lockdep_is_held(&local->chanctx_mtx));
>         if (!conf)
>                 return;
> 
> I'm not sure if that always happen. Perhaps would be better to change
> BSS_CHANGED_IDLE to BSS_CHANGED_BSSID, which is called directly from
> ieee80211_destroy_auth_data() ?

I don't think the "!conf" can hit in this case, since to even try to
associate you have to have a channel context assigned.

johannes

