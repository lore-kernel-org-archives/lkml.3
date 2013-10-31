Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3JaUcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:32:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3JaUcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:32:14 -0400
Date: Thu, 31 Oct 2013 16:31:44 -0400
From: Rik van Riel <riel@redhat.com>
To: peterz@infradead.org
Cc: mingo@kernel.org, prarit@redhat.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
Message-ID: <20131031163144.0fd27457@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between stop_two_cpus, and the global stop_cpus.

It is possible for two CPUs to get their stopper functions queued
"backwards" from one another, resulting in the stopper threads
getting stuck, and the system hanging. This can happen because
queuing up stoppers is not synchronized.

This patch adds synchronization between stop_cpus (a rare operation),
and stop_two_cpus.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
Prarit is running a test with this patch. By now the kernel would have
crashed already, yet it is still going. I expect Prarit will add his
Tested-by: some time tomorrow morning.

 kernel/stop_machine.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 32a6c44..46cb4c2 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -40,8 +40,10 @@ struct cpu_stopper {
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
+static DEFINE_PER_CPU(bool, stop_two_cpus_queueing);
 static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
 static bool stop_machine_initialized = false;
+static bool stop_cpus_queueing = false;
 
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
 {
@@ -261,16 +263,37 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 	cpu_stop_init_done(&done, 2);
 	set_state(&msdata, MULTI_STOP_PREPARE);
 
+ wait_for_global:
+	/* If a global stop_cpus is queuing up stoppers, wait. */
+	while (unlikely(stop_cpus_queueing))
+		cpu_relax();
+
+	/* This CPU is queuing up stoppers. */
+	preempt_disable();
+	this_cpu_write(stop_two_cpus_queueing, true);
+	smp_mb(); /* matches the smp_wmb in queue_stop_cpus_work */
+
+	/* Global stop_cpus got busy simultaneously. Wait and retry. */
+	if (unlikely(stop_cpus_queueing)) {
+		smp_mb(); /* matches the smp_wmb in queue_stop_cpus_work */
+		this_cpu_write(stop_two_cpus_queueing, false);
+		preempt_enable();
+		goto wait_for_global;
+	}
+
 	/*
 	 * Queuing needs to be done by the lowest numbered CPU, to ensure
 	 * that works are always queued in the same order on every CPU.
 	 * This prevents deadlocks.
 	 */
 	call_cpu = min(cpu1, cpu2);
-
 	smp_call_function_single(call_cpu, &irq_cpu_stop_queue_work,
 				 &call_args, 0);
 
+	smp_wmb(); /* matches the smp_mb in wait_on_stop_two_cpus */
+	this_cpu_write(stop_two_cpus_queueing, false);
+	preempt_enable();
+
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -295,6 +318,19 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 	cpu_stop_queue_work(cpu, work_buf);
 }
 
+static void wait_on_stop_two_cpus(const struct cpumask *cpumask)
+{
+	int cpu;
+
+	/* Do not reorder reads before this point */
+	smp_mb(); /* matches the smp_wmb in stop_two_cpus */
+	
+	/* Wait until no stop_two_cpus stopper tasks are being queued */
+	for_each_cpu(cpu, cpumask)
+		while (per_cpu(stop_two_cpus_queueing, cpu) == true)
+			cpu_relax();
+}
+
 /* static data for stop_cpus */
 static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
@@ -320,8 +356,12 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
 	 * to enter @fn which can lead to deadlock.
 	 */
 	preempt_disable();
+	stop_cpus_queueing = true;
+	wait_on_stop_two_cpus(cpumask);
 	for_each_cpu(cpu, cpumask)
 		cpu_stop_queue_work(cpu, &per_cpu(stop_cpus_work, cpu));
+	smp_wmb(); /* matches the smp_mb in stop_two_cpus */
+	stop_cpus_queueing = false;
 	preempt_enable();
 }
 
@@ -509,6 +549,7 @@ static int __init cpu_stop_init(void)
 
 		spin_lock_init(&stopper->lock);
 		INIT_LIST_HEAD(&stopper->works);
+		per_cpu(stop_two_cpus_queueing, cpu) = false;
 	}
 
 	BUG_ON(smpboot_register_percpu_thread(&cpu_stop_threads));
