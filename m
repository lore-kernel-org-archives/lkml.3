Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaBXPmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:42:03 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:59935 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaBXPkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:20 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 08/11] smp: Move __smp_call_function_single() below its safe version
Date: Mon, 24 Feb 2014 16:39:59 +0100
Message-Id: <1393256402-16907-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move this function closer to __smp_call_function_single(). These functions
have very similar behavior and should be displayed in the same block
for clarity.

Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/smp.c | 64 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 64bb0d4..fa04ab9 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -237,6 +237,38 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+/**
+ * __smp_call_function_single(): Run a function on a specific CPU
+ * @cpu: The CPU to run on.
+ * @csd: Pre-allocated and setup data structure
+ * @wait: If true, wait until function has completed on specified CPU.
+ *
+ * Like smp_call_function_single(), but allow caller to pass in a
+ * pre-allocated data structure. Useful for embedding @data inside
+ * other structures, for instance.
+ */
+int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
+{
+	int err = 0;
+	int this_cpu;
+
+	this_cpu = get_cpu();
+	/*
+	 * Can deadlock when called with interrupts disabled.
+	 * We allow cpu's that are not yet online though, as no one else can
+	 * send smp call function interrupt to this cpu and as such deadlocks
+	 * can't happen.
+	 */
+	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
+		     && !oops_in_progress);
+
+	err = generic_exec_single(cpu, csd, csd->func, csd->info, wait);
+	put_cpu();
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(__smp_call_function_single);
+
 /*
  * smp_call_function_any - Run a function on any of the given cpus
  * @mask: The mask of cpus it can run on.
@@ -281,38 +313,6 @@ call:
 EXPORT_SYMBOL_GPL(smp_call_function_any);
 
 /**
- * __smp_call_function_single(): Run a function on a specific CPU
- * @cpu: The CPU to run on.
- * @csd: Pre-allocated and setup data structure
- * @wait: If true, wait until function has completed on specified CPU.
- *
- * Like smp_call_function_single(), but allow caller to pass in a
- * pre-allocated data structure. Useful for embedding @data inside
- * other structures, for instance.
- */
-int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
-{
-	int err = 0;
-	int this_cpu;
-
-	this_cpu = get_cpu();
-	/*
-	 * Can deadlock when called with interrupts disabled.
-	 * We allow cpu's that are not yet online though, as no one else can
-	 * send smp call function interrupt to this cpu and as such deadlocks
-	 * can't happen.
-	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
-		     && !oops_in_progress);
-
-	err = generic_exec_single(cpu, csd, csd->func, csd->info, wait);
-	put_cpu();
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(__smp_call_function_single);
-
-/**
  * smp_call_function_many(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on (only runs on online subset).
  * @func: The function to run. This must be fast and non-blocking.
-- 
1.8.3.1

