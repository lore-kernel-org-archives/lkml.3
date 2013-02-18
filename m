Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3BRQPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:15:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59377 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab3BRQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:17 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724950"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 11/15] workqueue: split work_flags to delayed_flags and color_flags in __queue_work()
Date: Tue, 19 Feb 2013 00:12:12 +0800
Message-Id: <1361203940-6300-12-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:39,
	Serialize complete at 2013/02/19 00:13:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow we use delayed_flags only in different path in later patches.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7ac6824..cdd5523 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1226,7 +1226,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 {
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
-	unsigned int work_flags;
+	unsigned int color_flags, delayed_flags = 0;
 	unsigned int req_cpu = cpu;
 
 	/*
@@ -1284,18 +1284,18 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	}
 
 	cwq->nr_in_flight[cwq->work_color]++;
-	work_flags = work_color_to_flags(cwq->work_color);
 
 	if (likely(cwq->nr_active < cwq->max_active)) {
 		trace_workqueue_activate_work(work);
 		cwq->nr_active++;
 		worklist = &cwq->pool->worklist;
 	} else {
-		work_flags |= WORK_STRUCT_DELAYED;
+		delayed_flags = WORK_STRUCT_DELAYED;
 		worklist = &cwq->delayed_works;
 	}
 
-	insert_work(cwq, work, worklist, work_flags);
+	color_flags = work_color_to_flags(cwq->work_color);
+	insert_work(cwq, work, worklist, color_flags | delayed_flags);
 
 	spin_unlock(&cwq->pool->lock);
 }
-- 
1.7.7.6

