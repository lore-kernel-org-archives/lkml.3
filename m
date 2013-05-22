Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3EVL5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:57:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab3EVL53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:57:29 -0400
Date: Wed, 22 May 2013 13:59:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130522115908.GA22547@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
 <20130506123805.GA1602@redhat.com>
 <20130506083759.556dac76@chukar.edge2.net>
 <20130506153044.GB1602@redhat.com>
 <1367854279.8434.13.camel@jlt4.sipsolutions.net>
 <1367855046.8434.16.camel@jlt4.sipsolutions.net>
 <20130507084241.GA1581@redhat.com>
 <1367934810.8328.30.camel@jlt4.sipsolutions.net>
 <20130507153525.GB1576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507153525.GB1576@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 05:35:25PM +0200, Stanislaw Gruszka wrote:
> On Tue, May 07, 2013 at 03:53:30PM +0200, Johannes Berg wrote:
> > > I'm not sure if I like to add passive_no_rx to iwlegacy. Stopping queues
> > > and waiting for beacon looks sticky, what happen if beacon will not be
> > > received?
> > 
> > Good question, do we get stuck? I was assuming we'd time out, but maybe
> > that's not the case?
> 
> AFICT, we wake queues only if beacon arrives or mac80211 call drv_config
> with BSS_CHANGED_IDLE. I'm not sure if the latter prevent stuck. 

It should prevent stuck. When we fail to auth, drv_config() with BSS_CHANGED_IDLE
is called via:

ieee80211_destroy_auth_data ->
ieee80211_vif_release_channel ->
__ieee80211_vif_release_channel ->
ieee80211_unassign_vif_chanctx ->
ieee80211_bss_info_change_notify

But there is need to have ->vif.chanctx_conf valid in 
__ieee80211_vif_release_channel(), where is below condition:

        conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
                                         lockdep_is_held(&local->chanctx_mtx));
        if (!conf)
                return;

I'm not sure if that always happen. Perhaps would be better to change
BSS_CHANGED_IDLE to BSS_CHANGED_BSSID, which is called directly from
ieee80211_destroy_auth_data() ?

Stanislaw

