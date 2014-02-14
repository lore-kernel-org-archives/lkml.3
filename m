Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaBNEyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:54:47 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39547 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBNEyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:54:46 -0500
Message-ID: <52FDA18D.40100@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 12:54:37 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] sched: make sure sched-priority after invoke idle_balance()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021404-2674-0000-0000-00000CB688CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since idle_balance() will release rq-lock for a while, there is a chance that
RT/DL tasks will be enqueued and ask for the resched, the func used to be
invoked ahead of pick_next_task(), which will make sure we drop into the
bottom-half inside pick_next_task().

Now since idle_balance() was done inside pick_next_task_fair(), pick_next_task()
can no longer make sure the priority, the worst case is that we will going to
pick the pulled fair task while there is RT/DL on rq which actually should be
picked up.

This patch will prevent this happen by some rechecking after idle_balance(), it
utilize the resched-flag for the case when RT/DL task was enqueued but don't ask
for resched (will that ever happened?).

CC: Ingo Molnar <mingo@kernel.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 235cfa7..ce67514 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4776,6 +4776,16 @@ simple:
 
 idle:
 #ifdef CONFIG_SMP
+	/*
+	 * We came here only when there is no more tasks on rq (top-half of
+	 * pick_next_task()), and we are now going to pull some fair entities.
+	 *
+	 * Since prev is still the current on rq, clear it's resched-flag so
+	 * we would be able to know when we got a new resched-request during
+	 * idle_balance(), check below for more details.
+	 */
+	clear_tsk_need_resched(prev);
+
 	idle_enter_fair(rq);
 	/*
 	 * We must set idle_stamp _before_ calling idle_balance(), such that we
@@ -4784,7 +4794,18 @@ idle:
 	rq->idle_stamp = rq_clock(rq);
 	if (idle_balance(rq)) { /* drops rq->lock */
 		rq->idle_stamp = 0;
-		goto again;
+		/*
+		 * Before we start to pick one of the pulled fair entities, take
+		 * care if some RT/DL tasks has been enqueued during the time
+		 * we release rq-lock inside idle_balance().
+		 *
+		 * In such cases, since clear_tsk_need_resched() was done
+		 * already, need_resched() will imply the request to sched-in
+		 * the enqueued RT/DL tasks, so don't 'goto again' to make sure
+		 * the priority.
+		 */
+		if (rq->nr_running == rq->cfs.h_nr_running || !need_resched())
+			goto again;
 	}
 #endif
 
-- 
1.7.9.5

