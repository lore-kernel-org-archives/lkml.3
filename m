Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaAOMRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:17:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbaAOMRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:17:31 -0500
Date: Wed, 15 Jan 2014 13:17:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/memcg: fix endless iteration in reclaim
Message-ID: <20140115121728.GJ8782@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
 <alpine.LSU.2.11.1401131751080.2229@eggly.anvils>
 <20140114132727.GB32227@dhcp22.suse.cz>
 <20140114142610.GF32227@dhcp22.suse.cz>
 <alpine.LSU.2.11.1401141201120.3762@eggly.anvils>
 <20140115095829.GI8782@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115095829.GI8782@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-01-14 10:58:29, Michal Hocko wrote:
> On Tue 14-01-14 12:42:28, Hugh Dickins wrote:
> > On Tue, 14 Jan 2014, Michal Hocko wrote:
[...]
> > > Ouch. And thinking about this shows that out_css_put is broken as well
> > > for subtree walks (those that do not start at root_mem_cgroup level). We
> > > need something like the the snippet bellow.
> > 
> > It's the out_css_put precedent that I was following in not incrementing
> > for the root.  I think that's been discussed in the past, and rightly or
> > wrongly we've concluded that the caller of mem_cgroup_iter() always has
> > some hold on the root, which makes it safe to skip get/put on it here.
> > No doubt one of those many short cuts to avoid memcg overhead when
> > there's no memcg other than the root_mem_cgroup.
> 
> That might be true but I guess it makes sense to get rid of some subtle
> assumptions. Especially now that we have an effective per-cpu ref.
> counting for css.

OK, I finally found some time to think about this some more and it seems
that the issue you have reported and the above issue are in fact
identical. css reference counting optimization in fact also prevent from
the endless loop you are seeing here because we simply didn't call
css_tryget on the root...

Therefore I guess we should reintroduce the optimization. What do you
think about the following? This is on top of the current mmotm but it
certainly needs backporting to the stable kernels.
---
>From 560924e86059947ab9418732cb329ad149dd8f6a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 15 Jan 2014 11:52:09 +0100
Subject: [PATCH] memcg: fix css reference leak from mem_cgroup_iter

19f39402864e (memcg: simplify mem_cgroup_iter) has introduced a css
refrence leak (thus memory leak) because mem_cgroup_iter makes sure it
doesn't put a css reference on the root of the tree walk. The mentioned
commit however dropped the root check when the css reference is taken
while it keept the css_put optimization fora the root in place.

This means that css_put is not called and so css along with mem_cgroup
and other cgroup internal object tied by css lifetime are never freed.

Fix the issue by reintroducing root check in __mem_cgroup_iter_next.

This patch also fixes issue reported by Hugh Dickins when
mem_cgroup_iter might end up in an endless loop because a group which is
under hard limit reclaim is removed in parallel with iteration.
__mem_cgroup_iter_next would always return NULL because css_tryget on
the root (reclaimed memcg) would fail and there are no other memcg in
the hierarchy. prev == NULL in mem_cgroup_iter would prevent break out
from the root and so the while (!memcg) loop would never terminate.
as css_tryget is no longer called for the root of the tree walk this
doesn't happen anymore.

Cc: stable@vger.kernel.org # 3.10+
Reported-and-debugged-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f016d26adfd3..dd3974c9f08d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1078,7 +1078,8 @@ skip_node:
 	 * protected by css_get and the tree walk is rcu safe.
 	 */
 	if (next_css) {
-		if ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))
+		if ((next_css->flags & CSS_ONLINE) &&
+				(next_css == root || css_tryget(next_css)))
 			return mem_cgroup_from_css(next_css);
 		else {
 			prev_css = next_css;
-- 
1.8.5.2

-- 
Michal Hocko
SUSE Labs
