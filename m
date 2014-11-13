Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016AbaKMT1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:27:11 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:60735 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547AbaKMTZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:29 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 12/16] task_work: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:18 -0500
Message-Id: <1415906662-4576-13-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/task_work.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 8727032..b5599ce 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -62,8 +62,7 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 	 * we raced with task_work_run(), *pprev == NULL/exited.
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	while ((work = ACCESS_ONCE(*pprev))) {
-		smp_read_barrier_depends();
+	while ((work = lockless_dereference(*pprev))) {
 		if (work->func != func)
 			pprev = &work->next;
 		else if (cmpxchg(pprev, work, work->next) == work)
-- 
1.9.1

