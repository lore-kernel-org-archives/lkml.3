Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3IPIQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:16:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3IPIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:16:43 -0400
Date: Mon, 16 Sep 2013 10:16:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/2] sched: load_balance: Reset env when going to redo
 due to all pinned
Message-ID: <20130916081635.GQ21832@twins.programming.kicks-ass.net>
References: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
 <c34e2ebbe55403d5db111fa3ecdf6ca52b73a337.1379265590.git.vdavydov@parallels.com>
 <20130916054301.GK21832@twins.programming.kicks-ass.net>
 <5236BC9B.8040006@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5236BC9B.8040006@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:08:59PM +0400, Vladimir Davydov wrote:
> >>Signed-off-by: Vladimir Davydov<vdavydov@parallels.com>
> >>---
> >>  kernel/sched/fair.c |   12 ++++++++++--
> >>  1 file changed, 10 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >>index cd59640..d840e51 100644
> >>--- a/kernel/sched/fair.c
> >>+++ b/kernel/sched/fair.c
> >>@@ -5289,8 +5289,16 @@ more_balance:
> >>  		if (unlikely(env.flags & LBF_ALL_PINNED)) {
> >>  			cpumask_clear_cpu(cpu_of(busiest), cpus);
> >>  			if (!cpumask_empty(cpus)) {
> >>-				env.loop = 0;
> >>-				env.loop_break = sched_nr_migrate_break;
> >>+				env.dst_cpu	= this_cpu;
> >>+				env.dst_rq	= this_rq;
> >>+				env.flags	= 0;
> >>+				env.loop	= 0;
> >>+				env.loop_break	= sched_nr_migrate_break;
> >>+
> >>+				/* Reset cpus cleared in LBF_SOME_PINNED case */
> >>+				if (env.dst_grpmask)
> >>+					cpumask_or(cpus, cpus, env.dst_grpmask);
> >>+
> >>  				goto redo;
> >>  			}
> >>  			goto out_balanced;
> >So the problem I have with this is that it removes the bound on the
> >number of iterations we do. Currently we're limited by the bits in cpus,
> >but by resetting those we can do on and on and on...
> 
> find_busiest_group() never selects the local group, doesn't it? So none of
> env.dst_grpmask, which is initialized to sched_group_cpus(this_rq->sd), can
> be selected for the source cpu. That said, resetting env.dst_grpmask bits in
> the cpus bitmask actually doesn't affect the number of balance iterations.

Going by e02e60c10 the bits in cpus are what limit the DST_PINNED
(formerly SOME_PINNED) retry loop.

But yes, as you said, the entire scenario is entirely unlikely. I'll
drop this patch for now.
