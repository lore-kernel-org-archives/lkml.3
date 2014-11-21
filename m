Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbaKUPIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:08:30 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53616 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676AbaKUPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:07:15 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 8/9] task_work: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Fri, 21 Nov 2014 10:06:02 -0500
Message-Id: <1416582363-20661-9-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416582363-20661-1-git-send-email-bobby.prani@gmail.com>
References: <1416582363-20661-1-git-send-email-bobby.prani@gmail.com>
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

