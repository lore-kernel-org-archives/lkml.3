Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3KAOmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:42:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3KAOmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:42:18 -0400
Date: Fri, 1 Nov 2013 10:41:46 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, mingo@kernel.org, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -v2 -tip] fix race between stop_two_cpus and stop_cpus
Message-ID: <20131101104146.03d1e043@annuminas.surriel.com>
In-Reply-To: <5273BA58.6010404@redhat.com>
References: <20131031163144.0fd27457@annuminas.surriel.com>
	<20131101110825.GX2400@suse.de>
	<52739244.3060209@redhat.com>
	<20131101134424.GA32685@suse.de>
	<20131101142404.GG19466@laptop.lan>
	<5273BA58.6010404@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: fix race between stop_two_cpus and stop_cpus

There is a race between stop_two_cpus, and the global stop_cpus.

It is possible for two CPUs to get their stopper functions queued
"backwards" from one another, resulting in the stopper threads
getting stuck, and the system hanging. This can happen because
queuing up stoppers is not synchronized.

This patch adds synchronization between stop_cpus (a rare operation),
and stop_two_cpus.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
v2: use lglock, as suggested by Peter & Mel, thanks to both of you
for insisting on nicer code :)

 kernel/stop_machine.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 32a6c44..c5c1af1 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -20,6 +20,7 @@
 #include <linux/kallsyms.h>
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
+#include <linux/lglock.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -43,6 +44,14 @@ static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
 static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
 static bool stop_machine_initialized = false;
 
+/*
+ * Avoids a race between stop_two_cpus and global stop_cpus, where
+ * the stoppers could get queued up in reverse order, leading to
+ * system deadlock. Using an lglock means stop_two_cpus remains
+ * relatively cheap.
+ */
+DEFINE_STATIC_LGLOCK(stop_cpus_lock);
+
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
 {
 	memset(done, 0, sizeof(*done));
@@ -268,8 +277,10 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 	 */
 	call_cpu = min(cpu1, cpu2);
 
+	lg_local_lock(&stop_cpus_lock);
 	smp_call_function_single(call_cpu, &irq_cpu_stop_queue_work,
 				 &call_args, 0);
+	lg_local_unlock(&stop_cpus_lock);
 
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
@@ -319,10 +330,10 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
 	 * preempted by a stopper which might wait for other stoppers
 	 * to enter @fn which can lead to deadlock.
 	 */
-	preempt_disable();
+	lg_global_lock(&stop_cpus_lock);
 	for_each_cpu(cpu, cpumask)
 		cpu_stop_queue_work(cpu, &per_cpu(stop_cpus_work, cpu));
-	preempt_enable();
+	lg_global_unlock(&stop_cpus_lock);
 }
 
 static int __stop_cpus(const struct cpumask *cpumask,
