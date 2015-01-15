Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbbAOR05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:26:57 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:35674 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbbAOR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:26:56 -0500
Date: Thu, 15 Jan 2015 18:26:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH cgroup/for-3.19-fixes] cgroup: implement
 cgroup_subsys->unbind() callback
Message-ID: <20150115172652.GF7008@dhcp22.suse.cz>
References: <54B01335.4060901@arm.com>
 <20150110085525.GD2110@esperanza>
 <20150110214316.GF25319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110214316.GF25319@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10-01-15 16:43:16, Tejun Heo wrote:
> Currently, if a hierarchy doesn't have any live children when it's
> unmounted, the hierarchy starts dying by killing its refcnt.  The
> expectation is that even if there are lingering dead children which
> are lingering due to remaining references, they'll be put in a finite
> amount of time.  When the children are finally released, the hierarchy
> is destroyed and all controllers bound to it also are released.
> 
> However, for memcg, the premise that the lingering refs will be put in
> a finite amount time is not true.  In the absense of memory pressure,
> dead memcg's may hang around indefinitely pinned by its pages.  This
> unfortunately may lead to indefinite hang on the next mount attempt
> involving memcg as the mount logic waits for it to get released.
> 
> While we can change hierarchy destruction logic such that a hierarchy
> is only destroyed when it's not mounted anywhere and all its children,
> live or dead, are gone, this makes whether the hierarchy gets
> destroyed or not to be determined by factors opaque to userland.
> Userland may or may not get a new hierarchy on the next mount attempt.
> Worse, if it explicitly wants to create a new hierarchy with different
> options or controller compositions involving memcg, it will fail in an
> essentially arbitrary manner.
> 
> We want to guarantee that a hierarchy is destroyed once the
> conditions, unmounted and no visible children, are met.  To aid it,
> this patch introduces a new callback cgroup_subsys->unbind() which is
> invoked right before the hierarchy a subsystem is bound to starts
> dying.  memcg can implement this callback and initiate draining of
> remaining refs so that the hierarchy can eventually be released in a
> finite amount of time.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Vladimir Davydov <vdavydov@parallels.com>

Ohh, I have missed this one as I wasn't on the CC list.

FWIW this approach makes sense to me. I just think that we should have a
way to fail. E.g. kmem pages are impossible to reclaim because there
might be some objects lingering somewhere not bound to a task context
and reparenting is hard as Vladimir has pointed out several times
already.
Normal LRU pages should be reclaimable or reparented to the root easily.

I cannot judge the implementation but I agree with the fact that memcg
controller should be the one to take an action.
-- 
Michal Hocko
SUSE Labs
