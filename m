Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3LQBmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:42:19 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39277 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3LQBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:42:17 -0500
Date: Mon, 16 Dec 2013 17:41:38 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc breaks MEMCG_SWAP
In-Reply-To: <20131216172143.GJ32509@htj.dyndns.org>
Message-ID: <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils> <52AEC989.4080509@huawei.com> <20131216095345.GB23582@dhcp22.suse.cz> <20131216104042.GC23582@dhcp22.suse.cz> <20131216163530.GH32509@htj.dyndns.org> <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Tejun Heo wrote:
> On Mon, Dec 16, 2013 at 06:19:37PM +0100, Michal Hocko wrote:
> > I have to think about it some more (the brain is not working anymore
> > today). But what we really need is that nobody gets the same id while
> > the css is alive. So css_from_id returning NULL doesn't seem to be
> > enough.
> 
> Oh, I meant whether it's necessary to keep css_from_id() working
> (ie. doing successful lookups) between offline and release, because
> that's where lifetimes are coupled.  IOW, if it's enough for cgroup to
> not recycle the ID until all css's are released && fail css_from_id()
> lookup after the css is offlined, I can make a five liner quick fix.

Don't take my word on it, I'm too fuzzy on this: but although it would
be good to refrain from recycling the ID until all css's are released,
I believe that it would not be good enough to fail css_from_id() once
the css is offlined - mem_cgroup_uncharge_swap() needs to uncharge the
hierarchy of the dead memcg (for example, when tmpfs file is removed).

Uncharging the dead memcg itself is presumably irrelevant, but it does
need to locate the right parent to uncharge, and NULL css_from_id()
would make that impossible.  It would be easy if we said those charges
migrate to root rather than to parent, but that's inconsistent with
what we have happily converged upon doing elsewhere (in the preferred
use_hierarchy case), and it would be a change in behaviour.

I'm not nearly as enthusiastic for my patch as Michal is: I really
would prefer a five-liner from you or from Zefan.  I do think (and
this is probably what Michal likes) that my patch leaves MEMCG_SWAP
less surprising, and less likely to cause similar trouble in future;
but it's not how Kame chose to implement it, and it has those nasty
swap_cgroup array scans adding to the overhead of memcg removal -
we can layer on several different hacks/optimizations to reduce that
overhead, but I think it's debatable whether that will end up as an
improvement over what we have had until now.

Hugh
