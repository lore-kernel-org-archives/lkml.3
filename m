Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaANNfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:35:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANNe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:34:59 -0500
Date: Tue, 14 Jan 2014 14:34:57 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/memcg: fix endless iteration in reclaim
Message-ID: <20140114133457.GD32227@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
 <alpine.LSU.2.11.1401131751080.2229@eggly.anvils>
 <20140114132727.GB32227@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114132727.GB32227@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-01-14 14:27:27, Michal Hocko wrote:
> On Mon 13-01-14 17:52:30, Hugh Dickins wrote:
> > On one home machine I can easily reproduce (by rmdir of memcgdir during
> > reclaim) multiple processes stuck looping forever in mem_cgroup_iter():
> > __mem_cgroup_iter_next() keeps selecting the memcg being destroyed, fails
> > to tryget it, returns NULL to mem_cgroup_iter(), which goes around again.
> 
> So you had a single memcg (without any children) and a limit-reclaim
> on it when you removed it, right? This is nasty because
> __mem_cgroup_iter_next will try to skip it but there is nothing else so
> it returns NULL. We update iter->generation++ but that doesn't help us
> as prev = NULL as this is the first iteration so
> 		if (prev && reclaim->generation != iter->generation)
> 
> break out will not help us.

And looking closer at it we even do no need to be in reclaim
for_each_mem_cgroup_tree is used from more places and that might race as
well.

> You patch will surely help I am just not
> sure it is the right thing to do. Let me think about this.
> 
> Anyway very well spotted!
> 
> > It's better to err on the side of leaving the loop too soon than never
> > when such races occur: once we've served prev (using root if none),
> > get out the next time __mem_cgroup_iter_next() cannot deliver.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> > Securing the tree iterator against such races is difficult, I've
> > certainly got it wrong myself before.  Although the bug is real, and
> > deserves a Cc stable, you may want to play around with other solutions
> > before committing to this one.  The current iterator goes back to v3.12:
> > I'm really not sure if v3.11 was good or not - I never saw the problem
> > in the vanilla kernel, but with Google mods in we also had to make an
> > adjustment, there to stop __mem_cgroup_iter() being called endlessly
> > from the reclaim level.
> > 
> >  mm/memcontrol.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > --- mmotm/mm/memcontrol.c	2014-01-10 18:25:02.236448954 -0800
> > +++ linux/mm/memcontrol.c	2014-01-12 22:21:10.700570471 -0800
> > @@ -1254,8 +1252,11 @@ struct mem_cgroup *mem_cgroup_iter(struc
> >  				reclaim->generation = iter->generation;
> >  		}
> >  
> > -		if (prev && !memcg)
> > +		if (!memcg) {
> > +			if (!prev)
> > +				memcg = root;
> >  			goto out_unlock;
> > +		}
> >  	}
> >  out_unlock:
> >  	rcu_read_unlock();
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
