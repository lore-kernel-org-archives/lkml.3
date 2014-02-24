Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaBXPma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:42:30 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34049 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaBXPkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:19 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 07/11] smp: Consolidate the various smp_call_function_single() declensions
Date: Mon, 24 Feb 2014 16:39:58 +0100
Message-Id: <1393256402-16907-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__smp_call_function_single() and smp_call_function_single() share some
code that can be factorized: execute inline when the target is local,
check if the target is online, lock the csd, call generic_exec_single().

Lets move the common parts to generic_exec_single().

Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/smp.c | 80 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 5ff14e3..64bb0d4 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -117,13 +117,43 @@ static void csd_unlock(struct call_single_data *csd)
 	csd->flags &= ~CSD_FLAG_LOCK;
 }
 
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
+
 /*
  * Insert a previously allocated call_single_data element
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
+static int generic_exec_single(int cpu, struct call_single_data *csd,
+			       smp_call_func_t func, void *info, int wait)
 {
+	struct call_single_data csd_stack = { .flags = 0 };
+	unsigned long flags;
+
+
+	if (cpu == smp_processor_id()) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+		return 0;
+	}
+
+
+	if ((unsigned)cpu >= nr_cpu_ids || !cpu_online(cpu))
+		return -ENXIO;
+
+
+	if (!csd) {
+		csd = &csd_stack;
+		if (!wait)
+			csd = &__get_cpu_var(csd_data);
+	}
+
+	csd_lock(csd);
+
+	csd->func = func;
+	csd->info = info;
+
 	if (wait)
 		csd->flags |= CSD_FLAG_WAIT;
 
@@ -143,6 +173,8 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 
 	if (wait)
 		csd_lock_wait(csd);
+
+	return 0;
 }
 
 /*
@@ -168,8 +200,6 @@ void generic_smp_call_function_single_interrupt(void)
 	}
 }
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
-
 /*
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
@@ -181,12 +211,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
 int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 			     int wait)
 {
-	struct call_single_data d = {
-		.flags = 0,
-	};
-	unsigned long flags;
 	int this_cpu;
-	int err = 0;
+	int err;
 
 	/*
 	 * prevent preemption and reschedule on another processor,
@@ -203,26 +229,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress);
 
-	if (cpu == this_cpu) {
-		local_irq_save(flags);
-		func(info);
-		local_irq_restore(flags);
-	} else {
-		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-			struct call_single_data *csd = &d;
-
-			if (!wait)
-				csd = &__get_cpu_var(csd_data);
-
-			csd_lock(csd);
-
-			csd->func = func;
-			csd->info = info;
-			generic_exec_single(cpu, csd, wait);
-		} else {
-			err = -ENXIO;	/* CPU not online */
-		}
-	}
+	err = generic_exec_single(cpu, NULL, func, info, wait);
 
 	put_cpu();
 
@@ -285,9 +292,8 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
  */
 int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
 {
-	unsigned int this_cpu;
-	unsigned long flags;
 	int err = 0;
+	int this_cpu;
 
 	this_cpu = get_cpu();
 	/*
@@ -296,20 +302,12 @@ int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
+	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
 		     && !oops_in_progress);
 
-	if (cpu == this_cpu) {
-		local_irq_save(flags);
-		csd->func(csd->info);
-		local_irq_restore(flags);
-	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-		csd_lock(csd);
-		generic_exec_single(cpu, csd, wait);
-	} else {
-		err = -ENXIO;	/* CPU not online */
-	}
+	err = generic_exec_single(cpu, csd, csd->func, csd->info, wait);
 	put_cpu();
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(__smp_call_function_single);
-- 
1.8.3.1

