Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161118AbaDJNqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:46:19 -0400
Received: from forward2h.mail.yandex.net ([84.201.187.147]:50268 "EHLO
	forward2h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030713AbaDJNqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:46:17 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2014 09:46:17 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Michael wang <wangyun@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <53464164.5030701@linux.vnet.ibm.com>
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net> <530B1B80.4000307@linux.vnet.ibm.com> <20140224121218.GR15586@twins.programming.kicks-ass.net> <534610A4.5000302@oracle.com> <53464164.5030701@linux.vnet.ibm.com>
Subject: Re: sched: hang in migrate_swap
MIME-Version: 1.0
Message-Id: <336561397137116@web27h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 10 Apr 2014 17:38:36 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10.04.2014, 11:00, "Michael wang" <wangyun@linux.vnet.ibm.com>:
> On 04/10/2014 11:31 AM, Sasha Levin wrote:
> [snip]
>
>> šI'd like to re-open this issue. It seems that something broke and I'm
>> šnow seeing the same issues that have gone away 2 months with this patch
>> šagain.
>
> A new mechanism has been designed to move the priority checking inside
> idle_balance(), including Kirill who is the designer ;-)

Not sure, it's connected with my patch. But looks like, we forgot
exactly stop class. Maybe this will help?

[PATCH] sched: Checking for stop task appearance when balancing happens

Just do it, like we do for other higher priority classes...

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
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
index 7e9bd0b..c50275b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6727,7 +6727,8 @@ static int idle_balance(struct rq *this_rq)
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
 
