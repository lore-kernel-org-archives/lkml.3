Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab3AQBnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:06 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57349 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3AQBnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:01 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/17] workqueue: introduce WORK_OFFQ_CPU_NONE
Date: Wed, 16 Jan 2013 17:42:37 -0800
Message-Id: <1358386969-945-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when a work item is off queue, high bits of its data
encodes the last CPU it was on.  This is scheduled to be changed to
pool ID, which will make it impossible to use WORK_CPU_NONE to
indicate no association.

This patch limits the number of bits which are used for off-queue cpu
number to 31 (so that the max fits in an int) and uses the highest
possible value - WORK_OFFQ_CPU_NONE - to indicate no association.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h | 10 +++++++++-
 kernel/workqueue.c        |  4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index ff68b1d..f8b3576 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -73,13 +73,21 @@ enum {
 
 	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
 
+	/*
+	 * When a work item is off queue, its high bits point to the last
+	 * cpu it was on.  Cap at 31 bits and use the highest number to
+	 * indicate that no cpu is associated.
+	 */
 	WORK_OFFQ_FLAG_BITS	= 1,
 	WORK_OFFQ_CPU_SHIFT	= WORK_OFFQ_FLAG_BASE + WORK_OFFQ_FLAG_BITS,
+	WORK_OFFQ_LEFT		= BITS_PER_LONG - WORK_OFFQ_CPU_SHIFT,
+	WORK_OFFQ_CPU_BITS	= WORK_OFFQ_LEFT <= 31 ? WORK_OFFQ_LEFT : 31,
+	WORK_OFFQ_CPU_NONE	= (1LU << WORK_OFFQ_CPU_BITS) - 1,
 
 	/* convenience constants */
 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
-	WORK_STRUCT_NO_CPU	= (unsigned long)WORK_CPU_NONE << WORK_OFFQ_CPU_SHIFT,
+	WORK_STRUCT_NO_CPU	= (unsigned long)WORK_OFFQ_CPU_NONE << WORK_OFFQ_CPU_SHIFT,
 
 	/* bit mask for work_busy() return values */
 	WORK_BUSY_PENDING	= 1 << 0,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6e8bad6..9da3db2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -600,7 +600,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->gcwq;
 
 	cpu = data >> WORK_OFFQ_CPU_SHIFT;
-	if (cpu == WORK_CPU_NONE)
+	if (cpu == WORK_OFFQ_CPU_NONE)
 		return NULL;
 
 	BUG_ON(cpu >= nr_cpu_ids && cpu != WORK_CPU_UNBOUND);
@@ -610,7 +610,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 static void mark_work_canceling(struct work_struct *work)
 {
 	struct global_cwq *gcwq = get_work_gcwq(work);
-	unsigned long cpu = gcwq ? gcwq->cpu : WORK_CPU_NONE;
+	unsigned long cpu = gcwq ? gcwq->cpu : WORK_OFFQ_CPU_NONE;
 
 	set_work_data(work, (cpu << WORK_OFFQ_CPU_SHIFT) | WORK_OFFQ_CANCELING,
 		      WORK_STRUCT_PENDING);
-- 
1.8.0.2

