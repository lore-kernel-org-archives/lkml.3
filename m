Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3KMXef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:34:35 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36921 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3KMXe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:34:29 -0500
Date: Wed, 13 Nov 2013 18:34:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add memory.oom_control notification for
 system oom
Message-ID: <20131113233419.GJ707@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 02:19:00PM -0800, David Rientjes wrote:
> On Thu, 31 Oct 2013, Johannes Weiner wrote:
> 
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -155,6 +155,7 @@ static inline bool task_in_memcg_oom(struct task_struct *p)
> > >  }
> > >  
> > >  bool mem_cgroup_oom_synchronize(bool wait);
> > > +void mem_cgroup_root_oom_notify(void);
> > >  
> > >  #ifdef CONFIG_MEMCG_SWAP
> > >  extern int do_swap_account;
> > > @@ -397,6 +398,10 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
> > >  	return false;
> > >  }
> > >  
> > > +static inline void mem_cgroup_root_oom_notify(void)
> > > +{
> > > +}
> > > +
> > >  static inline void mem_cgroup_inc_page_stat(struct page *page,
> > >  					    enum mem_cgroup_stat_index idx)
> > >  {
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5641,6 +5641,15 @@ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
> > >  		mem_cgroup_oom_notify_cb(iter);
> > >  }
> > >  
> > > +/*
> > > + * Notify any process waiting on the root memcg's memory.oom_control, but do not
> > > + * notify any child memcgs to avoid triggering their per-memcg oom handlers.
> > > + */
> > > +void mem_cgroup_root_oom_notify(void)
> > > +{
> > > +	mem_cgroup_oom_notify_cb(root_mem_cgroup);
> > > +}
> > > +
> > >  static int mem_cgroup_usage_register_event(struct cgroup_subsys_state *css,
> > >  	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
> > >  {
> > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > --- a/mm/oom_kill.c
> > > +++ b/mm/oom_kill.c
> > > @@ -632,6 +632,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
> > >  		return;
> > >  	}
> > >  
> > > +	/* Avoid waking up processes for oom kills triggered by sysrq */
> > > +	if (!force_kill)
> > > +		mem_cgroup_root_oom_notify();
> > 
> > We have an API for global OOM notifications, please just use
> > register_oom_notifier() instead.
> > 
> 
> We can't use register_oom_notifier() because we don't want to notify the 
> root memcg for a system oom handler if existing oom notifiers free memory 
> (powerpc or s390).  We also don't want to notify the root memcg when 
> current is exiting or has a pending SIGKILL, we just want to silently give 
> it access to memory reserves and exit.  The mem_cgroup_root_oom_notify() 
> here is placed correctly.

This is all handwaving.  Somebody called out_of_memory() after they
failed reclaim, the machine is OOM.  The fact that current is exiting
without requiring a kill is coincidental and irrelevant.  You want an
OOM notification, use the OOM notifiers, that's what they're for.
