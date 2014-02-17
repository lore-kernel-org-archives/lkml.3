Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaBQSOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:14:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaBQSOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:14:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,862,1384272000"; 
   d="scan'208";a="9545760"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] workqueue: free worker earlier in worker_thread()
Date: Tue, 18 Feb 2014 00:24:01 +0800
Message-Id: <1392654243-2829-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com>
 <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 00:22:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 00:22:11,
	Serialize complete at 2014/02/18 00:22:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When @worker is set %WORKER_DIE, it is moved out from
idle_list&idr, no one can access it excepct kthread_data().

And in worker_thread, its task is clearred %PF_WQ_WORKER,
no one can access the @worker via kthread_data(),
we can safely free it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 783d5f2..fc05700 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1862,7 +1862,6 @@ static void destroy_worker(struct worker *worker)
 
 	kthread_stop(worker->task);
 	put_task_struct(worker->task);
-	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
 }
@@ -2297,6 +2296,8 @@ woke_up:
 		spin_unlock_irq(&pool->lock);
 		WARN_ON_ONCE(!list_empty(&worker->entry));
 		worker->task->flags &= ~PF_WQ_WORKER;
+		/* No one can access to @worker now, free it. */
+		kfree(worker);
 		return 0;
 	}
 
-- 
1.7.7.6

