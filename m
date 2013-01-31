Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3AaSo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:44:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab3AaSl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672838"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/13] workqueue: get pool from wq/cwq
Date: Fri, 1 Feb 2013 02:41:30 +0800
Message-Id: <1359657696-2767-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:48,
	Serialize complete at 2013/02/01 02:40:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__queue_work() calls to get_std_worker_pool(), it is indirectly,
we should get it directly from wq/cwq.

It is needed when we introduce non-std worker pool.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f04416..a138844 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1212,7 +1212,6 @@ static bool is_chained_work(struct workqueue_struct *wq)
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
-	bool highpri = wq->flags & WQ_HIGHPRI;
 	struct worker_pool *pool;
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
@@ -1247,7 +1246,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 * work needs to be queued on that cpu to guarantee
 		 * non-reentrancy.
 		 */
-		pool = get_std_worker_pool(cpu, highpri);
+		pool = get_cwq(cpu, wq)->pool;
 		last_pool = get_work_pool(work);
 
 		if (last_pool && last_pool != pool) {
@@ -1268,7 +1267,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			spin_lock(&pool->lock);
 		}
 	} else {
-		pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
+		pool = get_cwq(WORK_CPU_UNBOUND, wq)->pool;
 		spin_lock(&pool->lock);
 	}
 
-- 
1.7.7.6

