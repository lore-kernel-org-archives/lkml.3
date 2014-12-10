Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaLJPx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:29 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:34037 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467AbaLJPxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:25 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 11/12] timer: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:53 -0500
Message-Id: <1418226774-30215-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing user of cpu{mask|list}_scnprintf() and
node{mask|list}_scnprintf() which use them just to printk or
seq_printf() the resulting buffer to use the following functions
instead respectively.

* For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().

* For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().

Because these conversions usually break up a single output function
call into multiple, the reduction is LOC isn't too big but it removes
unnecessary complexity and/or arbitrary limit on the length printed.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4d54b75..dd43dd9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -326,13 +326,6 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-/*
- * Worst case string length in chunks of CPU range seems 2 steps
- * separations: 0,2,4,6,...
- * This is NR_CPUS + sizeof('\0')
- */
-static char __initdata nohz_full_buf[NR_CPUS + 1];
-
 static int tick_nohz_init_all(void)
 {
 	int err = -1;
@@ -393,8 +386,9 @@ void __init tick_nohz_init(void)
 		context_tracking_cpu_set(cpu);
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), tick_nohz_full_mask);
-	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
+	pr_info("NO_HZ: Full dynticks CPUs: ");
+	cpulist_pr_cont(tick_nohz_full_mask);
+	pr_cont(".\n");
 }
 #endif
 
-- 
2.1.0

