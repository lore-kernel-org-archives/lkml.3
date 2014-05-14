Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaENPlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:41:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbaENPlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:41:18 -0400
Date: Wed, 14 May 2014 11:40:37 -0400
From: Rik van Riel <riel@redhat.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com,
        Mel Gorman <mgorman@suse.de>,
        "Vinod, Chegu\" <chegu_vinod@hp.com>, Suresh Siddha <suresh.b.siddha@intel.com>"@redhat.com
Subject: [PATCH] sched: call select_idle_sibling when not affine_sd
Message-ID: <20140514114037.2d93266f@annuminas.surriel.com>
In-Reply-To: <1400040489.5157.44.camel@marge.simpson.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	<1399011219.5233.55.camel@marge.simpson.net>
	<53633B81.1080403@redhat.com>
	<1399016273.5233.94.camel@marge.simpson.net>
	<536379D0.8070306@redhat.com>
	<1399030032.5233.142.camel@marge.simpson.net>
	<5363B793.9010208@redhat.com>
	<20140506115448.GH11096@twins.programming.kicks-ass.net>
	<536943C9.4030502@redhat.com>
	<20140506203916.GQ17778@laptop.programming.kicks-ass.net>
	<536C3B69.1000208@redhat.com>
	<20140509012743.67d4006d@annuminas.surriel.com>
	<1399620873.5200.68.camel@marge.simpson.net>
	<536CE48E.2060305@redhat.com>
	<1399649042.31219.47.camel@marge.simpson.net>
	<536CF346.6080009@redhat.com>
	<1399658123.5187.2.camel@marge.simpson.net>
	<536D1B6D.8060004@redhat.com>
	<1399694090.5146.13.camel@marge.simpson.net>
	<53722754.6040102@redhat.com>
	<1400040489.5157.44.camel@marge.simpson.net>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 06:08:09 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> On Tue, 2014-05-13 at 10:08 -0400, Rik van Riel wrote:

> > 1) If the node_distance between nodes on a NUMA system is
> >    <= RECLAIM_DISTANCE, we will call select_idle_sibling for
> >    a wakeup of a previously existing task (SD_BALANCE_WAKE)
> > 
> > 2) If the node distance exceeds RECLAIM_DISTANCE, we will
> >    wake up a task on prev_cpu, even if it is not currently
> >    idle
> > 
> >    This behaviour only happens on certain large NUMA systems,
> >    and is different from the behaviour on small systems.
> >    I suspect we will want to call select_idle_sibling with
> >    prev_cpu in case target and prev_cpu are not in the same
> >    SD_WAKE_AFFINE domain.
> 
> Sometimes.  It's the same can of worms remote as it is local.. latency
> gain may or may not outweigh cache miss pain.

Ahh, but it is a DIFFERENT can of worms. If the distance between
cpu and prev_cpu exceeds RECLAIM_DISTANCE, we will not look for 
an idle sibling in the same LLC domain as prev_cpu.

If the distance is smaller, and we decide not to do an affine
wakeup, then we do look for an idle sibling of prev_cpu.

This patch makes sure that both types of systems have the same
can of worms :)

---8<---

Subject: sched: call select_idle_sibling when not affine_sd

On smaller systems, the top level sched domain will be an affine
domain, and select_idle_sibling is invoked for every SD_WAKE_AFFINE
wakeup. This seems to be working well.

On larger systems, with the node distance between far away NUMA nodes
being > RECLAIM_DISTANCE, select_idle_sibling is only called if the
waker and the wakee are on nodes less than RECLAIM_DISTANCE apart.

This patch leaves in place the policy of not pulling the task across
nodes on such systems, while fixing the issue that select_idle_sibling
is not called at all in certain circumstances.

The code will look for an idle CPU in the same CPU package as the
CPU where the task ran previously.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 39b63d0..1e58159 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4423,10 +4423,10 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			sd = tmp;
 	}
 
-	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
+	if (affine_sd && cpu != prev_cpu && wake_affine(affine_sd, p, sync))
+		prev_cpu = cpu;
 
+	if (sd_flag & SD_WAKE_AFFINE) {
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
 	}

