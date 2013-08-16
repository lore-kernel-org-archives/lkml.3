Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3HPP5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:57:13 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3HPP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:57:10 -0400
From: Richard Weinberger <richard@nod.at>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] print_worker_info: Handle pointer with more care
Date: Fri, 16 Aug 2013 17:56:46 +0200
Message-Id: <1376668606-32354-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function has a nice comment:
/*
 * This function is called without any synchronization and @task
 * could be in any state.  Be careful with dereferences.
 */

But a few lines later it blindly dereferences a few pointers.
E.g. It can happen that the worker function is already done,
then worker->current_pwq is NULL.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 kernel/workqueue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be..61382b9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4465,6 +4465,8 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	 * could be in any state.  Be careful with dereferences.
 	 */
 	worker = probe_kthread_data(task);
+	if (!worker)
+		return;
 
 	/*
 	 * Carefully copy the associated workqueue's workfn and name.  Keep
@@ -4472,7 +4474,13 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	 */
 	probe_kernel_read(&fn, &worker->current_func, sizeof(fn));
 	probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
+	if (!pwq)
+		goto print;
+
 	probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
+	if (!wq)
+		goto print;
+
 	probe_kernel_read(name, wq->name, sizeof(name) - 1);
 
 	/* copy worker description */
@@ -4480,6 +4488,7 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	if (desc_valid)
 		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
 
+print:
 	if (fn || name[0] || desc[0]) {
 		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
 		if (desc[0])
-- 
1.8.3.1

