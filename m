Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3HEMqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:46:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab3HEMqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:46:14 -0400
Date: Mon, 5 Aug 2013 08:44:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/23] cgroup: pass around cgroup_subsys_state instead of
 cgroup in subsystem methods
Message-ID: <20130805124417.GA2274@redhat.com>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375393801-4817-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 05:49:46PM -0400, Tejun Heo wrote:
> cgroup is currently in the process of transitioning to using struct
> cgroup_subsys_state * as the primary handle instead of struct cgroup *
> in subsystem implementations for the following reasons.
> 
> * With unified hierarchy, subsystems will be dynamically bound and
>   unbound from cgroups and thus css's (cgroup_subsys_state) may be
>   created and destroyed dynamically over the lifetime of a cgroup,
>   which is different from the current state where all css's are
>   allocated and destroyed together with the associated cgroup.  This
>   in turn means that cgroup_css() should be synchronized and may
>   return NULL, making it more cumbersome to use.
> 
> * Differing levels of per-subsystem granularity in the unified
>   hierarchy means that the task and descendant iterators should behave
>   differently depending on the specific subsystem the iteration is
>   being performed for.
> 
> * In majority of the cases, subsystems only care about its part in the
>   cgroup hierarchy - ie. the hierarchy of css's.  Subsystem methods
>   often obtain the matching css pointer from the cgroup and don't
>   bother with the cgroup pointer itself.  Passing around css fits
>   much better.
> 
> This patch converts all cgroup_subsys methods to take @css instead of
> @cgroup.  The conversions are mostly straight-forward.  A few
> noteworthy changes are
> 
> * ->css_alloc() now takes css of the parent cgroup rather than the
>   pointer to the new cgroup as the css for the new cgroup doesn't
>   exist yet.  Knowing the parent css is enough for all the existing
>   subsystems.
> 
> * In kernel/cgroup.c::offline_css(), unnecessary open coded css
>   dereference is replaced with local variable access.
> 
> This patch shouldn't cause any behavior differences.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  block/blk-cgroup.c        | 25 +++++++++++-----------

blk-cgroup changes look good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
