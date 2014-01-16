Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaAPOKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:10:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaAPOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:10:33 -0500
Date: Thu, 16 Jan 2014 15:10:31 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/3] memcg: notify userspace about OOM only when and action
 is due
Message-ID: <20140116141031.GE28157@dhcp22.suse.cz>
References: <1389798068-19885-1-git-send-email-mhocko@suse.cz>
 <1389798068-19885-2-git-send-email-mhocko@suse.cz>
 <20140115175655.GJ6963@cmpxchg.org>
 <20140115190015.GA22196@dhcp22.suse.cz>
 <20140115203047.GK6963@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115203047.GK6963@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-01-14 15:30:47, Johannes Weiner wrote:
> On Wed, Jan 15, 2014 at 08:00:15PM +0100, Michal Hocko wrote:
> > On Wed 15-01-14 12:56:55, Johannes Weiner wrote:
> > > On Wed, Jan 15, 2014 at 04:01:06PM +0100, Michal Hocko wrote:
> > > > Userspace is currently notified about OOM condition after reclaim
> > > > fails to uncharge any memory after MEM_CGROUP_RECLAIM_RETRIES rounds.
> > > > This usually means that the memcg is really in troubles and an
> > > > OOM action (either done by userspace or kernel) has to be taken.
> > > > The kernel OOM killer however bails out and doesn't kill anything
> > > > if it sees an already dying/exiting task in a good hope a memory
> > > > will be released and the OOM situation will be resolved.
> > > > 
> > > > Therefore it makes sense to notify userspace only after really all
> > > > measures have been taken and an userspace action is required or
> > > > the kernel kills a task.
> > > > 
> > > > This patch is based on idea by David Rientjes to not notify
> > > > userspace when the current task is killed or in a late exiting.
> > > > The original patch, however, didn't handle in kernel oom killer
> > > > back offs which is implemtented by this patch.
> > > > 
> > > > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > > 
> > > OOM is a temporary state because any task can exit at a time that is
> > > not under our control and outside our knowledge.  That's why the OOM
> > > situation is defined by failing an allocation after a certain number
> > > of reclaim and charge attempts.
> > > 
> > > As of right now, the OOM sampling window is MEM_CGROUP_RECLAIM_RETRIES
> > > loops of charge attempts and reclaim.  If a racing task is exiting and
> > > releasing memory during that window, the charge will succeed fine.  If
> > > the sampling window is too short in practice, it will have to be
> > > extended, preferrably through increasing MEM_CGROUP_RECLAIM_RETRIES.
> > 
> > The patch doesn't try to address the above race because that one is
> > unfixable. I hope that is clear.
> > 
> > It just tries to reduce burden on the userspace oom notification
> > consumers and given them a simple semantic. Notification comes only if
> > an action will be necessary (either kernel kills something or user space
> > is expected).
> 
> I.e. turn the OOM notification into an OOM kill event notification.

OK, maybe it's just me but I've considered OOM -> OOM kill. Because if
we for some reason do not need to perform an action then we are not OOM
really (one of them is the state the other part is an action).  Maybe
it's because you cannot find out you are under OOM unless you see the
OOM killer in action for ages (well memcg has changed that but...)

I might be wrong here of course...

> > E.g. consider a handler which tries to clean up after kernel handled
> > OOM and killed something. If the kernel could back off and refrain
> > from killing anything after the norification already fired up then the
> > userspace has no practical way to detect that (except for checking the
> > kernel log to search for OOM messages which might get suppressed due to
> > rate limitting etc.. Nothing I would call optimal).
> > Or do you think that such a use case doesn't make much sense and it is
> > an abuse of the notification interface?
> 
> I'm not sure what such a cleanup would be doing, a real life usecase
> would be useful when we are about to change notification semantics.
> I've heard "taking down the remaining tasks of the job" before, but
> that would be better solved by having the OOM killer operate on
> cgroups as single entities instead of taking out individual tasks.

I am not a direct user of the interface myself but I can imagine that
there might be many clean up actions to be done. The task receives
SIG_KILL so it doesn't have any chance to do the cleanup itself. This
might be something like reverting to the last consistent state for the
internal data or removing temporary files which, for some reason, had to
be visible througout the process life and many others.

> On the other hand, I can see how people use the OOM notification to
> monitor system/cgroup health.  David argued that vmpressure "critical"
> would be the same thing.  But first of all, this is not an argument to
> change semantics of an established interface. And secondly, it only
> tells you that reclaim is struggling, it doesn't give you the point of
> failure (the OOM condition), regardless of what the docs claim.

> So, please, if you need a new interface, make a clear case for it and
> then we can discuss if it's the right way to go.  We do the same for
> every other user interface, whether it's a syscall, an ioctl, a procfs
> file etc.  Just taking something existing that is close enough and
> skewing the semantics in your favor like this is not okay.

Agreed, that's why this has been sent as a request for comments and
discussion. It is sad that the discussion ended before it started...
I realize that the previous one was quite frustrating but maybe we can
do better.

I am not going to push for this very strong because I believe that last
second back offs before OOM killer fires doesn't happen all that often. 
Do we have any numbers for that, btw?
Maybe we should start by adding a counter and report it in (memcg)
statistics (quick patch on top of mmotm bellow). And base our future
decisions on those numbers? Because to be honest, something tells me
that the overall difference will be barely noticeable most workloads.

Anyway, I liked the notification to be tighter to the action because
it makes userspace notifiers easier to implement because they wouldn't
have to worry about back offs. Also the semantic is much cleaner IMO
because you get a notification that the situation is so bad that the
kernel had to use an emergency measures.

---
>From 0aa4a4450815e78c8d69ea2dd5b4ddf308f68110 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 16 Jan 2014 14:17:27 +0100
Subject: [PATCH] memcg: collect oom back off statistics

OOM killer might back off and not kill anything if it believes that the
memcg is not really OOM because there is a task(s) which is on the way
out and so it would free memory shortly.

We however do not have any way data to know how much those heuristics
are effective to prevent from the real killing. Let's add a statistic
for this event so we can collect data and make some educated conclusions
from it.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f016d26adfd3..b3c839ac6a1d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -100,6 +100,7 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
 	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
 	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
+	MEM_CGROUP_EVENTS_OOM_BACK_OFF,	/* # of oom killer backoffs */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
 
@@ -108,6 +109,7 @@ static const char * const mem_cgroup_events_names[] = {
 	"pgpgout",
 	"pgfault",
 	"pgmajfault",
+	"oom_back_off",
 };
 
 static const char * const mem_cgroup_lru_names[] = {
@@ -1752,6 +1754,13 @@ static u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
 	return limit;
 }
 
+static void mem_cgroup_inc_oom_backoff(struct mem_cgroup *memcg)
+{
+	preempt_disable();
+	this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_OOM_BACK_OFF]);
+	preempt_enable();
+}
+
 static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order)
 {
@@ -1768,6 +1777,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 */
 	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
 		set_thread_flag(TIF_MEMDIE);
+		mem_cgroup_inc_oom_backoff(memcg);
 		return;
 	}
 
@@ -1795,6 +1805,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				mem_cgroup_iter_break(memcg, iter);
 				if (chosen)
 					put_task_struct(chosen);
+				mem_cgroup_inc_oom_backoff(memcg);
 				return;
 			case OOM_SCAN_OK:
 				break;
-- 
1.8.5.2


-- 
Michal Hocko
SUSE Labs
