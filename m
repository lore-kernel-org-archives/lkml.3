Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaJ1LMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:12:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJ1LMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:12:00 -0400
Date: Tue, 28 Oct 2014 04:11:08 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-7d4d26966e0b6443c78123a8a8b602e8eaf67694@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        hpa@zytor.com
Reply-To: peterz@infradead.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140924082242.392279328@infradead.org>
References: <20140924082242.392279328@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, smp: Correctly deal with nested sleeps
Git-Commit-ID: 7d4d26966e0b6443c78123a8a8b602e8eaf67694
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

Commit-ID:  7d4d26966e0b6443c78123a8a8b602e8eaf67694
Gitweb:     http://git.kernel.org/tip/7d4d26966e0b6443c78123a8a8b602e8eaf67694
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:52 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:56:24 +0100

sched, smp: Correctly deal with nested sleeps

smp_hotplug_thread::{setup,unpark} functions can sleep too, so be
consistent and do the same for all callbacks.

 __might_sleep+0x74/0x80
 kmem_cache_alloc_trace+0x4e/0x1c0
 perf_event_alloc+0x55/0x450
 perf_event_create_kernel_counter+0x2f/0x100
 watchdog_nmi_enable+0x8d/0x160
 watchdog_enable+0x45/0x90
 smpboot_thread_fn+0xec/0x2b0
 kthread+0xe4/0x100
 ret_from_fork+0x7c/0xb0

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: oleg@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140924082242.392279328@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/smpboot.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index eb89e18..f032fb5 100644
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
