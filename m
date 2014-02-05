Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaBEQ3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:29:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaBEQ3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:29:43 -0500
Date: Wed, 5 Feb 2014 17:29:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH -v2 4/6] memcg: make sure that memcg is not offline when
 charging
Message-ID: <20140205162941.GF2425@dhcp22.suse.cz>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-5-git-send-email-mhocko@suse.cz>
 <20140204162939.GP6963@cmpxchg.org>
 <20140205133834.GB2425@dhcp22.suse.cz>
 <20140205152821.GY6963@cmpxchg.org>
 <20140205161940.GE2425@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205161940.GE2425@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-02-14 17:19:40, Michal Hocko wrote:
> On Wed 05-02-14 10:28:21, Johannes Weiner wrote:
[...]
> > I thought more about this and talked to Tejun as well.  He told me
> > that the rcu grace period between disabling tryget and calling
> > css_offline() is currently an implementation detail of the refcounter
> > that css uses, but it's not a guarantee.  So my initial idea of
> > reworking memcg to do css_tryget() and res_counter_charge() in the
> > same rcu section is no longer enough to synchronize against offlining.
> > We can forget about that.
> > 
> > On the other hand, memcg holds a css reference only while an actual
> > controller reference is being established (res_counter_charge), then
> > drops it.  This means that once css_tryget() is disabled, we only need
> > to wait for the css refcounter to hit 0 to know for sure that no new
> > charges can show up and reparent_charges() is safe to run, right?
> > 
> > Well, css_free() is the callback invoked when the ref counter hits 0,
> > and that is a guarantee.  From a memcg perspective, it's the right
> > place to do reparenting, not css_offline().
> 
> OK, it seems I've totally misunderstood what is the purpose of
> css_offline. My understanding was that any attempt to css_tryget will
> fail when css_offline starts. I will read through Tejun's email as well
> and think about it some more.

OK, so css_tryget fails at the time of css_offline but there is no rcu
guarantee which we rely on. This means that css_offline is of very
limitted use for us. Pages which are swapped out are not reachable for
reparent and so we still might have a lot of references to css. Whether
it makes much sense to call reparent only for the swapcache is
questionable. We are still relying on some task to release that memory
while it lives in other memcg.
-- 
Michal Hocko
SUSE Labs
