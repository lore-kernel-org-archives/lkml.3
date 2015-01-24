Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbbAXOF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:05:56 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47016 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbbAXOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:34 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 30/32] irq: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:36 -0500
Message-Id: <1422108218-25398-31-git-send-email-tj@kernel.org>
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
 kernel/irq/proc.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 9dc9bfd..df2f464 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -46,10 +46,9 @@ static int show_irq_affinity(int type, struct seq_file *m, void *v)
 		mask = desc->pending_mask;
 #endif
 	if (type)
-		seq_cpumask_list(m, mask);
+		seq_printf(m, "%*pbl\n", cpumask_pr_args(mask));
 	else
-		seq_cpumask(m, mask);
-	seq_putc(m, '\n');
+		seq_printf(m, "%*pb\n", cpumask_pr_args(mask));
 	return 0;
 }
 
@@ -67,8 +66,7 @@ static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
 		cpumask_copy(mask, desc->affinity_hint);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	seq_cpumask(m, mask);
-	seq_putc(m, '\n');
+	seq_printf(m, "%*pb\n", cpumask_pr_args(mask));
 	free_cpumask_var(mask);
 
 	return 0;
@@ -186,8 +184,7 @@ static const struct file_operations irq_affinity_list_proc_fops = {
 
 static int default_affinity_show(struct seq_file *m, void *v)
 {
-	seq_cpumask(m, irq_default_affinity);
-	seq_putc(m, '\n');
+	seq_printf(m, "%*pb\n", cpumask_pr_args(irq_default_affinity));
 	return 0;
 }
 
-- 
2.1.0

