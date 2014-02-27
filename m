Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaB0NdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:33:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaB0NdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:33:05 -0500
Date: Thu, 27 Feb 2014 05:32:20 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-26e61e8939b1fe8729572dabe9a9e97d930dd4f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        stable@vger.kernel.org, davej@redhat.com, vincent.weaver@maine.edu,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        davej@redhat.com, stable@vger.kernel.org, vincent.weaver@maine.edu,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20140221150312.GF3104@twins.programming.kicks-ass.net>
References: <20140221150312.GF3104@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix event scheduling
Git-Commit-ID: 26e61e8939b1fe8729572dabe9a9e97d930dd4f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26e61e8939b1fe8729572dabe9a9e97d930dd4f6
Gitweb:     http://git.kernel.org/tip/26e61e8939b1fe8729572dabe9a9e97d930dd4f6
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 21 Feb 2014 16:03:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:38:02 +0100

perf/x86: Fix event scheduling

Vince "Super Tester" Weaver reported a new round of syscall fuzzing (Trinity) failures,
with perf WARN_ON()s triggering. He also provided traces of the failures.

This is I think the relevant bit:

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

So we add the insn:p event (fd[23]).

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

Reported-and-Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20140221150312.GF3104@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 895604f..79f9f84 100644
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
 
