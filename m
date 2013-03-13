Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab3CMPIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:08:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMPIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:08:44 -0400
Date: Wed, 13 Mar 2013 16:08:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org
Subject: Re: [PATCH v4 -mm] rework mem_cgroup iterator
Message-ID: <20130313150835.GE13954@dhcp22.suse.cz>
References: <1360848396-16564-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360848396-16564-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
it seems that there were no other objections[1] to this version of the
patchset. Could you take it into your tree and target it for 3.10?

---
[1] The only one from Johannes (https://lkml.org/lkml/2013/2/8/379) has
been addressed

On Thu 14-02-13 14:26:30, Michal Hocko wrote:
> Hi,
> this is a fourth iteration of the patch series previously posted here:
> http://lkml.org/lkml/2013/1/3/293. I am adding Andrew to the CC as I
> feel this is getting to the acceptable state finally. It still need
> review as some things changed a lot since the last version but we are
> getting there...
> 
> The patch set tries to make mem_cgroup_iter saner in the way how it
> walks hierarchies. css->id based traversal is far from being ideal as
> it is not deterministic because it depends on the creation ordering.
> Additional to that css_id is considered a burden for cgroup maintainers
> because it is quite some code and memcg is the last user of it. After
> this series only the swap accounting uses css_id but that one will
> follow up later.
> 
> Diffstat (if we exclude removed/added comments) looks quite
> promissing. We got rid of some code:
> $ git diff mmotm... | grep -v "^[+-][[:space:]]*[/ ]\*" | diffstat
>  b/include/linux/cgroup.h |    3 ---
>  kernel/cgroup.c          |   33 ---------------------------------
>  mm/memcontrol.c          |    4 +++-
>  3 files changed, 3 insertions(+), 37 deletions(-)
> 
> The first patch is just preparatory and it changes when we release css
> of the previously returned memcg. Nothing controlversial.
> 
> The second patch is the core of the patchset and it replaces css_get_next
> based on css_id by the generic cgroup pre-order. This brings some
> chalanges for the last visited group caching during the reclaim
> (mem_cgroup_per_zone::reclaim_iter). We have to use memcg pointers
> directly now which means that we have to keep a reference to those
> groups' css to keep them alive.
> I also folded iter_lock introduced by https://lkml.org/lkml/2013/1/3/295
> in the previous version into this patch. Johannes felt the race I
> was describing should be mostly harmless and I haven't been able to
> trigger it so the lock doesn't deserve its own patch. It is still needed
> temporarily, though, because the reference counting on iter->last_visited
> depends on it. It will go away with the next patch.
> 
> The next patch fixups an unbounded cgroup removal holdoff caused
> by the elevated css refcount. The issue has been observed by
> Ying Han.  Johannes wasn't impressed by the previous version of the fix
> (https://lkml.org/lkml/2013/2/8/379) which cleaned up pending references
> during mem_cgroup_css_offline when a group is removed. He has suggested
> a different way when the iterator checks whether a cached memcg is
> still valid or no. More on that in the patch but the basic idea is that
> every memcg tracks the number removed subgroups and iterator records
> this number when a group is cached. These numbers are checked before
> iter->last_visited is about to be used and the iteration is restarted if
> it is invalid.
> 
> The fourth and fifth patches are an attempt for simplification of the
> mem_cgroup_iter. css juggling is removed and the iteration logic is
> moved to a helper so that the reference counting and iteration are
> separated.
> 
> The last patch just removes css_get_next as there is no user for it any
> longer.
> 
> I have dropped Acks from patches that needed a rework since the last
> time so please have a look at them again (especially 1-4). I hope I
> haven't screwed anything during the rebase.
> 
> My testing looked as follows:
>         A (use_hierarchy=1, limit_in_bytes=150M)
>        /|\
>       1 2 3
> 
> Children groups were created so that the number is never higher than
> 3 and their limits were random between 50-100M. Each group hosts a
> kernel build (starting with tar -xf so the tree is not shared and make
> -jNUM_CPUs/3) and terminated after random time - up to 5 minutes) and
> then it is removed.
> This should exercise both leaf and hierarchical reclaim as well as
> races with cgroup removals and debugging messages I added on top proved
> that. 100 groups were created during the test.
> 
> Shortlog says:
> Michal Hocko (6):
>       memcg: keep prev's css alive for the whole mem_cgroup_iter
>       memcg: rework mem_cgroup_iter to use cgroup iterators
>       memcg: relax memcg iter caching
>       memcg: simplify mem_cgroup_iter
>       memcg: further simplify mem_cgroup_iter
>       cgroup: remove css_get_next
> 
> Full diffstat says:
>  include/linux/cgroup.h |    7 ---
>  kernel/cgroup.c        |   49 ----------------
>  mm/memcontrol.c        |  145 ++++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 121 insertions(+), 80 deletions(-)
> 
> Any suggestions are welcome of course.
> 
> Thanks!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
