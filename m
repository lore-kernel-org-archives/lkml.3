Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBSDpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:45:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42437 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaBSDpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:45:31 -0500
X-IronPort-AV: E=Sophos;i="4.97,503,1389715200"; 
   d="scan'208";a="9557253"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: Fix possible unexpectedly worker wakeup before started
Date: Wed, 19 Feb 2014 11:47:58 +0800
Message-Id: <1392781678-31952-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/19 11:43:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/19 11:43:21,
	Serialize complete at 2014/02/19 11:43:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a worker is wokenup unexpectedly, it will start to work incorretly.
Although it hardly happen, we should catch it and wait for being started
if it does happen.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..bee5fe1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2284,6 +2284,12 @@ static int worker_thread(void *__worker)
 	struct worker *worker = __worker;
 	struct worker_pool *pool = worker->pool;
 
+	if (WARN_ON_ONCE(!(worker->flags & WORKER_STARTED))) {
+		/* The worker is wokenup unexpectedly before started */
+		mutex_lock(&pool->manager_mutex);
+		mutex_unlock(&pool->manager_mutex);
+	}
+
 	/* tell the scheduler that this is a workqueue worker */
 	worker->task->flags |= PF_WQ_WORKER;
 woke_up:
-- 
1.7.4.4

