Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab3FCQvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:51:32 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:46333 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759354Ab3FCQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:51:30 -0400
Date: Mon, 3 Jun 2013 12:51:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
Message-ID: <20130603165120.GH15576@cmpxchg.org>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601061151.GC15576@cmpxchg.org>
 <20130603163012.GA23257@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603163012.GA23257@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 06:31:34PM +0200, Michal Hocko wrote:
> On Sat 01-06-13 02:11:51, Johannes Weiner wrote:
> > @@ -2076,6 +2077,7 @@ static void memcg_wakeup_oom(struct mem_cgroup *memcg)
> >  {
> >  	/* for filtering, pass "memcg" as argument. */
> >  	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
> > +	atomic_inc(&memcg->oom_wakeups);
> >  }
> >  
> >  static void memcg_oom_recover(struct mem_cgroup *memcg)
> [...]
> > +	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
> > +	/* Only sleep if we didn't miss any wakeups since OOM */
> > +	if (atomic_read(&memcg->oom_wakeups) == current->memcg_oom.wakeups)
> > +		schedule();
> 
> On the way home it occured to me that the ordering might be wrong here.
> The wake up can be lost here.
> 					__wake_up(memcg_oom_waitq)
> 					<preempted>
> prepare_to_wait
> atomic_read(&memcg->oom_wakeups)
> 					atomic_inc(oom_wakeups)
> 
> I guess we want atomic_inc before __wake_up, right?

I think you are right, thanks for spotting this.  Will be fixed in
version 2.
