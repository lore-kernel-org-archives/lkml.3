Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaFXPdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:33:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbaFXPde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:33:34 -0400
Date: Tue, 24 Jun 2014 11:30:01 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 8/7] sched,numa: do not let a move increase the
 imbalance
Message-ID: <20140624113001.114a6590@riellap.home.surriel.com>
In-Reply-To: <20140624143820.GA28774@twins.programming.kicks-ass.net>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
	<20140623183011.28555a7c@annuminas.surriel.com>
	<20140624143820.GA28774@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 16:38:20 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Jun 23, 2014 at 06:30:11PM -0400, Rik van Riel wrote:
> > The HP DL980 system has a different NUMA topology from the 8 node
> > system I am testing on, and showed some bad behaviour I have not
> > managed to reproduce. This patch makes sure workloads converge.
> > 
> > When both a task swap and a task move are possible, do not let the
> > task move cause an increase in the load imbalance. Forcing task
> > swaps can help untangle workloads that have gotten stuck fighting
> > over the same nodes, like this run of "perf bench numa -m -0 -p
> > 1000 -p 16 -t 15":
> > 
> > Per-node process memory usage (in MBs)
> > 38035 (process 0      2      0      0      1   1000      0
> > 0      0  1003 38036 (process 1      2      0      0      1
> > 0   1000      0      0  1003 38037 (process 2    230    772
> > 0      1      0      0      0      0  1003 38038 (process 3
> > 1      0      0   1003      0      0      0      0  1004 38039
> > (process 4      2      0      0      1      0      0    994      6
> > 1003 38040 (process 5      2      0      0      1    994
> > 0      0      6  1003 38041 (process 6      2      0   1000
> > 1      0      0      0      0  1003 38042 (process 7   1003
> > 0      0      1      0      0      0      0  1004 38043 (process
> > 8      2      0      0      1      0   1000      0      0  1003
> > 38044 (process 9      2      0      0      1      0      0      0
> > 1000  1003 38045 (process 1   1002      0      0      1      0
> > 0      0      0  1003 38046 (process 1      3      0    954
> > 1      0      0      0     46  1004 38047 (process 1      2
> > 1000      0      1      0      0      0      0  1003 38048 (process
> > 1      2      0      0      1      0      0   1000      0  1003
> > 38049 (process 1      2      0      0   1001      0      0
> > 0      0  1003 38050 (process 1      2    934      0     67
> > 0      0      0      0  1003
> > 
> > Allowing task moves to increase the imbalance even slightly causes
> > tasks to move towards node 1, and not towards node 7, which prevents
> > the workload from converging once the above scenario has been
> > reached.
> > 
> > Reported-and-tested-by: Vinod Chegu <chegu_vinod@hp.com>
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > ---
> >  kernel/sched/fair.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 4723234..e98d290 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -1314,6 +1314,12 @@ static void task_numa_compare(struct
> > task_numa_env *env, 
> >  	if (moveimp > imp && moveimp > env->best_imp) {
> >  		/*
> > +		 * A task swap is possible, do not let a task move
> > +		 * increase the imbalance.
> > +		 */
> > +		int imbalance_pct = env->imbalance_pct;
> > +		env->imbalance_pct = 100;
> > +		/*
> 
> I would feel so much better if we could say _why_ this is so.

I can explain why, and will need to think a little about how to
write it best down in a concise form for a comment...

Basically, when we have more numa_groups than nodes on the
system, say 2x the number of nodes, it is possible that one node
is the most desirable node for 3 of the tasks or numa_groups
(node A), while another node is desirable to just 1 group (node B).

If we allow task moves to create an imbalance, the load balancer
will move tasks from groups 1, 2 & 3 from node A to node B,
while the NUMA code is allowed to move tasks back from node B
to node A.

Each of the numa groups are allowed equal movement here. A task
move has a higher improvement than a task swap, so the system
will prefer a task move.

By not doing the task moves, the workloads never "untangle" with
two of them winning node A, and the other ending up predominantly
on node B, until node B becomes its preferred nid.

Does that make sense?
