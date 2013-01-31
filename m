Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3AaSmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:42:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38873 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab3AaSlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672833"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/13] workqueue: fix work_busy()
Date: Fri, 1 Feb 2013 02:41:25 +0800
Message-Id: <1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:43,
	Serialize complete at 2013/02/01 02:40:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even get_work_pool() return NULL, the work may be pending.
Make work_pending() test unconditionally.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 973b290..d474a6c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3443,8 +3443,6 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  * Test whether @work is currently pending or running.  There is no
  * synchronization around this function and the test result is
  * unreliable and only useful as advisory hints or for debugging.
- * Especially for reentrant wqs, the pending state might hide the
- * running state.
  *
  * RETURNS:
  * OR'd bitmask of WORK_BUSY_* bits.
@@ -3453,15 +3451,13 @@ unsigned int work_busy(struct work_struct *work)
 {
 	struct worker_pool *pool = get_work_pool(work);
 	unsigned long flags;
-	unsigned int ret = 0;
+	unsigned int ret = work_pending(work) ? WORK_BUSY_PENDING : 0;
 
 	if (!pool)
-		return 0;
+		return ret;
 
 	spin_lock_irqsave(&pool->lock, flags);
 
-	if (work_pending(work))
-		ret |= WORK_BUSY_PENDING;
 	if (find_worker_executing_work(pool, work))
 		ret |= WORK_BUSY_RUNNING;
 
-- 
1.7.7.6

