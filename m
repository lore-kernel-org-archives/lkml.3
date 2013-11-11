Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3KKRxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:53:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46623 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3KKRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:52:48 -0500
Date: Mon, 11 Nov 2013 09:52:15 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-7053ea1a34fa8567cb5e3c39e04ace4c5d0fbeaa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <20131101104146.03d1e043@annuminas.surriel.com>
References: <20131101104146.03d1e043@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] stop_machine: Fix race between stop_two_cpus()
  and stop_cpus()
Git-Commit-ID: 7053ea1a34fa8567cb5e3c39e04ace4c5d0fbeaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 09:52:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7053ea1a34fa8567cb5e3c39e04ace4c5d0fbeaa
Gitweb:     http://git.kernel.org/tip/7053ea1a34fa8567cb5e3c39e04ace4c5d0fbeaa
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 1 Nov 2013 10:41:46 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Nov 2013 12:43:38 +0100

stop_machine: Fix race between stop_two_cpus() and stop_cpus()

There is a race between stop_two_cpus, and the global stop_cpus.

It is possible for two CPUs to get their stopper functions queued
"backwards" from one another, resulting in the stopper threads
getting stuck, and the system hanging. This can happen because
queuing up stoppers is not synchronized.

This patch adds synchronization between stop_cpus (a rare operation),
and stop_two_cpus.

Reported-and-Tested-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Link: http://lkml.kernel.org/r/20131101104146.03d1e043@annuminas.surriel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/stop_machine.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index c530bc5..84571e0 100644
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
@@ -276,6 +285,7 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 		return -ENOENT;
 	}
 
+	lg_local_lock(&stop_cpus_lock);
 	/*
 	 * Queuing needs to be done by the lowest numbered CPU, to ensure
 	 * that works are always queued in the same order on every CPU.
@@ -284,6 +294,7 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 	smp_call_function_single(min(cpu1, cpu2),
 				 &irq_cpu_stop_queue_work,
 				 &call_args, 0);
+	lg_local_unlock(&stop_cpus_lock);
 	preempt_enable();
 
 	wait_for_completion(&done.completion);
@@ -335,10 +346,10 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
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
