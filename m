Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab3HSQQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:16:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab3HSQO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:14:59 -0400
Date: Mon, 19 Aug 2013 18:09:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] task_work: documentation
Message-ID: <20130819160914.GA18942@redhat.com>
References: <20130819160845.GA18930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160845.GA18930@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, just comments.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/task_work.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 6ee0985..8727032 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -4,6 +4,23 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+/**
+ * task_work_add - ask the @task to execute @work->func()
+ * @task: the task which should run the callback
+ * @work: the callback to run
+ * @notify: send the notification if true
+ *
+ * Queue @work for task_work_run() below and notify the @task if @notify.
+ * Fails if the @task is exiting/exited and thus it can't process this @work.
+ * Otherwise @work->func() will be called when the @task returns from kernel
+ * mode or exits.
+ *
+ * This is like the signal handler which runs in kernel mode, but it doesn't
+ * try to wake up the @task.
+ *
+ * RETURNS:
+ * 0 if succeeds or -ESRCH.
+ */
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
@@ -21,6 +38,17 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 	return 0;
 }
 
+/**
+ * task_work_cancel - cancel a pending work added by task_work_add()
+ * @task: the task which should execute the work
+ * @func: identifies the work to remove
+ *
+ * Find the last queued pending work with ->func == @func and remove
+ * it from queue.
+ *
+ * RETURNS:
+ * The found work or NULL if not found.
+ */
 struct callback_head *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
@@ -46,6 +74,14 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 	return work;
 }
 
+/**
+ * task_work_run - execute the works added by task_work_add()
+ *
+ * Flush the pending works. Should be used by the core kernel code.
+ * Called before the task returns to the user-mode or stops, or when
+ * it exits. In the latter case task_work_add() can no longer add the
+ * new work after task_work_run() returns.
+ */
 void task_work_run(void)
 {
 	struct task_struct *task = current;
-- 
1.5.5.1


