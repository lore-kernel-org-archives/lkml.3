Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3G3O4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:56:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3G3O4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:56:03 -0400
Date: Tue, 30 Jul 2013 16:56:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] mm: memcg: do not trap chargers with full callstack
 on OOM
Message-ID: <20130730145602.GI15847@dhcp22.suse.cz>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org>
 <1374791138-15665-7-git-send-email-hannes@cmpxchg.org>
 <20130726144310.GH17761@dhcp22.suse.cz>
 <20130726212808.GD17975@cmpxchg.org>
 <20130730140913.GC15847@dhcp22.suse.cz>
 <20130730143228.GD715@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730143228.GD715@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-07-13 10:32:28, Johannes Weiner wrote:
> On Tue, Jul 30, 2013 at 04:09:13PM +0200, Michal Hocko wrote:
> > On Fri 26-07-13 17:28:09, Johannes Weiner wrote:
[...]
> > >  	} else {
> > >  		schedule();
> > > +		mem_cgroup_unmark_under_oom(memcg);
> > >  		finish_wait(&memcg_oom_waitq, &owait.wait);
> > >  	}
> > > -	spin_lock(&memcg_oom_lock);
> > > -	if (locked)
> > > -		mem_cgroup_oom_unlock(memcg);
> > > -	memcg_wakeup_oom(memcg);
> > > -	spin_unlock(&memcg_oom_lock);
> > >  
> > > -	mem_cgroup_unmark_under_oom(memcg);
> > > +	if (locked) {
> > > +		mem_cgroup_oom_unlock(memcg);
> > > +		/*
> > > +		 * There is no guarantee that a OOM-lock contender
> > > +		 * sees the wakeups triggered by the OOM kill
> > > +		 * uncharges.  Wake any sleepers explicitely.
> > > +		 */
> > > +		memcg_oom_recover(memcg);
> > 
> > This will be a noop because memcg is no longer under_oom (you wanted
> > memcg_wakeup_oom here I guess). Moreover, even the killed wouldn't wake
> > up anybody for the same reason.
> 
> Anybody entering this path will increase the under_oom counter.  The
> killer decreases it again, but everybody who is sleeping because they
> failed the trylock still hasn't unmarked the hierarchy (they call
> schedule() before unmark_under_oom()).  So we issue wakeups when there
> is somebody waiting for the lock.

True, sorry for the noise. Feel free to add

Acked-by: Michal Hocko <mhocko@suse.cz>
-- 
Michal Hocko
SUSE Labs
