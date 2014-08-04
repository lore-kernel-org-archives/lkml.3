Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaHDKj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:39:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:33287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaHDKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:39:54 -0400
Message-Id: <20140804103537.690931413@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 12:30:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 6/7] smp: Correctly deal with nested sleeps
References: <20140804103025.478913141@infradead.org>
Content-Disposition: inline; filename=peterz-might_sleep_smpboot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_hotplug_thread::{setup,unpark} functions can sleep too:

 __might_sleep+0x74/0x80
 kmem_cache_alloc_trace+0x4e/0x1c0
 perf_event_alloc+0x55/0x450
 perf_event_create_kernel_counter+0x2f/0x100
 watchdog_nmi_enable+0x8d/0x160
 watchdog_enable+0x45/0x90
 smpboot_thread_fn+0xec/0x2b0
 kthread+0xe4/0x100
 ret_from_fork+0x7c/0xb0

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/smpboot.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -110,7 +110,7 @@ static int smpboot_thread_fn(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		preempt_disable();
 		if (kthread_should_stop()) {
-			set_current_state(TASK_RUNNING);
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			if (ht->cleanup)
 				ht->cleanup(td->cpu, cpu_online(td->cpu));
@@ -136,26 +136,27 @@ static int smpboot_thread_fn(void *data)
 		/* Check for state change setup */
 		switch (td->status) {
 		case HP_THREAD_NONE:
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			if (ht->setup)
 				ht->setup(td->cpu);
 			td->status = HP_THREAD_ACTIVE;
-			preempt_disable();
-			break;
+			continue;
+
 		case HP_THREAD_PARKED:
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			if (ht->unpark)
 				ht->unpark(td->cpu);
 			td->status = HP_THREAD_ACTIVE;
-			preempt_disable();
-			break;
+			continue;
 		}
 
 		if (!ht->thread_should_run(td->cpu)) {
-			preempt_enable();
+			preempt_enable_no_resched();
 			schedule();
 		} else {
-			set_current_state(TASK_RUNNING);
+			__set_current_state(TASK_RUNNING);
 			preempt_enable();
 			ht->thread_fn(td->cpu);
 		}


