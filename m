Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab3BLPnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:43:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691Ab3BLPnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:43:33 -0500
Date: Tue, 12 Feb 2013 16:43:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130212154330.GG4863@dhcp22.suse.cz>
References: <1357235661-29564-5-git-send-email-mhocko@suse.cz>
 <20130208193318.GA15951@cmpxchg.org>
 <20130211151649.GD19922@dhcp22.suse.cz>
 <20130211175619.GC13218@cmpxchg.org>
 <20130211192929.GB29000@dhcp22.suse.cz>
 <20130211195824.GB15951@cmpxchg.org>
 <20130211212756.GC29000@dhcp22.suse.cz>
 <20130211223943.GC15951@cmpxchg.org>
 <20130212095419.GB4863@dhcp22.suse.cz>
 <20130212151002.GD15951@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212151002.GD15951@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-02-13 10:10:02, Johannes Weiner wrote:
> On Tue, Feb 12, 2013 at 10:54:19AM +0100, Michal Hocko wrote:
> > On Mon 11-02-13 17:39:43, Johannes Weiner wrote:
> > > On Mon, Feb 11, 2013 at 10:27:56PM +0100, Michal Hocko wrote:
> > > > On Mon 11-02-13 14:58:24, Johannes Weiner wrote:
> > > > > That way, if the dead count gives the go-ahead, you KNOW that the
> > > > > position cache is valid, because it has been updated first.
> > > > 
> > > > OK, you are right. We can live without css_tryget because dead_count is
> > > > either OK which means that css would be alive at least this rcu period
> > > > (and RCU walk would be safe as well) or it is incremented which means
> > > > that we have started css_offline already and then css is dead already.
> > > > So css_tryget can be dropped.
> > > 
> > > Not quite :)
> > > 
> > > The dead_count check is for completed destructions,
> > 
> > Not quite :P. dead_count is incremented in css_offline callback which is
> > called before the cgroup core releases its last reference and unlinks
> > the group from the siblinks. css_tryget would already fail at this stage
> > because CSS_DEACT_BIAS is in place at that time but this doesn't break
> > RCU walk. So I think we are safe even without css_get.
> 
> But you drop the RCU lock before you return.
>
> dead_count IS incremented for every destruction, but it's not reliable
> for concurrent ones, is what I meant.  Again, if there is a dead_count
> mismatch, your pointer might be dangling, easy case.  However, even if
> there is no mismatch, you could still race with a destruction that has
> marked the object dead, and then frees it once you drop the RCU lock,
> so you need try_get() to check if the object is dead, or you could
> return a pointer to freed or soon to be freed memory.

Wait a moment. But what prevents from the following race?

rcu_read_lock()
						mem_cgroup_css_offline(memcg)
						root->dead_count++
iter->last_dead_count = root->dead_count
iter->last_visited = memcg
						// final
						css_put(memcg);
// last_visited is still valid
rcu_read_unlock()
[...]
// next iteration
rcu_read_lock()
iter->last_dead_count == root->dead_count
// KABOOM

The race window between dead_count++ and css_put is quite big but that
is not important because that css_put can happen anytime before we start
the next iteration and take rcu_read_lock.
-- 
Michal Hocko
SUSE Labs
