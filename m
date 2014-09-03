Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaICLv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:51:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34514 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043AbaICLvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:51:25 -0400
Date: Wed, 3 Sep 2014 12:50:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140903115013.GA3127@leverpostej>
References: <20140901181808.GA6427@leverpostej>
 <20140901190534.GC5806@worktop.ger.corp.intel.com>
 <20140902185807.GA7434@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902185807.GA7434@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Further to my earlier reply I've come up with a potential fix below,
which has survived my stress test for both my WIP driver and the intel
uncore imc driver.

As it's impossible to synchronize with the event->ctx I'd hoped it would
be possible to synchronize with a field on the event itself.
Unfortunately all I managed to come up with were some shiny new ABBA
deadlocks.

Instead I've followed the example set by perf_event_open and inhibited
CPU hotplug for the portion of put_event that removes an event from its
context, which will prevent perf_pmu_migrate_context from modifying
event->ctx under our feet.

While there's the potential to starve CPU hotplug, that's already the
case for the perf_event_open path, so I'm not sure if that's a big deal
or not.

Thoughts?

Mark.

---->8----
>From 6465beace3ad9b12039127468f4596b8e87a53e8 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 3 Sep 2014 11:06:22 +0100
Subject: [PATCH] perf: prevent hotplug race on event->ctx

The perf_pmu_migrate_context code introduced in 0cda4c023132 (perf:
Introduce perf_pmu_migrate_context()) didn't take the tear-down of
events into account, and left open a race with put_event on event->ctx.
A resulting duplicate put_ctx of an event's original context can lead to
the context being erroneously kfreed via RCU, resulting in the below
splat with the intel uncore_imc PMU driver:

[   66.621306] ------------[ cut here ]------------
[   66.625933] kernel BUG at mm/slub.c:3380!
[   66.629947] invalid opcode: 0000 [#1] SMP
[   66.634101] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) x86_pkg_temp_thermal
[   66.643476] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           O  3.16.1-uncore-pmu-test #2
[   66.653132] Hardware name: LENOVO 10A6A03EUK/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[   66.660530] task: ffff88040b584f50 ti: ffff88040b5d4000 task.ti: ffff88040b5d4000
[   66.668009] RIP: 0010:[<ffffffff8114a443>]  [<ffffffff8114a443>] kfree+0x133/0x140
[   66.675615] RSP: 0018:ffff88041dc43ea8  EFLAGS: 00010246
[   66.680930] RAX: 0200000000000400 RBX: ffff88041dc18100 RCX: 00000000000000c8
[   66.688066] RDX: 0200000000000000 RSI: ffff8800db601800 RDI: ffff88041dc18100
[   66.695202] RBP: ffff88041dc43ec0 R08: 00000000000156e0 R09: ffff88041dc556e0
[   66.702334] R10: ffffea0010770600 R11: ffffea00036d8000 R12: ffffffff81c3dec0
[   66.709472] R13: ffffffff8109dd33 R14: ffff880409b96b08 R15: 0000000000000006
[   66.716607] FS:  0000000000000000(0000) GS:ffff88041dc40000(0000) knlGS:0000000000000000
[   66.724697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.730443] CR2: 00007fae8a93b000 CR3: 00000000dc962000 CR4: 00000000001407e0
[   66.737580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.744714] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   66.751852] Stack:
[   66.753873]  ffff88041dc4d300 ffffffff81c3dec0 000000000000000a ffff88041dc43f20
[   66.761371]  ffffffff8109dd33 ffff8800db600500 ffff88040b584f50 ffff88040b5d7fd8
[   66.768873]  ffff88041dc4d328 0000000000000000 0000000000000009 ffffffff81c090c8
[   66.776371] Call Trace:
[   66.778823]  <IRQ>
[   66.780759]  [<ffffffff8109dd33>] rcu_process_callbacks+0x1e3/0x540
[   66.787254]  [<ffffffff8104e70e>] __do_softirq+0xee/0x280
[   66.792654]  [<ffffffff8104eaad>] irq_exit+0x9d/0xb0
[   66.797625]  [<ffffffff81032b4f>] smp_apic_timer_interrupt+0x3f/0x50
[   66.803982]  [<ffffffff817de68a>] apic_timer_interrupt+0x6a/0x70
[   66.809994]  <EOI>
[   66.811926]  [<ffffffff81590ce7>] ? cpuidle_enter_state+0x47/0xc0
[   66.818250]  [<ffffffff81590e12>] cpuidle_enter+0x12/0x20
[   66.823650]  [<ffffffff81086aa6>] cpu_startup_entry+0x256/0x3f0
[   66.829572]  [<ffffffff81030d82>] start_secondary+0x192/0x200
[   66.835319] Code: 49 8b 02 31 f6 f6 c4 40 74 04 41 8b 72 68 4c 89 d7 e8 92 ed fb ff eb 93 4c 8b 50 30 48 8b 10 80 e6 80 4c 0f 44 d0 e9 36 ff ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 c7 c0 ea ff ff ff
[   66.855859] RIP  [<ffffffff8114a443>] kfree+0x133/0x140
[   66.861113]  RSP <ffff88041dc43ea8>
[   66.864617] ---[ end trace 825fa0ba52ca10eb ]---
[   66.869240] Kernel panic - not syncing: Fatal exception in interrupt
[   66.875616] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   66.885791] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

In response to a CPU notifier an uncore PMU driver calls
perf_pmu_migrate context, which will remove all events from the old CPU
context before placing them all into the new CPU context. For a short
period the events are in limbo and are part of neither context, though
their event->ctx pointers still point at the old context.

During this period another CPU may enter put_event, which will try to
remove the event from event->ctx. As this may still point at the old
context, put_ctx can be called twice for a given event on the original
context. The context's refcount may drop to zero unexpectedly, whereupon
put_ctx will queue up a kfree with RCU. This blows up at the end of the
next grace period as the uncore PMU contexts are housed within
perf_cpu_context and weren't directly allocated with k*alloc.

This patch prevents the issue by inhibiting hotplug for the portion of
put_event which must access event->ctx, preventing the notifiers which
call perf_pmu_migrate_context from running concurrently. Once the event
has been removed from its context perf_pmu_migrate_context will no
longer be able to access it, so it is not necessary to inhibit hotplug
for the duration of event tear-down.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zheng, Yan <zheng.z.yan@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
---
 kernel/events/core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9c1ed0..9e44cae 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3317,7 +3317,7 @@ static void free_event(struct perf_event *event)
  */
 static void put_event(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
+	struct perf_event_context *ctx;
 	struct task_struct *owner;
 
 	if (!atomic_long_dec_and_test(&event->refcount))
@@ -3356,6 +3356,16 @@ static void put_event(struct perf_event *event)
 		put_task_struct(owner);
 	}
 
+	/*
+	 * We must ensure that perf_pmu_migrate_context can't race on
+	 * event->ctx. Inhibit hotplug (and hence the notifiers
+	 * perf_pmu_migrate_context is called from) until the event is removed
+	 * from its current context.
+	 */
+	get_online_cpus();
+
+	ctx = event->ctx;
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
@@ -3373,6 +3383,8 @@ static void put_event(struct perf_event *event)
 	perf_remove_from_context(event, true);
 	mutex_unlock(&ctx->mutex);
 
+	put_online_cpus();
+
 	_free_event(event);
 }
 
-- 
1.9.1

