Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaEUQuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:50:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaEUQuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:50:11 -0400
Date: Wed, 21 May 2014 18:49:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
Message-ID: <20140521164959.GI5226@laptop.programming.kicks-ass.net>
References: <5371122D.6020605@oracle.com>
 <537AB86B.4020901@oracle.com>
 <20140520110431.GX2485@laptop.programming.kicks-ass.net>
 <537B52BD.1080807@oracle.com>
 <537CA54A.8030408@oracle.com>
 <20140521131948.GF2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521131948.GF2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:19:48PM +0200, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 09:08:26AM -0400, Sasha Levin wrote:

> > +++ b/kernel/sched/core.c
> > @@ -1154,6 +1156,7 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
> >                 goto out;
> > 
> >         trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
> > +       BUG_ON(cur == p);
> >         ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
> > 
> >  out:
> > 
> > 
> > Which seems to get hit. This sounds like a race with task moving to
> > other cpu maybe?
> 
> Oi, good call that, lemme go stare.

I think something simple like this should be sufficient to avoid the
problem of selecting oneself as a flip target.

---
 kernel/sched/fair.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28ccf502c63c..28ba71d815ee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1115,6 +1115,8 @@ static void task_numa_compare(struct task_numa_env *env,
 	cur = ACCESS_ONCE(dst_rq->curr);
 	if (cur->pid == 0) /* idle */
 		cur = NULL;
+	if (cur == env->p)
+		goto unlock;
 
 	/*
 	 * "imp" is the fault differential for the source task between the
