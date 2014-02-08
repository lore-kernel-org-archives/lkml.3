Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaBHQUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:20:46 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42032 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaBHQSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:18:54 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/11] smp: Teach __smp_call_function_single() to check for offline cpus
Date: Sat,  8 Feb 2014 17:18:35 +0100
Message-Id: <1391876320-25068-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Align __smp_call_function_single() with smp_call_function_single() so
that it also checks whether requested cpu is still online.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/smp.h |  3 +--
 kernel/smp.c        | 11 +++++++----
 kernel/up.c         |  5 +++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 9a1b8ba..1e8c721 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -50,8 +50,7 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags);
 
-void __smp_call_function_single(int cpuid, struct call_single_data *data,
-				int wait);
+int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/smp.c b/kernel/smp.c
index e3852de..5ff14e3 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -276,18 +276,18 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
 /**
  * __smp_call_function_single(): Run a function on a specific CPU
  * @cpu: The CPU to run on.
- * @data: Pre-allocated and setup data structure
+ * @csd: Pre-allocated and setup data structure
  * @wait: If true, wait until function has completed on specified CPU.
  *
  * Like smp_call_function_single(), but allow caller to pass in a
  * pre-allocated data structure. Useful for embedding @data inside
  * other structures, for instance.
  */
-void __smp_call_function_single(int cpu, struct call_single_data *csd,
-				int wait)
+int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
 {
 	unsigned int this_cpu;
 	unsigned long flags;
+	int err = 0;
 
 	this_cpu = get_cpu();
 	/*
@@ -303,11 +303,14 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
 		local_irq_save(flags);
 		csd->func(csd->info);
 		local_irq_restore(flags);
-	} else {
+	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
 		csd_lock(csd);
 		generic_exec_single(cpu, csd, wait);
+	} else {
+		err = -ENXIO;	/* CPU not online */
 	}
 	put_cpu();
+	return err;
 }
 EXPORT_SYMBOL_GPL(__smp_call_function_single);
 
diff --git a/kernel/up.c b/kernel/up.c
index 509403e..cdf03d1 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -22,14 +22,15 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-void __smp_call_function_single(int cpu, struct call_single_data *csd,
-				int wait)
+int __smp_call_function_single(int cpu, struct call_single_data *csd,
+			       int wait)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
 	csd->func(csd->info);
 	local_irq_restore(flags);
+	return 0;
 }
 EXPORT_SYMBOL(__smp_call_function_single);
 
-- 
1.8.3.1

