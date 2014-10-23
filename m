Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbaJWUKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:10:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39167 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449AbaJWUJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:09:59 -0400
Date: Thu, 23 Oct 2014 12:58:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023195808.GB4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013173504.GA27955@redhat.com>
 <543DDD5E.9080602@oracle.com>
 <20141023183917.GX4977@linux.vnet.ibm.com>
 <54494F2F.6020005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54494F2F.6020005@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102320-0025-0000-0000-000000D897A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 02:55:43PM -0400, Sasha Levin wrote:
> On 10/23/2014 02:39 PM, Paul E. McKenney wrote:
> > On Tue, Oct 14, 2014 at 10:35:10PM -0400, Sasha Levin wrote:
> >> On 10/13/2014 01:35 PM, Dave Jones wrote:
> >>> oday in "rcu stall while fuzzing" news:
> >>>
> >>> INFO: rcu_preempt detected stalls on CPUs/tasks:
> >>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> >>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> >>> 	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)
> >>
> >> I've complained about RCU stalls couple days ago (in a different context)
> >> on -next. I guess whatever causing them made it into Linus's tree?
> >>
> >> https://lkml.org/lkml/2014/10/11/64
> > 
> > And on that one, I must confess that I don't see where the RCU read-side
> > critical section might be.
> > 
> > Hmmm...  Maybe someone forgot to put an rcu_read_unlock() somewhere.
> > Can you reproduce this with CONFIG_PROVE_RCU=y?
> 
> Paul, if that was directed to me - Yes, I see stalls with CONFIG_PROVE_RCU
> set and nothing else is showing up before/after that.

Indeed it was directed to you.  ;-)

Does the following crude diagnostic patch turn up anything?

							Thanx, Paul

------------------------------------------------------------------------

softirq: Check for RCU read-side misnesting in softirq handlers

This commit adds checks for RCU read-side misnesting in softirq handlers.
Please note that this works only for CONFIG_TREE_PREEMPT_RCU=y because
the other RCU flavors have no way of knowing how deeply nested they are.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 501baa9ac1be..c6b63a4c576d 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -257,11 +257,13 @@ restart:
 	while ((softirq_bit = ffs(pending))) {
 		unsigned int vec_nr;
 		int prev_count;
+		int rcu_depth;
 
 		h += softirq_bit - 1;
 
 		vec_nr = h - softirq_vec;
 		prev_count = preempt_count();
+		rcu_depth = rcu_preempt_depth();
 
 		kstat_incr_softirqs_this_cpu(vec_nr);
 
@@ -274,6 +276,11 @@ restart:
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
 		}
+		if (IS_ENABLED(CONFIG_PROVE_RCU) &&
+		    rcu_depth != rcu_preempt_depth())
+			pr_err("huh, entered softirq %u %s %p with RCU nesting %08x, exited with %08x?\n",
+			       vec_nr, softirq_to_name[vec_nr], h->action,
+			       rcu_depth, rcu_preempt_depth());
 		h++;
 		pending >>= softirq_bit;
 	}

