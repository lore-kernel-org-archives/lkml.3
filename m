Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab3CSTce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:32:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7894 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933442Ab3CST2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:54 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904505"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 10/21] workqueue: use rcu_read_lock_sched() instead for accessing pwq in RCU
Date: Wed, 20 Mar 2013 03:28:10 +0800
Message-Id: <1363721306-2030-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:28,
	Serialize complete at 2013/03/20 03:27:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_read_lock_sched() is better than preempt_disable() if the code is
protected by RCU_SCHED.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ad190cd..469269e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3967,7 +3967,7 @@ bool workqueue_congested(int cpu, struct workqueue_struct *wq)
 	struct pool_workqueue *pwq;
 	bool ret;
 
-	preempt_disable();
+	rcu_read_lock_sched();
 
 	if (!(wq->flags & WQ_UNBOUND))
 		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
@@ -3975,7 +3975,7 @@ bool workqueue_congested(int cpu, struct workqueue_struct *wq)
 		pwq = first_pwq(wq);
 
 	ret = !list_empty(&pwq->delayed_works);
-	preempt_enable();
+	rcu_read_unlock_sched();
 
 	return ret;
 }
@@ -4361,16 +4361,16 @@ bool freeze_workqueues_busy(void)
 		 * nr_active is monotonically decreasing.  It's safe
 		 * to peek without lock.
 		 */
-		preempt_disable();
+		rcu_read_lock_sched();
 		for_each_pwq(pwq, wq) {
 			WARN_ON_ONCE(pwq->nr_active < 0);
 			if (pwq->nr_active) {
 				busy = true;
-				preempt_enable();
+				rcu_read_unlock_sched();
 				goto out_unlock;
 			}
 		}
-		preempt_enable();
+		rcu_read_unlock_sched();
 	}
 out_unlock:
 	mutex_unlock(&wqs_mutex);
-- 
1.7.7.6

