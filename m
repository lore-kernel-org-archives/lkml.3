Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab3FDBHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 21:07:48 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62331 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab3FDBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 21:07:44 -0400
Date: Mon, 3 Jun 2013 18:07:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch -v4 4/8] memcg: enhance memcg iterator to support
 predicates
Message-ID: <20130604010737.GF29989@mtj.dyndns.org>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <1370254735-13012-5-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370254735-13012-5-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 12:18:51PM +0200, Michal Hocko wrote:
> The caller of the iterator might know that some nodes or even subtrees
> should be skipped but there is no way to tell iterators about that so
> the only choice left is to let iterators to visit each node and do the
> selection outside of the iterating code. This, however, doesn't scale
> well with hierarchies with many groups where only few groups are
> interesting.
> 
> This patch adds mem_cgroup_iter_cond variant of the iterator with a
> callback which gets called for every visited node. There are three
> possible ways how the callback can influence the walk. Either the node
> is visited, it is skipped but the tree walk continues down the tree or
> the whole subtree of the current group is skipped.
> 
> TODO is it correct to reclaim + cond together? What if the cache simply
> skips interesting nodes which another predicate would find interesting?

I don't know.  Maybe it's just taste but it looks pretty ugly to me.
Why does everything have to be folded into the iteration function?
The iteration only depends on the current position.  Can't you factor
out skipping part outside the function rather than rolling into this
monstery thing with predicate callback?  Just test the condition
outside and call a function to skip whatever is necessary?

Also, cgroup_rightmost_descendant() can be pretty expensive depending
on how your tree looks like.  It travels to the rightmost child at
each level until it can't.  In extreme cases, you can travel the whole
subtree.  This usually isn't a problem for its usecases but yours may
be different, I'm not sure.

Thanks.

-- 
tejun
