Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab3HSQOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:14:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3HSQO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:14:28 -0400
Date: Mon, 19 Aug 2013 18:08:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] task_work: minor cleanups
Message-ID: <20130819160845.GA18930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial. Remove the unnecessary "work = NULL" initialization
and turn read_barrier_depends() into smp_read_barrier_depends()
in task_work_cancel().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/task_work.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 65bd3c9..6ee0985 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -25,7 +25,7 @@ struct callback_head *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
 	struct callback_head **pprev = &task->task_works;
-	struct callback_head *work = NULL;
+	struct callback_head *work;
 	unsigned long flags;
 	/*
 	 * If cmpxchg() fails we continue without updating pprev.
@@ -35,7 +35,7 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	while ((work = ACCESS_ONCE(*pprev))) {
-		read_barrier_depends();
+		smp_read_barrier_depends();
 		if (work->func != func)
 			pprev = &work->next;
 		else if (cmpxchg(pprev, work, work->next) == work)
-- 
1.5.5.1


