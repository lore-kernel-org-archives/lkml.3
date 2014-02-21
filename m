Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaBUPD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:03:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40029 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbaBUPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:03:27 -0500
Date: Fri, 21 Feb 2014 16:03:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140221150312.GF3104@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
 <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
 <20140219101949.GG15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
 <20140220100830.GN6835@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu>
 <20140220182300.GN9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220182300.GN9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 07:23:00PM +0100, Peter Zijlstra wrote:
> This is I think the relevant bit:
> 
>    pec_1076_warn-2804  [000] d...   147.926153: x86_pmu_disable: x86_pmu_disable
>    pec_1076_warn-2804  [000] d...   147.926153: x86_pmu_state: Events: {
>    pec_1076_warn-2804  [000] d...   147.926156: x86_pmu_state:   0: state: .R config: ffffffffffffffff (          (null))
>    pec_1076_warn-2804  [000] d...   147.926158: x86_pmu_state:   33: state: AR config: 0 (ffff88011ac99800)
>    pec_1076_warn-2804  [000] d...   147.926159: x86_pmu_state: }
>    pec_1076_warn-2804  [000] d...   147.926160: x86_pmu_state: n_events: 1, n_added: 0, n_txn: 1
>    pec_1076_warn-2804  [000] d...   147.926161: x86_pmu_state: Assignment: {
>    pec_1076_warn-2804  [000] d...   147.926162: x86_pmu_state:   0->33 tag: 1 config: 0 (ffff88011ac99800)
>    pec_1076_warn-2804  [000] d...   147.926163: x86_pmu_state: }
>    pec_1076_warn-2804  [000] d...   147.926166: collect_events: Adding event: 1 (ffff880119ec8800)

So we add the insn:p event (fd[23])

At this point we should have:

  n_events = 2, n_added = 1, n_txn = 1

>    pec_1076_warn-2804  [000] d...   147.926170: collect_events: Adding event: 0 (ffff8800c9e01800)
>    pec_1076_warn-2804  [000] d...   147.926172: collect_events: Adding event: 4 (ffff8800cbab2c00)

We try and add the {BP,cycles,br_insn} group (fd[3], fd[4], fd[15]).
These events are 0:cycles and 4:br_insn, the BP event isn't x86_pmu so
that's not visible.

group_sched_in()
  pmu->start_txn() /* nop - BP pmu */
  event_sched_in()
     event->pmu->add()

So here we should end up with:

0: n_events = 3, n_added = 2, n_txn = 2
4: n_events = 4, n_added = 3, n_txn = 3

But seeing the below state on x86_pmu_enable(), the must have failed,
because the 0 and 4 events aren't there anymore.

Looking at group_sched_in(), since the BP is the leader, its
event_sched_in() must have succeeded, for otherwise we would not have
seen the sibling adds.

But since neither 0 or 4 are in the below state; their event_sched_in()
must have failed; but I don't see why, the complete state: 0,0,1:p,4
fits perfectly fine on a core2.

However, since we try and schedule 4 it means the 0 event must have
succeeded!  Therefore the 4 event must have failed, its failure will
have put group_sched_in() into the fail path, which will call:

  event_sched_out()
    event->pmu->del()

on 0 and the BP event.

Now x86_pmu_del() will reduce n_events; but it will not reduce n_added;
giving what we see below:

 n_event = 2, n_added = 2, n_txn = 2

>    pec_1076_warn-2804  [000] d...   147.926177: x86_pmu_enable: x86_pmu_enable
>    pec_1076_warn-2804  [000] d...   147.926177: x86_pmu_state: Events: {
>    pec_1076_warn-2804  [000] d...   147.926179: x86_pmu_state:   0: state: .R config: ffffffffffffffff (          (null))
>    pec_1076_warn-2804  [000] d...   147.926181: x86_pmu_state:   33: state: AR config: 0 (ffff88011ac99800)
>    pec_1076_warn-2804  [000] d...   147.926182: x86_pmu_state: }
>    pec_1076_warn-2804  [000] d...   147.926184: x86_pmu_state: n_events: 2, n_added: 2, n_txn: 2
>    pec_1076_warn-2804  [000] d...   147.926184: x86_pmu_state: Assignment: {
>    pec_1076_warn-2804  [000] d...   147.926186: x86_pmu_state:   0->33 tag: 1 config: 0 (ffff88011ac99800)
>    pec_1076_warn-2804  [000] d...   147.926188: x86_pmu_state:   1->0 tag: 1 config: 1 (ffff880119ec8800)
>    pec_1076_warn-2804  [000] d...   147.926188: x86_pmu_state: }
>    pec_1076_warn-2804  [000] d...   147.926190: x86_pmu_enable: S0: hwc->idx: 33, hwc->last_cpu: 0, hwc->last_tag: 1 hwc->state: 0

So the problem is that x86_pmu_del(), when called from a
group_sched_in() that fails (for whatever reason), and without x86_pmu
TXN support (because the leader is !x86_pmu), will corrupt the n_added
state.

If this all is correct; the below ought to cure things.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 895604f2e916..79f9f848bee4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1192,6 +1192,9 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
 
+			if (i >= cpuc->n_events - cpuc->n_added)
+				--cpuc->n_added;
+
 			if (x86_pmu.put_event_constraints)
 				x86_pmu.put_event_constraints(cpuc, event);
 
