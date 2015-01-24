Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbbAXOEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:41 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:64973 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbbAXOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:33 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/32] proc: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:35 -0500
Message-Id: <1422108218-25398-30-git-send-email-tj@kernel.org>
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
---
 fs/proc/array.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index bd117d0..41fd02b 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -336,12 +336,10 @@ static inline void task_context_switch_counts(struct seq_file *m,
 
 static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_puts(m, "Cpus_allowed:\t");
-	seq_cpumask(m, &task->cpus_allowed);
-	seq_putc(m, '\n');
-	seq_puts(m, "Cpus_allowed_list:\t");
-	seq_cpumask_list(m, &task->cpus_allowed);
-	seq_putc(m, '\n');
+	seq_printf(m, "Cpus_allowed:\t%*pb\n",
+		   cpumask_pr_args(&task->cpus_allowed));
+	seq_printf(m, "Cpus_allowed_list:\t%*pbl\n",
+		   cpumask_pr_args(&task->cpus_allowed));
 }
 
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
-- 
2.1.0

