Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3EQQDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:03:09 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:45140 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab3EQQDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:03:06 -0400
Date: Fri, 17 May 2013 12:02:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Message-ID: <20130517160247.GA10023@cmpxchg.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368431172-6844-2-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 09:46:10AM +0200, Michal Hocko wrote:
> Memcg soft reclaim has been traditionally triggered from the global
> reclaim paths before calling shrink_zone. mem_cgroup_soft_limit_reclaim
> then picked up a group which exceeds the soft limit the most and
> reclaimed it with 0 priority to reclaim at least SWAP_CLUSTER_MAX pages.
> 
> The infrastructure requires per-node-zone trees which hold over-limit
> groups and keep them up-to-date (via memcg_check_events) which is not
> cost free. Although this overhead hasn't turned out to be a bottle neck
> the implementation is suboptimal because mem_cgroup_update_tree has no
> idea which zones consumed memory over the limit so we could easily end
> up having a group on a node-zone tree having only few pages from that
> node-zone.
> 
> This patch doesn't try to fix node-zone trees management because it
> seems that integrating soft reclaim into zone shrinking sounds much
> easier and more appropriate for several reasons.
> First of all 0 priority reclaim was a crude hack which might lead to
> big stalls if the group's LRUs are big and hard to reclaim (e.g. a lot
> of dirty/writeback pages).
> Soft reclaim should be applicable also to the targeted reclaim which is
> awkward right now without additional hacks.
> Last but not least the whole infrastructure eats quite some code.
> 
> After this patch shrink_zone is done in 2 passes. First it tries to do the
> soft reclaim if appropriate (only for global reclaim for now to keep
> compatible with the original state) and fall back to ignoring soft limit
> if no group is eligible to soft reclaim or nothing has been scanned
> during the first pass. Only groups which are over their soft limit or
> any of their parents up the hierarchy is over the limit are considered
> eligible during the first pass.

There are setups with thousands of groups that do not even use soft
limits.  Having them pointlessly iterate over all of them for every
couple of pages reclaimed is just not acceptable.

This is not the first time this implementation was proposed, either,
I'm afraid we have now truly gone full circle on this stuff.
