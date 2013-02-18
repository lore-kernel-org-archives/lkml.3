Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3BRQQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:16:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:5866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab3BRQN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:13:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724944"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 05/15] workqueue: only set pool id when the work is running
Date: Tue, 19 Feb 2013 00:12:06 +0800
Message-Id: <1361203940-6300-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:20,
	Serialize complete at 2013/02/19 00:13:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a work is dequeued via try_to_grab_pending(), its pool id is recored
in work->data. but this recording is useless when the work is not running.

In this patch, we only record pool id when the work is running.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5502188..06d6211 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1139,6 +1139,8 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		goto fail;
 
 	if (cwq) {
+		int pool_id;
+
 		debug_work_deactivate(work);
 
 		/*
@@ -1154,8 +1156,13 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		list_del_init(&work->entry);
 		cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
 
-		/* work->data points to cwq iff queued, point to pool */
-		set_work_pool_and_keep_pending(work, pool->id);
+		/* work is dequeued, work->data points to pool iff running */
+		if (worker)
+			pool_id = pool->id;
+		else
+			pool_id = WORK_OFFQ_POOL_NONE;
+
+		set_work_pool_and_keep_pending(work, pool_id);
 
 		spin_unlock(&pool->lock);
 		return 1;
-- 
1.7.7.6

