Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3HFHTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:19:53 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:51144 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab3HFHTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:19:52 -0400
X-CTCH-RefID: str=0001.0A0C0202.5200A393.00C6,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Message-ID: <5200A391.9030208@bmw-carit.de>
Date: Tue, 6 Aug 2013 09:19:45 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 08/23] cgroup: pass around cgroup_subsys_state instead
 of cgroup in subsystem methods
References: <1375393801-4817-1-git-send-email-tj@kernel.org> <1375393801-4817-9-git-send-email-tj@kernel.org> <20130802202408.GH29736@mtj.dyndns.org>
In-Reply-To: <20130802202408.GH29736@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.101.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 10:24 PM, Tejun Heo wrote:
> cgroup is currently in the process of transitioning to using struct
> cgroup_subsys_state * as the primary handle instead of struct cgroup *
> in subsystem implementations for the following reasons.
>
> * With unified hierarchy, subsystems will be dynamically bound and
>    unbound from cgroups and thus css's (cgroup_subsys_state) may be
>    created and destroyed dynamically over the lifetime of a cgroup,
>    which is different from the current state where all css's are
>    allocated and destroyed together with the associated cgroup.  This
>    in turn means that cgroup_css() should be synchronized and may
>    return NULL, making it more cumbersome to use.
>
> * Differing levels of per-subsystem granularity in the unified
>    hierarchy means that the task and descendant iterators should behave
>    differently depending on the specific subsystem the iteration is
>    being performed for.
>
> * In majority of the cases, subsystems only care about its part in the
>    cgroup hierarchy - ie. the hierarchy of css's.  Subsystem methods
>    often obtain the matching css pointer from the cgroup and don't
>    bother with the cgroup pointer itself.  Passing around css fits
>    much better.
>
> This patch converts all cgroup_subsys methods to take @css instead of
> @cgroup.  The conversions are mostly straight-forward.  A few
> noteworthy changes are
>
> * ->css_alloc() now takes css of the parent cgroup rather than the
>    pointer to the new cgroup as the css for the new cgroup doesn't
>    exist yet.  Knowing the parent css is enough for all the existing
>    subsystems.
>
> * In kernel/cgroup.c::offline_css(), unnecessary open coded css
>    dereference is replaced with local variable access.
>
> This patch shouldn't cause any behavior differences.
>
> v2: Unnecessary explicit cgrp->subsys[] deref in css_online() replaced
>      with local variable @css as suggested by Li Zefan.
>
>      Rebased on top of new for-3.12 which includes for-3.11-fixes so
>      that ->css_free() invocation added by da0a12caff ("cgroup: fix a
>      leak when percpu_ref_init() fails") is converted too.  Suggested
>      by Li Zefan.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Li Zefan <lizefan@huawei.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Steven Rostedt <rostedt@goodmis.org>

netprio and cls part:

Acked-By: Daniel Wagner <daniel.wagner@bmw-carit.de>

cheers,
daniel



