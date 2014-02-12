Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaBLXAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:00:37 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47349 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaBLXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:00:35 -0500
Date: Wed, 12 Feb 2014 14:59:44 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup
 destruction
In-Reply-To: <20140207164321.GE6963@cmpxchg.org>
Message-ID: <alpine.LSU.2.11.1402121417230.5029@eggly.anvils>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils> <20140207164321.GE6963@cmpxchg.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Johannes Weiner wrote:
> On Thu, Feb 06, 2014 at 03:56:01PM -0800, Hugh Dickins wrote:
> > Sometimes the cleanup after memcg hierarchy testing gets stuck in
> > mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> > 
> > There may turn out to be several causes, but a major cause is this: the
> > workitem to offline parent can get run before workitem to offline child;
> > parent's mem_cgroup_reparent_charges() circles around waiting for the
> > child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> > which prevents the child from reaching its mem_cgroup_reparent_charges().
> > 
> > Just use an ordered workqueue for cgroup_destroy_wq.
> > 
> > Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
> > Suggested-by: Filipe Brandenburger <filbranden@google.com>
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Cc: stable@vger.kernel.org # 3.10+
> 
> I think this is a good idea for now and -stable:
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

You might be wondering why this patch didn't reach Linus yet.

It's because more thorough testing, by others here, found that it
wasn't always solving the problem: so I asked Tejun privately to
hold off from sending it in, until we'd worked out why not.

Most of our testing being on a v3,11-based kernel, it was perfectly
possible that the problem was merely our own e.g. missing Tejun's
8a2b75384444 ("workqueue: fix ordered workqueues in NUMA setups").

But that turned out not to be enough to fix it either. Then Filipe
pointed out how percpu_ref_kill_and_confirm() uses call_rcu_sched()
before we ever get to put the offline on to the workqueue: by the
time we get to the workqueue, the ordering has already been lost.

So, thanks for the Acks, but I'm afraid that this ordered workqueue
solution is just not good enough: we should simply forget that patch
and provide a different answer.

So I'm now posting a couple of alternative solutions: 1/2 from Filipe
at the memcg end, and 2/2 from me at the cgroup end.  Each of these
has stood up to better testing, so you can choose between them,
or work out a better answer.

(By the way, I have another little pair of memcg/cgroup fixes to post
shortly, nothing to do with these two: it would be less confusing if
I had some third fix to add in there, but sadly not.)

Hugh
