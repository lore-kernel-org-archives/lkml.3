Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaBKKWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:22:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbaBKKWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:22:41 -0500
Date: Tue, 11 Feb 2014 11:22:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: change oom_info_lock to mutex
Message-ID: <20140211102238.GB11946@dhcp22.suse.cz>
References: <1392040082-14303-1-git-send-email-mhocko@suse.cz>
 <alpine.DEB.2.02.1402101339580.15624@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402101339580.15624@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-02-14 13:40:55, David Rientjes wrote:
> On Mon, 10 Feb 2014, Michal Hocko wrote:
> 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 19d5d4274e22..55e6731ebcd5 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1687,7 +1687,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> >  	 * protects memcg_name and makes sure that parallel ooms do not
> >  	 * interleave
> >  	 */
> > -	static DEFINE_SPINLOCK(oom_info_lock);
> > +	static DEFINE_MUTEX(oom_info_lock);
> >  	struct cgroup *task_cgrp;
> >  	struct cgroup *mem_cgrp;
> >  	static char memcg_name[PATH_MAX];
> > @@ -1698,7 +1698,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> >  	if (!p)
> >  		return;
> >  
> > -	spin_lock(&oom_info_lock);
> > +	mutex_lock(&oom_info_lock);
> >  	rcu_read_lock();
> >  
> >  	mem_cgrp = memcg->css.cgroup;
> > @@ -1767,7 +1767,7 @@ done:
> >  
> >  		pr_cont("\n");
> >  	}
> > -	spin_unlock(&oom_info_lock);
> > +	mutex_unlock(&oom_info_lock);
> >  }
> >  
> >  /*
> 
> Can we change oom_info_lock() to only protecting memcg_name and forget 
> about interleaving the hierarchical memcg stats instead?

Why? Is mutex or holding it for the whole mem_cgroup_print_oom_info a
big deal? I think that having clear oom report is really worth it.

-- 
Michal Hocko
SUSE Labs
