Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab3LWUj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:39:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab3LWUjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:39:53 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/9] smp: Teach __smp_call_function_single() to check for offline cpus
Date: Mon, 23 Dec 2013 21:39:25 +0100
Message-Id: <1387831171-5264-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387831171-5264-1-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align __smp_call_function_single() with smp_call_function_single() so
that it also checks whether requested cpu is still online.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/smp.h |  3 +--
 kernel/smp.c        | 11 +++++++----
 kernel/up.c         |  5 +++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 9a1b8ba05924..1e8c72100eda 100644
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
index 47b415e16c24..2efcfa1d11ee 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -284,18 +284,18 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
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
@@ -311,11 +311,14 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
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
index 509403e3fbc6..cdf03d16840e 100644
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
1.8.1.4

