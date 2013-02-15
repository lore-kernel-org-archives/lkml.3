Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3BOIUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:20:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59501 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3BOIUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:20:04 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <511DEF94.1080709@jp.fujitsu.com>
Date: Fri, 15 Feb 2013 17:19:32 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3/6] memcg: relax memcg iter caching
References: <1360848396-16564-1-git-send-email-mhocko@suse.cz> <1360848396-16564-4-git-send-email-mhocko@suse.cz>
In-Reply-To: <1360848396-16564-4-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/02/14 22:26), Michal Hocko wrote:
> Now that per-node-zone-priority iterator caches memory cgroups rather
> than their css ids we have to be careful and remove them from the
> iterator when they are on the way out otherwise they might live for
> unbounded amount of time even though their group is already gone (until
> the global/targeted reclaim triggers the zone under priority to find out
> the group is dead and let it to find the final rest).
> 
> We can fix this issue by relaxing rules for the last_visited memcg.
> Instead of taking a reference to the css before it is stored into
> iter->last_visited we can just store its pointer and track the number of
> removed groups from each memcg's subhierarchy.
> 
> This number would be stored into iterator everytime when a memcg is
> cached. If the iter count doesn't match the curent walker root's one we
> will start from the root again. The group counter is incremented upwards
> the hierarchy every time a group is removed.
> 
> The iter_lock can be dropped because racing iterators cannot leak
> the reference anymore as the reference count is not elevated for
> last_visited when it is cached.
> 
> Locking rules got a bit complicated by this change though. The iterator
> primarily relies on rcu read lock which makes sure that once we see
> a valid last_visited pointer then it will be valid for the whole RCU
> walk. smp_rmb makes sure that dead_count is read before last_visited
> and last_dead_count while smp_wmb makes sure that last_visited is
> updated before last_dead_count so the up-to-date last_dead_count cannot
> point to an outdated last_visited. css_tryget then makes sure that
> the last_visited is still alive in case the iteration races with the
> cached group removal (css is invalidated before mem_cgroup_css_offline
> increments dead_count).
> 
> In short:
> mem_cgroup_iter
>   rcu_read_lock()
>   dead_count = atomic_read(parent->dead_count)
>   smp_rmb()
>   if (dead_count != iter->last_dead_count)
>   	last_visited POSSIBLY INVALID -> last_visited = NULL
>   if (!css_tryget(iter->last_visited))
>   	last_visited DEAD -> last_visited = NULL
>   next = find_next(last_visited)
>   css_tryget(next)
>   css_put(last_visited) 	// css would be invalidated and parent->dead_count
>   			// incremented if this was the last reference
>   iter->last_visited = next
>   smp_wmb()
>   iter->last_dead_count = dead_count
>   rcu_read_unlock()
> 
> cgroup_rmdir
>   cgroup_destroy_locked
>    atomic_add(CSS_DEACT_BIAS, &css->refcnt) // subsequent css_tryget fail
>     mem_cgroup_css_offline
>      mem_cgroup_invalidate_reclaim_iterators
>       while(parent = parent_mem_cgroup)
>       	atomic_inc(parent->dead_count)
>    css_put(css) // last reference held by cgroup core
> 
> Spotted-by: Ying Han <yinghan@google.com>
> Original-idea-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

interesting. Thank you for your hard works.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


