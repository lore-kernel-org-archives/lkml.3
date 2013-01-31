Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3AaSmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:42:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab3AaSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:57 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672837"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/13] workqueue: get pool id from work->data directly if it is offq
Date: Fri, 1 Feb 2013 02:41:29 +0800
Message-Id: <1359657696-2767-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:47,
	Serialize complete at 2013/02/01 02:40:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We know that when the time of the two calls of get_work_pool_id(),
the work is offq, so we can get pool id from work->data directly
and remove the overhead of idr_find() called by get_work_pool_id().

Implement offq_work_pool_id() instead of get_work_pool_id().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b7cfaa1..9f04416 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -617,22 +617,22 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 }
 
 /**
- * get_work_pool_id - return the worker pool ID a given work is associated with
- * @work: the work item of interest
+ * offq_work_pool_id - return the worker pool ID a given work is associated with
+ * @work: the off-queued work item of interest
  *
  * Return the worker_pool ID @work was last associated with.
- * %WORK_OFFQ_POOL_NONE if none.
  */
-static int get_work_pool_id(struct work_struct *work)
+static int offq_work_pool_id(struct work_struct *work)
 {
-	struct worker_pool *pool = get_work_pool(work);
+	unsigned long data = atomic_long_read(&work->data);
 
-	return pool ? pool->id : WORK_OFFQ_POOL_NONE;
+	BUG_ON(data & WORK_STRUCT_CWQ);
+	return data >> WORK_OFFQ_POOL_SHIFT;
 }
 
 static void mark_work_canceling(struct work_struct *work)
 {
-	unsigned long pool_id = get_work_pool_id(work);
+	unsigned long pool_id = offq_work_pool_id(work);
 
 	pool_id <<= WORK_OFFQ_POOL_SHIFT;
 	set_work_data(work, pool_id | WORK_OFFQ_CANCELING, WORK_STRUCT_PENDING);
@@ -2952,7 +2952,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 		return false;
 
 	set_work_pool_and_clear_pending(&dwork->work,
-					get_work_pool_id(&dwork->work));
+					offq_work_pool_id(&dwork->work));
 	local_irq_restore(flags);
 	return ret;
 }
-- 
1.7.7.6

