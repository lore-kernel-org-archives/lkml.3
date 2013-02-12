Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab3BLQh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:37:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab3BLQh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:37:58 -0500
Date: Tue, 12 Feb 2013 17:37:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130212163756.GK4863@dhcp22.suse.cz>
References: <20130211175619.GC13218@cmpxchg.org>
 <20130211192929.GB29000@dhcp22.suse.cz>
 <20130211195824.GB15951@cmpxchg.org>
 <20130211212756.GC29000@dhcp22.suse.cz>
 <20130211223943.GC15951@cmpxchg.org>
 <20130212095419.GB4863@dhcp22.suse.cz>
 <20130212151002.GD15951@cmpxchg.org>
 <20130212154330.GG4863@dhcp22.suse.cz>
 <20130212161332.GI4863@dhcp22.suse.cz>
 <20130212162442.GJ4863@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212162442.GJ4863@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-02-13 17:24:42, Michal Hocko wrote:
> On Tue 12-02-13 17:13:32, Michal Hocko wrote:
> > On Tue 12-02-13 16:43:30, Michal Hocko wrote:
> > [...]
> > The example was not complete:
> > 
> > > Wait a moment. But what prevents from the following race?
> > > 
> > > rcu_read_lock()
> > 
> > cgroup_next_descendant_pre
> > css_tryget(css);
> > memcg = mem_cgroup_from_css(css)		atomic_add(CSS_DEACT_BIAS, &css->refcnt)
> > 
> > > 						mem_cgroup_css_offline(memcg)
> > 
> > We should be safe if we did synchronize_rcu() before root->dead_count++,
> > no?
> > Because then we would have a guarantee that if css_tryget(memcg)
> > suceeded then we wouldn't race with dead_count++ it triggered.
> > 
> > > 						root->dead_count++
> > > iter->last_dead_count = root->dead_count
> > > iter->last_visited = memcg
> > > 						// final
> > > 						css_put(memcg);
> > > // last_visited is still valid
> > > rcu_read_unlock()
> > > [...]
> > > // next iteration
> > > rcu_read_lock()
> > > iter->last_dead_count == root->dead_count
> > > // KABOOM
> 
> Ohh I have missed that we took a reference on the current memcg which
> will be stored into last_visited. And then later, during the next
> iteration it will be still alive until we are done because previous
> patch moved css_put to the very end.

And that wouldn't help because:
css_tryget(memcg) // OK
                                                CSS_DEACT_BIAS
                                                root->dead_count++
iter->last_visited = memcg
iter->last_dead_count = root->dead_count
prev = memcg                                    css_put(memcg)

memcg_iter_break
  css_put(memcg) // it will released

//new iteration
iter->last_dead_count == root->dead_count //ok
css_tryget() // KABOOM because css is already gone

Bit I still might be missing something and need to get back to this with
a clean head.

Sorry about the spam
-- 
Michal Hocko
SUSE Labs
