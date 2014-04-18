Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaDRI0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:26:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaDRI0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:26:37 -0400
Date: Fri, 18 Apr 2014 01:24:38 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-a1d9a3231eac4117cadaf4b6bba5b2902c15a33e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tkhai@yandex.ru,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tkhai@yandex.ru,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <336561397137116@web27h.yandex.ru>
References: <336561397137116@web27h.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Check for stop task appearance when balancing happens
Git-Commit-ID: a1d9a3231eac4117cadaf4b6bba5b2902c15a33e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1d9a3231eac4117cadaf4b6bba5b2902c15a33e
Gitweb:     http://git.kernel.org/tip/a1d9a3231eac4117cadaf4b6bba5b2902c15a33e
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Thu, 10 Apr 2014 17:38:36 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 Apr 2014 13:39:51 +0200

sched: Check for stop task appearance when balancing happens

We need to do it like we do for the other higher priority classes..

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/336561397137116@web27h.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 11 ++++++++++-
 kernel/sched/fair.c     |  3 ++-
 kernel/sched/rt.c       |  7 ++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 27ef409..b080957 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1021,8 +1021,17 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 
 	dl_rq = &rq->dl;
 
-	if (need_pull_dl_task(rq, prev))
+	if (need_pull_dl_task(rq, prev)) {
 		pull_dl_task(rq);
+		/*
+		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
+		 * means a stop task can slip in, in which case we need to
+		 * re-start task selection.
+		 */
+		if (rq->stop && rq->stop->on_rq)
+			return RETRY_TASK;
+	}
+
 	/*
 	 * When prev is DL, we may throttle it in put_prev_task().
 	 * So, we update time before we check for dl_nr_running.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4f14a65..7570dd9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6728,7 +6728,8 @@ static int idle_balance(struct rq *this_rq)
 out:
 	/* Is there a task of a high priority class? */
 	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
-	    (this_rq->dl.dl_nr_running ||
+	    ((this_rq->stop && this_rq->stop->on_rq) ||
+	     this_rq->dl.dl_nr_running ||
 	     (this_rq->rt.rt_nr_running && !rt_rq_throttled(&this_rq->rt))))
 		pulled_task = -1;
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d8cdf16..bd2267a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1362,10 +1362,11 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 		pull_rt_task(rq);
 		/*
 		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
-		 * means a dl task can slip in, in which case we need to
-		 * re-start task selection.
+		 * means a dl or stop task can slip in, in which case we need
+		 * to re-start task selection.
 		 */
-		if (unlikely(rq->dl.dl_nr_running))
+		if (unlikely((rq->stop && rq->stop->on_rq) ||
+			     rq->dl.dl_nr_running))
 			return RETRY_TASK;
 	}
 
