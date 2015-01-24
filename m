Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbbAXOIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:08:45 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:59622 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbbAXOEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:13 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 16/32] time: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:22 -0500
Message-Id: <1422108218-25398-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1363d58..a4c4eda 100644
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
@@ -393,8 +386,8 @@ void __init tick_nohz_init(void)
 		context_tracking_cpu_set(cpu);
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), tick_nohz_full_mask);
-	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
+	pr_info("NO_HZ: Full dynticks CPUs: %*pbl.\n",
+		cpumask_pr_args(tick_nohz_full_mask));
 }
 #endif
 
-- 
2.1.0

